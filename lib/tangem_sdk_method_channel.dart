import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'model/sdk.dart';
import 'tangem_sdk_platform_interface.dart';

/// An implementation of [TangemSdkPlatform] that uses method channels.
class MethodChannelTangemSdk extends TangemSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tangem_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    return await methodChannel.invokeMethod<String>('getPlatformVersion');
  }

  @override
  Future<String> runJSONRPCRequest(Map<String, dynamic> request) async {
    return await methodChannel.invokeMethod("runJSONRPCRequest", request);
  }

  @override
  Future<String> setScanImage(ScanTagImage? scanCardImage) async {
    Map<String, dynamic> args = {};
    if (scanCardImage != null) {
      args = scanCardImage.toJson();
    }
    return await methodChannel.invokeMethod("setScanImage", args);
  }
}
