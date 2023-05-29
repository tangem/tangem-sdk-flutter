
import 'tangem_sdk_platform_interface.dart';

class TangemSdk {
  Future<String?> getPlatformVersion() {
    return TangemSdkPlatform.instance.getPlatformVersion();
  }
}
