import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:tangem_sdk/card_responses/card_response.dart';

import 'card_responses/other_responses.dart';
import 'model/sdk.dart';

/// Flutter TangemSdk is an interface which provides access to platform specific TangemSdk library.
/// The response from the successfully completed execution of the 'channel method' is expected in the json.
/// If an error occurs within the 'channel method', it is expected PlatformException converter to the json.
class TangemSdk {
  static const cScanCard = 'scanCard';
  static const cSign = 'sign';
  static const cPersonalize = 'personalize';
  static const cDepersonalize = 'depersonalize';
  static const cCreateWallet = 'createWallet';
  static const cPurgeWallet = 'purgeWallet';
  static const cReadIssuerData = 'readIssuerData';
  static const cWriteIssuerData = 'writeIssuerData';
  static const cReadIssuerExData = 'readIssuerExData';
  static const cWriteIssuerExData = 'writeIssuerExData';
  static const cReadUserData = 'readUserData';
  static const cWriteUserData = 'writeUserData';
  static const cWriteUserProtectedData = 'writeUserProtectedData';
  static const cSetPin1 = 'setPin1';
  static const cSetPin2 = 'setPin2';

  static const isAllowedOnlyDebugCards = "isAllowedOnlyDebugCards";
  static const cid = "cid";
  static const initialMessage = "initialMessage";
  static const initialMessageHeader = "header";
  static const initialMessageBody = "body";
  static const hashes = "hashes";
  static const cardConfig = "cardConfig";
  static const issuer = "issuer";
  static const manufacturer = "manufacturer";
  static const acquirer = "acquirer";
  static const issuerData = "issuerData";
  static const issuerDataSignature = "issuerDataSignature";
  static const startingSignature = "startingSignature";
  static const finalizingSignature = "finalizingSignature";
  static const issuerDataCounter = "issuerDataCounter";
  static const userData = "userData";
  static const userCounter = "userCounter";
  static const userProtectedData = "userProtectedData";
  static const userProtectedCounter = "userProtectedCounter";
  static const pinCode = "pinCode";

  static const MethodChannel _channel = const MethodChannel('tangemSdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future allowsOnlyDebugCards(bool isAllowed) {
    return _channel.invokeMethod("allowsOnlyDebugCards", {isAllowedOnlyDebugCards: isAllowed});
  }

