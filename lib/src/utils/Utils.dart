import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/Screens/BookOrder/MyCartScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginMobileScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginEmailScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';

import 'Callbacks.dart';
import 'DialogUtils.dart';

class Utils {
  static ProgressDialog pr;

  static void showToast(String msg, bool shortLength) {
    try {
      if (shortLength) {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: toastbgColor.withOpacity(0.9),
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: toastbgColor.withOpacity(0.9),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<PackageInfo> getAppVersionDetails(
      StoreResponse storeData) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    SharedPrefs.storeSharedValue(AppConstant.appName, packageInfo.appName);
    SharedPrefs.storeSharedValue(
        AppConstant.old_appverion, packageInfo.version);

    return packageInfo;
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    /*if (!regex.hasMatch(value))
      return true;
    else
      return false;*/
    return regex.hasMatch(value);
  }

  static Future<void> showLoginDialog(BuildContext context) async {
    try {
      //User Login with Mobile and OTP
      // 1 = email and 0 = ph-no
      StoreModel model = await SharedPrefs.getStore();
      if (model.internationalOtp == "0") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginMobileScreen("menu")),
        );
        Map<String, dynamic> attributeMap = new Map<String, dynamic>();
        attributeMap["ScreenName"] = "LoginMobileScreen";
        Utils.sendAnalyticsEvent("Clicked LoginMobileScreen", attributeMap);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginEmailScreen("menu")),
        );
        Map<String, dynamic> attributeMap = new Map<String, dynamic>();
        attributeMap["ScreenName"] = "LoginEmailScreen";
        Utils.sendAnalyticsEvent("Clicked LoginEmailScreen", attributeMap);
      }
    } catch (e) {
      print(e);
    }
  }

  static void showLoginDialog2(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Login"),
          content: Text(AppConstant.pleaseLogin),
          actions: [
            FlatButton(
              child: new Text("YES"),
              onPressed: () {
                Navigator.of(context).pop();
                SharedPrefs.getStore().then((storeData) {
                  StoreModel model = storeData;
                  //print("---internationalOtp--${model.internationalOtp}");
                  //User Login with Mobile and OTP
                  // 1 = email and 0 = ph-no
                  if (model.internationalOtp == "0") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginMobileScreen("menu")),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginEmailScreen("menu")),
                    );
                  }
                });
              },
            ),
            FlatButton(
              child: const Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<bool> isNetworkAvailable() async {
    bool isNetworkAvailable = false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      isNetworkAvailable = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isNetworkAvailable = true;
    }
    return isNetworkAvailable;
  }

  static void showProgressDialog(BuildContext context) {
    //For normal dialog
    if (pr != null && pr.isShowing()) {
      pr.hide();
    }
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.show();
  }

  static void hideProgressDialog(BuildContext context) {
    //For normal dialog
    try {
      if (pr != null && pr.isShowing()) {
        pr.hide();
        pr = null;
      } else {
        if (pr != null) {
          pr.hide();
        }
      }
    } catch (e) {
      print(e);
    }
  }

  static double roundOffPrice(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static showFavIcon(String isFav) {
    Icon favIcon;
    //print("-showFavIcon- ${isFav}");
    if (isFav == null) {
      favIcon = Icon(Icons.favorite_border);
      return favIcon;
    }
    if (isFav.isEmpty) {
      favIcon = Icon(Icons.favorite_border);
      return favIcon;
    }
    if (isFav == "1") {
      favIcon = Icon(
        Icons.favorite,
        color: appThemeSecondary,
      );
    } else if (isFav == "0") {
      favIcon = Icon(Icons.favorite_border);
    }

    return favIcon;
  }

  static double calculateDistance(lat1, lon1, lat2, lon2) {
    try {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      return 12742 * asin(sqrt(a));
    } catch (e) {
      print(e);
      return 0.0;
    }
  }

  static double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Widget showDivider(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 1,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Color(0xFFDBDCDD),
    );
  }

  static Widget getEmptyView(String value) {
    return Container(
      child: Expanded(
        child: Center(
          child: Text(value,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              )),
        ),
      ),
    );
  }

  static Widget getImgPlaceHolder() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: CachedNetworkImage(
          imageUrl: "${AppConstant.placeholderUrl}", fit: BoxFit.cover),
    );
  }

  static Widget showVariantDropDown(ClassType classType, Product product) {
    //print("variants = ${product.variants} and ${classType}");

    if (classType == ClassType.CART) {
      return Icon(Icons.keyboard_arrow_down,
          color: appThemeSecondary, size: 25);
    } else {
      bool isVariantNull = false;
      if (product.variants != null) {
        if (product.variants.length == 1) {
          isVariantNull = true;
        }
      }
      return Icon(Icons.keyboard_arrow_down,
          color: isVariantNull ? whiteColor : appThemeSecondary, size: 25);
    }
  }

  static String getDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMM yyyy');
    String formatted = formatter.format(now);
    //print(formatted); // something like 2013-04-20
    return formatted;
  }

  static String getCurrentDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    //print(formatted); // something like 2013-04-20
    return formatted;
  }

  static String getCurrentDateTime() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy hh:mm');
    String formatted = formatter.format(now);
    //print(formatted); // something like 2013-04-20
    return formatted;
  }

  static convertStringToDate2(String dateObj) {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    DateTime dateTime = dateFormat.parse(dateObj);
    DateFormat formatter = new DateFormat('dd MMM yyyy');
    String formatted = formatter.format(dateTime);
    //print(formatted);
    return formatted;
  }

  static convertStringToDate(String dateObj) {
    DateFormat dateFormat = DateFormat("dd MMM yyyy");
    DateTime dateTime = dateFormat.parse(dateObj);
    DateFormat formatter = new DateFormat('dd MMM');
    String formatted = formatter.format(dateTime);
    //print(formatted);
    return formatted;
  }

  static convertDateFormat(String dateObj) {
    DateFormat dateFormat = DateFormat("dd MMM yyyy");
    DateTime dateTime = dateFormat.parse(dateObj);
    DateFormat formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(dateTime);
    //print(formatted);
    return formatted;
  }

  static convertOrderDateTime(String date) {
    String formatted = date;
    try {
      DateFormat format = new DateFormat("yyyy-MM-dd hh:mm:ss");
      //UTC time true
      DateTime time = format.parse(date, true);
      time = time.toLocal();
      //print("time.toLocal()=   ${time.toLocal()}");
      DateFormat formatter = new DateFormat('dd MMM yyyy, hh:mm a');
      formatted = formatter.format(time.toLocal());
    } catch (e) {
      print(e);
    }

    return formatted;
  }

  static convertOrderDate(String date) {
    String formatted = date;
    try {
      DateFormat format = new DateFormat("yyyy-MM-dd hh:mm:ss");
      //UTC time true
      DateTime time = format.parse(date, true);
      time = time.toLocal();
      //print("time.toLocal()=   ${time.toLocal()}");
      DateFormat formatter = new DateFormat('dd MMM, yyyy');
      formatted = formatter.format(time.toLocal());
    } catch (e) {
      print(e);
    }

    return formatted;
  }

  static convertNotificationDateTime(String date, {bool onlyTime = false}) {
    String formatted = date;
    try {
      DateFormat format = new DateFormat("dd MMM yyyy hh:mm a");
      //UTC time true
      DateTime time = format.parse(date, true);
      time = time.toLocal();
      //print("time.toLocal()=   ${time.toLocal()}");
      DateFormat formatter = new DateFormat('dd MMM yyyy');
      if (onlyTime) {
        formatter = new DateFormat('hh:mm a');
      }
      formatted = formatter.format(time.toLocal());
    } catch (e) {
      print(e);
    }

    return formatted;
  }

  static bool getDayOfWeek(StoreModel store) {
    bool isStoreOpen;
    DateFormat dateFormat = DateFormat("hh:mma");
    DateFormat apiDateFormat = new DateFormat("yyyy-MM-dd hh:mm a");

    var currentDate = DateTime.now();
    print(currentDate
        .toString()); // prints something like 2019-12-10 10:02:22.287949

    String currentTime = apiDateFormat.format(currentDate);
    //currentTime = currentTime.replaceAll("AM", "am").replaceAll("PM","pm");
    /*print("----------------------------------------------");
    print("openhoursFrom= ${store.openhoursFrom}");
    print("openhoursTo=   ${store.openhoursTo}");
    print("currentTime=   ${currentTime}");
    print("----------------------------------------------");*/

    String openhours_From =
        store.openhoursFrom.replaceAll("am", " AM").replaceAll("pm", " PM");
    String openhours_To =
        store.openhoursTo.replaceAll("am", " AM").replaceAll("pm", " PM");
    // print("--${getCurrentDate()}--openhoursFrom----${openhours_From} and ${openhours_To}");

    String openhoursFrom =
        "${getCurrentDate()} ${openhours_From}"; //"2020-06-02 09:30 AM";
    String openhoursTo =
        "${getCurrentDate()} ${openhours_To}"; //"2020-06-02 06:30 PM";
    String currentDateTime = currentTime; //"2020-06-02 08:30 AM";

    DateTime storeOpenTime = apiDateFormat.parse(openhoursFrom);
    DateTime storeCloseTime = apiDateFormat.parse(openhoursTo);
    DateTime currentTimeObj = apiDateFormat.parse(currentDateTime);

    //print("${dateFormat.format(storeOpenTime)} and ${dateFormat.format(storeCloseTime)}");
    //print("currentTimeObj = ${currentTimeObj.toString()}");
    //print("----------------------------------------------");
    //print("openhoursFrom=   ${openhoursFrom}");
    //print("openhoursTo=     ${openhoursTo}");
    //print("currentDateTime= ${currentDateTime}");
    //print("----------------------------------------------");
    if (currentTimeObj.isAfter(storeOpenTime) &&
        currentTimeObj.isBefore(storeCloseTime)) {
      // do something
      //print("---if----isAfter---and --isBefore---}");
      isStoreOpen = true;
    } else {
      //print("---else---else--else---else----else-------------}");
      isStoreOpen = false;
    }
    return isStoreOpen;
  }

  static bool checkStoreOpenDays(StoreModel store) {
    bool isStoreOpenToday;
    var date = DateTime.now();
    //print(DateFormat('EEE').format(date)); // prints Tuesday
    String dayName = DateFormat('EEE').format(date).toLowerCase();

    List<String> storeOpenDaysList = store.storeOpenDays.split(",");
    //print("${dayName} and ${storeOpenDaysList}");

    if (storeOpenDaysList.contains(dayName)) {
      //print("true contains");
      isStoreOpenToday = true;
    } else {
      //print("false contains");
      isStoreOpenToday = false;
    }
    return isStoreOpenToday;
  }

  static bool checkStoreOpenTime(
      StoreModel storeObject, OrderType deliveryType) {
    // in case of deliver ignore is24x7Open
    bool status = false;
    try {
      // user selct deliver  = is24x7Open ignore , if delivery slots is 1
      //if delivery slots = 0 , is24x7Open == 0, proced aage, then check time
      if (deliveryType == OrderType.Delivery) {
        if (storeObject.deliverySlot == "1") {
          status = true;
        } else if (storeObject.deliverySlot == "0" &&
            storeObject.is24x7Open == "0") {
          bool isStoreOpenToday = Utils.checkStoreOpenDays(storeObject);
          if (isStoreOpenToday) {
            bool isStoreOpen = Utils.getDayOfWeek(storeObject);
            status = isStoreOpen;
          } else {
            status = false;
          }
        } else if (storeObject.is24x7Open == "1") {
          status = true;
        }
      } else {
        if (deliveryType == OrderType.PickUp) {
          if (storeObject.is24x7Open == "1") {
            // 1 = means store open 24x7
            // 0 = not open for 24x7
            status = true;
          } else if (storeObject.openhoursFrom.isEmpty ||
              storeObject.openhoursFrom.isEmpty) {
            status = true;
          } else {
            bool isStoreOpenToday = Utils.checkStoreOpenDays(storeObject);
            if (isStoreOpenToday) {
              bool isStoreOpen = Utils.getDayOfWeek(storeObject);
              status = isStoreOpen;
            } else {
              status = false;
            }
          }
        }
      }
      return status;
    } catch (e) {
      print(e);
      return true;
    }
  }

  static Widget getIndicatorView() {
    return Center(
      child: CircularProgressIndicator(
          backgroundColor: Colors.black26,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)),
    );
  }

  static Widget getEmptyView2(String value) {
    return Container(
      child: Center(
        child: Text(value,
            overflow: TextOverflow.ellipsis,
            style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18.0,
            )),
      ),
    );
  }

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  static Future<void> setSetCurrentScreen(
      String screenName, String screenClassOverride) async {
    await analytics.setCurrentScreen(
      screenName: '${screenName}',
      screenClassOverride: '${screenClassOverride}',
    );
  }

  static Future<void> sendAnalyticsEvent(
      String name, Map<String, dynamic> parameters) async {
    String eventName = name.replaceAll(" ", "_");
    await analytics.logEvent(
      name: '${eventName}',
      parameters: parameters,
    );
  }

  static Future<void> sendSearchAnalyticsEvent(String searchTerm) async {
    await analytics.logSearch(
      searchTerm: '${searchTerm}',
    );
  }

  static Future<List<DeliveryAddressData>> checkDeletedAreaFromStore(
      BuildContext context, List<DeliveryAddressData> addressList,
      {bool showDialogBool, bool hitApi = false, String id = ""}) async {
    DeliveryAddressData deletedItem;
    print(id);
    for (int i = 0; i < addressList.length; i++) {
      print(addressList[i].id.compareTo(id) == 0);
      if (id.isNotEmpty &&
          addressList[i].id.compareTo(id) == 0 &&
          addressList[i].isDeleted) {
        deletedItem = addressList[i];
        break;
      } else if (id.isEmpty && addressList[i].isDeleted) {
        deletedItem = addressList[i];
        break;
      }
    }

    if (deletedItem != null) {
      bool results = false;
      if (showDialogBool) {
        results = await DialogUtils.showAreaRemovedDialog(
            context, deletedItem.areaName);
      } else {
        results = true;
      }
      if (results) {
        //Hit api
        if (hitApi)
          ApiController.deleteDeliveryAddressApiRequest(deletedItem.id);
        addressList.remove(deletedItem);
        addressList = await checkDeletedAreaFromStore(context, addressList,
            showDialogBool: false, hitApi: hitApi);
      }
    }
    return addressList;
  }

  static Future<String> getCartItemsListToJson(
      {bool isOrderVariations = true,
      List<OrderDetail> responseOrderDetail}) async {
    List jsonList = OrderDetail.encodeToJson(responseOrderDetail,
        removeOutOfStockProducts: true);
    String encodedDoughnut = jsonEncode(jsonList);
    return encodedDoughnut;
  }

  static Color colorGeneralization(Color passedColor, String colorString) {
    Color returnedColor = passedColor;
    if (colorString != null) {
      try {
        returnedColor = Color(int.parse(colorString.replaceAll("#", "0xff")));
      } catch (e) {
        print(e);
      }
    }
    return returnedColor;
  }

  static void insertInCartTable(String storeName, BuildContext context,
      OrderItems product, int quantity) async {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    String variantId, weight, mrpPrice, price, discount, isUnitType;
    variantId = product.variantId;
    weight = product.weight;
    mrpPrice = product.mrpPrice;
    price = product.price;
    discount = product.discount;
    isUnitType = product.unitType;

    var mId = int.parse(product.id);
    //String variantId = product.variantId;

    Map<String, dynamic> row = {
      DatabaseHelper.ID: mId,
      DatabaseHelper.VARIENT_ID: variantId,
      DatabaseHelper.WEIGHT: weight,
      DatabaseHelper.MRP_PRICE: mrpPrice,
      DatabaseHelper.PRICE: price,
      DatabaseHelper.DISCOUNT: discount,
      DatabaseHelper.UNIT_TYPE: isUnitType,
      DatabaseHelper.PRODUCT_ID: product.id,
      /* product.isFav*/
      DatabaseHelper.isFavorite: '',
      DatabaseHelper.QUANTITY: quantity.toString(),
      DatabaseHelper.IS_TAX_ENABLE: product.isTaxEnable,
      DatabaseHelper.Product_Name: product.productName,
      DatabaseHelper.nutrient: product.nutrient,
      DatabaseHelper.description: product.description,
      DatabaseHelper.imageType: product.imageType,
      DatabaseHelper.imageUrl: product.imageUrl,
      DatabaseHelper.image_100_80: product.image10080,
      DatabaseHelper.image_300_200: product.image300200
    };

    int count = await databaseHelper.checkIfProductsExistInDb(
        DatabaseHelper.CART_Table, variantId);
    //print("-count-- ${count}");
    if (count == 0) {
      count = await databaseHelper.addProductToCart(row);
//          widget.callback();
      eventBus.fire(updateCartCount());
    } else {
      count = await databaseHelper.updateProductInCart(row, variantId);
//          widget.callback();
      eventBus.fire(updateCartCount());
    }
    var result = await DialogUtils.displayCommonDialog(context, storeName,
        'Your order is successfully added to your cart. Please check your cart to proceed',
        buttonText: 'Ok');
    if (result == true) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MyCartScreen(() {})));
    }
  }

  static void reOrderItems(
      String storeName, BuildContext context, OrderData orderData) {
    Utils.showProgressDialog(context);
    ApiController.getOrderDetail(orderData.orderId).then((respone) {
      if (respone != null &&
          respone.success &&
          respone.orders != null &&
          respone.orders.isNotEmpty) {
        for (int i = 0; i < respone.orders.first.orderItems.length; i++) {
          insertInCartTable(storeName, context, respone.orders.first.orderItems[i],
              int.parse(respone.orders.first.orderItems[i].quantity));
        }
      }
      Utils.hideProgressDialog(context);
    });
  }
}

enum ClassType { CART, SubCategory, Favourites, Search }

enum OrderType { Delivery, PickUp, Menu }

enum PaymentType { COD, ONLINE, ONLINE_PAYTM, CANCEL }
enum RadioButtonEnum { SELECTD, UNSELECTED }

class AdditionItemsConstants {
  static const ABOUT_US = "About Us";
  static const FAQ = "FAQ";
  static const TERMS_CONDITIONS = "Terms and Conditions";
  static const PRIVACY_POLICY = "Privacy Policy";
  static const REFUND_POLICY = "Refund Policy";
}
