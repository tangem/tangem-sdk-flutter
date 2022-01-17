import 'dart:math';
import 'dart:typed_data';

class Utils {
  final String jsonRpcSingleCommandTemplate = """
    {
        "jsonrpc": "2.0",
        "id": 2,
        "method": "scan",
        "params": {}
    }
    """;

  final String jsonRpcListCommandsTemplate = """
    [
        {
          "method": "scan",
          "params": {},
          "id": 1,
          "jsonrpc": "2.0"
        },
        {
          "method": "create_wallet",
          "params": {
            "curve": "Secp256k1"
          },
          "jsonrpc": "2.0"
        },
        {
          "method": "scan",
          "id": 2,
          "jsonrpc": "2.0"
        }
    ]
    """;

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
