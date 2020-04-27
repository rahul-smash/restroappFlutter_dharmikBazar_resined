import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/Screens/LoginSignUp/OtpScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class LoginMobileScreen extends StatefulWidget {

  String menu;
  LoginMobileScreen(this.menu);

  @override
  _LoginMobileScreen createState() => _LoginMobileScreen(menu);

}

class _LoginMobileScreen extends State<LoginMobileScreen> {

  String menu;
  _LoginMobileScreen(this.menu);

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  LoginMobile loginMobile = new LoginMobile();
  final phoneController = new TextEditingController();

  StoreModel store;
  String otpSkip;

  @override
  void initState() {
    super.initState();
    getOTPSkip();
  }
  void getOTPSkip() async {
    store = await SharedPrefs.getStore();
    setState(() {
      otpSkip = store.otpSkip;
      String delieveryAdress=  store.deliveryFacility;
      print('@@HomeModel   ${otpSkip} and ${delieveryAdress}');
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle:  true,
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
                      child: new Text(
                        AppConstant.txt_mobile,
                        style: new TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      )),
                  new TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      hintText: 'Mobile Number',
                      labelText: 'Mobile Number',
                    ),
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    validator: (val) =>
                    val.isEmpty ? AppConstant.enterPhone : null,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    onSaved: (val) {
                      loginMobile.phone = val;
                    },
                  ),
                  new Container(
                      padding: const EdgeInsets.only(
                          left: 40.0, top: 20.0, right: 40.0),
                      child: new RaisedButton(
                        color: appTheme,
                        textColor: Colors.white,
                        child: const Text('Submit',style: TextStyle(
                          color: Colors.white,
                        ),
                        ),
                        onPressed: _submitForm,
                      )),
                ],
              ))),
    );
  }

  void _submitForm() {
    print('@@MENUGET'+menu);

    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save(); //This invokes each onSaved event
      Utils.isNetworkAvailable().then((isNetworkAvailable) async {
        if (isNetworkAvailable) {
          Utils.showProgressDialog(context);
          ApiController.mobileVerification(loginMobile) .then((response) {

            Utils.hideProgressDialog(context);
            if (response != null && response.success) {

              print("=====otpVerify===${response.user.otpVerify}--and--${response.userExists}-----");

              if(response.userExists == 1 || otpSkip == "yes"){
                //print('@@NotOTP__Screen');
                Navigator.pop(context);

              }else{
                //print('@@NOTP__Screen');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OtpScreen(menu,response,loginMobile)),
                  //    MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            }
          });
        } else {
          Utils.showToast(AppConstant.noInternet, true);
        }
      });
    }else{
      Utils.showToast("Please enter Mobile number", true);
    }
  }
}
class LoginMobile {
  String phone;
}
