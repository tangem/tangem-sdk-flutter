class Message {
  String? header;
  String? body;

  Message([this.header, this.body]);

  Map<String, dynamic> toJson() => {
        "header": header,
        "body": body,
      };
}

class ScanTagImage {
  final String base64;
  final int verticalOffset;

  ScanTagImage(this.base64, [this.verticalOffset = 0]);

  Map<String, dynamic> toJson() => {
        "base64": base64,
        "verticalOffset": verticalOffset,
      };
}

abstract class JSONRPC {
  final String jsonrpc = "2.0";
  final dynamic id;

  JSONRPC([this.id]);
}

class JSONRPCRequest extends JSONRPC {
  final String method;
  final Map<String, dynamic> params;

  JSONRPCRequest(this.method, [this.params = const {}, dynamic id]) : super(id);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'method': method,
        'params': params,
        'id': id,
        'jsonrpc': jsonrpc,
      };

  factory JSONRPCRequest.fromJson(Map<String, dynamic> json) => JSONRPCRequest(
        json['method'] as String,
        json['params'] as Map<String, dynamic>,
        json['id'],
      );
}

class JSONRPCResponse extends JSONRPC {
  final dynamic result;
  final dynamic error;

  JSONRPCResponse(this.result, this.error, [dynamic id]) : super(id);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'result': result,
        'error': error,
        'id': id,
        'jsonrpc': jsonrpc,
      };

  factory JSONRPCResponse.fromJson(Map<String, dynamic> json) =>
      JSONRPCResponse(
        json['result'],
        json['error'],
        json['id'],
      );
}
