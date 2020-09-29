import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  static Future<bool> displayDialog(BuildContext context, String title,
      String body, String buttonText1, String buttonText2) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Text(
              body,
              textAlign: TextAlign.center,
            ),
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

  static Future<PaymentType> displayPaymentDialog(
      BuildContext context, String title, String note) async {
    return await showDialog<PaymentType>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            print("onWillPop onWillPop");
            Navigator.pop(context);
          },
          child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Text(
                title,
                textAlign: TextAlign.center,
              ),
              content: Container(
                child: Wrap(
                  children: <Widget>[
                    Text(
                      note,
                      textAlign: TextAlign.center,
                    ),
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
              )),
        );
      },
    );
  }

  static Future<Datum> displayCityDialog(
      BuildContext context, String title, PickUpModel storeArea) async {
    return await showDialog<Datum>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: storeArea.data.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemBuilder: (context, index) {
                  Datum areaObject = storeArea.data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, areaObject);
                      },
                    child: ListTile(
                      title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(areaObject.city.city,
                                  style: TextStyle(color: Colors.black,fontSize: 16)),
                            ),
                          ]),
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
                  Navigator.pop(context,null);
                  // true here means you clicked ok
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<Area> displayAreaDialog(
      BuildContext context, String title, Datum cityObject) async {
    return await showDialog<Area>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: cityObject.area.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemBuilder: (context, index) {
                  Area object = cityObject.area[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, object);
                    },
                    child: ListTile(
                      title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(object.pickupAdd,
                                  style: TextStyle(color: Colors.black,fontSize: 16)),
                            ),
                          ]),
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
                  Navigator.pop(context,null);
                  // true here means you clicked ok
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<Variant> displayVariantsDialog(
      BuildContext context, String title, List<Variant> variants) async {
    return await showDialog<Variant>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Container(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
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
                      title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(areaObject.weight,
                                  style: TextStyle(color: Colors.black)),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                    overflow: TextOverflow.visible,
                                    text: (areaObject.discount == "0.00" ||
                                            areaObject.discount == "0" ||
                                            areaObject.discount == "0.0")
                                        ? TextSpan(
                                            text:
                                                "${AppConstant.currency}${areaObject.price}",
                                            style: TextStyle(
                                                color: grayColorTitle,
                                                fontWeight: FontWeight.w700),
                                          )
                                        : TextSpan(
                                            text:
                                                "${AppConstant.currency}${areaObject.price}",
                                            style: TextStyle(
                                                color: grayColorTitle,
                                                fontWeight: FontWeight.w700),
                                            children: <TextSpan>[
                                              TextSpan(text: " "),
                                              TextSpan(
                                                  text:
                                                      "${AppConstant.currency}${areaObject.mrpPrice}",
                                                  style: TextStyle(
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: grayColorTitle,
                                                      fontWeight:
                                                          FontWeight.w400)),
                                            ],
                                          )),
                              ),
                            )
