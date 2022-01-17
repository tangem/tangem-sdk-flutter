import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  String? _cardId;
  String? _walletPublicKey;
  String _response = "";
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      setState(() {});
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
              ActionButton("Scan card", _handleScanCard),
              ActionButton("Sign hash", _handleSign),
            ],
          ),
          ActionType("Wallet"),
          RowActions(
            [
              ActionButton("Create", _handleCreateWallet),
              ActionButton("Purge", _handlePurgeWallet),
            ],
          ),
          ActionType("Pins"),
          RowActions(
            [
              ActionButton("Set access code", _handleSetAccessCode),
              ActionButton("Set passcode", _handleSetPasscode),
            ],
          ),
          SizedBox(height: 5),
          Divider(),
          ActionType("JSONRRPC"),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 5),
                TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    labelText: "Paste the configuration",
                    isDense: true,
                  ),
                  minLines: 1,
                  maxLines: 25,
                  controller: _controller,
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    OutlinedButton(
                        onPressed: () async {
                          final data = await Clipboard.getData(Clipboard.kTextPlain);
                          final textData = data?.text ?? "";
                          if (textData.isEmpty) return;

                          _controller.value = TextEditingValue(text: textData);
                        },
                        child: Icon(Icons.paste)),
                    SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        child: Text("Launch"),
                        onPressed: _controller.text.isEmpty ? null : () => _handleJsonRpc(_controller.text),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          ActionType("RESULT"),
          Text(_response),
        ],
      ),
    );
  }

  void _handleScanCard() {
    final json = {
      "id": 1,
      "jsonrpc": "2.0",
      "method": "scan",
      "params": <String, dynamic>{},
    };
    _launchJSONRPCRequest(json);
  }

  void _handleSign() {
    if (_cardId == null || _walletPublicKey == null) {
      _showToast("Scan the card or create a wallet");
      return;
    }

    final json = {
      "method": "sign_hash",
      "jsonrpc": "2.0",
      "params": <String, dynamic>{
        "walletPublicKey": _walletPublicKey,
        "hash": "f1642bb080e1f320924dde7238c1c5f8",
      },
    };
    _launchJSONRPCRequest(json, _cardId);
  }

  void _handleCreateWallet() {
    if (_cardId == null) {
      _showToast("Scan the card");
      return;
    }

    _showToast("Only for: Secp256k1");
    final json = {
      "id": 3,
      "jsonrpc": "2.0",
      "method": "create_wallet",
      "params": <String, dynamic>{
        "curve": "Secp256k1",
      },
    };
    _launchJSONRPCRequest(json, _cardId);
  }

  void _handlePurgeWallet() {
    if (_cardId == null || _walletPublicKey == null) {
      _showToast("Scan the card or create a wallet");
      return;
    }

    final json = {
      "id": 4,
      "jsonrpc": "2.0",
      "method": "purge_wallet",
      "params": <String, dynamic>{
        "walletPublicKey": _walletPublicKey,
      },
    };
    _launchJSONRPCRequest(json, _cardId);
  }

  void _handleSetAccessCode() {
    if (_cardId == null) {
      _showToast("Scan the card");
      return;
    }

    final json = {
      "jsonrpc": "2.0",
      "method": "set_accesscode",
      "params": <String, dynamic>{"accessCode": "ABCDEFGH"},
    };
    _launchJSONRPCRequest(json, _cardId);
  }

  void _handleSetPasscode() {
    if (_cardId == null) {
      _showToast("Scan the card");
      return;
    }

    final json = {
      "jsonrpc": "2.0",
      "method": "set_passcode",
      "params": <String, dynamic>{"passcode": "ABCDEFGH"},
    };
    _launchJSONRPCRequest(json, _cardId);
  }

  void _handleJsonRpc(String text) {
    _launchJSONRPCRequest(text.trim(), null, null);
  }

  void _launchJSONRPCRequest(dynamic requestStructure, [String? cardId, Message? message]) {
    String? request;
    if (requestStructure is String) {
      request = requestStructure;
    } else if (requestStructure is Map<String, dynamic>) {
      request = jsonEncode(JSONRPCRequest.fromJson(requestStructure));
    } else if (requestStructure is List) {
      final requests = requestStructure.map((e) => JSONRPCRequest.fromJson(e)).toList();
      request = jsonEncode(requests);
    }

    if (request == null) {
      _showToast("Can't recognize the request structure");
      return;
    }

    final callback = Callback((success) {
      final decodedResponse = jsonDecode(success);
      _printResponse(decodedResponse);
      _parseResponse(decodedResponse);
    }, (error) {
      // it is not expected
    });

    TangemSdk.runJSONRPCRequest(callback, request, cardId, message);
  }

  void _printResponse(Object decodedResponse) {
    final prettyJson = _jsonEncoder.convert(decodedResponse);
    prettyJson.split("\n").forEach((element) => print(element));

    setState(() {
      _response = prettyJson;
    });
  }

  void _parseResponse(Object decodedResponse) {
    if (decodedResponse is List || decodedResponse is! Map<String, dynamic>) return;

    JSONRPCResponse jsonRpcResponse;
    try {
      jsonRpcResponse = JSONRPCResponse.fromJson(decodedResponse);
    } catch (ex) {
      print(ex.toString());
      return;
    }

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

  _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.8),
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
