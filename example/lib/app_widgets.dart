import 'package:flutter/material.dart';

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
