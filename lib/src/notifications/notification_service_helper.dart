import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/Dashboard/ProductDetailScreen.dart';
import 'package:restroapp/src/Screens/Offers/OfferScreen.dart';
import 'package:restroapp/src/Screens/Offers/OrderDetailScreenVersion2.dart';
import 'package:restroapp/src/UI/SubscriptionHistoryDetails.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

import '../Screens/BookOrder/SubCategoryProductScreen.dart';
import '../Screens/Dashboard/HomeScreen.dart';
import '../Screens/Offers/MyOrderScreenVersion2.dart';
import '../models/CategoryResponseModel.dart';
import '../models/ConfigModel.dart';
import 'notification_service.dart';

class NotificationServiceHelper extends NotificationService {
  static NotificationServiceHelper _instance;
  GlobalKey<NavigatorState> _globalKey;

  NotificationServiceHelper._() : super(notificationIcon: 'ic_notification');

  static NotificationServiceHelper get instance =>
      _instance ??= NotificationServiceHelper._();

  @override
  void setGlobalNavigationKey(GlobalKey<NavigatorState> globalKey) {
    _globalKey = globalKey;
  }

  @override
  void saveFCMToken(String token) {
    debugPrint('FCM Token: $token');
    SharedPrefs.storeSharedValue(AppConstant.deviceToken, token.toString());
  }

  @override
  Future<void> handleNotificationClick(RemoteMessage message) async {
    debugPrint('------On Notification Tap-------');
    if (message == null || message.data == null) return;
    debugPrint('On Notification Data: ${message.data.toString()}');
    try {
      Map<String, dynamic> map = message.data;
      String id = '';
      String type = '';
      StoreModel store = await SharedPrefs.getStore();

      bool isRatingEnable = store.reviewRatingDisplay != null &&
          store.reviewRatingDisplay.compareTo('1') == 0;
      _globalKey.currentState.popUntil((route) => route.isFirst);
      if (Platform.isIOS) {
      } else {
        id = map['id'];
        type = map['redirectTo'];
        // type = type.toLowerCase();
      }

      switch (type) {
        case 'offers':
          _globalKey.currentState.push(
            MaterialPageRoute(builder: (context) => MyOfferScreen(context)),
          );
          break;
        // case 'product':
        //   _globalKey.currentState.push(
        //     MaterialPageRoute(
        //         builder: (context) => Home()),
        //   );
        //   break;
      }
    } catch (e) {
      print(e);
    }

    Map<String, dynamic> attributeMap = new Map<String, dynamic>();
    attributeMap["ScreenName"] = "MyOrderScreen";
    Utils.sendAnalyticsEvent("Clicked MyOrderScreen", attributeMap);
  }

  @override
  Future<void> onSelectNotification(String payload) async {
    if (payload == null || payload.isEmpty) {
      return;
    }
    debugPrint('------payload------${payload}');
    try {
      Map<String, dynamic> map = jsonDecode(payload);
      String id = '';
      String type = '';
      StoreModel store = await SharedPrefs.getStore();
      bool isRatingEnable = store.reviewRatingDisplay != null &&
          store.reviewRatingDisplay.compareTo('1') == 0;
      _globalKey.currentState.popUntil((route) => route.isFirst);
      if (Platform.isIOS) {
      } else {
        id = map['id'];
        type = map['redirectTo'];
        // type = type.toLowerCase();
      }

      switch (type) {
        case 'offers':
          _globalKey.currentState.push(
            MaterialPageRoute(builder: (context) => MyOfferScreen(context)),
          );
          break;
        // case 'store':
        //   _globalKey.currentState.push(
        //     MaterialPageRoute(
        //         builder: (context) => HomeScreen(
        //            store,,true
        //         )),
        //   );
        //   break;
        // case 'product':
        //   _globalKey.currentState.push(
        //     MaterialPageRoute(
        //         builder: (context) => HomeScreen(
        //
        //         )),
        //   );
        //   break;
      }
    } catch (e) {
      print(e);
    }

    Map<String, dynamic> attributeMap = new Map<String, dynamic>();
    attributeMap["ScreenName"] = "MyOrderScreen";
    Utils.sendAnalyticsEvent("Clicked MyOrderScreen", attributeMap);
  }
}
