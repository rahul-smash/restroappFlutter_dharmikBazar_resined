import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/WalleModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class WalletHistoryScreen extends StatefulWidget {

  WalletHistoryScreen();

  @override
  _WalletHistoryScreenState createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {

  WalleModel walleModel;

  @override
  void initState() {
    super.initState();
    ApiController.getUserWallet().then((response){
      setState(() {
        this.walleModel = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appTheme,
        title: Text("Wallet Balance",style:TextStyle(color: Colors.white,),),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: walleModel == null
          ? Utils.showIndicator()
          : walleModel.data.walletHistory.isEmpty
          ? Container(child: showEmptyWidget(),)
          : SafeArea(
        child: Container(
          child: Stack(
            children: [

              Column(
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        margin: EdgeInsets.only(top: 130,left: 15,right: 15),
                        child: ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: Text("Transcations",style: TextStyle(color: Colors.black,fontSize: 16)),
                            ),
                            ListView.builder(
                              itemBuilder: (context, index) {

                                return Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Column(
                                    children: [
                                      showWalletView(walleModel.data.walletHistory[index]),
                                      SizedBox(height: 15,),
                                      Utils.showDivider(context),
                                    ],
                                  ),
                                );
                              },
                              itemCount: walleModel.data.walletHistory.length,
                              shrinkWrap: true,
                            ),
                          ],
                        )
                    ),
                  )
                ],
              ),

              Container(
                margin: EdgeInsets.fromLTRB(20, 30, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Wallet Balance",
                      style: TextStyle(color: Colors.black54,fontSize: 16),),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          child: Text("${AppConstant.currency}",
                              style: TextStyle(color: Colors.black,fontSize: 16)),
                          padding: EdgeInsets.fromLTRB(0, 1, 0, 0),
                        ),
                        Text("${walleModel.data.userWallet}",
                            style: TextStyle(color: Colors.black,fontSize: 24)),
                      ],
                    )
                  ],
                )
              ),


              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 30, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Image.asset("images/walletbalancegreaphics.png",width: 150,height: 150,),
                ),
              )

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
              height: 45,width: 45,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    width: 0.0,
                    color: walletHistory.refund_type=="order_refund"?red1:green1,
                  ),
                color: walletHistory.refund_type=="order_refund"?red1:green1,
              ),
              child: Padding(
                padding: EdgeInsets.all(6),
                child: Image.asset(walletHistory.refund_type == "order_refund"
                    ? "images/orderrefund.png"
                    : "images/cashbackicon.png",height: 20,width: 20,fit: BoxFit.fill,),
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
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 15)),
              ]
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('${walletHistory.refund_type == "order_refund" ? " - " : " + "}${AppConstant.currency}${walletHistory.refund}',
                    style: TextStyle(
                        color: walletHistory.refund_type=="order_refund"?Colors.black:green2,
                        fontSize: 18,
                        fontWeight: FontWeight.normal)),
                SizedBox(height: 5),
                Text("${Utils.convertWalletDate(walletHistory.dateTime.toString())}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 15)),
              ]
          ),
        ),
      ],
    );
  }

  Widget showEmptyWidget() {
    print("-------showEmptyWidget-----------");
    return Stack(
      children: [
        Container(
            height: Utils.getDeviceHeight(context)/2.2,
            width: Utils.getDeviceWidth(context),
            //color: Colors.white,
            child: Container(
              child: ClipPath(
                clipper: ClippingClass(),
                child: Container(
                  color: Colors.grey[300],
                  //child: Text("Textview"),
                ),
              ),
            )
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 140,
            //color: Colors.grey,
            child: Center(
              child: Column(
                children: [
                  Text("Your Wallet is Empty",style:
                  TextStyle(color: blue1,fontSize: 20,fontWeight: FontWeight.bold),),
                  SizedBox(height: 20,),
                  Text("Look like there are no credit"),
                  Text("in your wallet at that moment"),
                  Text("kindly purchase moreto continue"),
                  Text("to continue"),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 0, (Utils.getDeviceHeight(context)/3.5)),
          child: Align(
            alignment: Alignment.center,
            child: Image.asset("images/emptywalletbalancegreaphics.png",
              width: 240,height: 240,),
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

    path.quadraticBezierTo(size.width/4, size.height, size.width/2, size.height);

    path.quadraticBezierTo(size.width -(size.width/4), size.height,
        size.width, size.height- 30);

    path.lineTo(size.width, 0.0);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}



