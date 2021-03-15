import 'package:json_annotation/json_annotation.dart';

part 'sdk.g.dart';

@JsonSerializable()
class CardConfigSdk {
  final String issuerName;
  final String acquirerName;
  final String series;
  final int startNumber;
  final int count;
  final List<int> pin;
  final List<int> pin2;
  final List<int> pin3;
  final String hexCrExKey;
  final String cvc;
  final int pauseBeforePin2;
  final bool smartSecurityDelay;
  final String curveID;
  final SigningMethodMaskSdk signingMethods;
  final int maxSignatures;
  final bool isReusable;
  final bool allowSetPIN1;
  final bool allowSetPIN2;
  final bool useActivation;
  final bool useCvc;
  final bool useNDEF;
  final bool useDynamicNDEF;
  final bool useOneCommandAtTime;
  final bool useBlock;
  final bool allowSelectBlockchain;
  final bool prohibitPurgeWallet;
  final bool allowUnencrypted;
  final bool allowFastEncryption;
  final bool protectIssuerDataAgainstReplay;
  final bool prohibitDefaultPIN1;
  final bool disablePrecomputedNDEF;
  final bool skipSecurityDelayIfValidatedByIssuer;
  final bool skipCheckPIN2CVCIfValidatedByIssuer;
  final bool skipSecurityDelayIfValidatedByLinkedTerminal;
  final bool restrictOverwriteIssuerExtraData;
  final bool requireTerminalTxSignature;
  final bool requireTerminalCertSignature;
  final bool checkPIN3OnCard;
  final bool createWallet;
  final int walletsCount;
  final CardDataSdk cardData;
  final List<NdefRecordSdk> ndefRecords;

  CardConfigSdk({
    this.issuerName,
    this.acquirerName,
    this.series,
    this.startNumber,
    this.count,
    this.pin,
    this.pin2,
    this.pin3,
    this.hexCrExKey,
    this.cvc,
    this.pauseBeforePin2,
    this.smartSecurityDelay,
    this.curveID,
    this.signingMethods,
    this.maxSignatures,
    this.isReusable,
    this.allowSetPIN1,
    this.allowSetPIN2,
    this.useActivation,
    this.useCvc,
    this.useNDEF,
    this.useDynamicNDEF,
    this.useOneCommandAtTime,
    this.useBlock,
    this.allowSelectBlockchain,
    this.prohibitPurgeWallet,
    this.allowUnencrypted,
    this.allowFastEncryption,
    this.protectIssuerDataAgainstReplay,
    this.prohibitDefaultPIN1,
    this.disablePrecomputedNDEF,
    this.skipSecurityDelayIfValidatedByIssuer,
    this.skipCheckPIN2CVCIfValidatedByIssuer,
    this.skipSecurityDelayIfValidatedByLinkedTerminal,
    this.restrictOverwriteIssuerExtraData,
    this.requireTerminalTxSignature,
    this.requireTerminalCertSignature,
    this.checkPIN3OnCard,
    this.createWallet,
    this.walletsCount,
    this.cardData,
    this.ndefRecords,
  });

  factory CardConfigSdk.fromJson(Map<String, dynamic> json) => _$CardConfigSdkFromJson(json);

  Map<String, dynamic> toJson() => _$CardConfigSdkToJson(this);
}

@JsonSerializable()
class Issuer {
  final String name;
  final String id;
  final KeyPairHex dataKeyPair;
  final KeyPairHex transactionKeyPair;

  Issuer(this.name, this.id, this.dataKeyPair, this.transactionKeyPair);

  factory Issuer.fromJson(Map<String, dynamic> json) => _$IssuerFromJson(json);

  Map<String, dynamic> toJson() => _$IssuerToJson(this);
}

@JsonSerializable()
class Acquirer {
  final String name;
  final String id;
  final KeyPairHex keyPair;

  Acquirer(this.name, this.id, this.keyPair);

  factory Acquirer.fromJson(Map<String, dynamic> json) => _$AcquirerFromJson(json);

  Map<String, dynamic> toJson() => _$AcquirerToJson(this);
}

@JsonSerializable()
class Manufacturer {
  final String name;
  final KeyPairHex keyPair;

  Manufacturer(this.name, this.keyPair);

