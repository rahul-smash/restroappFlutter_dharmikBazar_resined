import 'package:flutter/material.dart';

class DialogUtils {

  static Future<bool> displayOutdoorShotDialog(BuildContext context,String title
      ,String body,String buttonText1,String buttonText2) async {

    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){

          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            title: Text(title,textAlign: TextAlign.center,),
            content: Text(body,textAlign: TextAlign.center,),
            actions: <Widget>[
              new FlatButton(
                child: new Text(buttonText1),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop(false);
                  // true here means you clicked ok
                },
              ),
              new FlatButton(
                child: Text(buttonText2),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.of(context).pop(true);
                  // true here means you clicked ok
                },
              ),
            ],
          ),
        );
      },
    );
  }


}

