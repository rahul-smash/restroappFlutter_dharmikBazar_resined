import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/Screens/Dashboard/SplashScreen.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AppConstant.isLoggedIn = await SharedPrefs.isUserLoggedIn();

  if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    SharedPrefs.storeSharedValue(
        AppConstant.deviceId, iosDeviceInfo.identifierForVendor);
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    SharedPrefs.storeSharedValue(
        AppConstant.deviceId, androidDeviceInfo.androidId);
  }
  runApp(ValueApp());
}

class ValueApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // define it once at root level.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restro App',
      theme: ThemeData(
        primaryColor: appTheme,
      ),
      home: SplashScreen(),
    );
  }
}
