import 'package:flutter_test/flutter_test.dart';
import 'package:tangem_sdk/model/sdk.dart';
import 'package:tangem_sdk/tangem_sdk_plugin.dart';
import 'package:tangem_sdk/tangem_sdk_platform_interface.dart';
import 'package:tangem_sdk/tangem_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTangemSdkPlatform
    with MockPlatformInterfaceMixin
    implements TangemSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String> runJSONRPCRequest(Map<String, dynamic> request, [String? cardId, Message? initialMessage, String? accessCode]) {
    throw UnimplementedError();
  }

  @override
  Future<String> setScanImage(ScanTagImage? scanCardImage) {
    throw UnimplementedError();
  }
}

void main() {
  final TangemSdkPlatform initialPlatform = TangemSdkPlatform.instance;

  test('$MethodChannelTangemSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTangemSdk>());
  });

  test('getPlatformVersion', () async {
    TangemSdk tangemSdkPlugin = TangemSdk();
    MockTangemSdkPlatform fakePlatform = MockTangemSdkPlatform();
    TangemSdkPlatform.instance = fakePlatform;

    expect(await tangemSdkPlugin.getPlatformVersion(), '42');
  });
}