  factory Manufacturer.fromJson(Map<String, dynamic> json) => _$ManufacturerFromJson(json);

  Map<String, dynamic> toJson() => _$ManufacturerToJson(this);
}

@JsonSerializable()
class KeyPairHex {
  final String publicKey;
  final String privateKey;

  KeyPairHex(this.publicKey, this.privateKey);

  factory KeyPairHex.fromJson(Map<String, dynamic> json) => _$KeyPairHexFromJson(json);

  Map<String, dynamic> toJson() => _$KeyPairHexToJson(this);
}

@JsonSerializable()
class CardDataSdk {
  final String issuerName;
  final String batchId;
  final String blockchainName;
  @JsonKey(includeIfNull: false)
  final String tokenSymbol;
  @JsonKey(includeIfNull: false)
  final String tokenContractAddress;
  @JsonKey(includeIfNull: false)
  final int tokenDecimal;
  @JsonKey(includeIfNull: false)
  final List<int> manufacturerSignature;
  final String manufactureDateTime;
  final ProductMaskSdk productMask;

  CardDataSdk({
    this.productMask,
    this.issuerName,
    this.manufacturerSignature,
    this.batchId,
    this.blockchainName,
    this.manufactureDateTime,
    this.tokenSymbol,
    this.tokenContractAddress,
    this.tokenDecimal,
  });

  factory CardDataSdk.fromJson(Map<String, dynamic> json) => _$CardDataSdkFromJson(json);

  Map<String, dynamic> toJson() => _$CardDataSdkToJson(this);
}

@JsonSerializable()
class SigningMethodMaskSdk {
  final int rawValue;

  SigningMethodMaskSdk(this.rawValue);

  factory SigningMethodMaskSdk.fromJson(Map<String, dynamic> json) => _$SigningMethodMaskSdkFromJson(json);

  Map<String, dynamic> toJson() => _$SigningMethodMaskSdkToJson(this);
}

@JsonSerializable()
class ProductMaskSdk {
  final int rawValue;

  ProductMaskSdk(this.rawValue);

  factory ProductMaskSdk.fromJson(Map<String, dynamic> json) => _$ProductMaskSdkFromJson(json);

  Map<String, dynamic> toJson() => _$ProductMaskSdkToJson(this);
}

@JsonSerializable()
class NdefRecordSdk {
  final String type;
  final String value;

  NdefRecordSdk({this.type, this.value});

  factory NdefRecordSdk.fromJson(Map<String, dynamic> json) => _$NdefRecordSdkFromJson(json);

  Map<String, dynamic> toJson() => _$NdefRecordSdkToJson(this);
}

enum PinType { PIN1, PIN2, PIN3 }

abstract class FileDataHex {
  final String data;

  FileDataHex(this.data);
}

@JsonSerializable()
class DataProtectedByPasscodeHex extends FileDataHex {
  DataProtectedByPasscodeHex(String data) : super(data);

  factory DataProtectedByPasscodeHex.fromJson(Map<String, dynamic> json) => _$DataProtectedByPasscodeHexFromJson(json);

  Map<String, dynamic> toJson() => _$DataProtectedByPasscodeHexToJson(this);
}

@JsonSerializable()
class DataProtectedBySignatureHex extends FileDataHex {
  final int counter;
  @JsonKey(nullable: false)
  final FileDataSignatureHex signature;
  @JsonKey(nullable: true)
  final String issuerPublicKey;

  DataProtectedBySignatureHex(String data, this.counter, this.signature, [this.issuerPublicKey]) : super(data);

  factory DataProtectedBySignatureHex.fromJson(Map<String, dynamic> json) =>
      _$DataProtectedBySignatureHexFromJson(json);

  Map<String, dynamic> toJson() => _$DataProtectedBySignatureHexToJson(this);
}

@JsonSerializable()
class FileDataSignatureHex {
  final String startingSignature;
  final String finalizingSignature;

  FileDataSignatureHex(this.startingSignature, this.finalizingSignature);

  factory FileDataSignatureHex.fromJson(Map<String, dynamic> json) => _$FileDataSignatureHexFromJson(json);

  Map<String, dynamic> toJson() => _$FileDataSignatureHexToJson(this);
}
