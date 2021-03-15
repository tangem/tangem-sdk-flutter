// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignResponse _$SignResponseFromJson(Map<String, dynamic> json) {
  return SignResponse(
    cardId: json['cardId'] as String,
    signature: json['signature'] as String,
    walletRemainingSignatures: json['walletRemainingSignatures'] as int,
    walletSignedHashes: json['walletSignedHashes'] as int,
  );
}

Map<String, dynamic> _$SignResponseToJson(SignResponse instance) => <String, dynamic>{
      'cardId': instance.cardId,
      'signature': instance.signature,
      'walletRemainingSignatures': instance.walletRemainingSignatures,
      'walletSignedHashes': instance.walletSignedHashes,
    };

DepersonalizeResponse _$DepersonalizeResponseFromJson(Map<String, dynamic> json) {
  return DepersonalizeResponse(
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$DepersonalizeResponseToJson(DepersonalizeResponse instance) => <String, dynamic>{
      'success': instance.success,
    };

CreateWalletResponse _$CreateWalletResponseFromJson(Map<String, dynamic> json) {
  return CreateWalletResponse(
    json['cardId'] as String,
    json['status'] as String,
    json['walletPublicKey'] as String,
  );
}

Map<String, dynamic> _$CreateWalletResponseToJson(CreateWalletResponse instance) => <String, dynamic>{
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

Map<String, dynamic> _$PurgeWalletResponseToJson(PurgeWalletResponse instance) => <String, dynamic>{
      'cardId': instance.cardId,
      'status': instance.status,
    };

ReadIssuerDataResponse _$ReadIssuerDataResponseFromJson(Map<String, dynamic> json) {
  return ReadIssuerDataResponse(
    json['cardId'] as String,
    json['issuerData'] as String,
    json['issuerDataSignature'] as String,
    json['issuerDataCounter'] as int,
  );
}

Map<String, dynamic> _$ReadIssuerDataResponseToJson(ReadIssuerDataResponse instance) => <String, dynamic>{
      'cardId': instance.cardId,
      'issuerData': instance.issuerData,
      'issuerDataSignature': instance.issuerDataSignature,
      'issuerDataCounter': instance.issuerDataCounter,
    };

WriteIssuerDataResponse _$WriteIssuerDataResponseFromJson(Map<String, dynamic> json) {
  return WriteIssuerDataResponse(
    json['cardId'] as String,
  );
}

Map<String, dynamic> _$WriteIssuerDataResponseToJson(WriteIssuerDataResponse instance) => <String, dynamic>{
      'cardId': instance.cardId,
    };

ReadIssuerExDataResponse _$ReadIssuerExDataResponseFromJson(Map<String, dynamic> json) {
  return ReadIssuerExDataResponse(
    json['cardId'] as String,
    json['size'] as int,
    json['issuerData'] as String,
    json['issuerDataSignature'] as String,
    json['issuerDataCounter'] as int,
  );
}

Map<String, dynamic> _$ReadIssuerExDataResponseToJson(ReadIssuerExDataResponse instance) => <String, dynamic>{
      'cardId': instance.cardId,
      'size': instance.size,
      'issuerData': instance.issuerData,
      'issuerDataSignature': instance.issuerDataSignature,
      'issuerDataCounter': instance.issuerDataCounter,
    };

WriteIssuerExDataResponse _$WriteIssuerExDataResponseFromJson(Map<String, dynamic> json) {
  return WriteIssuerExDataResponse(
    json['cardId'] as String,
  );
}

Map<String, dynamic> _$WriteIssuerExDataResponseToJson(WriteIssuerExDataResponse instance) => <String, dynamic>{
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

Map<String, dynamic> _$ReadUserDataResponseToJson(ReadUserDataResponse instance) => <String, dynamic>{
      'cardId': instance.cardId,
      'userData': instance.userData,
      'userCounter': instance.userCounter,
      'userProtectedData': instance.userProtectedData,
      'userProtectedCounter': instance.userProtectedCounter,
    };

WriteUserDataResponse _$WriteUserDataResponseFromJson(Map<String, dynamic> json) {
  return WriteUserDataResponse(
    json['cardId'] as String,
  );
}

Map<String, dynamic> _$WriteUserDataResponseToJson(WriteUserDataResponse instance) => <String, dynamic>{
      'cardId': instance.cardId,
    };

SetPinResponse _$SetPinResponseFromJson(Map<String, dynamic> json) {
  return SetPinResponse(
    json['cardId'] as String,
    json['status'] as String,
  );
}

Map<String, dynamic> _$SetPinResponseToJson(SetPinResponse instance) => <String, dynamic>{
      'cardId': instance.cardId,
      'status': instance.status,
    };

FileHashDataHex _$FileHashDataHexFromJson(Map<String, dynamic> json) {
  return FileHashDataHex(
    json['startingHash'] as String,
    json['finalizingHash'] as String,
    json['startingSignature'] as String,
    json['finalizingSignature'] as String,
  );
}

Map<String, dynamic> _$FileHashDataHexToJson(FileHashDataHex instance) => <String, dynamic>{
      'startingHash': instance.startingHash,
      'finalizingHash': instance.finalizingHash,
      'startingSignature': instance.startingSignature,
      'finalizingSignature': instance.finalizingSignature,
    };

WriteFilesResponse _$WriteFilesResponseFromJson(Map<String, dynamic> json) {
  return WriteFilesResponse(
    json['cardId'] as String,
    json['fileIndex'] as int,
  );
}

Map<String, dynamic> _$WriteFilesResponseToJson(WriteFilesResponse instance) => <String, dynamic>{
      'cardId': instance.cardId,
      'fileIndex': instance.fileIndex,
    };

ReadFilesResponse _$ReadFilesResponseFromJson(Map<String, dynamic> json) {
  return ReadFilesResponse(
    (json['files'] as List)?.map((e) => e == null ? null : FileHex.fromJson(e as Map<String, dynamic>))?.toList(),
  );
}

Map<String, dynamic> _$ReadFilesResponseToJson(ReadFilesResponse instance) => <String, dynamic>{
      'files': instance.files,
    };

FileHex _$FileHexFromJson(Map<String, dynamic> json) {
  return FileHex(
    json['fileIndex'] as int,
    json['fileData'] as String,
    _$enumDecodeNullable(_$FileSettingsEnumMap, json['fileSettings']),
  );
}

Map<String, dynamic> _$FileHexToJson(FileHex instance) => <String, dynamic>{
      'fileIndex': instance.fileIndex,
      'fileData': instance.fileData,
      'fileSettings': _$FileSettingsEnumMap[instance.fileSettings],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries.singleWhere((e) => e.value == source, orElse: () => null)?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$FileSettingsEnumMap = {
  FileSettings.Public: 'Public',
  FileSettings.Private: 'Private',
};

ChangeFileSettings _$ChangeFileSettingsFromJson(Map<String, dynamic> json) {
  return ChangeFileSettings(
    json['fileIndex'] as int,
    _$enumDecodeNullable(_$FileSettingsEnumMap, json['settings']),
  );
}

Map<String, dynamic> _$ChangeFileSettingsToJson(ChangeFileSettings instance) => <String, dynamic>{
      'fileIndex': instance.fileIndex,
      'settings': _$FileSettingsEnumMap[instance.settings],
    };

DeleteFilesResponse _$DeleteFilesResponseFromJson(Map<String, dynamic> json) {
  return DeleteFilesResponse(
    json['cardId'] as String,
  );
}

Map<String, dynamic> _$DeleteFilesResponseToJson(DeleteFilesResponse instance) => <String, dynamic>{
  'cardId': instance.cardId,
};

ChangeFilesSettingsResponse _$ChangeFilesSettingsResponseFromJson(Map<String, dynamic> json) {
  return ChangeFilesSettingsResponse(
    json['cardId'] as String,
  );
}

Map<String, dynamic> _$ChangeFilesSettingsResponseToJson(ChangeFilesSettingsResponse instance) => <String, dynamic>{
  'cardId': instance.cardId,
};