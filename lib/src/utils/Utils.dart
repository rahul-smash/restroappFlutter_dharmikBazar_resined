import 'dart:core';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginMobileScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginEmailScreen.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';

class Utils {
  static ProgressDialog pr;

  static void showToast(String msg, bool shortLength) {
    try {
      if (shortLength) {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: toastbgColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: toastbgColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
  }

  static void hideKeyboard(BuildContext context){
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

  static void showLoginDialog(BuildContext context) {
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
                SharedPrefs.getStore().then((storeData){
                  StoreModel model = storeData;
                  //print("---internationalOtp--${model.internationalOtp}");
                  //User Login with Mobile and OTP
                  // 1 = email and 0 = ph-no
                  if(model.internationalOtp == "0"){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginMobileScreen("menu")),
                    );
                  }else{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginEmailScreen("menu")),
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
      }else{
        if (pr != null){
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
    if(isFav == null){
      favIcon = Icon(Icons.favorite_border);
      return favIcon;
    }
    if(isFav == "1"){
      favIcon = Icon(Icons.favorite,color: orangeColor,);
    }else if(isFav == "0"){
      favIcon = Icon(Icons.favorite_border);
    }
    return favIcon;
  }

  static double calculateDistance(lat1, lon1, lat2, lon2){
    try {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 - c((lat2 - lat1) * p)/2 +
              c(lat1 * p) * c(lat2 * p) *
                  (1 - c((lon2 - lon1) * p))/2;
      return 12742 * asin(sqrt(a));
    } catch (e) {
      print(e);
      return 0.0;
    }
  }

  static double getDeviceWidth(BuildContext context){

    return MediaQuery.of(context).size.width;
  }

  static Widget getEmptyView(String value){
    return  Container(
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

  static Widget getImgPlaceHolder(){
    return Padding(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: CachedNetworkImage(
          imageUrl: "${AppConstant.placeholderUrl}",
          fit: BoxFit.cover
      ),
    );
  }

  static Widget showVariantDropDown(ClassType classType, Product product){
    //print("variants = ${product.variants} and ${classType}");

    if(classType == ClassType.CART){
      return Icon(Icons.keyboard_arrow_down,
          color: orangeColor,
          size: 25);
    }else{
      bool isVariantNull= false;
      if(product.variants != null){
        if(product.variants.length == 1){
          isVariantNull = true;
        }
      }
      return Icon(Icons.keyboard_arrow_down,
          color: isVariantNull ? whiteColor : orangeColor,
          size: 25);
    }
  }

  static String getDate(){
    var now = new DateTime.now();
    var formatter = new DateFormat('MMM yyyy');
    String formatted = formatter.format(now);
    //print(formatted); // something like 2013-04-20
    return formatted;
  }

  static String getCurrentDate(){
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    //print(formatted); // something like 2013-04-20
    return formatted;
  }

  static String getCurrentDateTime(){
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy hh:mm');
    String formatted = formatter.format(now);
    //print(formatted); // something like 2013-04-20
    return formatted;
  }

  static convertStringToDate2(String dateObj){
    DateFormat dateFormat = DateFormat("dd-MM-yyyy");
    DateTime dateTime = dateFormat.parse(dateObj);
    DateFormat formatter = new DateFormat('dd MMM');
    String formatted = formatter.format(dateTime);
    //print(formatted);
    return formatted;
  }

  static convertStringToDate(String dateObj){
    DateFormat dateFormat = DateFormat("dd MMM yyyy");
    DateTime dateTime = dateFormat.parse(dateObj);
    DateFormat formatter = new DateFormat('dd MMM');
    String formatted = formatter.format(dateTime);
    //print(formatted);
    return formatted;
  }

  static convertDateFormat(String dateObj){
    DateFormat dateFormat = DateFormat("dd MMM yyyy");
    DateTime dateTime = dateFormat.parse(dateObj);
    DateFormat formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(dateTime);
    //print(formatted);
    return formatted;
  }

  static convertOrderDateTime(String date){
    String formatted = date;
    try {
      DateFormat format = new DateFormat("yyyy-MM-dd hh:mm:ss");
      DateTime time = format.parse(date);
      time.toLocal();
      print("time.toLocal()=   ${time.toLocal()}");

      DateFormat formatter = new DateFormat('dd MMM yyyy');
      formatted = formatter.format(time.toLocal());
    } catch (e) {
      print(e);
    }

    return formatted;
  }

  static bool getDayOfWeek(StoreModel store){
    bool isStoreOpen;
    DateFormat dateFormat = DateFormat("hh:mma");
    DateFormat apiDateFormat = new DateFormat("yyyy-MM-dd hh:mm a");

    var currentDate = DateTime.now();
    print(currentDate.toString()); // prints something like 2019-12-10 10:02:22.287949

    String currentTime = apiDateFormat.format(currentDate);
    //currentTime = currentTime.replaceAll("AM", "am").replaceAll("PM","pm");
    print("----------------------------------------------");
    print("openhoursFrom= ${store.openhoursFrom}");
    print("openhoursTo=   ${store.openhoursTo}");
    print("currentTime=   ${currentTime}");
    print("----------------------------------------------");

    String openhours_From = store.openhoursFrom.replaceAll("am", " AM").replaceAll("pm"," PM");
    String openhours_To = store.openhoursTo.replaceAll("am", " AM").replaceAll("pm"," PM");
   // print("--${getCurrentDate()}--openhoursFrom----${openhours_From} and ${openhours_To}");

    String openhoursFrom = "${getCurrentDate()} ${openhours_From}";//"2020-06-02 09:30 AM";
    String openhoursTo =   "${getCurrentDate()} ${openhours_To}";//"2020-06-02 06:30 PM";
    String currentDateTime = currentTime; //"2020-06-02 08:30 AM";

    DateTime storeOpenTime = apiDateFormat.parse(openhoursFrom);
    DateTime storeCloseTime = apiDateFormat.parse(openhoursTo);
    DateTime currentTimeObj = apiDateFormat.parse(currentDateTime);

    //print("${dateFormat.format(storeOpenTime)} and ${dateFormat.format(storeCloseTime)}");
    //print("currentTimeObj = ${currentTimeObj.toString()}");
    print("----------------------------------------------");
    print("openhoursFrom=   ${openhoursFrom}");
    print("openhoursTo=     ${openhoursTo}");
    print("currentDateTime= ${currentDateTime}");
    print("----------------------------------------------");
    if(currentTimeObj.isAfter(storeOpenTime) && currentTimeObj.isBefore(storeCloseTime)) {
      // do something
      print("---if----isAfter---and --isBefore---}");
      isStoreOpen = true;
    }else{
      print("---else---else--else---else----else-------------}");
      isStoreOpen = false;
    }
    return isStoreOpen;
  }


  static bool checkStoreOpenDays(StoreModel store){
    bool isStoreOpenToday;
    var date = DateTime.now();
    //print(DateFormat('EEE').format(date)); // prints Tuesday
    String dayName = DateFormat('EEE').format(date).toLowerCase();

    List<String> storeOpenDaysList = store.storeOpenDays.split(",");
    //print("${dayName} and ${storeOpenDaysList}");

    if(storeOpenDaysList.contains(dayName)){
      //print("true contains");
      isStoreOpenToday = true;
    }else{
      //print("false contains");
      isStoreOpenToday = false;
    }
    return isStoreOpenToday;
  }

  static bool checkStoreOpenTime(StoreModel storeObject, OrderType deliveryType) {
    // in case of deliver ignore is24x7Open
    bool status = false;
    if(storeObject.is24x7Open == "1" && deliveryType == OrderType.PickUp){
      // 1 = means store open 24x7
      // 0 = not open for 24x7
      status = true;
    }else if (storeObject.openhoursFrom.isEmpty || storeObject.openhoursFrom.isEmpty) {
      status = true;
    } else {
      bool isStoreOpenToday = Utils.checkStoreOpenDays(storeObject);
      if(isStoreOpenToday){
        bool isStoreOpen = Utils.getDayOfWeek(storeObject);
        status = isStoreOpen;
      }else{
        status = false;
      }
    }
    return status;
  }

  static Widget getEmptyView2(String value){
    return  Container(
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

  static Future<void> _setSetCurrentScreen(String screenName,String screenClassOverride) async {
    await analytics.setCurrentScreen(
      screenName: '${screenName}',
      screenClassOverride: '${screenClassOverride}',
    );
  }

  static Future<void> _sendAnalyticsEvent(String name,Map<String, dynamic> parameters) async {
    await analytics.logEvent(
      name: '${name}',
      parameters: parameters,
    );
  }


}




enum ClassType {
  CART,SubCategory,Favourites,Search
}

enum OrderType {
  Delivery,PickUp,Menu
}

enum PaymentType {
  COD,ONLINE,CANCEL
}

