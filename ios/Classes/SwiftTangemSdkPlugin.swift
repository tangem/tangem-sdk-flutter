import Flutter
import UIKit
import TangemSdk

@available(iOS 13.0, *)
public class SwiftTangemSdkPlugin: NSObject, FlutterPlugin {
    private lazy var sdk: TangemSdk = {
        let sdk = TangemSdk()
        return sdk
    }()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tangemSdk", binaryMessenger: registrar.messenger())
        let instance = SwiftTangemSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            switch call.method {
            case "runJSONRPCRequest":
                try runJSONRPCRequest(call.arguments, result)
            default:
                result(FlutterMethodNotImplemented)
            }
        } catch {
            print(error)
            print(error.localizedDescription)
            result(error as? FlutterError ?? .underlyingError(error))
        }
    }
    
    private func runJSONRPCRequest(_ args: Any?, _ completion: @escaping FlutterResult) throws {
        guard let request: String = getArg(for: .request, from: args) else {
            throw FlutterError.missingRequest
        }
        
        let cardId: String? = getArg(for: .cardId, from: args)
        let initialMessage: String? = getArg(for: .initialMessage, from: args)
        let accessCode: String? = getArg(for: .accessCode, from: args)
        
        sdk.startSession(with: request,
                         cardId: cardId,
                         initialMessage: initialMessage,
                         accessCode: accessCode) { completion($0) }
    }
  
    private func getArg<T>(for key: ArgKey, from arguments: Any?) -> T? {
        if let value = (arguments as? NSDictionary)?[key.rawValue] {
            return value as? T
        }
        
        return nil
    }
}

fileprivate enum ArgKey: String {
    case cardId
    case initialMessage
    case accessCode
    case request = "JSONRPCRequest"
}

extension FlutterError: Error {}

fileprivate extension FlutterError {
    static let genericCode = "9999"
    
    static var missingRequest: FlutterError {
        FlutterError(code: genericCode, message: "Missing JSON RPC request", details: nil)
    }
    
    static func underlyingError(_ error: Error) -> FlutterError {
        FlutterError(code: genericCode, message: "Some error occured", details: error)
    }
    
    static var iosTooOld: FlutterError {
        FlutterError(code: genericCode, message: "Tangem SDK available from iOS 13", details: nil)
    }
}
