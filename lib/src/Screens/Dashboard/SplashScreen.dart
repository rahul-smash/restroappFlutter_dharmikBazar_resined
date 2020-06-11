import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/ConfigModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/Screens/Dashboard/HomeScreen.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/BaseState.dart';
import 'package:restroapp/src/utils/Utils.dart';

class SplashScreen extends StatefulWidget {

  ConfigModel configObject;
  StoreResponse storeData;
  SplashScreen(this.configObject,this.storeData );

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  String appName = "";
  String version = "";
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    getdeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/splash.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          child: FutureBuilder(
            future: Utils.getAppVersionDetails(),
            builder: (context,projectSnap){
              if (projectSnap.connectionState == ConnectionState.none &&
                  projectSnap.hasData == null) {
                return Container(color: const Color(0xFFFFE306));
              }
              else {
                if(projectSnap.hasData){
                  PackageInfo packageInfo = projectSnap.data;
                  appName = packageInfo.appName;
                  version = packageInfo.version;

                  return showHomeScreen();

                } else {
                  return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.black26,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.black26)),
                  );
                }
              }

            },
          ),
        ),
      ),
    );
  }

  void getdeviceToken() {
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token){
      print("----token---- ${token}");
      try {
        SharedPrefs.storeSharedValue(AppConstant.deviceToken, token.toString());
      } catch (e) {
        print(e);
      }
    });
  }

  Widget showHomeScreen() {
    StoreResponse model = widget.storeData;
    if (model.success) {
      setAppThemeColors(model.store);
      SharedPrefs.storeSharedValue(AppConstant.DeliverySlot, model.store.deliverySlot);
      SharedPrefs.storeSharedValue(AppConstant.is24x7Open, model.store.is24x7Open);

      List<ForceDownload> forceDownload = model.store.forceDownload;
      print("app= ${version} and -androidAppVerison--${forceDownload[0].androidAppVerison}");
      int index1 = version.lastIndexOf(".");
      //print("--substring--${version.substring(0,index1)} ");
      double currentVesrion = double.parse(version.substring(0,index1).trim());
      double apiVesrion = 1.0;
      try {
        apiVesrion = double.parse(forceDownload[0].androidAppVerison.substring(0,index1).trim());
      } catch (e) {
        print("-apiVesrion--catch--${e}----");
      }
      print("--currentVesrion--${currentVesrion} and ${apiVesrion}");
      if(apiVesrion > currentVesrion){
        return ForceUpdateAlert(forceDownload[0].forceDownloadMessage,appName);
      }else{
        return HomeScreen(model.store,widget.configObject);
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

  void setAppThemeColors(StoreModel store) {
    if(store.showCurrency == "symbol"){
      if(store.currency_unicode.isEmpty){
        AppConstant.currency = store.currencyAbbr;
      }else{
        AppConstant.currency = widget.configObject.currency;
      }
      //U+020B9 // \u20B9
    }else{
      AppConstant.currency = store.currencyAbbr;
    }
    //print("======currency====${AppConstant.currency}");
    //String currency = "\u20B9";
  }
}




class ForceUpdateAlert extends StatefulWidget{
  String forceDownloadMessage;
  String appName;
  ForceUpdateAlert(this.forceDownloadMessage, this.appName);

  @override
  State<StatefulWidget> createState() {
    return ForceUpdateAlertState();
  }
}

class ForceUpdateAlertState extends BaseState<ForceUpdateAlert>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/splash.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))
          ),
          title: Text("${widget.appName}",textAlign: TextAlign.center,),
          content: Text("${widget.forceDownloadMessage}",textAlign: TextAlign.center,),
          actions: <Widget>[
            new FlatButton(
              child: Text("OK"),
              textColor: Colors.blue,
              onPressed: () {
                SystemNavigator.pop();
                //Navigator.of(context).pop(true);
                // true here means you clicked ok
              },
            ),
          ],
        ),
      ),
    );
  }


}


class CustomPageRoute<T> extends PageRoute<T> {
  CustomPageRoute(this.child);
  @override
  Color get barrierColor => Colors.black;

  @override
  String get barrierLabel => null;

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(seconds: 1);
}
