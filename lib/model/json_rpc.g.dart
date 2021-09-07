// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_rpc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JSONRPCRequest _$JSONRPCRequestFromJson(Map<String, dynamic> json) {
  return JSONRPCRequest(
    json['method'] as String,
    json['params'] as Map<String, dynamic>,
    json['id'],
    json['jsonrpc'] as String,
  );
}

Map<String, dynamic> _$JSONRPCRequestToJson(JSONRPCRequest instance) => <String, dynamic>{
      'id': instance.id,
      'jsonrpc': instance.jsonrpc,
      'method': instance.method,
      'params': instance.params,
    };

JSONRPCResponse _$JSONRPCResponseFromJson(Map<String, dynamic> json) {
  return JSONRPCResponse(
    json['result'],
    json['error'] == null ? null : JSONRPCError.fromJson(json['error'] as Map<String, dynamic>),
    json['id'],
    json['jsonrpc'] as String,
  );
}

Map<String, dynamic> _$JSONRPCResponseToJson(JSONRPCResponse instance) => <String, dynamic>{
      'id': instance.id,
      'jsonrpc': instance.jsonrpc,
      'result': instance.result,
      'error': instance.error,
    };

JSONRPCError _$JSONRPCErrorFromJson(Map<String, dynamic> json) {
  return JSONRPCError(
    json['code'] as int,
    json['message'] as String,
    json['data'],
  );
}

Map<String, dynamic> _$JSONRPCErrorToJson(JSONRPCError instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
