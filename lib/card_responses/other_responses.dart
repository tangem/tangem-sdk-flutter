import 'package:json_annotation/json_annotation.dart';

part 'other_responses.g.dart';

@JsonSerializable(nullable: false)
class SignResponse {
  String cardId;
  String signature;
  int walletRemainingSignatures;
  int walletSignedHashes;

  SignResponse({this.cardId, this.signature, this.walletRemainingSignatures, this.walletSignedHashes});

  factory SignResponse.fromJson(Map<String, dynamic> json) => _$SignResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignResponseToJson(this);
}

@JsonSerializable(nullable: false)
class DepersonalizeResponse {
  bool success;

  DepersonalizeResponse({this.success});

  factory DepersonalizeResponse.fromJson(Map<String, dynamic> json) => _$DepersonalizeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DepersonalizeResponseToJson(this);
}

@JsonSerializable(nullable: false)
class CreateWalletResponse {
  final String cardId;
  final String status;
  final String walletPublicKey;

  CreateWalletResponse(this.cardId, this.status, this.walletPublicKey);

  factory CreateWalletResponse.fromJson(Map<String, dynamic> json) => _$CreateWalletResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateWalletResponseToJson(this);
}

@JsonSerializable(nullable: false)
class PurgeWalletResponse {
  final String cardId;
  final String status;

  PurgeWalletResponse(this.cardId, this.status);

  factory PurgeWalletResponse.fromJson(Map<String, dynamic> json) => _$PurgeWalletResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PurgeWalletResponseToJson(this);
}

@JsonSerializable()
class ReadIssuerDataResponse {
  final String cardId;
  final String issuerData;
  final String issuerDataSignature;
  final int issuerDataCounter;

  ReadIssuerDataResponse(this.cardId, this.issuerData, this.issuerDataSignature, this.issuerDataCounter);

  factory ReadIssuerDataResponse.fromJson(Map<String, dynamic> json) => _$ReadIssuerDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReadIssuerDataResponseToJson(this);
}

@JsonSerializable()
class WriteIssuerDataResponse {
  final String cardId;

  WriteIssuerDataResponse(this.cardId);

  factory WriteIssuerDataResponse.fromJson(Map<String, dynamic> json) => _$WriteIssuerDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WriteIssuerDataResponseToJson(this);
}

@JsonSerializable()
class ReadIssuerExDataResponse {
  final String cardId;
  final int size;
  final String issuerData;
  final String issuerDataSignature;
  final int issuerDataCounter;

  ReadIssuerExDataResponse(this.cardId, this.size, this.issuerData, this.issuerDataSignature, this.issuerDataCounter);

  factory ReadIssuerExDataResponse.fromJson(Map<String, dynamic> json) => _$ReadIssuerExDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReadIssuerExDataResponseToJson(this);
}

@JsonSerializable()
class WriteIssuerExDataResponse {
  final String cardId;

  WriteIssuerExDataResponse(this.cardId);

  factory WriteIssuerExDataResponse.fromJson(Map<String, dynamic> json) => _$WriteIssuerExDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WriteIssuerExDataResponseToJson(this);
}

@JsonSerializable()
class ReadUserDataResponse {
  final String cardId;
  final String userData;
  final int userCounter;
  final String userProtectedData;
  final int userProtectedCounter;

  ReadUserDataResponse(this.cardId, this.userData, this.userProtectedData, this.userCounter, this.userProtectedCounter);

  factory ReadUserDataResponse.fromJson(Map<String, dynamic> json) => _$ReadUserDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReadUserDataResponseToJson(this);
}

@JsonSerializable()
class WriteUserDataResponse {
  final String cardId;

  WriteUserDataResponse(this.cardId);

  factory WriteUserDataResponse.fromJson(Map<String, dynamic> json) => _$WriteUserDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WriteUserDataResponseToJson(this);
}

@JsonSerializable()
class SetPinResponse {
  final String cardId;
  final String status;

  SetPinResponse(this.cardId, this.status);

  factory SetPinResponse.fromJson(Map<String, dynamic> json) => _$SetPinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SetPinResponseToJson(this);
}

@JsonSerializable()
class FileHashDataHex {
  final String startingHash;
  final String finalizingHash;
  final String startingSignature;
  final String finalizingSignature;

  FileHashDataHex(this.startingHash, this.finalizingHash, [this.startingSignature, this.finalizingSignature]);

  factory FileHashDataHex.fromJson(Map<String, dynamic> json) => _$FileHashDataHexFromJson(json);

  Map<String, dynamic> toJson() => _$FileHashDataHexToJson(this);
}

@JsonSerializable()
class WriteFilesResponse {
  final String cardId;
  final int fileIndex;

  WriteFilesResponse(this.cardId, [this.fileIndex]);

  factory WriteFilesResponse.fromJson(Map<String, dynamic> json) => _$WriteFilesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WriteFilesResponseToJson(this);
}

@JsonSerializable()
class ReadFilesResponse {
  final List<FileHex> files;

  ReadFilesResponse(this.files);

  factory ReadFilesResponse.fromJson(Map<String, dynamic> json) => _$ReadFilesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReadFilesResponseToJson(this);
}

@JsonSerializable()
class FileHex {
  final int fileIndex;
  final String fileData;
  final FileSettings fileSettings;

  FileHex(this.fileIndex, this.fileData, [this.fileSettings]);

  factory FileHex.fromJson(Map<String, dynamic> json) => _$FileHexFromJson(json);

  Map<String, dynamic> toJson() => _$FileHexToJson(this);
}

@JsonSerializable()
class ChangeFileSettings {
  final int fileIndex;
  final FileSettings settings;

  ChangeFileSettings(this.fileIndex, this.settings);

  factory ChangeFileSettings.fromJson(Map<String, dynamic> json) => _$ChangeFileSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeFileSettingsToJson(this);
}

enum FileSettings { Public, Private }

extension FileSettingsCode on FileSettings {
  static const codes = {
    FileSettings.Public: 0x0001,
    FileSettings.Private: 0x0000,
  };

  int get code => codes[this];
}

@JsonSerializable()
class DeleteFilesResponse {
  final String cardId;

  DeleteFilesResponse(this.cardId);

  factory DeleteFilesResponse.fromJson(Map<String, dynamic> json) => _$DeleteFilesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteFilesResponseToJson(this);
}

@JsonSerializable()
class ChangeFilesSettingsResponse {
  final String cardId;

  ChangeFilesSettingsResponse(this.cardId);

  factory ChangeFilesSettingsResponse.fromJson(Map<String, dynamic> json) => _$ChangeFilesSettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeFilesSettingsResponseToJson(this);
}
