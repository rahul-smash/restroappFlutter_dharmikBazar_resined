import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/Screens/Address/PickUpOrderScreen.dart';
import 'package:restroapp/src/Screens/Address/StoreLocationScreen.dart';
import 'package:restroapp/src/Screens/BookOrder/OrderSelectionScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/Screens/BookOrder/MyCartScreen.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/PickUpModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartTotalPriceBottomBar extends StatefulWidget {
  ParentInfo parent;
  _CartTotalPriceBottomBarState state = _CartTotalPriceBottomBarState();

  CartTotalPriceBottomBar(this.parent);

  @override
  _CartTotalPriceBottomBarState createState() => state;
}

class _CartTotalPriceBottomBarState extends State<CartTotalPriceBottomBar> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  double totalPrice = 0.00;
  StoreModel store;
  String pickupfacility, delieveryAdress;

  @override
  void initState() {
    super.initState();
    updateTotalPrice();
  }

  void getAddresKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    store = await SharedPrefs.getStore();
    setState(() {
      pickupfacility = store.pickupFacility;
      delieveryAdress = store.deliveryFacility;
    });
  }

  updateTotalPrice() {
    databaseHelper.getTotalPrice().then((mTotalPrice) {
      setState(() {
        totalPrice = mTotalPrice;
        //print("----mTotalPrice==== ${mTotalPrice}--");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.parent == ParentInfo.productList ||
            widget.parent == ParentInfo.favouritesList ||
            widget.parent == ParentInfo.searchList
        ? addProductScreenBottom()
        : addMyCartScreenBottom();
  }

  Widget addProductScreenBottom() {
    return BottomAppBar(
      child: Container(
          height: 55,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: appTheme),
            ),
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Center(
                  child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: RichText(
                  text: TextSpan(
                    text: "Total: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black),
                    children: [
                      TextSpan(
                        text:
                            "${AppConstant.currency}${databaseHelper.roundOffPrice(totalPrice, 2).toStringAsFixed(2)}",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              )),
              Container(
                  color: appTheme,
                  child: FlatButton(
                    child: Row(children: <Widget>[
                      Image.asset("images/my_order.png", width: 25),
                      SizedBox(width: 5),
                      Text("Proceed To Order",
                          style: TextStyle(fontSize: 12, color: Colors.white)),
                    ]),
                    onPressed: () {
                      if (totalPrice == 0.0) {
                        Utils.showToast(AppConstant.addItems, false);
                      } else {
                        goToMyCartScreen(context);
                      }
                    },
                  ))
            ],
          )),
    );
  }

  Widget addMyCartScreenBottom() {
    return Container(
      color: appTheme,
      child: Column(
        children: <Widget>[
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  Text(
                    "${AppConstant.currency}${databaseHelper.roundOffPrice(totalPrice, 2).toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 2.0,
          ),
          InkWell(
            onTap: () async {
              if (AppConstant.isLoggedIn) {
                if (totalPrice == 0.0) {
                  Utils.showToast(AppConstant.addItems, false);
                } else {
                  Map<String, dynamic> attributeMap =
                      new Map<String, dynamic>();
                  attributeMap["ScreenName"] = "Place Order View";
                  attributeMap["action"] = "Clicked on Place Order button";
                  attributeMap["value"] = "totalPrice=${totalPrice}";
                  Utils.sendAnalyticsEvent("Clicked Place Order", attributeMap);
                  store = await SharedPrefs.getStore();
                  pickupfacility = store.pickupFacility;
                  delieveryAdress = store.deliveryFacility;

                  //print('---------${pickupfacility} and ${delieveryAdress}--------');
                  if (delieveryAdress == "1" && pickupfacility == "1") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          OrderSelectionScreen(pickupfacility, delieveryAdress),
                    );
                  }else if(pickupfacility=="1"){
                    StoreModel storeObject = await SharedPrefs.getStore();
                    bool status = Utils.checkStoreOpenTime(storeObject,OrderType.Delivery);
                    if(!status){
                      Utils.showToast("${storeObject.closehoursMessage}", false);
                      return;
                    }

                    Utils.showProgressDialog(context);
                    ApiController.getStorePickupAddress().then((response){

                      Utils.hideProgressDialog(context);
                      PickUpModel storeArea = response;

                      print('---PickUpModel---${storeArea.data.length}--');
                      if(storeArea != null && storeArea.data.isNotEmpty){
                        if(storeArea.data.length == 1 && storeArea.data[0].area.length == 1){
                          Area areaObject = storeArea.data[0].area[0];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StoreLocationScreen(areaObject,OrderType.PickUp)),
                          );
                        }else{
                          Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => PickUpOrderScreen(storeArea,OrderType.PickUp)),
                          );
                        }
                      }else{
                        Utils.showToast("No pickup data found!", true);
                      }
                    });
                  }else {
                    //by default delivery
                    //issue reported :=When both delivery address and pickup address are off then user is not able to place order
                    StoreModel storeObject = await SharedPrefs.getStore();
                    bool status = Utils.checkStoreOpenTime(storeObject,OrderType.Delivery);
                    if(!status){
                      Utils.showToast("${storeObject.closehoursMessage}", false);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DeliveryAddressList(true,OrderType.Delivery)),
                    );
                  }
                }
              } else {
                Utils.showLoginDialog(context);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,
              crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0,5),
                  child: Text(
                    "Place Order",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void goToMyCartScreen(BuildContext _context) async {
    print("-goToMyCart-----${widget.parent.toString()}----");
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MyCartScreen(() {})));
    /*Navigator.push(_context,
        MaterialPageRoute(
          builder: (BuildContext context) => MyCartScreen(() {
            updateTotalPrice();
          }),
          fullscreenDialog: true,
        ));*/
  }
}

enum ParentInfo { productList, cartList, favouritesList, searchList }
