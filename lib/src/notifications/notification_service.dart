import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationService {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  bool _isAuthorized = false;
  final bool isForegroundNotificationEnabled;
  final String notificationIcon;
  final String channelId;
  final String channelName;
  final String channelDescription;

  AndroidNotificationChannel _channel;

  NotificationService({
    @required this.notificationIcon,
    this.isForegroundNotificationEnabled = true,
    this.channelId = 'default_channel_id',
    this.channelName = 'default_channel_name',
    this.channelDescription = 'default_channel_description',
  }) : assert(notificationIcon != null, 'notification icon can not be null');

  bool get isAuthorized => _isAuthorized;

  /// Handle notification when user click on it, for re-direction
  void handleNotificationClick(RemoteMessage message);

  /// Save the fcm token
  void saveFCMToken(String token);

  /// Set navigation key for handling notification re-directions
  void setGlobalNavigationKey(GlobalKey<NavigatorState> globalKey);

  /// Initialize the firebase messaging system
  Future<void> initialize() async {
    await Firebase.initializeApp();
    await _requestPermissionIOS();
    await _initLocalNotification();
    await _initFirebaseMessaging();
  }

  /// Initailize the location notification settings for android and ios
  Future<void> _initLocalNotification() async {
    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings(notificationIcon);

    const IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);

    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await _createChannelAndroid();
  }

  /// Request notification permission for iOS in case of
  /// android permission is granted by default
  Future<void> _requestPermissionIOS() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    _isAuthorized =
        settings.authorizationStatus == AuthorizationStatus.authorized;

    if (isForegroundNotificationEnabled) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    }
  }

  /// Setup notification channel for android, update the notification channel name in
  /// the manifest meta-data schema for firebase default_notification_channel
  Future<void> _createChannelAndroid() async {
    _channel = AndroidNotificationChannel(
        channelId, // id
        channelName,
        description: channelDescription,
        importance: Importance.max,
        enableLights: true);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// Listen for the firebase notification
  Future<void> _initFirebaseMessaging() async {
    // Will return the fcm token
    FirebaseMessaging.instance
        .getToken()
        .then(saveFCMToken, onError: _printError);

    // Will be called if the app opened from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(handleNotificationClick, onError: _printError);

    // Will be called when app is in foreground
    FirebaseMessaging.onMessage.listen(showNotification, onError: _printError);

    // Will be called if app opened from background state not terminated
    FirebaseMessaging.onMessageOpenedApp
        .listen(handleNotificationClick, onError: _printError);
  }

  /// Display notification locally
  void showNotification(RemoteMessage remoteMessage) {
    if (remoteMessage == null && remoteMessage.notification == null) {
      return;
    }

    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(_channel.id, _channel.name,
            channelDescription: _channel.description);

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    _flutterLocalNotificationsPlugin.show(
        remoteMessage.hashCode,
        remoteMessage.notification.title,
        remoteMessage.notification.body,
        notificationDetails);
  }

  /// Print error message information
  void _printError(Object error) =>
      debugPrint('NotificationService: ${error.toString()}');

  Future<bool> isAutoStartEnabled() =>
      DisableBatteryOptimization.isAutoStartEnabled;

  Future<bool> isBatteryOptimizationDisabled() =>
      DisableBatteryOptimization.isBatteryOptimizationDisabled;

  Future<bool> isManufacturerBatteryOptimizationDisabled() =>
      DisableBatteryOptimization.isManufacturerBatteryOptimizationDisabled;

  Future<bool> isAllBatteryOptimizationDisabled() =>
      DisableBatteryOptimization.isAllBatteryOptimizationDisabled;

  Future<bool> showEnableAutoStartSettings() =>
      DisableBatteryOptimization.showEnableAutoStartSettings(
          "Enable Auto Start",
          "Follow the steps and enable the auto start of this app");

  Future<bool> showDisableBatteryOptimizationSettings() =>
      DisableBatteryOptimization.showDisableBatteryOptimizationSettings();

  Future<bool> showDisableManufacturerBatteryOptimizationSettings() =>
      DisableBatteryOptimization.showDisableManufacturerBatteryOptimizationSettings(
          "Your device has additional battery optimization",
          "Follow the steps and disable the optimizations to allow smooth functioning of this app");

  Future<bool> showDisableAllOptimizationsSettings() =>
      DisableBatteryOptimization.showDisableAllOptimizationsSettings(
          "Enable Auto Start",
          "Follow the steps and enable the auto start of this app",
          "Your device has additional battery optimization",
          "Follow the steps and disable the optimizations to allow smooth functioning of this app");
}
