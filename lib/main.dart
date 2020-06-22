import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:restroapp/src/Screens/Dashboard/HomeScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginEmailScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/Screens/Dashboard/SplashScreen.dart';
import 'package:restroapp/src/models/ConfigModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'dart:io';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:restroapp/src/utils/Utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AppConstant.isLoggedIn = await SharedPrefs.isUserLoggedIn();

  bool isAdminLogin = false;
  String jsonResult = await loadAsset();
  final parsed = json.decode(jsonResult);
  ConfigModel configObject = ConfigModel.fromJson(parsed);
  if (Platform.isIOS) {
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    SharedPrefs.storeSharedValue(
        AppConstant.deviceId, iosDeviceInfo.identifierForVendor);
  } else {
    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    SharedPrefs.storeSharedValue(
        AppConstant.deviceId, androidDeviceInfo.androidId);
  }

  String branch_id =
      await SharedPrefs.getStoreSharedValue(AppConstant.branch_id);
  if (branch_id == null || branch_id.isEmpty) {
  } else if (branch_id.isNotEmpty) {
    configObject.storeId = branch_id;
  }
  //print(configObject.storeId);

  Crashlytics.instance.enableInDevMode = true;
  StoreResponse storeData =
      await ApiController.versionApiRequest("${configObject.storeId}");
  setAppThemeColors(storeData.store);
  // Pass all uncaught errors to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  SharedPrefs.storeSharedValue(AppConstant.isAdminLogin, "${isAdminLogin}");

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // To turn off landscape mode
  runZoned(() {
    runApp(ValueApp(isAdminLogin, configObject, storeData));
  }, onError: Crashlytics.instance.recordError);
}

void setAppThemeColors(StoreModel store) {
  AppThemeColors appThemeColors = store.appThemeColors;
  appTheme = Color(int.parse(appThemeColors.appThemeColor));

  left_menu_header_bkground =
      Color(int.parse(appThemeColors.leftMenuHeaderBackgroundColor));
  left_menu_icon_colors = Color(int.parse(appThemeColors.leftMenuIconColor));
  left_menu_background_color =
      Color(int.parse(appThemeColors.leftMenuBackgroundColor));
  leftMenuWelcomeTextColors =
      Color(int.parse(appThemeColors.leftMenuUsernameColor));
  leftMenuUsernameColors =
      Color(int.parse(appThemeColors.leftMenuUsernameColor));
  bottomBarIconColor = Color(int.parse(appThemeColors.bottomBarIconColor));
  bottomBarTextColor = Color(int.parse(appThemeColors.bottomBarTextColor));
  dotIncreasedColor = Color(int.parse(appThemeColors.dotIncreasedColor));
  bottomBarBackgroundColor =
      Color(int.parse(appThemeColors.bottom_bar_background_color));
  leftMenuLabelTextColors =
      Color(int.parse(appThemeColors.left_menu_label_Color));
}

void setAppCurrency(StoreModel store, ConfigModel configObject) {
  if (store.showCurrency == "symbol") {
    if (store.currency_unicode.isEmpty) {
      AppConstant.currency = store.currencyAbbr;
    } else {
      AppConstant.currency = configObject.currency;
    }
    //U+020B9 // \u20B9
  } else {
    AppConstant.currency = store.currencyAbbr;
  }
  //print("======currency====${AppConstant.currency}");
  //String currency = "\u20B9";
}

class ValueApp extends StatelessWidget {
  bool isAdminLogin;
  ConfigModel configObject;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  StoreResponse storeData;

  ValueApp(this.isAdminLogin, this.configObject, this.storeData);

  @override
  Widget build(BuildContext context) {
    // define it once at root level.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '${storeData.store.storeName}',
      theme: ThemeData(
        primaryColor: appTheme,
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      home: isAdminLogin == true? LoginEmailScreen("menu"):SplashScreen(configObject,storeData),
//      home: isAdminLogin == true
//          ? LoginEmailScreen("menu")
//          : getHome(storeData, configObject),
    );
  }
}

Widget getHome(StoreResponse storeData, ConfigModel configObject) {
  return Container(
    child: FutureBuilder(
      future: Utils.getAppVersionDetails(),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container(color: const Color(0xFFFFE306));
        } else {
          if (projectSnap.hasData) {
            PackageInfo packageInfo = projectSnap.data;
            String appName = packageInfo.appName;
            String version = packageInfo.version;
            return showHomeScreen(storeData, configObject, version, appName);
          } else {
            return Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.black26,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)),
            );
          }
        }
      },
    ),
  );
}

Widget showHomeScreen(StoreResponse storeData, ConfigModel configObject,
    String version, String appName) {
  StoreResponse model = storeData;
  if (model.success) {
    setAppCurrency(model.store, configObject);
    SharedPrefs.storeSharedValue(
        AppConstant.DeliverySlot, model.store.deliverySlot);
    SharedPrefs.storeSharedValue(
        AppConstant.is24x7Open, model.store.is24x7Open);

    List<ForceDownload> forceDownload = model.store.forceDownload;
    //print("app= ${version} and -androidAppVerison--${forceDownload[0].androidAppVerison}");

    int index1 = version.lastIndexOf(".");
    //print("--substring--${version.substring(0,index1)} ");
    double currentVesrion = double.parse(version.substring(0, index1).trim());
    double apiVesrion = 1.0;
    try {
      apiVesrion = double.parse(
          forceDownload[0].androidAppVerison.substring(0, index1).trim());
    } catch (e) {
      //print("-apiVesrion--catch--${e}----");
    }
    //print("--currentVesrion--${currentVesrion} and ${apiVesrion}");
    if (apiVesrion > currentVesrion) {
      return ForceUpdateAlert(forceDownload[0].forceDownloadMessage, appName);
    } else {
      return HomeScreen(model.store, configObject);
    }
  } else {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/splash.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/app_config.json');
}
