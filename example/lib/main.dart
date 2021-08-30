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
  String _walletPublicKey;

  @override
  void initState() {
    super.initState();

    _callback = Callback((response) {
      if (response is! JSONRPCResponse) {
        print("Response is not an instance of the JSONRPCResponse");
      } else {
        final jsonRpcResponse = response as JSONRPCResponse;
        if (jsonRpcResponse.result != null) {
          switch (jsonRpcResponse.id) {
            case 1:
              {
                _cardId = jsonRpcResponse.result["cardId"];
                final wallets = jsonRpcResponse.result["wallets"];
                if (wallets is List && wallets.isNotEmpty) {
                  _walletPublicKey = wallets[0]["publicKey"];
                }
                break;
              }
            case 3:
              {
                _walletPublicKey = jsonRpcResponse.result["wallet"]["publicKey"];
                break;
              }
            case 4:
              {
                _walletPublicKey = null;
                break;
              }
          }
        }
      }
      _printResponse(response);
    }, (error) {
      print(error);
    });
  }

  void _printResponse(response) {
    try {
      final prettyJson = _jsonEncoder.convert(response.toJson());
      prettyJson.split("\n").forEach((element) => print(element));
    } catch (e) {
      print('The provided string is not valid JSON');
      print(response.toString());
    }
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
              ActionButton(text: "Sign hash", action: handleSign),
            ],
          ),
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
              ActionButton(text: "Set access code", action: handleSetAccessCode),
              ActionButton(text: "Set passcode", action: handleSetPasscode),
            ],
          ),
          SizedBox(height: 25)
        ],
      ),
    );
  }

  void _launchJSONRPCRequest(Map<String, dynamic> json, [String cardId, Message message]) {
    TangemSdk.runJSONRPCRequest(_callback, JSONRPCRequest.fromJson(json), cardId, message);
  }

  handleScanCard() {
    final json = {
      "id": 1,
      "method": "scan",
      "params": <String, dynamic>{},
    };
    _launchJSONRPCRequest(json, null, Message.body("Some body"));
  }

  handleSign() {
    if (_cardId == null || _walletPublicKey == null) {
      _showToast("Scan the card or create a wallet");
      return;
    }

    final json = {
      "method": "sign_hash",
      "params": <String, dynamic>{
        "walletPublicKey": _walletPublicKey,
        "hash": "f1642bb080e1f320924dde7238c1c5f8",
      },
    };
    _launchJSONRPCRequest(json, _cardId);
  }

  handleCreateWallet() {
    if (_cardId == null) {
      _showToast("Scan the card");
      return;
    }

    _showToast("Only for: Secp256k1");
    final json = {
      "id": 3,
      "method": "create_wallet",
      "params": <String, dynamic>{
        "curve": "Secp256k1",
      },
    };
    _launchJSONRPCRequest(json, _cardId);
  }

  handlePurgeWallet() {
    if (_cardId == null || _walletPublicKey == null) {
      _showToast("Scan the card or create a wallet");
      return;
    }

    final json = {
      "id": 4,
      "method": "purge_wallet",
      "params": <String, dynamic>{
        "walletPublicKey": _walletPublicKey,
      },
    };
    _launchJSONRPCRequest(json, _cardId);
  }

  handleSetAccessCode() {
    if (_cardId == null) {
      _showToast("Scan the card");
      return;
    }

    final json = {
      "method": "set_accesscode",
      "params": <String, dynamic>{"accessCode": "ABCDEFGH"},
    };
    _launchJSONRPCRequest(json, _cardId);
  }

  handleSetPasscode() {
    if (_cardId == null) {
      _showToast("Scan the card");
      return;
    }

    final json = {
      "method": "set_passcode",
      "params": <String, dynamic>{"passcode": "ABCDEFGH"},
    };
    _launchJSONRPCRequest(json, _cardId);
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
