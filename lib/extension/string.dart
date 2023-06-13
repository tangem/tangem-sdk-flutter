import 'dart:convert';

import 'package:convert/convert.dart';

extension OnStringNullSafe on String {
  List<int> hexToBytes() {
    final length = this.length ~/ 2;
    return List.generate(length, (index) => int.parse(this.substring(2 * index, 2 * index + 2), radix: 16));
  }

  String hexToString() => utf8.decode(this.hexToBytes());

  String toHexString() => hex.encode(this.toBytes());

  List<int> toBytes() => this.codeUnits;

}
