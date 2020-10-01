import 'dart:math';
import 'dart:typed_data';

import 'package:rxdart/rxdart.dart';
import 'package:tangem_sdk/tangem_sdk_plugin.dart';

class SdkBridge {
  final _psNotificationSender = PublishSubject<String>();
  final Utils utils = Utils();

  Callback _callback;
  String _cardId;

  SdkBridge() {
    _callback = createCallback();
  }

  Callback createCallback() => Callback((response) {
        if (response is CardResponse) {
          _cardId = response.cardId;
        }
        print(response);
      }, (error) {
        if (error is ErrorResponse) {
          print(error.localizedDescription);
        } else {
          print(error);
        }
      });

  Stream<String> get notificationStream => _psNotificationSender.stream;

  scanCard() {
    TangemSdk.scanCard(_callback, {});
  }

  sign() {
    final listOfData = List.generate(utils.randomInt(1, 10), (index) => utils.randomString(20));
    final listOfHashes = listOfData.map((e) => e.toHexString()).toList();
    TangemSdk.sign(_callback, {
      TangemSdk.cid: _cardId,
      TangemSdk.hashesHex: listOfHashes,
    });
  }

  readIssuerData() {
    TangemSdk.readIssuerData(_callback, {
      TangemSdk.cid: _cardId,
    });
  }

  writeIssuerData() {
    if (_cardId == null) {
      _psNotificationSender.add("CardId required. Scan your card before proceeding");
      return;
    }

    final issuerData = utils.randomString(utils.randomInt(15, 30)).toBytes();
    final counter = 1;

    TangemSdk.writeIssuerData(_callback, {
      TangemSdk.cid: _cardId,
      TangemSdk.issuerDataHex: issuerData.toHexString(),
      TangemSdk.issuerPrivateKeyHex: utils.issuerPrivateKeyHex,
      TangemSdk.issuerDataCounter: counter,
    });
  }

  readIssuerExData() {
    TangemSdk.readIssuerExData(_callback, {
      TangemSdk.cid: _cardId,
    });
  }

  writeIssuerExData() {
    if (_cardId == null) {
      _psNotificationSender.add("CardId required. Scan your card before proceeding");
      return;
    }

    final issuerExData = utils.randomBytes(1524, secure: true);
    final counter = 1;

    TangemSdk.writeIssuerExData(_callback, {
      TangemSdk.cid: _cardId,
      TangemSdk.issuerExDataHex: issuerExData.toHexString(),
      TangemSdk.issuerPrivateKeyHex: utils.issuerPrivateKeyHex,
      TangemSdk.issuerDataCounter: counter,
    });
  }

  readUserData() {
    TangemSdk.readUserData(_callback, {
      TangemSdk.cid: _cardId,
    });
  }

  writeUserData() {
    final userData = "User data to be written on a card";
    final counter = 1;

    TangemSdk.writeUserData(_callback, {
      TangemSdk.cid: _cardId,
      TangemSdk.userDataHex: userData.toHexString(),
      TangemSdk.userCounter: counter,
    });
  }

  writeUserProtectedData() {
    final userProtectedData = "Protected user data to be written on a card";
    final protectedCounter = 1;

    TangemSdk.writeUserProtectedData(_callback, {
      TangemSdk.cid: _cardId,
      TangemSdk.userProtectedDataHex: userProtectedData.toHexString(),
      TangemSdk.userProtectedCounter: protectedCounter,
    });
  }

  createWallet() {
    TangemSdk.createWallet(_callback, {
      TangemSdk.cid: _cardId,
    });
  }

  purgeWallet() {
    TangemSdk.purgeWallet(_callback, {
      TangemSdk.cid: _cardId,
    });
  }

  setPin1() {
    TangemSdk.setPinCode(PinType.PIN1, _callback, {
      TangemSdk.cid: _cardId,
    });
  }

  setPin2() {
    TangemSdk.setPinCode(PinType.PIN2, _callback, {
      TangemSdk.cid: _cardId,
    });
  }
}

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
