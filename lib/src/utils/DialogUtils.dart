import 'package:flutter/material.dart';
import 'package:restroapp/src/models/PickUpModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';

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


  static Future<bool> displayPaymentDialog(BuildContext context,String title,String note) async {

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
            content: Container(
              child: Wrap(
                children: <Widget>[
                  Text(note,textAlign: TextAlign.center,),
                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(20),
                        child: FlatButton(
                          child: Text('Offline'),
                          color: appTheme,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        child: FlatButton(
                          child: Text('Online'),
                          color: appTheme,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
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


  static Future<Variant> displayVariantsDialog(BuildContext context,String title, List<Variant> variants) async {

    return await showDialog<Variant>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            title: Container(
              child: Text(title,textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),),
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: variants.length,
                separatorBuilder: (BuildContext context, int index) {

                  return Divider();
                },
                itemBuilder: (context, index) {
                  Variant areaObject = variants[index];
                  return InkWell(
                      onTap: () {
                        Navigator.pop(context, areaObject);
                      },
                    child: ListTile(
                      title: Text(areaObject.weight,style: TextStyle(color: Colors.black)),
                      trailing: Text("₹ ${areaObject.price}",style: TextStyle(color: Colors.black)),
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Cancel"),
                textColor: Colors.blue,
                onPressed: () {
                  Navigator.pop(context);
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

