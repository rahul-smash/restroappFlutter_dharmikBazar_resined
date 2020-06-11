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
  StoreModel storeModel;

  _LoginEmailScreenState(this.menu);
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
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
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 0),
        child: Column(
          children: <Widget>[
            Stack(
              fit: StackFit.loose,
              children: [addPageHeader(), addLoginFields()],
            ),
            addLoginButton(),
            //SocialLoginTabs(),
            addSignUpButton()
          ],
        ),
      ),
    );
  }

  Widget addPageHeader() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: SizedBox(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: CachedNetworkImage(
                imageUrl: storeModel == null ? "" : storeModel.banner300200,
                fit: BoxFit.cover
            ),
          ),
        ),
      ),
    );
  }

  Widget addLoginFields() {
    return Container(
      margin: EdgeInsets.only(top: 200),
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20,),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Login',
            style: TextStyle(
              fontFamily: 'Bold',
              fontSize: 24,
              color: colorText,
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Medium',
              color: colorInputText,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              labelText: 'Username',
              labelStyle: TextStyle(
                fontFamily: 'Medium',
                color: colorText,
                fontSize: 14,
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
          SizedBox(height: 15),

          MaterialButton(
            onPressed: () {
              print('@@ForgotPassword--clcik');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ForgotPasswordScreen(menu)),
                //    MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            textColor: Colors.white,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  fontFamily: 'Medium',
                  fontSize: 14,
                  color: colorBlueText,

                ),

              ),
            ),
          ),
          SizedBox(height: 10),
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
            color: appTheme,
            padding: EdgeInsets.symmetric(
              vertical: 15,
            ),
            width: 200,
            margin: EdgeInsets.only(top: 20),
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: RichText(
            text: TextSpan(
              text: 'New User?',
              style: TextStyle(
                  fontFamily: 'Medium', fontSize: 16, color: appTheme),
              children: [
                TextSpan(
                    text: ' Sign Up',
                    style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appTheme),
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
