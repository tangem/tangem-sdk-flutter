package com.tangem.flutter.plugin.tangem_sdk

import android.app.Activity
import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import com.google.gson.Gson
import com.google.gson.JsonSyntaxException
import com.google.gson.reflect.TypeToken
import com.squareup.sqldelight.android.AndroidSqliteDriver
import com.tangem.*
import com.tangem.commands.common.ResponseConverter
import com.tangem.commands.common.card.FirmwareType
import com.tangem.commands.file.FileData
import com.tangem.commands.file.FileDataSignature
import com.tangem.commands.file.FileSettingsChange
import com.tangem.commands.personalization.entities.Acquirer
import com.tangem.commands.personalization.entities.CardConfig
import com.tangem.commands.personalization.entities.Issuer
import com.tangem.commands.personalization.entities.Manufacturer
import com.tangem.common.CardValuesDbStorage
import com.tangem.common.CompletionResult
import com.tangem.common.extensions.calculateSha256
import com.tangem.common.extensions.hexToBytes
import com.tangem.tangem_sdk_new.DefaultSessionViewDelegate
import com.tangem.tangem_sdk_new.NfcLifecycleObserver
import com.tangem.tangem_sdk_new.TerminalKeysStorage
import com.tangem.tangem_sdk_new.extensions.localizedDescription
import com.tangem.tangem_sdk_new.nfc.NfcManager
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
public class TangemSdkPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {

  private val handler = Handler(Looper.getMainLooper())
  private val converter = ResponseConverter()
  private lateinit var sdk: TangemSdk
  private var replyAlreadySubmit = false;

  override fun onAttachedToActivity(pluginBinding: ActivityPluginBinding) {
    val activity = pluginBinding.activity
    wActivity = WeakReference(activity)
    val hiddenLifecycleReference: HiddenLifecycleReference = pluginBinding.lifecycle as HiddenLifecycleReference

    val nfcManager = NfcManager().apply {
      setCurrentActivity(activity)
      hiddenLifecycleReference.lifecycle.addObserver(NfcLifecycleObserver(this))
    }
    val cardManagerDelegate = DefaultSessionViewDelegate(nfcManager, nfcManager.reader).apply { this.activity = activity }
    val config = Config(cardFilter = CardFilter(EnumSet.of(FirmwareType.Sdk)))
    val valueStorage = CardValuesDbStorage(AndroidSqliteDriver(Database.Schema, activity.applicationContext,
        "flutter_cards.db"))
    val keyStorage = TerminalKeysStorage(activity.application)
    sdk = TangemSdk(nfcManager.reader, cardManagerDelegate, config, valueStorage, keyStorage)
  }

  override fun onDetachedFromActivity() {
  }

