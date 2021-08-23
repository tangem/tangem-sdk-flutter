import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tangem_sdk/tangem_sdk.dart';
import 'package:tangem_sdk_example/app_widgets.dart';
import 'package:tangem_sdk_example/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Tangem SDK plugin example')),
        body: CommandListWidget(),
      ),
    );
  }
}

class CommandListWidget extends StatefulWidget {
  @override
  _CommandListWidgetState createState() => _CommandListWidgetState();
}

class _CommandListWidgetState extends State<CommandListWidget> {
  final Utils _utils = Utils();
  final _jsonEncoder = JsonEncoder.withIndent('  ');

  Callback _callback;
  String _cardId;

  @override
  void initState() {
    super.initState();

    _callback = Callback((success) {
      if (success is CardResponse) {
        _cardId = success.cardId;
      }
      try {
        final prettyJson = _jsonEncoder.convert(success.toJson());
        prettyJson.split("\n").forEach((element) => print(element));
      } catch (e) {
        print('The provided string is not valid JSON');
        print(success.toString());
      }
    }, (error) {
      if (error is ErrorResponse) {
        print(error.localizedDescription);
      } else {
        print(error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 25),
          RowActions(
            [
              ActionButton(text: "Scan card", action: handleScanCard),
              ActionButton(text: "Sign", action: handleSign),
              ActionButton(text: "Canonize", action: handleCanonize),
            ],
          ),
          ActionType("Issuer data"),
          RowActions(
            [
              ActionButton(text: "Read", action: handleReadIssuerData),
              ActionButton(text: "Write", action: handleWriteIssuerData),
            ],
          ),
          ActionType("Issuer extra data"),
          RowActions(
            [
              ActionButton(text: "Read", action: handleReadIssuerExtraData),
              ActionButton(text: "Write", action: handleWriteIssuerExtraData),
            ],
          ),
          ActionType("User data"),
          RowActions(
            [
              ActionButton(text: "Read (all)", action: handleReadUserData),
              ActionButton(text: "Write data", action: handleWriteUserData),
            ],
          ),
          RowActions([
            ActionButton(text: "Write protected data", action: handleWriteUserProtectedData),
          ]),
          ActionType("Wallet"),
          RowActions(
            [
              ActionButton(text: "Create", action: handleCreateWallet),
              ActionButton(text: "Purge", action: handlePurgeWallet),
            ],
          ),
          ActionType("Pins"),
          RowActions(
            [
              ActionButton(text: "Change PIN1", action: handleSetPin1),
              ActionButton(text: "Change PIN2", action: handleSetPin2),
            ],
          ),
          SizedBox(height: 25)
        ],
      ),
    );
  }

  handleScanCard() {
    TangemSdk.scanCard(_callback);
  }

  handleSign() {
    final listOfData = List.generate(_utils.randomInt(1, 10), (index) => _utils.randomString(20));
    final hashes = listOfData.map((e) => e.toHexString()).toList();

    TangemSdk.sign(_callback, hashes, {TangemSdk.cid: _cardId});
  }

  handleCanonize() {
    final hashHex = "5133574D6642484D393164644F6545467A513965";
    final publicKeyHex = "04C29EE14CAAAB4A64687C7E25EF39D8204990EB9F2C34FD6AAC9668951E9F74AF19EB00D5977B01CB4F57BF9F98D962DEFD7645B6BB391D500FDE676630A7FF09";
    final signatureHex = "BE71CF2383364C29D6BAAA33CCE1D5D179E27B3BC93B85E4E9949BDBC15509B885C0D0D6A805D68E8AB6565A3FAEB709680B21BBD596527F517EA767CD6F2FD0";
    final resultForCheck = "BE71CF2383364C29D6BAAA33CCE1D5D179E27B3BC93B85E4E9949BDBC15509B87A3F2F2957FA29717549A9A5C05148F552A3BB2AD9B24DBC6E53B72502C71171";

    TangemSdk.normalizeVerify(publicKeyHex, hashHex, signatureHex, _callback);
  }

  handleReadIssuerData() {
    TangemSdk.readIssuerData(_callback, {TangemSdk.cid: _cardId});
  }

  handleWriteIssuerData() {
    if (_cardId == null) {
      _showToast("CardId required. Scan your card before proceeding");
      return;
    }

    final issuerData = "Issuer data to be written on a card";
    final issuerDataSignature = "(cardId.bytes + issuerData.bytes + counter.bytes(4)).sign(issuerPrivateKey)";
    final issuerDataCounter = 1;

    TangemSdk.writeIssuerData(_callback, issuerData.toHexString(), issuerDataSignature.toHexString(), {
      TangemSdk.cid: _cardId,
      TangemSdk.issuerDataCounter: issuerDataCounter,
    });
  }

  handleReadIssuerExtraData() {
    TangemSdk.readIssuerExtraData(_callback, {TangemSdk.cid: _cardId});
  }

  handleWriteIssuerExtraData() {
    if (_cardId == null) {
      _showToast("CardId required. Scan your card before proceeding");
      return;
    }

    final issuerData = "Issuer extra data to be written on a card";
    final startingSignature =
        "(cardId.bytes + counter.bytes(4) + issuerData.bytes.size.bytes(2)).sign(issuerPrivateKey)";
    final finalizingSignature = "(cardId.bytes + issuerData.bytes + counter.bytes(4)).sign(issuerPrivateKey)";
    final counter = 1;

    TangemSdk.writeIssuerExtraData(
        _callback, issuerData.toHexString(), startingSignature.toHexString(), finalizingSignature.toHexString(), {
      TangemSdk.cid: _cardId,
      TangemSdk.issuerDataCounter: counter,
    });
  }

  handleReadUserData() {
    TangemSdk.readUserData(_callback, {TangemSdk.cid: _cardId});
  }

  handleWriteUserData() {
    final userData = "User data to be written on a card";
    final userCounter = 1;

    TangemSdk.writeUserData(_callback, userData.toHexString(), {
      TangemSdk.cid: _cardId,
      TangemSdk.userCounter: userCounter,
    });
  }

  handleWriteUserProtectedData() {
    final userProtectedData = "Protected user data to be written on a card";
    final protectedCounter = 1;

    TangemSdk.writeUserProtectedData(_callback, userProtectedData.toHexString(), {
      TangemSdk.cid: _cardId,
      TangemSdk.userProtectedCounter: protectedCounter,
    });
  }

  handleCreateWallet() {
    TangemSdk.createWallet(_callback, {TangemSdk.cid: _cardId});
  }

  handlePurgeWallet() {
    TangemSdk.purgeWallet(_callback, {TangemSdk.cid: _cardId});
  }

  handleSetPin1() {
    TangemSdk.setPinCode(PinType.PIN1, _callback, {TangemSdk.cid: _cardId});
  }

  handleSetPin2() {
    TangemSdk.setPinCode(PinType.PIN2, _callback, {TangemSdk.cid: _cardId});
  }

  _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.8),
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
