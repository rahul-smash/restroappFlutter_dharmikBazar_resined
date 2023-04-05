import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:restroapp/src/Screens/Dashboard/HomeScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/ConfigModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/notifications/notification_service_helper.dart';
import 'package:restroapp/src/singleton/app_version_singleton.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'src/UI/Language.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationServiceHelper.instance.initialize();
  NotificationServiceHelper.instance.showNotification(message);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  String value =
      await SharedPrefs.getStoreSharedValue(AppConstant.SelectedLanguage);
  if (value == null) {
    SharedPrefs.storeSharedValue(
        AppConstant.SelectedLanguage, AppConstant.ENGLISH);
  }
  Language language = Language();
  language.changeLanguage();

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
    SharedPrefs.storeSharedValue(AppConstant.deviceId, androidDeviceInfo.id);
  }

  if (configObject.isGroceryApp == "true") {
    AppConstant.isRestroApp = false;
  } else {
    AppConstant.isRestroApp = true;
  }

  String branch_id =
      await SharedPrefs.getStoreSharedValue(AppConstant.branch_id);
  if (branch_id == null || branch_id.isEmpty) {
  } else if (branch_id.isNotEmpty) {
    configObject.storeId = branch_id;
  }
  //print(configObject.storeId);

  // Crashlytics.instance.enableInDevMode = true;
  StoreResponse storeData =
      await ApiController.versionApiRequest("${configObject.storeId}");
  AppVersionSingleton.instance.appVersion = storeData;
  setAppThemeColors(storeData.store);
  // Pass all uncaught errors to Crashlytics.
  // FlutterError.onError = Crashlytics.instance.recordFlutterError;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  SharedPrefs.storeSharedValue(AppConstant.isAdminLogin, "$isAdminLogin");

  PackageInfo packageInfo = await Utils.getAppVersionDetails(storeData);
 SystemUiOverlayStyle.light.copyWith(
   statusBarIconBrightness: Brightness.dark,
   statusBarColor: whiteColor
 );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Utils.getDeviceInfo(storeData);
  // To turn off landscape mode
  runZonedGuarded(() {
    runApp(ValueApp(packageInfo, configObject, storeData));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError);
}

class ValueApp extends StatefulWidget {
  ConfigModel configObject;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  StoreResponse storeData;
  PackageInfo packageInfo;

  ValueApp(this.packageInfo, this.configObject, this.storeData);

  @override
  State<ValueApp> createState() => _ValueAppState();
}

class _ValueAppState extends State<ValueApp> {
  GlobalKey<NavigatorState> _globalKey;

  @override
  void initState() {
    _globalKey = GlobalKey<NavigatorState>();
    NotificationServiceHelper.instance.setGlobalNavigationKey(_globalKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // define it once at root level.
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '${widget.storeData.store.storeName}',
      navigatorKey: _globalKey,
      theme: ThemeData(
          primaryColor: appTheme, appBarTheme: AppBarTheme(color: appTheme)),
      navigatorObservers: <NavigatorObserver>[ValueApp.observer],
      //home: isAdminLogin == true? LoginEmailScreen("menu"):SplashScreen(configObject,storeData),
      home: MyWidget(widget.storeData, widget.configObject, widget.packageInfo),
    );
  }
}

class MyWidget extends StatelessWidget {
  StoreResponse storeData;
  PackageInfo packageInfo;
  ConfigModel configObject;

  MyWidget(this.storeData, this.configObject, this.packageInfo);

  @override
  Widget build(BuildContext context) {
    //print("getDeviceWidth-${Utils.getDeviceWidth(context)} X ${Utils.getDeviceHeight(context)}");
    Utils.width = Utils.getDeviceWidth(context);
    Utils.height = Utils.getDeviceHeight(context);
    return Scaffold(
      body: showHomeScreen(storeData, configObject, packageInfo),
    );
  }
}

Widget showHomeScreen(
    StoreResponse model, ConfigModel configObject, PackageInfo packageInfo) {
  String version = packageInfo.version;
  if (model.success) {
    setStoreCurrency(model.store, configObject);
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
      if (Platform.isIOS) {
        apiVesrion = double.parse(
            forceDownload[0].iosAppVersion.substring(0, index1).trim());
      } else {
        apiVesrion = double.parse(
            forceDownload[0].androidAppVerison.substring(0, index1).trim());
      }
    } catch (e) {
      //print("-apiVesrion--catch--${e}----");
    }
    //print("--currentVesrion--${currentVesrion} and ${apiVesrion}");
    if (apiVesrion > currentVesrion) {
      //return ForceUpdateAlert(forceDownload[0].forceDownloadMessage,appName);
      return HomeScreen(model.store, configObject, true);
    } else {
      return HomeScreen(model.store, configObject, false);
    }
  } else {
    return Container();
  }
}

void setStoreCurrency(StoreModel store, ConfigModel configObject) {
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
}

void setAppThemeColors(StoreModel store) {
  AppThemeColors appThemeColors = store.appThemeColors;
  appTheme = Color(int.parse(appThemeColors.appThemeColor));
  appThemeLight = appTheme.withOpacity(0.1);

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

  //flow change
  if (store.webAppThemeColors != null) {
    WebAppThemeColors webAppThemeColors = store.webAppThemeColors;
    appTheme = Utils.colorGeneralization(
        appTheme, webAppThemeColors.webThemePrimaryColor);
    appThemeLight = appTheme.withOpacity(0.1);
    appThemeSecondary = Utils.colorGeneralization(
        appThemeSecondary, webAppThemeColors.webThemeSecondaryColor);

    dotIncreasedColor = appThemeSecondary;
    webThemeCategoryOpenColor = Utils.colorGeneralization(
        appThemeLight, webAppThemeColors.webThemeCategoryOpenColor);
    stripsColor =
        Utils.colorGeneralization(stripsColor, webAppThemeColors.stripsColor);
    footerColor =
        Utils.colorGeneralization(footerColor, webAppThemeColors.footerColor);
    listingBackgroundColor = Utils.colorGeneralization(
        listingBackgroundColor, webAppThemeColors.listingBackgroundColor);
    listingBorderColor = Utils.colorGeneralization(
        listingBorderColor, webAppThemeColors.listingBorderColor);
    listingBoxBackgroundColor = Utils.colorGeneralization(
        listingBoxBackgroundColor, webAppThemeColors.listingBoxBackgroundColor);
    homeSubHeadingColor = Utils.colorGeneralization(
        homeSubHeadingColor, webAppThemeColors.homeSubHeadingColor);
    homeDescriptionColor = Utils.colorGeneralization(
        homeDescriptionColor, webAppThemeColors.homeDescriptionColor);
    categoryListingButtonBorderColor = Utils.colorGeneralization(
        categoryListingButtonBorderColor,
        webAppThemeColors.categoryListingButtonBorderColor);
    categoryListingBoxBackgroundColor = Utils.colorGeneralization(
        categoryListingBoxBackgroundColor,
        webAppThemeColors.categoryListingBoxBackgroundColor);

    bottomBarTextColor =
        Utils.colorGeneralization(bottomBarBackgroundColor, "#000000");
    bottomBarIconColor = appTheme;
    bottomBarBackgroundColor =
        Utils.colorGeneralization(bottomBarBackgroundColor, "#ffffff");
    leftMenuLabelTextColors =
        Utils.colorGeneralization(leftMenuLabelTextColors, "#ffffff");
  } else {
    appTheme = Color(int.parse(appThemeColors.appThemeColor));
    appThemeLight = appTheme.withOpacity(0.1);
  }
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/app_config.json');
}
