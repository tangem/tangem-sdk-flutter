import 'model/sdk.dart';
import 'tangem_sdk_platform_interface.dart';

class TangemSdk {
  Future<String?> getPlatformVersion() {
    return TangemSdkPlatform.instance.getPlatformVersion();
  }

  Future<String> runJSONRPCRequest(Map<String, dynamic> request) {
    return TangemSdkPlatform.instance.runJSONRPCRequest(request);
  }

  Future<String> setScanImage(ScanTagImage? scanCardImage) async {
    return TangemSdkPlatform.instance.setScanImage(scanCardImage);
  }
}
