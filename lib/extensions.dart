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

extension ToList on String {
  List<String> toList({String delimiter = ",", List<String> ifEmpty}) {
    if (this == null || this.isEmpty) return ifEmpty;

    if (this.contains(delimiter)) {
      return this.split(delimiter).toList().map((e) => e.trim()).toList();
    } else {
      return [this.trim()];
    }
  }
}

extension ByteArrayToHex on List<int> {
  String toHexString() => hex.encode(this);
}

extension ListInt on List {
  List<int> toIntList() =>
      this.map((e) => int.tryParse(e.toString())).toList()..removeWhere((element) => element == null);

  List<String> toStringList() => this.map((e) => e?.toString()).toList()..removeWhere((element) => element == null);
}
