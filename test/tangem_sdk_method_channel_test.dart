import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tangem_sdk/tangem_sdk_method_channel.dart';

void main() {
  MethodChannelTangemSdk platform = MethodChannelTangemSdk();
  const MethodChannel channel = MethodChannel('tangem_sdk');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
