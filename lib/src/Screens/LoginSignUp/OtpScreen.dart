import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/Screens/Address/PickUpOrderScreen.dart';
import 'package:restroapp/src/Screens/Dashboard/HomeScreen.dart';
import 'package:restroapp/src/Screens/SideMenu/ProfileScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/MobileVerified.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

import 'LoginMobileScreen.dart';
import 'RegisterScreen.dart';

class OtpScreen extends StatefulWidget {

  String menu;
  MobileVerified response;
  LoginMobile phone;
  OtpScreen(this.menu, this.response, this.phone);

  @override
  _OtpScreen createState() => _OtpScreen();
}

class _OtpScreen extends State<OtpScreen> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  OTPData otpModel = new OTPData();
  Timer _timer;
  int _start = 30;

  StoreModel store;
  String otpSkip,pickupfacility,delieveryAdress;
  @override
  void initState() {
    super.initState();
    startTimer();
    getAddresKey();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(_timer != null){
      _timer.cancel();
    }
  }

  void getAddresKey() async {
    store = await SharedPrefs.getStore();
    setState(() {
      pickupfacility = store.pickupFacility;
      delieveryAdress=store.deliveryFacility;
      print('@@HomeModel   '+pickupfacility+'  Delievery'+delieveryAdress);
    });
  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: whiteColor,
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Mobile Verification',style: new TextStyle(
          color: Colors.white,
        ),),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: Utils.getDeviceWidth(context),
                child: AppConstant.isRestroApp ?
                Image.asset("images/login_restro_bg.jpg",fit: BoxFit.fitWidth,)
                    :Image.asset("images/login_img.jpg",fit: BoxFit.fitWidth,),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Form(
                  key: _formKey,
                  autovalidate: true,
                  child: new ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.only(top: 40.0),
                          margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                          child: new Text(
                            AppConstant.txt_OTP,
                            style: new TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                            ),
                          )),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter OTP Number',
                          //labelText: 'Enter OTP Number',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (val) =>
                        val.isEmpty ? AppConstant.enterOtp : null,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                        onSaved: (val) {
                          otpModel.otp = val;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: EdgeInsets.only( left: 0.0, top: 10.0, right: 20.0),
                              child: new RaisedButton(
                                color: appThemeSecondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                textColor: Colors.white,
                                child: Text(_start != 0 ? "${_start} sec" : "Skip",style: TextStyle(
                                  color: Colors.white,
                                ),
                                ),
                                onPressed: onSkipButtonPressed,
                              )),
                          Container(
                              padding: EdgeInsets.only( left: 20.0, top: 10.0, right: 0.0),
                              child: new RaisedButton(
                                color: appThemeSecondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                textColor: Colors.white,
                                child: const Text('Submit',style: TextStyle(
                                  color: Colors.white,
                                ),
                                ),
                                onPressed: onSubmitClicked,
                              )
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }


  void startTimer() {
    //print('--startTimer===  $_start');
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec,
          (Timer timer) {
            //print('--periodic===  $_start');
        setState(
              () {
            if (_start < 1) {
              timer.cancel();
            } else {
              _start = _start - 1;
            }
          },

        );
      },
    );
  }

  void onSkipButtonPressed() {
    //print('@@MENUGET'+widget.menu);
    //print('--periodic===  $_start');
    if(_start == 0){
      // user clicked on skip button
      //print('--Skip=Skip==');
      proceedToNextActivity();
    }
  }


 /* void resendOtpScreen(){
    Utils.isNetworkAvailable().then((isNetworkAvailable) async {
      if (isNetworkAvailable) {
        Utils.showProgressDialog(context);
        ApiController.mobileVerification(widget.phone) .then((response) {
          Utils.hideProgressDialog(context);
          if (response != null && response.success) {
            Utils.showToast("Otp sent successfully", true);
            _start = 40;
            startTimer();
          }
        });
      } else {
        Utils.showToast(AppConstant.noInternet, true);
      }
    });

  }*/

  void onSubmitClicked(){
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save(); //This invokes each onSaved event
      Utils.isNetworkAvailable().then((isNetworkAvailable) async {
        if (isNetworkAvailable) {

          Utils.showProgressDialog(context);

          ApiController.otpVerified(otpModel,widget.phone).then((response) {
            Utils.hideProgressDialog(context);
            if (response != null && response.success) {
              //print('@@----object+'+response.success.toString());
              Utils.showToast(response.message, true);
              //Navigator.pop(context);
              proceedToNextActivity();
            }else{
              if (response != null) {
                Utils.showToast(response.message, true);
              }
            }
          });
        } else {
          Utils.showToast(AppConstant.noInternet, true);
        }
      });
    }else{
      Utils.showToast("Please enter OTP", true);
    }
  }

  void proceedToNextActivity() {
    print('@@MENUGET'+widget.menu);
    if (widget.menu == ("menu")) {
      Navigator.pop(context);
      Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(true,widget.response.user.id,widget.response.user.fullName)),
      );
      //Navigator.pop(context);
    }

  }

}


class OTPData {

  String otp;
}