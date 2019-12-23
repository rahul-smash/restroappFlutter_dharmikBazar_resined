#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
// Add the following import.
#import "GoogleMaps/GoogleMaps.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  // Add the following line, with your API key
    [GMSServices provideAPIKey: @"AIzaSyCwKXvgsBElyhqwj03ro9e-Lnu3fmRmpJI"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
