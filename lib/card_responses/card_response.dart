import 'package:json_annotation/json_annotation.dart';

part 'card_response.g.dart';

@JsonSerializable()
class CardResponse {
  CardDataResponse cardData;
  String cardId;
  String cardPublicKey;
  String curve;
  String firmwareVersion;
  int health;
  bool isActivated;
  String issuerPublicKey;
  String manufacturerName;
  int maxSignatures;
  int pauseBeforePin2;
  List<String> settingsMask;
  List<String> signingMethods;
  String status;
  bool terminalIsLinked;
  String walletPublicKey;
  int walletRemainingSignatures;
  int walletSignedHashes;

  CardResponse(
      {this.cardData,
      this.cardId,
      this.cardPublicKey,
      this.curve,
      this.firmwareVersion,
      this.health,
      this.isActivated,
      this.issuerPublicKey,
      this.manufacturerName,
      this.maxSignatures,
      this.pauseBeforePin2,
      this.settingsMask,
      this.signingMethods,
      this.status,
      this.terminalIsLinked,
      this.walletPublicKey,
      this.walletRemainingSignatures,
      this.walletSignedHashes});

  factory CardResponse.fromJson(Map<String, dynamic> json) => _$CardResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CardResponseToJson(this);
}

@JsonSerializable()
class CardDataResponse {
  final String batchId;
  final String blockchainName;
  final String issuerName;
  final String manufacturerSignature;
  final String manufactureDateTime;
  final List<String> productMask;
  @JsonKey(includeIfNull: false)
  final String tokenContractAddress;
  @JsonKey(includeIfNull: false)
  final String tokenSymbol;
  @JsonKey(includeIfNull: false)
  final int tokenDecimal;

  CardDataResponse({
    this.batchId,
    this.blockchainName,
    this.issuerName,
    this.manufacturerSignature,
    this.manufactureDateTime,
    this.productMask,
    this.tokenContractAddress,
    this.tokenSymbol,
    this.tokenDecimal,
  });

  factory CardDataResponse.fromJson(Map<String, dynamic> json) => _$CardDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CardDataResponseToJson(this);
}
