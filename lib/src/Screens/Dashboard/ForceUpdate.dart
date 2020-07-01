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
    return AlertDialog(
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
    );
  }
}

