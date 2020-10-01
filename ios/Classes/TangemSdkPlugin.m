#import "TangemSdkPlugin.h"
#if __has_include(<tangem_sdk/tangem_sdk-Swift.h>)
#import <tangem_sdk/tangem_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "tangem_sdk-Swift.h"
#endif

@implementation TangemSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTangemSdkPlugin registerWithRegistrar:registrar];
}
@end
