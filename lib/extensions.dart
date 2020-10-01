import 'dart:convert';

import 'package:convert/convert.dart';

extension hexAndBytes on String {
  List<int> hexToBytes() {
    final length = this.length ~/ 2;
    final byteArray = List<int>(length);
    for (int i = 0; i < length; i++) {
      final subs = this.substring(2 * i, 2 * i + 2);
      byteArray[i] = int.parse(subs, radix: 16);
    }
    return byteArray;
  }

  String hexToString() => utf8.decode(this.hexToBytes());

  String toHexString() => hex.encode(this.toBytes());

  List<int> toBytes() => this.codeUnits;
}

extension ByteArrayToHex on List<int> {
  String toHexString() => hex.encode(this);
}