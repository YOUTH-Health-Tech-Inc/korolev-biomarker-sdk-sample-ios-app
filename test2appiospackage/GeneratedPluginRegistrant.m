//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<flutter_inappwebview_ios/InAppWebViewFlutterPlugin.h>)
#import <flutter_inappwebview_ios/InAppWebViewFlutterPlugin.h>
#else
@import flutter_inappwebview_ios;
#endif

#if __has_include(<permission_handler_apple/PermissionHandlerPlugin.h>)
#import <permission_handler_apple/PermissionHandlerPlugin.h>
#else
@import permission_handler_apple;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [InAppWebViewFlutterPlugin registerWithRegistrar:[registry registrarForPlugin:@"InAppWebViewFlutterPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
}

@end
