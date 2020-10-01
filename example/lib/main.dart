import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tangem_sdk_example/bridge.dart';

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
  SdkBridge _bridge;
  StreamSubscription<String> _toastSubscription;

  @override
  void initState() {
    super.initState();

    _bridge = SdkBridge();
    _toastSubscription = _bridge.notificationStream.listen(_showToast);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 25),
          RowActions(
            [
              ActionButton(text: "Scan card", action: _bridge.scanCard),
              ActionButton(text: "Sign", action: _bridge.sign),
            ],
          ),
          ActionType("Issuer data"),
          RowActions(
            [
              ActionButton(text: "Read", action: _bridge.readIssuerData),
              ActionButton(text: "Write", action: _bridge.writeIssuerData),
            ],
          ),
          ActionType("Issuer extra data"),
          RowActions(
            [
              ActionButton(text: "Read", action: _bridge.readIssuerExData),
              ActionButton(text: "Write", action: _bridge.writeIssuerExData),
            ],
          ),
          ActionType("User data"),
          RowActions(
            [
              ActionButton(text: "Read (all)", action: _bridge.readUserData),
              ActionButton(text: "Write data", action: _bridge.writeUserData),
            ],
          ),
          RowActions([
            ActionButton(text: "Write protected data", action: _bridge.writeUserProtectedData),
          ]),
          ActionType("Wallet"),
          RowActions(
            [
              ActionButton(text: "Create", action: _bridge.createWallet),
              ActionButton(text: "Purge", action: _bridge.purgeWallet),
            ],
          ),
          ActionType("Pins"),
          RowActions(
            [
              ActionButton(text: "Change PIN1", action: _bridge.setPin1),
              ActionButton(text: "Change PIN2", action: _bridge.setPin2),
            ],
          ),
        ],
      ),
    );
  }

  _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      fontSize: 14,
      backgroundColor: Colors.black.withOpacity(0.8),
      toastLength: Toast.LENGTH_LONG,
    );
  }

  @override
  void dispose() {
    _toastSubscription.cancel();
    super.dispose();
  }
}

class RowActions extends StatelessWidget {
  final List<Widget> children;

  const RowActions(this.children, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spacer = SizedBox(width: 10);
    final wrappedChildren = <Widget>[];
    wrappedChildren.add(spacer);
    children.forEach((e) {
      wrappedChildren.add(e);
      wrappedChildren.add(spacer);
    });
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: wrappedChildren,
      ),
    );
  }
}

class ActionType extends StatelessWidget {
  final String name;

  const ActionType(this.name, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        Center(child: Text(name)),
        SizedBox(height: 5),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final Function action;

  const ActionButton({Key key, this.text, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        child: Text(text),
        onPressed: action,
      ),
    );
  }
}
