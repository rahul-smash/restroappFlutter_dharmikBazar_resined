import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/Screens/BookOrder/MyCartScreen.dart';
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

  @override
  void initState() {
    super.initState();
    updateTotalPrice();
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeliveryAddressList(true)),
                  );
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
