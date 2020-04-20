import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/Screens/Address/PickUpOrderScreen.dart';
import 'package:restroapp/src/Screens/Dashboard/HomeScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class OtpScreen extends StatefulWidget {
  String menu;
  OtpScreen(this.menu);
  @override
  _OtpScreen createState() => _OtpScreen(this.menu);
}

class _OtpScreen extends State<OtpScreen> {
  String menu;
  _OtpScreen(this.menu);
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  OTPData otpModel = new OTPData();
  final phoneController = new TextEditingController();
  Timer _timer;
  int _start = 20;

  StoreModel store;
  String otpSkip,pickupfacility,delieveryAdress;
  @override
  void initState() {
    super.initState();
    startTimer();
    getAddresKey();

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
      appBar: new AppBar(
        centerTitle: true,
        title: new Text('Mobile Verification',style: new TextStyle(
          color: Colors.white,
        ),),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new Container(

                      padding: const EdgeInsets.only(top: 40.0),
                      margin: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                      child: new Text(
                        AppConstant.txt_OTP,
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      )),
                  new TextFormField(
                    //    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Enter OTP Number',
                      labelText: 'Enter OTP Number',
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
                  GestureDetector(
                    child: new Container(
                      padding: const EdgeInsets.all(10.0),
                      child: new Row(

                        children: [

                          // First child in the Row for the name and the
                          new Expanded(

                            // Name and Address are in the same column
                            child: new Row(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Container(
                                    padding: const EdgeInsets.only(
                                        left: 40.0, top: 10.0, right: 10.0),
                                    child: new RaisedButton(
                                      color: appTheme,
                                      textColor: Colors.white,
                                      child: Text("$_start"+" sec",style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      ),
                                      onPressed: _otpForm,
                                    )),

                                // Code to create the view for name.
                                new Container(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, top: 10.0, right: 40.0),
                                    child: new RaisedButton(
                                      color: appTheme,
                                      textColor: Colors.white,
                                      child: const Text('Submit',style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      ),
                                      onPressed: _otpForm,
                                    )),


                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


                  /*new Container(
                      padding: const EdgeInsets.only(
                          left: 40.0, top: 20.0, right: 40.0),
                      child: new RaisedButton(
                        color: appTheme,
                        textColor: Colors.white,
                        child: const Text('Submit',style: TextStyle(
                          color: Colors.white,
                        ),
                        ),
                        onPressed: _otpForm,
                      )),*/

                  /*   new Container(
                      padding: const EdgeInsets.only(
                          left: 40.0, top: 20.0, right: 40.0),
                      child: new RaisedButton(
                        color: appTheme,
                        textColor: Colors.white,
                        child:  Text("$_start"+" sec",style: TextStyle(
                          color: Colors.white,
                        ),

                        ),

                      //  onPressed: _otpForm,
                      )),*/
                ],
              ))),
    );
  }



  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();

          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  void _otpForm() {
    print('@@MENUGET'+menu);

    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save(); //This invokes each onSaved event
      Utils.isNetworkAvailable().then((isNetworkAvailable) async {
        if (isNetworkAvailable) {
          Utils.showProgressDialog(context);
          ApiController.otpVerified(otpModel)
              .then((response) {
            Utils.hideProgressDialog(context);
            if (response != null && response.success) {
              print('@@----object+'+response.success.toString());
              Utils.showToast(response.message, true);
              //Navigator.pop(context);
              proceedtoActivity();
            }
          });
        } else {
          Utils.showToast(AppConstant.noInternet, true);
        }
      });
    }
  }

  void proceedtoActivity() {
    print('@@MENUGET'+menu);
    if (menu==("menu")) {
      //  if (isNameExist && isEmailExist) {
      //           showAlertDialogForLogin(getActivity(), "Sucess", "You have login successfully. Please continue.");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(store)),
      );
      /*  } else {
        proceedToEmail(from);
      }
*/
    }
    //else if (from.equals("shop_cart")) {
    // if (isNameExist && isEmailExist) {
    else{  if(delieveryAdress==("1") && pickupfacility==("1")){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DeliveryAddressList(false)),
      );
    }
    else if(delieveryAdress==("1") && pickupfacility==("0")){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PickUpOrderScreen()),
      );
    }
    else if(delieveryAdress==("0") && pickupfacility==("1")){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PickUpOrderScreen()),
      );
    }
    else {
      // intentDelivery = new Intent(getActivity(), DeliveryActivity.class);
    }

    }

    /*    intentDelivery.putExtra(AppConstant.FROM, "shop_cart");
        startActivity(intentDelivery);
        getActivity().finish();
        AnimUtil.slideFromRightAnim(getActivity());*/
    //}
    /* else {
        proceedToEmail(from);
      }*/
    //  }
  }



}


class OTPData {

  String otp;
}