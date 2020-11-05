import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
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
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  LoginMobile loginMobile = new LoginMobile();
  final phoneController = new TextEditingController();
  StoreModel store;
  String otpSkip;

  _LoginMobileScreen(this.menu);

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
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: new Text('Login',style: new TextStyle(
          color: Colors.white,
        ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Utils.hideKeyboard(context);
            return Navigator.pop(context, false);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.only(top: 40.0),
                              child: Text(
                                AppConstant.txt_mobile,textAlign: TextAlign.center,
                                style: new TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              )),
                          TextFormField(
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
                          Container(
                              padding: const EdgeInsets.only(left: 0.0, top: 0.0, right: 20.0),
                              child: new RaisedButton(
                                color: appThemeSecondary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                textColor: Colors.white,
                                child: Text('Submit',style: TextStyle(
                                  color: Colors.white,
                                ),
                                ),
                                onPressed: _submitForm,
                              )),
                        ],
                      )),
                ),
              ),

            ],
          ),
        ),
      ),

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
                print('@@userExists=${response.userExists} and otpSkip = ${response.user.otpVerify}');
                if (response.success) {
                  SharedPrefs.setUserLoggedIn(true);
                  SharedPrefs.saveUserMobile(response.user);
                }
                Navigator.pop(context);

              }else{
                //print('@@NOTP__Screen');
                Navigator.pop(context);
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