//
                          ]),
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

  static Future<bool> displayPickUpDialog(
      BuildContext context, StoreModel storeModel) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            //print("onWillPop onWillPop");
            //Navigator.pop(context);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text(
                          "Thank You",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grayColorTitle, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Center(
                        child: Text(
                          "Thank you for placing the order.\nWe will confirm your order soon.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
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
                              child: Text(
                                'Guide Me',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
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
              )),
        );
      },
    );
  }

  static Future<bool> displayCommonDialog(
      BuildContext context, String title, String message,{String buttonText='OK'}) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            //print("onWillPop onWillPop");
            //Navigator.pop(context);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text(
                          "${title}",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grayColorTitle, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: Center(
                        child: Text(
                          "${message}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
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
                              child: Text('$buttonText'),
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
              )),
        );
      },
    );
  }

  static Future<bool> displayThankYouDialog(
      BuildContext context, String message) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            //print("onWillPop onWillPop");
            //Navigator.pop(context);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text(
                          "Thank You",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grayColorTitle, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Center(
                        child: Text(
                          "${message}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
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
              )),
        );
      },
    );
  }

  static Future<bool> displayOrderConfirmationDialog(
      BuildContext context, String title, String deliveryNoteText) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            //print("onWillPop onWillPop");
            //Navigator.pop(context);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text(
                          "${title}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: appTheme, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Center(
                        child: Text(
                          "${deliveryNoteText}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
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
              )),
        );
      },
    );
  }

  static Future<BranchData> displayBranchDialog(
      BuildContext context,
      String title,
      StoreBranchesModel branchesModel,
      BranchData selectedbranchData) async {
    return await showDialog<BranchData>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Container(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
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
                      SharedPrefs.storeSharedValue(
                          AppConstant.branch_id, storeObject.id);
                      Navigator.pop(context, storeObject);
                    },
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Icon(Icons.location_on),
                          Flexible(
                            child: Text(storeObject.storeName,
                                textAlign: TextAlign.center,
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

  static Future<bool> displayCommonDialog2(BuildContext context, String title,
      String message, String button1, String button2) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            //print("onWillPop onWillPop");
            Navigator.pop(context);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text(
                          "${title}",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grayColorTitle, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Center(
                        child: Text(
                          "${message}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
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
                              child: Text('${button1}'),
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
                              child: Text('${button2}'),
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
              )),
        );
      },
    );
  }

  static Future<bool> showForceUpdateDialog(
      BuildContext context, String title, String message) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            //print("onWillPop onWillPop");
            //Navigator.pop(context);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text(
                          "${title}",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grayColorTitle, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                      child: Center(
                        child: Text(
                          "${message}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
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
                                SystemNavigator.pop();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  static Future<bool> showInviteEarnAlert(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            //print("onWillPop onWillPop");
            Navigator.pop(context, false);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Wrap(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                      child: Center(
                        child: Text(
                          "Invite & Earn",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(height: 3, color: appTheme, width: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 35, 0, 30),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Please log in to share your",
                            style: TextStyle(
                              color: grayColorTitle,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "\nreferral code and earn a",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "\ndiscount coupon",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: "\non your next order.",
                                style: TextStyle(
                                  color: grayColorTitle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: FlatButton(
                              child: Text('Go For Login'),
                              color: appTheme,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context, true);
                                Utils.showLoginDialog(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  static Future<bool> showInviteEarnAlert2(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            //print("onWillPop onWillPop");
            Navigator.pop(context, false);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              //title: Text(title,textAlign: TextAlign.center,),
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Wrap(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context, false);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Color(0xffdbdbdb)),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(0),
                                  width: 80.0,
                                  height: 80.0,
                                  decoration: new BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage("images/gifticon.png"),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                      child: Center(
                        child: Text(
                          "Have a referral code?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(height: 3, color: appTheme, width: 20),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Signup with the ",
                            style: TextStyle(
                              color: grayColorTitle,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Referral code",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: " and",
                                style: TextStyle(
                                    color: grayColorTitle,
                                    fontWeight: FontWeight.normal),
                              ),
                              TextSpan(
                                text: "\nearn a ",
                                style: TextStyle(
                                  color: grayColorTitle,
                                ),
                              ),
                              TextSpan(
                                text: "Discount Coupon",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: FlatButton(
                              child: Text('Sign up'),
                              color: appTheme,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context, true);
                                Utils.showLoginDialog(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: FlatButton(
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            color: Colors.white,
                            textColor: appTheme,
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  static Future<void> openMap(
      StoreModel storeModel, double latitude, double longitude) async {
    String address = "${storeModel.storeName}, ${storeModel.location},"
        "${storeModel.city}, ${storeModel.state}, ${storeModel.country}, ${storeModel.zipcode}";
    print("address= ${address}");
    //String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$address';
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

  static Future<String> displayCommentDialog(
      BuildContext context, String passedComment) async {
    final commentController = TextEditingController();
    commentController.text = passedComment.trim();
    return await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              Navigator.pop(context, passedComment.trim());
            },
            child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                //title: Text(title,textAlign: TextAlign.center,),
                child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Container(
                      child: Wrap(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context, passedComment.trim());
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Text(
                              "Your Comment",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            height: 120,
                            margin: EdgeInsets.fromLTRB(20, 15, 20, 20),
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(5.0)),
                              border: new Border.all(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                              child: TextField(
                                textAlign: TextAlign.left,
                                maxLength: 250,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: commentController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  width: 130,
                                  child: FlatButton(
                                    child: Text('Submit'),
                                    color: orangeColor,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      Utils.hideKeyboard(context);
                                      Navigator.pop(context,
                                          commentController.text.trim());
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))),
          );
        });
  }

  static Future<String> displayMultipleOnlinePaymentMethodDialog(
      BuildContext context, StoreModel storeObject) async {
    return await showDialog<String>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              Navigator.pop(context, "");
            },
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              title: Container(
                child: Text(
                  "Payment Via",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black),
                ),
              ),
              content: Container(
                width: double.maxFinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: storeObject.paymentGatewaySettings.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                  itemBuilder: (context, index) {
                    PaymentGatewaySettings paymentGatewaySettings = storeObject.paymentGatewaySettings[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pop(context, paymentGatewaySettings.paymentGateway);
                      },
                      child: ListTile(
                        title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: Text(paymentGatewaySettings.paymentGateway,
                                    style: TextStyle(color: Colors.black)),
                              ),
                            ]),
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
                    Navigator.pop(context,"");
                    // true here means you clicked ok
                  },
                ),
              ],
            ),
          );
        });
  }

  static Future<bool> showAreaRemovedDialog(
      BuildContext context, String area) async {
    StoreModel storeModel = await SharedPrefs.getStore();
    String storeName = storeModel.storeName;
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              storeName,
              textAlign: TextAlign.center,
            ),
            content: Text(
              AppConstant.deliveryAreaChanges,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              new FlatButton(
                child: Text("OK"),
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
