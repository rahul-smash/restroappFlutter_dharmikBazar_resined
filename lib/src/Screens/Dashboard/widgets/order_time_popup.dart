import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../apihandler/ApiController.dart';
import '../../../database/SharedPrefs.dart';
import '../../../models/StoreResponseModel.dart';
import '../../../utils/AppConstants.dart';
import '../../../utils/Utils.dart';
import '../../Offers/OrderDetailScreenVersion2.dart';

class OrderTimePopup extends StatefulWidget {

  OrderTimePopup();

  @override
  _OrderTimePopupState createState() {
    return _OrderTimePopupState();
  }
}

class _OrderTimePopupState extends State<OrderTimePopup> {

  Timer _timer;
  bool isAnyPendingOrder = false;
  String orderID;

  @override
  void initState() {
    super.initState();
    Utils.isNetworkAvailable().then((isNetworkAvailable){
      if (!isNetworkAvailable) {
        Utils.showToast(AppConstant.noInternet, false);
        return;
      }else{
        callOrderTimeApi();
        _checkLoginState();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
   if(_timer != null){
     _timer.cancel();
   }
  }

  @override
  Widget build(BuildContext context) {

    return Visibility(
      visible: AppConstant.isLoggedIn ?  true : false,
      child: !isAnyPendingOrder ? Container() : Container(
          decoration: BoxDecoration(
            color: Color(0xff464D55),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          margin: EdgeInsets.only(right:20, bottom: 20),
          width: 150, height: 120,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left:10, bottom: 3,right: 10,top: 10),
                child: Row(
                  children: [
                    //Icon(Icons.account_box),
                    Container(
                      //margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Image.asset("images/boxicon.png", height: 30.0,width: 35,),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Order",style: TextStyle(color: Color(0xffD3D4D6)),),
                        Text("Arriving in",style: TextStyle(color: Color(0xffD3D4D6)),),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  child: Text("$remainingOrderTime",
                    style: TextStyle(fontSize: 16,color: Colors.white),
                  )
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  Utils.isNetworkAvailable().then((isNetworkAvailable){
                    if (isNetworkAvailable) {
                      openOrderDetail();
                    }else{
                      Utils.showToast(AppConstant.noInternet, false);
                    }
                  });
                },
                child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(right:10, left: 10,),
                    padding: EdgeInsets.only(top: 2,bottom: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                    child: Center(
                      child: Text("VIEW DETAIL",
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                    )
                ),
              ),
              SizedBox(height: 10,),
            ],
          )
      ),
    );
  }

  //TimeOfDay _timeOfDay;
  String remainingOrderTime = '';
  void _checkLoginState() {
    //print('----AppConstant.isLoggedIn---=${AppConstant.isLoggedIn}');
    int interval = 5;
    var duration = Duration(seconds: interval);
    _timer = new Timer.periodic(
      duration, (Timer timer) {
      if (AppConstant.isLoggedIn) {
        //print('------Timer.periodic------');
        Utils.isNetworkAvailable().then((isNetworkAvailable){
          if (isNetworkAvailable) {
            callOrderTimeApi();
          }
        });
      }
    },
    );
  }

  callOrderTimeApi(){
    ApiController.getOrderTime().then((value){
      if(value.success){
        this.isAnyPendingOrder = value.success;
        if(value.data == null){
          return;
        }
        this.orderID = value.data.orderId;
        //print('---deliverySlot--${Utils.convertOrderDateTime2(value.data.deliverySlot)}');
        //print('---CurrentDateTime=${Utils.getCurrentDateTime2()}');
        DateFormat format = new DateFormat("dd MMM yyyy, hh:mm a");

        DateTime a = format.parse(Utils.convertOrderDateTime2(value.data.deliverySlot));
        DateTime b = format.parse(Utils.getCurrentDateTime2());

        //print("inHours=${a.difference(b).inHours} inMinutes=${a.difference(b).inMinutes}");
        //print("${Utils.minutesToTimeOfDay(a.difference(b).inMinutes).hour}:${Utils.minutesToTimeOfDay(a.difference(b).inMinutes).minute}");

        List<String> splitTime = Utils.durationToString(a.difference(b).inMinutes).split(',');
        //print("splitTime=${splitTime}");
        List<String> splitTimeValue = splitTime[0].split(':');
        String hourValue = splitTimeValue[0];
        String minutesValue = splitTimeValue[1];
        //print("hourValue=${hourValue} : minutesValue${minutesValue}");
        remainingOrderTime = '$hourValue:$minutesValue hours';

        if(hourValue == '01' && minutesValue == '00'){
          remainingOrderTime = '$hourValue:$minutesValue hour';
        }
        if(hourValue == '00'){
          remainingOrderTime = '$minutesValue mins';
          if(hourValue == '00' && minutesValue == '01'){
            remainingOrderTime = '$minutesValue min';
          }
        }
        if(hourValue == '00' && minutesValue == '00'){
          remainingOrderTime = 'Arriving soon...';
        }
        if(a.difference(b).inHours < 0 || a.difference(b).inMinutes < 0){
          remainingOrderTime = 'Arriving soon...';
        }
        setState(() {
        });
      }else{
        this.isAnyPendingOrder = value.success;
        setState(() {
        });
      }
    });
  }

  Future<void> openOrderDetail() async {
    StoreModel store = await SharedPrefs.getStore();
    bool isRatingEnable = store.reviewRatingDisplay != null &&
        store.reviewRatingDisplay.compareTo('1') == 0;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderDetailScreenVersion2(
            isRatingEnable,
            store,
            orderId: orderID,
          )),
    );
  }

}