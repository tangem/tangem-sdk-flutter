// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) {
  return ErrorResponse(
    code: json['code'] as int,
    localizedDescription: json['localizedDescription'] as String,
  );
}

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'localizedDescription': instance.localizedDescription,
    };

SignResponse _$SignResponseFromJson(Map<String, dynamic> json) {
  return SignResponse(
    cardId: json['cardId'] as String,
    signature: json['signature'] as String,
    walletRemainingSignatures: json['walletRemainingSignatures'] as int,
    walletSignedHashes: json['walletSignedHashes'] as int,
  );
}

Map<String, dynamic> _$SignResponseToJson(SignResponse instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'signature': instance.signature,
      'walletRemainingSignatures': instance.walletRemainingSignatures,
      'walletSignedHashes': instance.walletSignedHashes,
    };

DepersonalizeResponse _$DepersonalizeResponseFromJson(
    Map<String, dynamic> json) {
  return DepersonalizeResponse(
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$DepersonalizeResponseToJson(
        DepersonalizeResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
    };

CreateWalletResponse _$CreateWalletResponseFromJson(Map<String, dynamic> json) {
  return CreateWalletResponse(
    json['cardId'] as String,
    json['status'] as String,
    json['walletPublicKey'] as String,
  );
}

Map<String, dynamic> _$CreateWalletResponseToJson(
        CreateWalletResponse instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'status': instance.status,
      'walletPublicKey': instance.walletPublicKey,
    };

PurgeWalletResponse _$PurgeWalletResponseFromJson(Map<String, dynamic> json) {
  return PurgeWalletResponse(
    json['cardId'] as String,
    json['status'] as String,
  );
}

Map<String, dynamic> _$PurgeWalletResponseToJson(
        PurgeWalletResponse instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'status': instance.status,
    };

ReadIssuerDataResponse _$ReadIssuerDataResponseFromJson(
    Map<String, dynamic> json) {
  return ReadIssuerDataResponse(
    json['cardId'] as String,
    json['issuerData'] as String,
    json['issuerDataSignature'] as String,
    json['issuerDataCounter'] as int,
  );
}

Map<String, dynamic> _$ReadIssuerDataResponseToJson(
        ReadIssuerDataResponse instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'issuerData': instance.issuerData,
      'issuerDataSignature': instance.issuerDataSignature,
      'issuerDataCounter': instance.issuerDataCounter,
    };

WriteIssuerDataResponse _$WriteIssuerDataResponseFromJson(
    Map<String, dynamic> json) {
  return WriteIssuerDataResponse(
    json['cardId'] as String,
  );
}

Map<String, dynamic> _$WriteIssuerDataResponseToJson(
        WriteIssuerDataResponse instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
    };

ReadIssuerExDataResponse _$ReadIssuerExDataResponseFromJson(
    Map<String, dynamic> json) {
  return ReadIssuerExDataResponse(
    json['cardId'] as String,
    json['size'] as int,
    json['issuerData'] as String,
    json['issuerDataSignature'] as String,
    json['issuerDataCounter'] as int,
  );
}

Map<String, dynamic> _$ReadIssuerExDataResponseToJson(
        ReadIssuerExDataResponse instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'size': instance.size,
      'issuerData': instance.issuerData,
      'issuerDataSignature': instance.issuerDataSignature,
      'issuerDataCounter': instance.issuerDataCounter,
    };

WriteIssuerExDataResponse _$WriteIssuerExDataResponseFromJson(
    Map<String, dynamic> json) {
  return WriteIssuerExDataResponse(
    json['cardId'] as String,
  );
}

Map<String, dynamic> _$WriteIssuerExDataResponseToJson(
        WriteIssuerExDataResponse instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
    };

ReadUserDataResponse _$ReadUserDataResponseFromJson(Map<String, dynamic> json) {
  return ReadUserDataResponse(
    json['cardId'] as String,
    json['userData'] as String,
    json['userProtectedData'] as String,
    json['userCounter'] as int,
    json['userProtectedCounter'] as int,
  );
}

Map<String, dynamic> _$ReadUserDataResponseToJson(
        ReadUserDataResponse instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'userData': instance.userData,
      'userCounter': instance.userCounter,
      'userProtectedData': instance.userProtectedData,
      'userProtectedCounter': instance.userProtectedCounter,
    };

WriteUserDataResponse _$WriteUserDataResponseFromJson(
    Map<String, dynamic> json) {
  return WriteUserDataResponse(
    json['cardId'] as String,
  );
}

Map<String, dynamic> _$WriteUserDataResponseToJson(
        WriteUserDataResponse instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
    };

SetPinResponse _$SetPinResponseFromJson(Map<String, dynamic> json) {
  return SetPinResponse(
    json['cardId'] as String,
    json['status'] as String,
  );
}

Map<String, dynamic> _$SetPinResponseToJson(SetPinResponse instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'status': instance.status,
    };
