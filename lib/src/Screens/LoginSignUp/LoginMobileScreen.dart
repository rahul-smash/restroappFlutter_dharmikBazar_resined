import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:restroapp/src/Screens/LoginSignUp/OtpScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/FacebookModel.dart';
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
  FacebookLogin facebookSignIn = new FacebookLogin();

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
                              padding:EdgeInsets.only(left: 0.0, top: 0.0, right: 20.0),
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
                              )
                          ),


                          InkWell(
                            onTap: (){
                              print("------fblogin------");
                              fblogin();
                            },
                            child: Container(
                              height: 40,
                              color: fbblue,
                              width: Utils.getDeviceWidth(context),
                              margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
                              child: Image.asset("images/fblogin_btn.png"),
                            ),
                          ),

                          InkWell(
                            onTap: (){
                              print("------_googleSignInButton------");
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 20, 10),
                              child: _googleSignInButton(),
                            ),
                          ),

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

  Widget _googleSignInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {

      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/google_logo.png"), height: 25.0),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> fblogin() async {
    final FacebookLoginResult result =
    await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken accessToken = result.accessToken;

        FacebookModel fbModel =  await ApiController.getFbUserData(accessToken.token);
        if(fbModel != null){
          print("email=${fbModel.email} AND id=${fbModel.id}");
        }

        /*_showMessage('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');*/
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        Utils.showToast("Login cancelled", false);
        break;
      case FacebookLoginStatus.error:
        Utils.showToast("Something went wrong ${result.errorMessage}", false);
        break;
    }
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

void _showMessage(String s) {
  print("_showMessage=${s}");
}
class LoginMobile {
  String phone;
}
