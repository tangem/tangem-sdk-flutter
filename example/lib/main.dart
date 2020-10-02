import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tangem_sdk/tangem_sdk_plugin.dart';
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

    _callback = Callback((response) {
      if (response is CardResponse) {
        _cardId = response.cardId;
      }
      final prettyJson = _jsonEncoder.convert(response.toJson());
      prettyJson.split("\n").forEach((element) => print(element));
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
              ActionButton(text: "Read", action: handleReadIssuerExData),
              ActionButton(text: "Write", action: handleWriteIssuerExData),
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
    TangemSdk.scanCard(_callback, {});
  }

  handleSign() {
    final listOfData = List.generate(_utils.randomInt(1, 10), (index) => _utils.randomString(20));
    final listOfHashes = listOfData.map((e) => e.toHexString()).toList();

    TangemSdk.sign(_callback, {
      TangemSdk.cid: _cardId,
      TangemSdk.hashesHex: listOfHashes,
    });
  }

  handleReadIssuerData() {
    TangemSdk.readIssuerData(_callback, {TangemSdk.cid: _cardId});
  }

  handleWriteIssuerData() {
    if (_cardId == null) {
      _showToast("CardId required. Scan your card before proceeding");
      return;
    }

    final issuerData = _utils.randomString(_utils.randomInt(15, 30)).toBytes();
    final counter = 1;

    TangemSdk.writeIssuerData(_callback, {
      TangemSdk.cid: _cardId,
      TangemSdk.issuerDataHex: issuerData.toHexString(),
      TangemSdk.issuerPrivateKeyHex: _utils.issuerPrivateKeyHex,
      TangemSdk.issuerDataCounter: counter,
    });
  }

  handleReadIssuerExData() {
    TangemSdk.readIssuerExData(_callback, {TangemSdk.cid: _cardId});
  }

  handleWriteIssuerExData() {
    if (_cardId == null) {
      _showToast("CardId required. Scan your card before proceeding");
      return;
    }

    final issuerExData = _utils.randomBytes(1524 * 5, secure: true);
    final counter = 1;

    TangemSdk.writeIssuerExData(_callback, {
      TangemSdk.cid: _cardId,
      TangemSdk.issuerExDataHex: issuerExData.toHexString(),
      TangemSdk.issuerPrivateKeyHex: _utils.issuerPrivateKeyHex,
      TangemSdk.issuerDataCounter: counter,
    });
  }

  handleReadUserData() {
    TangemSdk.readUserData(_callback, {TangemSdk.cid: _cardId});
  }

  handleWriteUserData() {
    final userData = "User data to be written on a card";
    final counter = 1;

    TangemSdk.writeUserData(_callback, {
      TangemSdk.cid: _cardId,
      TangemSdk.userDataHex: userData.toHexString(),
      TangemSdk.userCounter: counter,
    });
  }

  handleWriteUserProtectedData() {
    final userProtectedData = "Protected user data to be written on a card";
    final protectedCounter = 1;

    TangemSdk.writeUserProtectedData(_callback, {
      TangemSdk.cid: _cardId,
      TangemSdk.userProtectedDataHex: userProtectedData.toHexString(),
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
