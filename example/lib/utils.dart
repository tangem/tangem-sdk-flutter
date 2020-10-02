import 'dart:math';
import 'dart:typed_data';

class Utils {
  final issuerPrivateKeyHex = "11121314151617184771ED81F2BACF57479E4735EB1405083927372D40DA9E92";

  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  int randomInt(int min, int max) => min + Random().nextInt(max - min);

  String randomString(int length) {
    return String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Uint8List randomBytes(int length, {bool secure = false}) {
    assert(length > 0);

    final random = secure ? Random.secure() : _rnd;
    final ret = Uint8List(length);

    for (var i = 0; i < length; i++) {
      ret[i] = random.nextInt(256);
    }

    return ret;
  }
}
