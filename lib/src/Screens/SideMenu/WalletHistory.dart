import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/WalleModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:restroapp/src/Screens/SideMenu/WalletTopUp.dart';

class WalletHistoryScreen extends StatefulWidget {
  WalletHistoryScreen(this.store);

  StoreModel store;

  @override
  _WalletHistoryScreenState createState() => _WalletHistoryScreenState();
}

//subscription_payment//subscription_refund
class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  WalleModel walleModel;

  @override
  void initState() {
    super.initState();
    ApiController.getUserWallet().then((response) {
      setState(() {
        this.walleModel = response;
        if (walleModel != null &&
            walleModel.success &&
            walleModel.data.walletHistory.isNotEmpty) {
          //sorting
          walleModel.data.walletHistory.sort((a, b) {
            return b.dateTime.compareTo(a.dateTime);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: appTheme,
        // title: Text(
        //   "Wallet Balance",
        //   style: TextStyle(
        //     color: Colors.white,
        //   ),
        // ),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: walleModel == null
          ? Utils.showIndicator()
          : walleModel.data.walletHistory.isEmpty
              ? Container(
                  child: showEmptyWidget(),
                )
              : SafeArea(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                                margin: EdgeInsets.fromLTRB(20, 30, 10, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Wallet Balance",
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 16),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          child: Text("${AppConstant.currency}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16)),
                                          padding:
                                              EdgeInsets.fromLTRB(0, 1, 0, 0),
                                        ),
                                        Text("${walleModel.data.userWallet}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 24)),
                                      ],
                                    )
                                  ],
                                )),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Image.asset(
                                  "images/walletbalancegreaphics.png",
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 20, 10, 10),
                          child: Text("Transcations",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.only(top: 0, left: 15, right: 15),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: Column(
                                  children: [
                                    showWalletView(
                                        walleModel.data.walletHistory[index]),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Utils.showDivider(context),
                                  ],
                                ),
                              );
                            },
                            itemCount: walleModel.data.walletHistory.length,
                            shrinkWrap: true,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget showWalletView(WalletHistory walletHistory) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          //child: Icon(Icons.add_circle_outline),
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                width: 0.0,
                color: walletHistory.refund_type != "order_refund" ||
                        walletHistory.refund_type != "subscription_refund"
                    ? red1
                    : green1,
              ),
              color: walletHistory.refund_type != "order_refund" ||
                      walletHistory.refund_type != "subscription_refund"
                  ? red1
                  : green1,
            ),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Image.asset(
                walletHistory.refund_type != "order_refund" ||
                        walletHistory.refund_type != "subscription_refund"
                    ? "images/orderrefund.png"
                    : "images/cashbackicon.png",
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
            ),
          ),
          /*child: Image.asset(walletHistory.refund_type == "order_refund"
              ? "images/orderrefund.png"
              : "images/cashbackicon.png"),*/
        ),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${walletHistory.label}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal)),
                SizedBox(height: 5),
                Text("#${walletHistory.displayOrderId}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[500], fontSize: 15)),
              ]),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                    '${walletHistory.refund_type == "order_refund" || walletHistory.refund_type == "subscription_refund" ? " + " : " - "}${AppConstant.currency}${walletHistory.refund}',
                    style: TextStyle(
                        color: walletHistory.refund_type == "order_refund" ||
                                walletHistory.refund_type ==
                                    "subscription_refund"
                            ? green2
                            : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal)),
                SizedBox(height: 5),
                Text(
                    "${Utils.convertWalletDate(walletHistory.dateTime.toString())}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[500], fontSize: 15)),
              ]),
        ),
      ],
    );
  }

  Widget showEmptyWidget() {
    print("-------showEmptyWidget-----------");
    return Stack(
      children: [
        Container(
            height: Utils.getDeviceHeight(context) / 2.2,
            width: Utils.getDeviceWidth(context),
            //color: Colors.white,
            child: Container(
              child: ClipPath(
                clipper: ClippingClass(),
                child: Container(
                  padding: EdgeInsets.only(left: 20),
                  color: appTheme,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Wallet Balance",
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              child: Text("${AppConstant.currency}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                            ),
                            Text("${walleModel.data.userWallet}",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24)),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 250,
            //color: Colors.grey,
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Your Wallet is Empty",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Text("AS per discussed we remove this text",style: TextStyle(color: Colors.grey[500]),),
                  // Text("in your wallet at that moment"),
                  //Text("kindly purchase more to continue"),
                  SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: 180,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WalletTopUp(widget.store)),
                        );
                      },
                      child: Text('Add Money'),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(appTheme),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              40, 0, 0, (Utils.getDeviceHeight(context) / 3.5)),
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              "images/emptywalletbalancegreaphics.png",
              width: 240,
              height: 240,
            ),
          ),
        ),
      ],
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);

    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 30);

    path.lineTo(size.width, 0.0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
