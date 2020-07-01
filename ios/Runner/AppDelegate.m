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
    //AIzaSyCwKXvgsBElyhqwj03ro9e-Lnu3fmRmpJI
    if (@available(iOS 10.0, *)) {
         [UNUserNotificationCenter currentNotificationCenter].delegate =  self;
       }
    [GMSServices provideAPIKey: @"AIzaSyBB1QThVluIt-PzfhPs3ZUWV_CZq8H4qXA"];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
