import 'package:device_id/device_id.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/utils/Constants.dart';

class Utils{


  static void showToast(String msg, bool shortLength){
    try {
      if(shortLength){
            Fluttertoast.showToast(
                msg: msg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }else{
            Fluttertoast.showToast(
                msg: msg,
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0
            );
          }
      /*Scaffold.of(_context).showSnackBar(SnackBar(content: Text("$result"),
      duration: Duration(seconds: 3),));*/
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> isNetworkAvailable() async {
    bool isNetworkAvailable = false;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      isNetworkAvailable = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isNetworkAvailable =  true;
    }
    return isNetworkAvailable;
  }

  static Future<String> getDeviceId()  async {
    String device_id = await DeviceId.getID;
    print("-----device id------ ${device_id}");
    SharedPrefs.storeSharedValue(AppConstant.DEVICE_ID, device_id);
    return device_id;
  }

}