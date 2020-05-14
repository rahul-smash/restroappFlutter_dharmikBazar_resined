import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginEmailScreen.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/Screens/Dashboard/SplashScreen.dart';
import 'package:restroapp/src/models/ConfigModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AppConstant.isLoggedIn = await SharedPrefs.isUserLoggedIn();

  bool isAdminLogin = false;
  String jsonResult =  await loadAsset();
  final parsed = json.decode(jsonResult);
  ConfigModel configObject = ConfigModel.fromJson(parsed);
  print(configObject.storeId);
  setAppThemeColors(configObject);

  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  SharedPrefs.storeSharedValue(AppConstant.isAdminLogin, "${isAdminLogin}");

  if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    SharedPrefs.storeSharedValue(AppConstant.deviceId, iosDeviceInfo.identifierForVendor);
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    SharedPrefs.storeSharedValue(AppConstant.deviceId, androidDeviceInfo.androidId);
  }

  runZoned(() {
    runApp(ValueApp(isAdminLogin,configObject));
  }, onError: Crashlytics.instance.recordError);

}

void setAppThemeColors(ConfigModel configObject) {
  appTheme = Color(int.parse(configObject.appTheme));
  left_menu_header_bkground = Color(int.parse(configObject.left_menu_header_bkground));
  left_menu_icon_colors = Color(int.parse(configObject.leftMenuIconColors));
  left_menu_background_color = Color(int.parse(configObject.leftMenuBackgroundColor));
  leftMenuWelcomeTextColors = Color(int.parse(configObject.leftMenuTitleColors));
  leftMenuUsernameColors = Color(int.parse(configObject.leftMenuUsernameColors));
  bottomBarIconColor = Color(int.parse(configObject.bottomBarIconColor));
  bottomBarTextColor = Color(int.parse(configObject.bottomBarTextColor));
  dotIncreasedColor = Color(int.parse(configObject.dotIncreasedColor));
}

class ValueApp extends StatelessWidget {

  bool isAdminLogin;
  ConfigModel configObject;
  ValueApp(this.isAdminLogin, this.configObject);

  @override
  Widget build(BuildContext context) {
    // define it once at root level.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restro App',
      theme: ThemeData(
        primaryColor: appTheme,
      ),
      home: isAdminLogin == true? LoginEmailScreen("menu"): SplashScreen(configObject),
    );
  }
}


Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/app_config.json');
}