import 'package:json_annotation/json_annotation.dart';

part 'sdk.g.dart';

@JsonSerializable()
class Message {
  final String? body;
  final String? header;

  Message(this.body, this.header);

  factory Message.body(String body) => Message(body, null);

  factory Message.header(String header) => Message(null, header);

  factory Message.empty() => Message(null, null);

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

  Map<String, dynamic> toJson() => _$MessageToJson(this);
}
