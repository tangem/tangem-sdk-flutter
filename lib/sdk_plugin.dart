import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tangem_sdk/model/json_rpc.dart';
import 'package:tangem_sdk/plugin_error.dart';

import 'model/sdk.dart';

/// Flutter TangemSdk is an interface which provides access to platform specific TangemSdk library.
/// The response from the successfully completed execution of the 'channel method' is expected in the json.
/// If an error occurs within the 'channel method', it is expected PlatformException converter to the json.
class TangemSdk {
  static const MethodChannel _channel = const MethodChannel('tangemSdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future allowsOnlyDebugCards(bool isAllowed) {
    return _channel.invokeMethod("allowsOnlyDebugCards", {"isAllowedOnlyDebugCards": isAllowed});
  }

  static Future runJSONRPCRequest(
      Callback callback,
      String request, [
        String? cardId,
        Message? initialMessage,
        String? accessCode,
      ]) async {
    final valuesToExport = <String, dynamic>{"JSONRPCRequest": request};
    if (cardId != null) valuesToExport["cardId"] = cardId;
    if (initialMessage != null) valuesToExport["initialMessage"] = initialMessage.toJson();
    if (accessCode != null) valuesToExport["accessCode"] = accessCode;

    _channel
        .invokeMethod("runJSONRPCRequest", valuesToExport)
        .then((result) => callback.onSuccess(result))
        .catchError((error) => _sendBackError(callback, error));
  }

  static _sendBackError(Callback callback, dynamic error) {
    callback.onError(TangemSdkPluginError.createError(error));
  }
}

class Callback {
  final Function(dynamic success) onSuccess;
  final Function(dynamic error) onError;

  Callback(this.onSuccess, this.onError);
}
