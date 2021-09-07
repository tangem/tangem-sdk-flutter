import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'json_rpc.g.dart';

abstract class JSONRPC {
  final dynamic id;
  final String jsonrpc;

  JSONRPC(this.id, this.jsonrpc);
}

@JsonSerializable()
class JSONRPCRequest extends JSONRPC {
  final String method;
  final Map<String, dynamic> params;

  JSONRPCRequest(this.method, this.params, [dynamic id, String jsonrpc = "2.0"]) : super(id, jsonrpc);

  Map<String, dynamic> toJson() => _$JSONRPCRequestToJson(this);

  factory JSONRPCRequest.fromJson(Map<String, dynamic> json) => _$JSONRPCRequestFromJson(json);
}

@JsonSerializable()
class JSONRPCResponse extends JSONRPC {
  final dynamic result;
  final JSONRPCError? error;

  JSONRPCResponse(this.result, this.error, [dynamic id, String jsonrpc = "2.0"]) : super(id, jsonrpc);

  Map<String, dynamic> toJson() => _$JSONRPCResponseToJson(this);

  factory JSONRPCResponse.fromJson(Map<String, dynamic> json) => _$JSONRPCResponseFromJson(json);
}

@JsonSerializable()
class JSONRPCError {
  final int code;
  final String message;
  final dynamic data;

  JSONRPCError(this.code, this.message, this.data);

  Map<String, dynamic> toJson() => _$JSONRPCErrorToJson(this);

  factory JSONRPCError.fromJson(Map<String, dynamic> json) => _$JSONRPCErrorFromJson(json);
}