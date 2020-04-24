import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginMobileScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginEmailScreen.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
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
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: appTheme,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: msg,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: appTheme,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }
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
    if (pr != null && pr.isShowing()) {
      pr.hide();
    }
  }

  static double roundOffPrice(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static showFavIcon(String isFav) {
    Icon favIcon;
    //print("-showFavIcon- ${isFav}");
    if(isFav == null || isFav == "null" || isFav == "1"){
      favIcon = Icon(Icons.favorite);
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

}
