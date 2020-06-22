import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/Screens/Dashboard/HomeScreen.dart';
import 'package:restroapp/src/Screens/Dashboard/SplashScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/ForgotPasswordScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/RegisterScreen.dart';
import 'package:restroapp/src/UI/SocialLoginTabs.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/AdminLoginModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:flutter/gestures.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class LoginEmailScreen extends StatefulWidget {

  String menu;
  LoginEmailScreen(this.menu);

  @override
  _LoginEmailScreenState createState() => _LoginEmailScreenState(menu);
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {

  String menu;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  StoreModel storeModel;

  _LoginEmailScreenState(this.menu);

  @override
  void initState() {
    super.initState();
    SharedPrefs.getStore().then((value){
      setState(() {
        storeModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      resizeToAvoidBottomPadding: true,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: Utils.getDeviceWidth(context),
              child: Image.asset("images/login_img.jpg",fit: BoxFit.fitWidth,),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text('Login With Email',
                      style: TextStyle(fontFamily: 'Bold',fontSize: 24, color: colorText,),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      style: TextStyle(fontSize: 18,fontFamily: 'Medium',color: colorInputText,),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        labelText: 'Email',
                        labelStyle: TextStyle(fontFamily: 'Medium',color: colorText,fontSize: 14,
                        ),
                      ),
                      inputFormatters: [new LengthLimitingTextInputFormatter(80)],
                      controller: _usernameController,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Medium',
                        color: colorInputText,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(0),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontFamily: 'Medium',
                          color: colorText,
                          fontSize: 14,
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () {
                        print('@@ForgotPassword--clcik');
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordScreen(menu)),
                        );
                      },
                      textColor: Colors.white,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text('Forgot password?',
                          style: TextStyle(
                            fontFamily: 'Medium',fontSize: 14,color: orangeColor,),

                        ),
                      ),
                    ),
                    addLoginButton(),
                    addSignUpButton()
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget addLoginButton() {
    return InkWell(
      onTap: () async {
        String isAdminLogin = await SharedPrefs.getStoreSharedValue(AppConstant.isAdminLogin);
        print("${isAdminLogin}");
        if(isAdminLogin == "true"){
          performAdminLogin();
        }else{
          _performLogin();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            decoration: new BoxDecoration(
              color: orangeColor,
              borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
              border: new Border.all(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            width: 200,
            margin: EdgeInsets.only(top: 10),
            child: Center(
              child: Text(
                'LOGIN',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Bold',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addSignUpButton() {
    return Padding(
      padding: const EdgeInsets.only(top:20 ,bottom: 5),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: RichText(
          text: TextSpan(
            text: 'New User?',
            style: TextStyle(
                fontFamily: 'Medium', fontSize: 16, color: orangeColor),
            children: [
              TextSpan(
                  text: ' Sign Up',
                  style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: orangeColor),
                  recognizer: (TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterUser()),
                      );
                    })),
            ],
          ),
        ),
      ),
    );
  }

  void _performLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    Utils.isNetworkAvailable().then((isNetworkAvailable) async {
      if(isNetworkAvailable) {
        if (username.isEmpty) {
          Utils.showToast(AppConstant.enterUsername, true);
        } else if (password.isEmpty) {
          Utils.showToast(AppConstant.enterPassword, true);
        } else {
          Utils.showProgressDialog(context);
          ApiController.loginApiRequest(username, password).then((response) {
            Utils.hideProgressDialog(context);
            if (response != null && response.success) {
              Navigator.pop(context);
              Utils.showToast("Login Successfully", true);
            }else{
              Utils.showToast(response.message, true);
            }
          });
        }
      } else {
        Utils.showToast(AppConstant.noInternet, true);
      }
    });
  }

  void performAdminLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    Utils.isNetworkAvailable().then((isNetworkAvailable) async {
      if(isNetworkAvailable) {
        if (username.isEmpty) {
          Utils.showToast(AppConstant.enterUsername, true);
        } else if (password.isEmpty) {
          Utils.showToast(AppConstant.enterPassword, true);
        } else {

          Utils.showProgressDialog(context);
          ApiController.getAdminApiRequest(username, password).then((response) {

            AdminLoginModel categoryResponse = response;
            if (categoryResponse != null && categoryResponse.success) {
              //Navigator.pop(context);
              Utils.showToast(response.message, true);

              ApiController.versionApiRequest("7").then((response){
                Utils.hideProgressDialog(context);
                StoreResponse model = response;
                if(model != null && model.success){
                  //Navigator.of(context).pushReplacement(CustomPageRoute(HomeScreen(model.store)));
                }else{
                  Utils.showToast("Something went wrong!", false);
                }

              });

            }else{
              Utils.showToast(response.message, true);
              Utils.hideProgressDialog(context);
            }
          });

        }
      } else {
        Utils.showToast(AppConstant.noInternet, true);
      }
    });
  }


}
