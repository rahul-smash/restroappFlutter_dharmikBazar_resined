import 'dart:async';

import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginEmailScreen.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/Screens/Dashboard/SplashScreen.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AppConstant.isLoggedIn = await SharedPrefs.isUserLoggedIn();

  bool isAdminLogin = false;

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
    SharedPrefs.storeSharedValue(
        AppConstant.deviceId, iosDeviceInfo.identifierForVendor);
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    SharedPrefs.storeSharedValue(
        AppConstant.deviceId, androidDeviceInfo.androidId);
  }

  runZoned(() {
    runApp(ValueApp(isAdminLogin));
  }, onError: Crashlytics.instance.recordError);

}

class ValueApp extends StatelessWidget {

  bool isAdminLogin;
  ValueApp(this.isAdminLogin);

  @override
  Widget build(BuildContext context) {
    // define it once at root level.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restro App',
      theme: ThemeData(
        primaryColor: appTheme,
      ),
      home: isAdminLogin == true? LoginEmailScreen("menu"): SplashScreen(),
    );
  }
}
