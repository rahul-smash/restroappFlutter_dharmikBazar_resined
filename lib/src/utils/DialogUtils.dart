import 'package:flutter/material.dart';
import 'package:restroapp/src/models/PickUpModel.dart';

class DialogUtils {

  static Future<bool> displayDialog(BuildContext context,String title
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


  static Future<Datum> displayCityDialog(BuildContext context,String title,PickUpModel storeArea) async {

    return await showDialog<Datum>(
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
            content: Container(
              width: double.maxFinite,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: storeArea.data.length,
                      itemBuilder: (context, index) {
                        Datum areaObject = storeArea.data[index];
                        return InkWell(
                            onTap: () {
                              Navigator.pop(context, areaObject);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                    BorderSide(width: 1.0, color: Colors.black)),
                                color: Colors.white,
                              ),
                              child: Center(child: Text(areaObject.city.city)),
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  static Future<Area> displayAreaDialog(BuildContext context,String title,Datum cityObject) async {

    return await showDialog<Area>(
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
            content: Container(
              width: double.maxFinite,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cityObject.area.length,
                      itemBuilder: (context, index) {
                        Area object = cityObject.area[index];
                        return InkWell(
                            onTap: () {
                              Navigator.pop(context, object);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                    bottom:
                                    BorderSide(width: 1.0, color: Colors.black)),
                                color: Colors.white,
                              ),
                              child: Center(child: Text(object.areaName)),
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }




}

