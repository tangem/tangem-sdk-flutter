import 'package:flutter/services.dart';

abstract class TangemSdkPluginError implements Exception {
  final int code;
  final String message;

  TangemSdkPluginError(this.code, this.message);

  String toString() => "${this.runtimeType}. Code: $code, message: $message";

  String toJson() => toString();

  static const int unknownCode = -1;
  static const int pluginFlutter = 100;
  static const int pluginKotlin = 1000;

  static TangemSdkPluginError createError(dynamic error) {
    if (error is TangemSdkPluginError) return error;

    if (error is PlatformException) {
      final code = int.tryParse(error.code) ?? unknownCode;
      final message = error.message ?? error.details ?? "";

      switch (code) {
        case unknownCode:
          return PluginUnknownError(message, error.details?.toString() ?? "");
        case pluginKotlin:
          return PluginKotlinError(message);
        default:
          return PluginTangemSdkError(code, "$message. Detail: ${error.details}");
      }
    }
    return PluginUnknownError(error.toString(), error.toString());
  }
}

class PluginFlutterError extends TangemSdkPluginError {
  PluginFlutterError(String message) : super(TangemSdkPluginError.pluginFlutter, message);
}

class PluginKotlinError extends TangemSdkPluginError {
  PluginKotlinError(String message) : super(TangemSdkPluginError.pluginKotlin, message);
}

class PluginTangemSdkError extends TangemSdkPluginError {
  PluginTangemSdkError(int code, String message) : super(code, message);
}

class PluginUnknownError extends TangemSdkPluginError {
  final String details;

  PluginUnknownError(String message, this.details) : super(TangemSdkPluginError.unknownCode, message);
}

extension OnTangemSdkPluginError on TangemSdkPluginError {
  bool isUnknownError() => code == TangemSdkPluginError.unknownCode;

  bool isPluginFlutterError() => code == TangemSdkPluginError.pluginFlutter;

  bool isPluginKotlinError() => code == TangemSdkPluginError.pluginKotlin;

  bool isTangemSdkError() => code >= 10000 && code <= 100000;

  bool isUserCancelledError() => code == 50002;
}