  override fun onReattachedToActivityForConfigChanges(pluginBinding: ActivityPluginBinding) {
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "tangemSdk")
    channel.setMethodCallHandler(this);
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    replyAlreadySubmit = false
    when (call.method) {
      "allowsOnlyDebugCards" -> allowsOnlyDebugCards(call, result)
      "scanCard" -> scanCard(call, result)
      "sign" -> sign(call, result)
      "personalize" -> personalize(call, result)
      "depersonalize" -> depersonalize(call, result)
      "readIssuerData" -> readIssuerData(call, result)
      "writeIssuerData" -> writeIssuerData(call, result)
      "readIssuerExData" -> readIssuerExtraData(call, result)
      "writeIssuerExData" -> writeIssuerExtraData(call, result)
      "readUserData" -> readUserData(call, result)
      "writeUserData" -> writeUserData(call, result)
      "writeUserProtectedData" -> writeUserProtectedData(call, result)
      "createWallet" -> createWallet(call, result)
      "purgeWallet" -> purgeWallet(call, result)
      "setPin1" -> setPin1(call, result)
      "setPin2" -> setPin2(call, result)
      "writeFiles" -> writeFiles(call, result)
      "readFiles" -> readFiles(call, result)
      "deleteFiles" -> deleteFiles(call, result)
      "changeFilesSettings" -> changeFilesSettings(call, result)
      "prepareHashes" -> prepareHashes(call, result)
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      else -> result.notImplemented()
    }
  }

  private fun scanCard(call: MethodCall, result: Result) {
    try {
      sdk.scanCard { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun sign(call: MethodCall, result: Result) {
    try {
      sdk.sign(hashes(call), null, cid(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun personalize(call: MethodCall, result: Result) {
    try {
      val cardConfig = extractObject("cardConfig", call, converter.gson, CardConfig::class.java)
      val issuer = extractPersonalizeObject("issuer", call, Issuer::class.java)
      val manufacturer = extractPersonalizeObject("manufacturer", call, Manufacturer::class.java)
      val acquirer = extractPersonalizeObject("acquirer", call, Acquirer::class.java)

      sdk.personalize(cardConfig, issuer, manufacturer, acquirer, message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun depersonalize(call: MethodCall, result: Result) {
    try {
      sdk.depersonalize(message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun createWallet(call: MethodCall, result: Result) {
    try {
      sdk.createWallet(null, null, cid(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun purgeWallet(call: MethodCall, result: Result) {
    try {
      sdk.purgeWallet(null, cid(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun readIssuerData(call: MethodCall, result: Result) {
    try {
      sdk.readIssuerData(cid(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun writeIssuerData(call: MethodCall, result: Result) {
    try {
      val issuerData = hexDataToBytes(call, "issuerData")
      val dataSignature = hexDataToBytes(call, "issuerDataSignature")
      val cardId = cid(call)
      val counter = issuerDataCounter(call)

      sdk.writeIssuerData(
          cardId,
          issuerData,
          dataSignature,
          counter,
          message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun readIssuerExtraData(call: MethodCall, result: Result) {
    try {
      sdk.readIssuerExtraData(cid(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun writeIssuerExtraData(call: MethodCall, result: Result) {
    try {
      // from app
      val issuerExData = hexDataToBytes(call, "issuerData")
      val startingSignature = hexDataToBytes(call, "startingSignature")
      val finalizingSignature = hexDataToBytes(call, "finalizingSignature")

      val cardId = cid(call)
      val dataCounter = issuerDataCounter(call) ?: 1

      sdk.writeIssuerExtraData(
          cardId,
          issuerExData,
          startingSignature,
          finalizingSignature,
          dataCounter,
          message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun readUserData(call: MethodCall, result: Result) {
    try {
      sdk.readUserData(cid(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun writeUserData(call: MethodCall, result: Result) {
    try {
      val userData = hexDataToBytes(call, "userData")
      sdk.writeUserData(cid(call), userData, userCounter(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun setPin1(call: MethodCall, result: Result) {
    try {
      sdk.changePin1(cid(call), pinCode(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun setPin2(call: MethodCall, result: Result) {
    try {
      sdk.changePin2(cid(call), pinCode(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun writeUserProtectedData(call: MethodCall, result: Result) {
    try {
      val userProtectedData = hexDataToBytes(call, "userProtectedData")
      sdk.writeUserProtectedData(cid(call), userProtectedData, userProtectedCounter(call), message(call)) {
        handleResult(result, it)
      }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun writeFiles(call: MethodCall, result: Result) {
    try {
      val filesList = extractFilesToWrite(call, result)
      sdk.writeFiles(filesList, cid(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun readFiles(call: MethodCall, result: Result) {
    try {
      val readPrivateFiles = call.argument<Boolean>("readPrivateFiles") ?: false
      val indices = call.argument<List<Int>>("indices")?.toList()
      sdk.readFiles(readPrivateFiles, indices, cid(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun deleteFiles(call: MethodCall, result: Result) {
    try {
      val indices = call.argument<List<Int>>("indices")?.toList()
      sdk.deleteFiles(indices, cid(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun changeFilesSettings(call: MethodCall, result: Result) {
    try {
      val listOfSettings = extractChangesOfFileSettings(call, result)
      sdk.changeFilesSettings(listOfSettings, cid(call), message(call)) { handleResult(result, it) }
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun prepareHashes(call: MethodCall, result: Result) {
    try {
      val cid = cid(call) !!
      val data = hexDataToBytes(call, "fileData")
      val counter = call.argument<Int>("fileCounter") !!
      val privateKey = hexDataToBytes(call, "privateKey")
      val fileHasData = sdk.prepareHashes(cid, data, counter, privateKey)
      handleResult(result, CompletionResult.Success(fileHasData))
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun allowsOnlyDebugCards(call: MethodCall, result: Result) {
    try {
      val name = "isAllowedOnlyDebugCards"
      assert(call, name)
      val allowedOnlyDebug = call.argument<Boolean>(name) !!
      val allowedCardTypes = if (allowedOnlyDebug) EnumSet.of(FirmwareType.Sdk) else EnumSet.allOf(FirmwareType::class.java)
      sdk.config.cardFilter.allowedCardTypes = allowedCardTypes
    } catch (ex: Exception) {
      handleException(result, ex)
    }
  }

  private fun handleResult(result: Result, completionResult: CompletionResult<*>) {
    if (replyAlreadySubmit) return
    replyAlreadySubmit = true

    when (completionResult) {
      is CompletionResult.Success -> {
        handler.post { result.success(converter.gson.toJson(completionResult.data)) }
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
          result.error("${error.code}", errorMessage, converter.gson.toJson(pluginError))
        }
      }
    }
  }

  private fun handleException(result: Result, ex: Exception) {
    if (replyAlreadySubmit) return
    replyAlreadySubmit = true

    handler.post {
      val code = 9999
      val localizedDescription: String = if (ex is JsonSyntaxException) ex.cause.toString() else ex.toString()
      result.error("$code", localizedDescription, converter.gson.toJson(PluginError(code, localizedDescription)))
    }
  }

  companion object {
    // Companion methods must be of two types:
    // for optional request => return if (fieldIsFound) foundField else null
    // for required parameters request => return if (fieldIsFound) foundField else throw NoSuchFieldException
    // All exceptions must be handled by an external representative.
    lateinit var wActivity: WeakReference<Activity>

    @Throws(Exception::class)
    fun message(call: MethodCall): Message? {
      if (! call.hasArgument("initialMessage")) return null

      val objMessage = call.argument<Any>("initialMessage")
      if (objMessage == null || objMessage !is Map<*, *>) return null

      val mapMessage = objMessage.map { (key, value) -> key.toString() to value.toString() }.toMap<String, String>()
      val header = mapMessage["header"] ?: ""
      val body = mapMessage["body"] ?: ""
      return Message(header, body)
    }

    @Throws(Exception::class)
    fun cid(call: MethodCall): String? {
      return call.argument<String>("cid")
    }

    @Throws(Exception::class)
    fun hashes(call: MethodCall): Array<ByteArray> {
      val name = "hashes"
      assert(call, name)

      val javaList = call.argument(name) as? ArrayList<String>?
      if (javaList == null || javaList.isEmpty()) throw NoSuchFieldException(name)

      return javaList.map { it.hexToBytes() }.toTypedArray()
    }

    @Throws(Exception::class)
    fun issuerDataCounter(call: MethodCall): Int? {
      return call.argument<Int>("issuerDataCounter")
    }

    fun userCounter(call: MethodCall): Int? {
      return call.argument<Int>("userCounter")
    }

    fun userProtectedCounter(call: MethodCall): Int? {
      return call.argument<Int>("userProtectedCounter")
    }

    fun pinCode(call: MethodCall): ByteArray? {
      if (! call.hasArgument("pinCode")) return null

      return call.argument<String>("pinCode")?.calculateSha256()
    }

    @Throws(Exception::class)
    private fun hexDataToBytes(call: MethodCall, name: String): ByteArray {
      assert(call, name)
      val hexString = call.argument<String>(name) !!
      return hexString.hexToBytes()
    }

    @Throws(Exception::class)
    private fun <T> extractObject(name: String, call: MethodCall, gson: Gson, type: Class<T>): T {
      if (! call.hasArgument(name)) throw NoSuchFieldException(name)

      val jsonString = call.argument<String>(name)
      return gson.fromJson(jsonString, type)
    }

    @Throws(Exception::class)
    private fun <T> extractPersonalizeObject(name: String, call: MethodCall, type: Class<T>): T {
      if (! call.hasArgument(name)) throw NoSuchFieldException(name)

      val gson = Gson()
      val mapType = object: TypeToken<MutableMap<String, Any?>>() {}.type
      val argMap: MutableMap<String, Any?> = gson.fromJson(call.argument<String>(name), mapType)
      val jsonString = when (name) {
        "issuer" -> {
          val dataKeyPair = gson.fromJson(argMap["dataKeyPair"].toString(), KeyPairHex::class.java)
          val transactionKeyPair = gson.fromJson(argMap["transactionKeyPair"].toString(), KeyPairHex::class.java)
          argMap["dataKeyPair"] = dataKeyPair.convert()
          argMap["transactionKeyPair"] = transactionKeyPair.convert()
          gson.toJson(argMap)
        }
        "manufacturer" -> {
          val keyPair = gson.fromJson(argMap["keyPair"].toString(), KeyPairHex::class.java)
          argMap["keyPair"] = keyPair.convert()
          gson.toJson(argMap)
        }
        "acquirer" -> {
          val keyPair = gson.fromJson(argMap["keyPair"].toString(), KeyPairHex::class.java)
          argMap["keyPair"] = keyPair.convert()
          gson.toJson(argMap)
        }
        else -> throw NoSuchFieldException(name)
      }
      return gson.fromJson(jsonString, type)
    }

    private fun extractFilesToWrite(call: MethodCall, result: Result): List<FileData> {
      val gson = Gson()
      val mapType = object: TypeToken<MutableList<MutableMap<String, Any>>>() {}.type
      val json = call.argument<String>("files")
      val rawList = gson.fromJson<MutableList<MutableMap<String, Any>>>(json, mapType)
      if (rawList.isEmpty()) return mutableListOf()

      val jsonList = rawList.map { gson.toJson(it) }
      return if (rawList[0].containsKey("signature")) {
        jsonList.map { gson.fromJson(it, FileDataHex.DataProtectedBySignatureHex::class.java) }.map { it.convert() }
      } else {
        jsonList.map { gson.fromJson(it, FileDataHex.DataProtectedByPasscodeHex::class.java) }.map { it.convert() }
      }
    }

    private fun extractChangesOfFileSettings(call: MethodCall, result: Result): List<FileSettingsChange> {
      val gson = Gson()
      val mapType = object: TypeToken<MutableList<MutableMap<String, Any>>>() {}.type
      val json = call.argument<String>("changes")
      val rawList = gson.fromJson<MutableList<MutableMap<String, Any>>>(json, mapType)
      if (rawList.isEmpty()) return mutableListOf()

      return rawList.map { gson.toJson(it) }.map { gson.fromJson(it, FileSettingsChange::class.java) }
    }

    @Throws(Exception::class)
    private fun assert(call: MethodCall, name: String) {
      if (! call.hasArgument(name)) throw NoSuchFieldException(name)
    }
  }
}

typealias HexString = String

data class PluginError(val code: Int, val localizedDescription: String)
data class KeyPairHex(val publicKey: HexString, val privateKey: HexString) {
  fun convert(): KeyPair = KeyPair(publicKey.hexToBytes(), privateKey.hexToBytes())
}

sealed class FileDataHex(val data: HexString) {
  class DataProtectedBySignatureHex(
      data: HexString,
      val counter: Int,
      val signature: FileDataSignatureHex,
      val issuerPublicKey: HexString? = null
  ): FileDataHex(data) {
    fun convert(): FileData.DataProtectedBySignature {
      return FileData.DataProtectedBySignature(data.hexToBytes(), counter, signature.convert(), issuerPublicKey?.hexToBytes())
    }
  }

  class DataProtectedByPasscodeHex(data: HexString): FileDataHex(data) {
    fun convert(): FileData.DataProtectedByPasscode = FileData.DataProtectedByPasscode(data.hexToBytes())
  }
}

class FileDataSignatureHex(
    val startingSignature: HexString,
    val finalizingSignature: HexString,
) {
  fun convert(): FileDataSignature = FileDataSignature(startingSignature.hexToBytes(), finalizingSignature.hexToBytes())
}