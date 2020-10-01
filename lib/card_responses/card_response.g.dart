// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardResponse _$CardResponseFromJson(Map<String, dynamic> json) {
  return CardResponse(
    cardData: json['cardData'] == null
        ? null
        : CardDataResponse.fromJson(json['cardData'] as Map<String, dynamic>),
    cardId: json['cardId'] as String,
    cardPublicKey: json['cardPublicKey'] as String,
    curve: json['curve'] as String,
    firmwareVersion: json['firmwareVersion'] as String,
    health: json['health'] as int,
    isActivated: json['isActivated'] as bool,
    issuerPublicKey: json['issuerPublicKey'] as String,
    manufacturerName: json['manufacturerName'] as String,
    maxSignatures: json['maxSignatures'] as int,
    pauseBeforePin2: json['pauseBeforePin2'] as int,
    settingsMask:
        (json['settingsMask'] as List)?.map((e) => e as String)?.toList(),
    signingMethods:
        (json['signingMethods'] as List)?.map((e) => e as String)?.toList(),
    status: json['status'] as String,
    terminalIsLinked: json['terminalIsLinked'] as bool,
    walletPublicKey: json['walletPublicKey'] as String,
    walletRemainingSignatures: json['walletRemainingSignatures'] as int,
    walletSignedHashes: json['walletSignedHashes'] as int,
  );
}

Map<String, dynamic> _$CardResponseToJson(CardResponse instance) =>
    <String, dynamic>{
      'cardData': instance.cardData,
      'cardId': instance.cardId,
      'cardPublicKey': instance.cardPublicKey,
      'curve': instance.curve,
      'firmwareVersion': instance.firmwareVersion,
      'health': instance.health,
      'isActivated': instance.isActivated,
      'issuerPublicKey': instance.issuerPublicKey,
      'manufacturerName': instance.manufacturerName,
      'maxSignatures': instance.maxSignatures,
      'pauseBeforePin2': instance.pauseBeforePin2,
      'settingsMask': instance.settingsMask,
      'signingMethods': instance.signingMethods,
      'status': instance.status,
      'terminalIsLinked': instance.terminalIsLinked,
      'walletPublicKey': instance.walletPublicKey,
      'walletRemainingSignatures': instance.walletRemainingSignatures,
      'walletSignedHashes': instance.walletSignedHashes,
    };

CardDataResponse _$CardDataResponseFromJson(Map<String, dynamic> json) {
  return CardDataResponse(
    batchId: json['batchId'] as String,
    blockchainName: json['blockchainName'] as String,
    issuerName: json['issuerName'] as String,
    manufacturerSignature: json['manufacturerSignature'] as String,
    manufactureDateTime: json['manufactureDateTime'] as String,
    productMask:
        (json['productMask'] as List)?.map((e) => e as String)?.toList(),
    tokenContractAddress: json['tokenContractAddress'] as String,
    tokenSymbol: json['tokenSymbol'] as String,
    tokenDecimal: json['tokenDecimal'] as int,
  );
}

Map<String, dynamic> _$CardDataResponseToJson(CardDataResponse instance) {
  final val = <String, dynamic>{
    'batchId': instance.batchId,
    'blockchainName': instance.blockchainName,
    'issuerName': instance.issuerName,
    'manufacturerSignature': instance.manufacturerSignature,
    'manufactureDateTime': instance.manufactureDateTime,
    'productMask': instance.productMask,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tokenContractAddress', instance.tokenContractAddress);
  writeNotNull('tokenSymbol', instance.tokenSymbol);
  writeNotNull('tokenDecimal', instance.tokenDecimal);
  return val;
}