  static Future scanCard(Callback callback, [Map<String, dynamic> valuesToExport]) async {
    _channel
        .invokeMethod(cScanCard, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cScanCard, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  static Future sign(Callback callback, List<String> hashesHex, [Map<String, dynamic> valuesToExport]) async {
    valuesToExport[hashes] = hashesHex;
    _channel
        .invokeMethod(cSign, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cSign, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  // static Future personalize(Callback callback, [Map<String, dynamic> valuesToExport]) async {
  //   _channel
  //       .invokeMethod(cPersonalize, valuesToExport)
  //       .then((result) => callback.onSuccess(_createResponse(cPersonalize, result)))
  //       .catchError((error) => _sendBackError(callback, error));
  // }

  // static Future depersonalize(Callback callback, [Map<String, dynamic> valuesToExport]) async {
  //   _channel
  //       .invokeMethod(cDepersonalize, valuesToExport)
  //       .then((result) => callback.onSuccess(_createResponse(cDepersonalize, result)))
  //       .catchError((error) => _sendBackError(callback, error));
  // }

  static Future createWallet(Callback callback, [Map<String, dynamic> valuesToExport]) async {
    _channel
        .invokeMethod(cCreateWallet, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cCreateWallet, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  static Future purgeWallet(Callback callback, [Map<String, dynamic> valuesToExport]) async {
    _channel
        .invokeMethod(cPurgeWallet, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cPurgeWallet, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  static Future readIssuerData(Callback callback, [Map<String, dynamic> valuesToExport]) async {
    _channel
        .invokeMethod(cReadIssuerData, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cReadIssuerData, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  static Future writeIssuerData(Callback callback, String issuerDataHex, String issuerDataSignatureHex,
      [Map<String, dynamic> valuesToExport]) async {
    valuesToExport[issuerData] = issuerDataHex;
    valuesToExport[issuerDataSignature] = issuerDataSignatureHex;
    _channel
        .invokeMethod(cWriteIssuerData, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cWriteIssuerData, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  static Future readUserData(Callback callback, [Map<String, dynamic> valuesToExport]) async {
    _channel
        .invokeMethod(cReadUserData, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cReadUserData, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  static Future writeUserData(Callback callback, String userDataHex, [Map<String, dynamic> valuesToExport]) async {
    valuesToExport[userData] = userDataHex;
    _channel
        .invokeMethod(cWriteUserData, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cWriteUserData, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  static Future writeUserProtectedData(Callback callback, String userProtectedDataHex,
      [Map<String, dynamic> valuesToExport]) async {
    valuesToExport[userProtectedData] = userProtectedDataHex;
    _channel
        .invokeMethod(cWriteUserProtectedData, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cWriteUserData, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  static Future readIssuerExtraData(Callback callback, [Map<String, dynamic> valuesToExport]) async {
    _channel
        .invokeMethod(cReadIssuerExData, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cReadIssuerExData, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  static Future writeIssuerExtraData(
      Callback callback, String issuerDataHex, String startingSignatureHex, String finalizingSignatureHex,
      [Map<String, dynamic> valuesToExport]) async {
    valuesToExport[issuerData] = issuerDataHex;
    valuesToExport[startingSignature] = startingSignatureHex;
    valuesToExport[finalizingSignature] = finalizingSignatureHex;
    _channel
        .invokeMethod(cWriteIssuerExData, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cWriteIssuerExData, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  static Future setPinCode(PinType pinType, Callback callback, [Map<String, dynamic> valuesToExport]) async {
    final cPinMethod = pinType == PinType.PIN1 ? cSetPin1 : cSetPin2;
    _channel
        .invokeMethod(cPinMethod, valuesToExport)
        .then((result) => callback.onSuccess(_createResponse(cPinMethod, result)))
        .catchError((error) => _sendBackError(callback, error));
  }

  static dynamic _createResponse(String name, dynamic response) {
    final jsonResponse = jsonDecode(response);

    switch (name) {
      case cScanCard:
        return CardResponse.fromJson(jsonResponse);
      case cSign:
        return SignResponse.fromJson(jsonResponse);
      case cPersonalize:
        return CardResponse.fromJson(jsonResponse);
      case cDepersonalize:
        return DepersonalizeResponse.fromJson(jsonResponse);
      case cCreateWallet:
        return CreateWalletResponse.fromJson(jsonResponse);
      case cPurgeWallet:
        return PurgeWalletResponse.fromJson(jsonResponse);
      case cReadIssuerData:
        return ReadIssuerDataResponse.fromJson(jsonResponse);
      case cWriteIssuerData:
        return WriteIssuerDataResponse.fromJson(jsonResponse);
      case cReadIssuerExData:
        return ReadIssuerExDataResponse.fromJson(jsonResponse);
      case cWriteIssuerExData:
        return WriteIssuerExDataResponse.fromJson(jsonResponse);
      case cReadUserData:
        return ReadUserDataResponse.fromJson(jsonResponse);
      case cWriteUserData:
        return WriteUserDataResponse.fromJson(jsonResponse);
      case cWriteUserProtectedData:
        return WriteUserDataResponse.fromJson(jsonResponse);
      case cSetPin1:
        return SetPinResponse.fromJson(jsonResponse);
      case cSetPin2:
        return SetPinResponse.fromJson(jsonResponse);
    }
    return response;
  }

  static _sendBackError(Callback callback, PlatformException ex) {
    final error = ErrorResponse.fromException(ex);
    callback.onError(error);
  }
}

class Callback {
  final Function(dynamic success) onSuccess;
  final Function(dynamic error) onError;

  Callback(this.onSuccess, this.onError);
}
