import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginMobileScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginScreen.dart';
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
                Navigator.push(
                  context,
                     MaterialPageRoute(builder: (context) => LoginScreen("cart")),
                //  MaterialPageRoute(builder: (context) => LoginMobileScreen("cart")),
                );
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
}
