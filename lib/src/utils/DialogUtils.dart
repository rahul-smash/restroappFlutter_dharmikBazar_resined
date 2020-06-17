import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/PickUpModel.dart';
import 'package:restroapp/src/models/StoreBranchesModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AppConstants.dart';
import 'Utils.dart';

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


  static Future<PaymentType> displayPaymentDialog(BuildContext context,String title,String note) async {

    return await showDialog<PaymentType>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){
            print("onWillPop onWillPop");
            Navigator.pop(context);
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        //margin: EdgeInsets.all(10),
                        child: FlatButton(
                          child: Text('COD'),
                          color: appTheme,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context, PaymentType.COD);
                          },
                        ),
                      ),
                      Container(
                        //margin: EdgeInsets.all(10),
                        child: FlatButton(
                          child: Text('Online'),
                          color: appTheme,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context, PaymentType.ONLINE);
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
                      trailing: Text("${AppConstant.currency}${areaObject.price}",style: TextStyle(color: Colors.black)),
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


  static Future<bool> displayPickUpDialog(BuildContext context, StoreModel storeModel) async {

    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){
            //print("onWillPop onWillPop");
            //Navigator.pop(context);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text("Thank You",textAlign: TextAlign.center,
                          style: TextStyle(color: grayColorTitle,
                          fontSize: 18),),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Center(
                        child: Text("Thank you for placing the order.\nWe will confirm your order soon.",textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black,),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: FlatButton(
                              child: Text('Guide Me',style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),),
                              color: Colors.white,
                              textColor: orangeColor,
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: FlatButton(
                              child: Text('OK'),
                              color: orangeColor,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
        );
      },
    );
  }


  static Future<bool> displayCommonDialog(BuildContext context,String title, String message) async {

    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){
            //print("onWillPop onWillPop");
            //Navigator.pop(context);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text("${title}",textAlign: TextAlign.center,
                          style: TextStyle(color: grayColorTitle,fontSize: 18),),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Center(
                        child: Text("${message}",textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black,),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: FlatButton(
                              child: Text('OK'),
                              color: orangeColor,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
        );
      },
    );
  }


  static Future<bool> displayThankYouDialog(BuildContext context,String message) async {

    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){
            //print("onWillPop onWillPop");
            //Navigator.pop(context);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text("Thank You",textAlign: TextAlign.center,
                          style: TextStyle(color: grayColorTitle,fontSize: 18),),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Center(
                        child: Text("${message}",textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black,),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: FlatButton(
                              child: Text('OK'),
                              color: orangeColor,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
        );
      },
    );
  }


  static Future<bool> displayOrderConfirmationDialog(BuildContext context,String title,
      String deliveryNoteText) async {

    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: (){
            //print("onWillPop onWillPop");
            //Navigator.pop(context);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text("${title}",textAlign: TextAlign.center,
                          style: TextStyle(color: appTheme,fontWeight: FontWeight.bold),),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Center(
                        child: Text("${deliveryNoteText}",textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black,),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: FlatButton(
                              child: Text('Cancel'),
                              color: orangeColor,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: FlatButton(
                              child: Text('Proceed'),
                              color: appTheme,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
        );
      },
    );
  }


  static Future<BranchData> displayBranchDialog(BuildContext context,String title,
      StoreBranchesModel branchesModel, BranchData selectedbranchData) async {

    return await showDialog<BranchData>(
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
                itemCount: branchesModel.data.length,
                separatorBuilder: (BuildContext context, int index) {

                  return Divider();
                },
                itemBuilder: (context, index) {
                  BranchData storeObject = branchesModel.data[index];
                  return InkWell(
                    onTap: () {
                      SharedPrefs.storeSharedValue(AppConstant.branch_id, storeObject.id);
                      Navigator.pop(context, storeObject);
                    },
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.location_on),
                          Flexible(
                            child: Text(storeObject.storeName,textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black)),
                          ),
                        ],
                      ),
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

  static Future<void> openMap(StoreModel storeModel,double latitude, double longitude) async {
    String address = "${storeModel.storeName}, ${storeModel.location},"
        "${storeModel.city}, ${storeModel.state}, ${storeModel.country}, ${storeModel.zipcode}";
    print("address= ${address}");
    //String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$address';
    if (Platform.isIOS) {
         googleUrl = 'http://maps.apple.com/?q=$address';
    }

    print("urlll ===> ${Uri.encodeFull(googleUrl)}");
    if (await canLaunch(Uri.encodeFull(googleUrl))) {
      print("launchedd");
      await launch(Uri.encodeFull(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

}

