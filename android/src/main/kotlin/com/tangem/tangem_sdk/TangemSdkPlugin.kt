package com.tangem.tangem_sdk

import android.app.Activity
import android.os.Handler
import android.os.Looper
import android.util.Base64
import com.tangem.*
import com.tangem.common.biometric.BiometricManager
import com.tangem.common.core.Config
import com.tangem.common.core.ScanTagImage
import com.tangem.common.core.ScanTagImage.GenericCard
import com.tangem.common.extensions.hexToBytes
import com.tangem.common.json.MoshiJsonConverter
import com.tangem.common.services.secure.SecureStorage
import com.tangem.crypto.bip39.Wordlist
import com.tangem.sdk.DefaultSessionViewDelegate
import com.tangem.sdk.NfcLifecycleObserver
import com.tangem.sdk.extensions.getWordlist
import com.tangem.sdk.extensions.initBiometricManager
import com.tangem.sdk.nfc.NfcManager
import com.tangem.sdk.storage.create
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.lifecycle.HiddenLifecycleReference
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.ref.WeakReference

/** TangemSdkPlugin */
class TangemSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel

    private val handler = Handler(Looper.getMainLooper())
    private lateinit var wActivity: WeakReference<Activity>

    private lateinit var sdk: TangemSdk
    private lateinit var nfcManager: NfcManager
    private val converter = MoshiJsonConverter.default()

    private var replyAlreadySubmit = false

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tangem_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(pluginBinding: ActivityPluginBinding) {
        val activity = pluginBinding.activity as FlutterFragmentActivity
        wActivity = WeakReference(activity)

        nfcManager = createNfcManager(pluginBinding)
        val viewDelegate = createViewDelegate(activity, nfcManager)
        val storage = SecureStorage.create(activity)
        val config = Config()
        val biometricManager: BiometricManager = TangemSdk.initBiometricManager(activity, storage)
        val wordlist: Wordlist = Wordlist.getWordlist(activity)
        sdk = TangemSdk(nfcManager.reader, viewDelegate, storage, biometricManager, wordlist, config)
        nfcManager.onStart()
    }

    override fun onDetachedFromActivity() {
    }

    private fun createNfcManager(pluginBinding: ActivityPluginBinding): NfcManager {
        val hiddenLifecycleReference = pluginBinding.lifecycle as HiddenLifecycleReference
        return NfcManager().apply {
            setCurrentActivity(pluginBinding.activity)
            hiddenLifecycleReference.lifecycle.addObserver(NfcLifecycleObserver(this))
        }
    }

    private fun createViewDelegate(activity: Activity, nfcManager: NfcManager): SessionViewDelegate {
        return DefaultSessionViewDelegate(nfcManager, nfcManager.reader, activity)
    }

    override fun onReattachedToActivityForConfigChanges(pluginBinding: ActivityPluginBinding) {
        wActivity = WeakReference(pluginBinding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        wActivity = WeakReference(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        replyAlreadySubmit = false
        when (call.method) {
            "runJSONRPCRequest" -> {
                runJSONRPCRequest(call, result)
            }
            "setScanImage" -> {
                setScanImage(call, result)
            }
            else -> result.notImplemented()
        }
    }

    private fun runJSONRPCRequest(call: MethodCall, result: Result) {
        try {
            sdk.startSessionWithJsonRequest(
                    call.extract("JSONRPCRequest"),
                    call.extractOptional("cardId"),
                    call.extractOptional("initialMessage"),
                    call.extractOptional("accessCode")
            ) {
                handleResult(it, result)
            }
        } catch (ex: Exception) {
            handleException(ex, result)
        }
    }

    /**
     * {
     *    "base64": "encodedBase64ImageSource",
     *    "verticalOffset": 0    // optional
     * }
     */
    private fun setScanImage(call: MethodCall, callback: Result) {
        fun sendSuccessResult(callback: Result) {
            val successResult = "{ \"success\": true }"
            handleResult(successResult, callback)
        }

        try {
            val base64String: String? = call.extractOptional("base64")
            if (base64String == null) {
                sdk.setScanImage(GenericCard)
                sendSuccessResult(callback)
            } else {
                val base64Image: ByteArray = Base64.decode(base64String, Base64.DEFAULT)
                val verticalOffset: Int = call.extractOptional("verticalOffset") ?: 0
                val scanTagImage = ScanTagImage.Image(base64Image, verticalOffset)

                sdk.setScanImage(scanTagImage)
                sendSuccessResult(callback)
            }
        } catch (ex: Exception) {
            handleException(ex, callback)
        }
    }

    private fun handleResult(methodResul: String, callback: Result) {
        if (replyAlreadySubmit) return
        replyAlreadySubmit = true

        handler.post {
            callback.success(methodResul)
        }
    }

    private fun handleException(ex: Exception, result: Result) {
        if (replyAlreadySubmit) return
        replyAlreadySubmit = true

        handler.post {
            result.error("-1", converter.prettyPrint(ex, "  "), null)
        }
    }

    @Throws(Exception::class)
    private inline fun <reified T> MethodCall.extract(name: String): T {
        return this.extractOptional(name) ?: throw NoSuchFieldException(name)
    }

    private inline fun <reified T> MethodCall.extractOptional(name: String): T? {
        if (!this.hasArgument(name)) return null
        val argument = this.argument<Any>(name) ?: return null

        if (argument is String && T::class.java == ByteArray::class.java) {
            return argument.hexToBytes() as T
        }

        return if (argument is String) {
            argument as T
        } else {
            val json = converter.toJson(argument)
            converter.fromJson<T>(json)!!
        }
    }
}