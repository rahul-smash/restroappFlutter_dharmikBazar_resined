import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/Screens/Address/PickUpOrderScreen.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/Screens/BookOrder/MyCartScreen.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class CartTotalPriceBottomBar extends StatefulWidget {
  final ParentInfo parent;
  final _CartTotalPriceBottomBarState state = _CartTotalPriceBottomBarState();
  CartTotalPriceBottomBar(this.parent);

  @override
  _CartTotalPriceBottomBarState createState() => state;
}

class _CartTotalPriceBottomBarState extends State<CartTotalPriceBottomBar> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  double totalPrice = 0.00;

  StoreModel store;
  String pickupfacility,delieveryAdress;
  @override
  void initState() {
    super.initState();
    updateTotalPrice();
  }
  void getAddresKey() async {
    store = await SharedPrefs.getStore();
    setState(() {
      pickupfacility = store.pickupFacility;
      delieveryAdress=store.deliveryFacility;
      print('@@HomeModel   '+pickupfacility+'  Delievery'+delieveryAdress);
    });
  }
  updateTotalPrice() {
    databaseHelper.getTotalPrice().then((mTotalPrice) {
      setState(() {
        totalPrice = mTotalPrice;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.parent == ParentInfo.productList
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
                            "\$${databaseHelper.roundOffPrice(totalPrice, 2)}",
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
      height: 80.0,
      color: appTheme,
      child: Column(
        children: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  Text(
                    "\$${databaseHelper.roundOffPrice(totalPrice, 2)}",
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
            onTap: () {
              if (AppConstant.isLoggedIn) {
                if (totalPrice == 0.0) {
                  Utils.showToast(AppConstant.addItems, false);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => OrderSelectionScreen(
                    ),
                  );

                  //Here comment ocde-----


                  print('OderType code Commented in screenCardBottomView');
                  /*    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryAddressList(true)),
                  );*/
                }
              } else {
                Utils.showLoginDialog(context);
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Place Order",
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void goToMyCartScreen(BuildContext _context) async {
    Navigator.push(
        _context,
        new MaterialPageRoute(
          builder: (BuildContext context) => MyCartScreen(() {
            updateTotalPrice();
          }),
          fullscreenDialog: true,
        ));
  }
}

enum ParentInfo {
  productList,
  cartList,
}
class OrderSelectionScreen extends StatefulWidget {

  @override
  _OrderSelectionScreen createState() => _OrderSelectionScreen();
}

class _OrderSelectionScreen extends State<OrderSelectionScreen> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  StoreModel store;
  String pickupfacility,delieveryAdress;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddresKey();
  }
  void getAddresKey() async {
    store = await SharedPrefs.getStore();
    setState(() {
      pickupfacility = store.pickupFacility;
      delieveryAdress=store.deliveryFacility;
      //String dine=store.
      print('@@HomeModel   '+pickupfacility+'  Delievery'+delieveryAdress);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: new ListView(children: <Widget>[

          Visibility(

            visible: true,
            child:  GestureDetector(
              onTap: () {
                print('@@CartBottomView----'+"DeliveryScreen");

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryAddressList(true)),
                );
              },
              child: new Container(
                margin: const EdgeInsets.fromLTRB(10.0, 90.0, 10.0, 10.0),

                padding: const EdgeInsets.all(10.0),
                child: new Row(
                  children: [
                    // First child in the Row for the name and the
                    new Expanded(
                      // Name and Address are in the same column
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          // Code to create the view for name.
                          new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 90.0, 10.0, 10.0),
                            height: 100.0,
                            width: 100.0,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: new AssetImage(
                                  'images/deliver.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Code to create the view for address.

                        ],
                      ),
                    ),
                    // Icon to indicate the phone number.
                  ],
                ),
              ),
            ),),

          Visibility(
            visible: true,
            child:  GestureDetector(
              onTap: () {
                print('@@CartBottomView----'+"PickUPActivy");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PickUpOrderScreen()),
                );


              },
              child: new Container(
                margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),

                padding: const EdgeInsets.all(10.0),
                child: new Row(
                  children: [
                    // First child in the Row for the name and the
                    new Expanded(
                      // Name and Address are in the same column
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Code to create the view for name.
                          new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),

                            height: 100.0,
                            width: 100.0,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: new AssetImage(
                                  'images/pickup.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Code to create the view for address.

                        ],
                      ),
                    ),
                    // Icon to indicate the phone number.
                  ],
                ),
              ),
            ),),

          /* GestureDetector(
            onTap: () {
              print('@@CartBottomView----'+"DelieveryAddressList");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DeliveryAddressList(true)),
              );
            },
            child: new Container(
              padding: const EdgeInsets.all(10.0),
              child: new Row(
                children: [
                  // First child in the Row for the name and the
                  new Expanded(
                    // Name and Address are in the same column
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Code to create the view for name.
                        new Container(
                          margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),

                          height: 100.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: new AssetImage(
                                'images/pickup.png',
                              ),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Code to create the view for address.

                      ],
                    ),
                  ),
                  // Icon to indicate the phone number.
                ],
              ),
            ),
          ),*/
          Visibility(
            visible: false,
            child: GestureDetector(
              onTap: () {
                print('@@CartBottomView----'+"DineIn");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryAddressList(true)),
                );
              },
              child: new Container(
                padding: const EdgeInsets.all(10.0),
                child: new Row(
                  children: [
                    // First child in the Row for the name and the
                    new Expanded(
                      // Name and Address are in the same column
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Code to create the view for name.
                          new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),

                            height: 100.0,
                            width: 100.0,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: new AssetImage(
                                  'images/dining.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),

                          /* new Container(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: new Text(
                            AppConstant.dine,
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ),*/
                          // Code to create the view for address.

                        ],
                      ),
                    ),
                    // Icon to indicate the phone number.
                  ],
                ),
              ),
            ),)

          ////////////////////Dine View Show and commwnet
          /*   GestureDetector(
            onTap: () {
              print('@@CartBottomView----'+"DineIn");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DeliveryAddressList(true)),
              );
            },
            child: new Container(
              padding: const EdgeInsets.all(10.0),
              child: new Row(
                children: [
                  // First child in the Row for the name and the
                  new Expanded(
                    // Name and Address are in the same column
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Code to create the view for name.
                        new Container(
                          margin: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),

                          height: 100.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            image: DecorationImage(
                              image: new AssetImage(
                                'images/dining.png',
                              ),
                              fit: BoxFit.fill,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
          ////////////////////Dine View Show and commwnet
          ////////////////////Dine View Show and commwnet
          ////////////////////Dine View Show and commwnet
          ////////////////////Dine View Show and commwnet

                        // Code to create the view for address.

                      ],
                    ),
                  ),
                  // Icon to indicate the phone number.
                ],
              ),
            ),
          ),*/
        ]));

    /* child: addBottomBar());*/
  }


  Widget addBottomBar() {
    return Column(
      children: [
        new Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [

            GestureDetector(
              onTap: () {
                print('@@CartBottomView----'+"PickUPActivy");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryAddressList(true)),
                );
              },
              child: new Container(
                padding: const EdgeInsets.all(15.0),
                child: new Column(

                  children: [
                    // First child in the Row for the name and the
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: new AssetImage(
                                  'images/logo.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Code to create the view for name.
                          // Code to create the view for address.
                        ],
                      ),
                    ),
                    // Icon to indicate the phone number.
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('@@CartBottomView----'+"DelieveryAddressList");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryAddressList(true)),
                );
              },
              child: new Container(
                padding: const EdgeInsets.all(15.0),
                child: new Column(

                  children: [
                    // First child in the Row for the name and the
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: new AssetImage(
                                  'images/theme35.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          // Code to create the view for name.
                          // Code to create the view for address.
                        ],
                      ),
                    ),
                    // Icon to indicate the phone number.
                  ],
                ),
              ),
            ),

            /* GestureDetector(
              child: addBottomBoxView(MediaQuery
                  .of(context)
                  .size
                  .width / 3,
                  1.0, 0.0, 'images/home_basket.png', AppConstant.cart),
              onTap: () {
                print('@@CartBottomView----'+"DelieveryAddressList");
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryAddressList(true)),
                  );
              },
            ),*/
          ],
        ),
      ],
    );
  }


}