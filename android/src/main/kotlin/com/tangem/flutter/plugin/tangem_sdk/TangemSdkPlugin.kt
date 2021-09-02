package com.tangem.flutter.plugin.tangem_sdk

import android.app.Activity
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.tangem.*
import com.tangem.common.CompletionResult
import com.tangem.common.card.FirmwareVersion
import com.tangem.common.core.CardSession
import com.tangem.common.core.Config
import com.tangem.common.core.TangemSdkError
import com.tangem.common.extensions.hexToBytes
import com.tangem.common.json.MoshiJsonConverter
import com.tangem.common.services.secure.SecureStorage
import com.tangem.tangem_sdk_new.DefaultSessionViewDelegate
import com.tangem.tangem_sdk_new.NfcLifecycleObserver
import com.tangem.tangem_sdk_new.extensions.createLogger
import com.tangem.tangem_sdk_new.extensions.localizedDescription
import com.tangem.tangem_sdk_new.nfc.NfcManager
import com.tangem.tangem_sdk_new.storage.create
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference
import java.util.*

/** TangemSdkPlugin */
class TangemSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private val handler = Handler(Looper.getMainLooper())
  private lateinit var wActivity: WeakReference<Activity>

  private lateinit var sdk: TangemSdk
  private var cardSession: CardSession? = null

  private var replyAlreadySubmit = false

  override fun onAttachedToActivity(pluginBinding: ActivityPluginBinding) {
    val activity = pluginBinding.activity
    wActivity = WeakReference(activity)

    val nfcManager = createNfcManager(pluginBinding)
    val config = Config().apply { linkedTerminal = false }

    sdk = TangemSdk(
        nfcManager.reader,
        createViewDelegate(activity, nfcManager),
        SecureStorage.create(activity),
        config,
    )
    Log.addLogger(TangemSdk.createLogger())
  }

  private fun createNfcManager(pluginBinding: ActivityPluginBinding): NfcManager {
    val hiddenLifecycleReference: HiddenLifecycleReference = pluginBinding.lifecycle as HiddenLifecycleReference
    return NfcManager().apply {
      setCurrentActivity(pluginBinding.activity)
      hiddenLifecycleReference.lifecycle.addObserver(NfcLifecycleObserver(this))
    }
  }

  private fun createViewDelegate(activity: Activity, nfcManager: NfcManager): SessionViewDelegate =
      DefaultSessionViewDelegate(nfcManager, nfcManager.reader).apply { this.activity = activity }

  override fun onDetachedFromActivity() {
  }

  override fun onReattachedToActivityForConfigChanges(pluginBinding: ActivityPluginBinding) {
    wActivity = WeakReference(pluginBinding.activity)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    wActivity = WeakReference(null)
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val messenger = flutterPluginBinding.binaryMessenger
    MethodChannel(messenger, "tangemSdk").setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }


  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    replyAlreadySubmit = false
    when (call.method) {
      "runJSONRPCRequest" -> runJSONRPCRequest(call, result)
      "allowsOnlyDebugCards" -> allowsOnlyDebugCards(call, result)
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      else -> result.notImplemented()
    }
  }

  private fun runJSONRPCRequest(call: MethodCall, result: Result) {
    try {
      replyAlreadySubmit = false
      val stringOfJSONRPCRequest = call.extract<String>("JSONRPCRequest")

      val callback = callbackWithResult@{ response: String ->
        if (! replyAlreadySubmit) {
          replyAlreadySubmit = true
          handler.post { result.success(response) }
        }
      }

      if (cardSession == null) {
        sdk.startSessionWithJsonRequest(
            stringOfJSONRPCRequest,
            call.extractOptional("cardId"),
            call.extractOptional("initialMessage"),
            callback
        )
      } else {
        cardSession !!.run(stringOfJSONRPCRequest, callback)
      }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun allowsOnlyDebugCards(call: MethodCall, result: Result) {
    try {
      val allowedOnlyDebug = call.extract<Boolean>("isAllowedOnlyDebugCards")
      val allowedCardTypes = if (allowedOnlyDebug) {
        listOf(FirmwareVersion.FirmwareType.Sdk)
      } else {
        listOf(FirmwareVersion.FirmwareType.Sdk, FirmwareVersion.FirmwareType.Release)
      }
      sdk.config.filter.allowedCardTypes = allowedCardTypes
      handleResult(result, CompletionResult.Success(true))
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun handleResult(result: Result, completionResult: CompletionResult<*>) {
    if (replyAlreadySubmit) return
    replyAlreadySubmit = true

    when (completionResult) {
      is CompletionResult.Success -> {
        handler.post { result.success(converter.toJson(completionResult.data)) }
      }
      is CompletionResult.Failure -> {
        val error = completionResult.error
        val errorMessage = if (error is TangemSdkError) {
          val activity = wActivity.get()
          if (activity == null) error.customMessage else error.localizedDescription(activity)
        } else {
          error.customMessage
        }
        val pluginError = PluginError(error.code, errorMessage)
        handler.post {
          result.error("${error.code}", errorMessage, converter.toJson(pluginError))
        }
      }
    }
  }

  private fun handleException(result: Result, ex: Exception) {
    if (replyAlreadySubmit) return
    replyAlreadySubmit = true

    handler.post {
      val code = 9999
      val localizedDescription: String = ex.toString()
      result.error("$code", localizedDescription, converter.toJson(PluginError(code, localizedDescription)))
    }
  }

  @Throws(PluginException::class)
  inline fun <reified T> MethodCall.extract(name: String): T {
    return try {
      this.extractOptional(name) ?: throw PluginException("MethodCall.extract: no such field: $name, or field is NULL")
    } catch (ex: Exception) {
      throw ex as? PluginException ?: PluginException("MethodCall.extractOptional", ex)
    }
  }

  inline fun <reified T> MethodCall.extractOptional(name: String): T? {
    if (! this.hasArgument(name)) return null
    val argument = this.argument<Any>(name) ?: return null

    if (argument is String && T::class.java == ByteArray::class.java) {
      return argument.hexToBytes() as T
    }

    return if (argument is String) {
      argument as T
    } else {
      val json = converter.toJson(argument)
      converter.fromJson(json) !!
    }
  }

  companion object {
    val converter = MoshiJsonConverter.INSTANCE
  }
}

data class PluginError(
    // code = 1000 - it's the plugin or it's the tangemSdk internal exception
    // any other value in code greater than 10000 - it's the tangemSdk internal error
    val code: Int,
    val localizedDescription: String
)

class PluginException(
    message: String, cause: Throwable? = null
): Exception("TangemSdkPlugin exception. Message: $message", cause)