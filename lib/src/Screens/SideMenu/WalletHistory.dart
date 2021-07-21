import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restroapp/src/Screens/Dashboard/HomeScreen.dart';
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
    _callWalletApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
//        toolbarHeight: 40,
        elevation: 0,
      ),
      backgroundColor: Colors.white70,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          walleModel == null
              ? Utils.showIndicator()
              : walleModel.data.walletHistory.isEmpty
                  ? Container(
                      child: showEmptyWidget(),
                    )
                  : SafeArea(
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                                color: appTheme,
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Wallet Balance",
                                          style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 16),
                                        ),
                                        walleModel == null
                                            ? Container()
                                            : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    child: Text(
                                                        "${AppConstant.currency}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16)),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 1, 0, 0),
                                                  ),
                                                  Text(
                                                      "${walleModel.data.userWallet}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 24)),
                                                ],
                                              ),
                                        SizedBox(
                                          height: 50,
                                        )
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "images/walletbalancegreaphics.png",
                                        width: 200,
                                      ),
                                    ),
                                  ],
                                )),
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(height: 40, color: appTheme),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 20, 0, 10),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text("Transactions",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14)),
                                            ),
                                          ),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: walleModel.data
                                                          .walletHistory.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(10, 10,
                                                                  10, 0),
                                                          child: Column(
                                                            children: [
                                                              showWalletView(
                                                                  walleModel
                                                                          .data
                                                                          .walletHistory[
                                                                      index]),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Utils.showDivider(
                                                                  context),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                  Container(
                                                    height: 100,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          _addMoneyButton(),
        ],
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
                color: _checkItemColor(walletHistory),
              ),
              color:_checkItemColor(walletHistory) ,
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Image.asset(
                /*_isCheckType(walletHistory)
                    ? "images/cashbackicon.png"
                    : "images/orderrefund.png",*/
                _checkIcon(walletHistory),
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
                walletHistory.displayOrderId == ""
                    ? Container()
                    : Text("#${walletHistory.displayOrderId}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: Colors.grey[500], fontSize: 12)),
              ]),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                    '${_isCheckType(walletHistory) ? " + " : " - "}${AppConstant.currency}${walletHistory.refund}',
                    style: TextStyle(
                        color:
                            _isCheckType(walletHistory) ? green2 : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal)),
                SizedBox(height: 5),
                Text(
                    "${Utils.convertWalletDate(walletHistory.dateTime.toString())}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ]),
        ),
      ],
    );
  }

  Widget showEmptyWidget() {
    print("-------showEmptyWidget-----------");
    return Container(
      color: Colors.white,
      child: Stack(
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
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 16),
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
                              Text(
                                  "${walleModel.data.userWallet}",
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
                    //_addMoneyButton()
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
      ),
    );
  }

  void _openWalletTopScreen() async {
    bool isTopUpSuccess = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WalletTopUp(widget.store, walleModel)),
    );
    if (isTopUpSuccess) {
      _callWalletApi(showLoading: true);
    }
  }

  void _callWalletApi({bool showLoading = false}) {
    if (showLoading) Utils.showProgressDialog(context);
    ApiController.getUserWallet().then((response) {
      if (showLoading) Utils.hideProgressDialog(context);
      if (mounted)
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

  Widget _addMoneyButton() {
    return Visibility(
      visible: widget.store.walletSettings.status == '1' &&
          widget.store.walletSettings.customerWalletTopUpStatus == '1',
      child: Container(
        width: 180,
        height: 45,
        margin: EdgeInsets.only(bottom: 40),
        child: ElevatedButton(
          onPressed: () {
            _openWalletTopScreen();
          },
          child: Text('Add Money'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(appTheme),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isCheckType(WalletHistory walletHistory) {
    return walletHistory.refund_type == "order_refund" ||
        walletHistory.refund_type == "subscription_refund" ||
        walletHistory.refund_type == "wallet_topup";
  }

  String _checkIcon(WalletHistory walletHistory) {
    switch (walletHistory.refund_type) {
      case 'order_payment':
        return "images/order_place.png";
        break;
      case 'order_refund':
        return "images/orderrefund.png";
        break;
      case 'wallet_topup':
        return "images/cashbackicon.png";
        break;
      case 'subscription_payment':
        return "images/order_place.png";
        break;
      case 'subscription_refund':
        return "images/orderrefund.png";
        break;
      default:
        return "images/order_place.png";
    }
  }

 Color _checkItemColor(WalletHistory walletHistory) {


    switch (walletHistory.refund_type) {
      case 'order_payment':
        return Colors.blue[50];
        break;
      case 'order_refund':
        return red1;
        break;
      case 'wallet_topup':
        return green1;
        break;
      case 'subscription_payment':
        return Colors.blue[50];
        break;
      case 'subscription_refund':
        return red1;
        break;
      default:
        return Colors.blue[50];
    }
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
