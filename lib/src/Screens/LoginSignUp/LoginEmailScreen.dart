import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restroapp/src/Screens/Dashboard/HomeScreen.dart';
import 'package:restroapp/src/Screens/Dashboard/ForceUpdate.dart';
import 'package:restroapp/src/Screens/LoginSignUp/ForgotPasswordScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/RegisterScreen.dart';
import 'package:restroapp/src/Screens/SideMenu/ProfileScreen.dart';
import 'package:restroapp/src/UI/SocialLoginTabs.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/AdminLoginModel.dart';
import 'package:restroapp/src/models/FacebookModel.dart';
import 'package:restroapp/src/models/MobileVerified.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:flutter/gestures.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

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
  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;
  FacebookLogin facebookSignIn = new FacebookLogin();

  _LoginEmailScreenState(this.menu);

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: ['email','https://www.googleapis.com/auth/contacts.readonly',],);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
        print("displayName=${_currentUser.displayName}");
        print("email=${_currentUser.email}");
        print("id=${_currentUser.id}");
      });
    });

    _keyboardState = _keyboardVisibility.isKeyboardVisible;
    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
        onChange: (bool visible) {
      setState(() {
        _keyboardState = visible;
        print("_keyboardState= ${_keyboardState}");
      });
    },
    );
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
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Container(
                  color: _keyboardState ? whiteColor : Colors.transparent,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
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
                              fontFamily: 'Medium',fontSize: 14,color: appThemeSecondary,),

                          ),
                        ),
                      ),
                      addLoginButton(),

                      Visibility(
                        visible: true,
                        //visible: storeModel == null ? false : storeModel.social_login == "0" ? false : true,
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
                          width: Utils.getDeviceWidth(context),
                          child: Center(
                            child: Text("──────── OR CONNECT WITH ────────",
                              style: TextStyle(color: gray9),),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: true,
                        //visible: storeModel == null ? false : storeModel.social_login == "0" ? false : true,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () async {
                                print("------fblogin------");
                                bool isNetworkAvailable =await Utils.isNetworkAvailable();
                                if(!isNetworkAvailable){
                                  Utils.showToast(AppConstant.noInternet, true);
                                  return;
                                }

                                bool isFbLoggedIn = await facebookSignIn.isLoggedIn;
                                print("isFbLoggedIn=${isFbLoggedIn}");
                                if(isFbLoggedIn){
                                  await facebookSignIn.logOut();
                                }

                                fblogin();
                              },
                              child: Container(
                                  height: 35,
                                  width: Utils.getDeviceWidth(context)/2.6,
                                  margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                  decoration: BoxDecoration(
                                      color: fbblue,
                                      border: Border.all(color: fbblue,),
                                      borderRadius: BorderRadius.all(Radius.circular(5))
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Image.asset("images/f_logo_white.png",height: 25.0),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Text("Facebook",
                                          style: TextStyle(color: Colors.white,fontSize: 18),),
                                      )
                                    ],
                                  )
                              ),
                            ),
                            Container(
                              height: 35,
                              width: Utils.getDeviceWidth(context)/2.6,
                              margin: EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: _googleSignInButton(),
                            ),
                          ],
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterUser()),
                          );
                        },
                        child: addSignUpButton(),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _googleSignInButton(){
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async{
        bool isNetworkAvailable = await Utils.isNetworkAvailable();
        if(!isNetworkAvailable){
          Utils.showToast(AppConstant.noInternet, true);
        }else{
          bool isGoogleSignedIn = await _googleSignIn.isSignedIn();
          print("isGoogleSignedIn=${isGoogleSignedIn}");
          if(isGoogleSignedIn){
            await _googleSignIn.signOut();
          }

          try {
            GoogleSignInAccount result = await _googleSignIn.signIn();
            if(result != null){
              print("result.id=${result.id}");
              MobileVerified verifyEmailModel = await ApiController.verifyEmail(result.email);
              if(verifyEmailModel.userExists == 0){
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(true,"",
                      "${result.displayName}",null,result)),
                );

              }else if(verifyEmailModel.userExists == 1){
                SharedPrefs.setUserLoggedIn(true);
                SharedPrefs.saveUserMobile(verifyEmailModel.user);
                UserModel user = UserModel();
                user.fullName = verifyEmailModel.user.fullName;
                user.email = verifyEmailModel.user.email;
                user.phone = verifyEmailModel.user.phone;
                user.id = verifyEmailModel.user.id;
                SharedPrefs.saveUser(user);
                Navigator.pop(context);
              }
            }else{
              Utils.showToast("Something went wrong while login!", false);
            }

          } catch (error) {
            print("catch.googleSignIn=${error}");
          }
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("images/google_logo.png"), height: 25.0),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Google',
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
        Utils.showProgressDialog(context);
        FacebookModel fbModel =  await ApiController.getFbUserData(accessToken.token);
        //Utils.hideProgressDialog(context);
        if(fbModel != null){
          print("email=${fbModel.email} AND id=${fbModel.id}");
          MobileVerified verifyEmailModel = await ApiController.verifyEmail(fbModel.email);
          Utils.hideProgressDialog(context);
          if(verifyEmailModel.userExists == 0){
            Navigator.pop(context);
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileScreen(true,"",
                  "${fbModel.name}",fbModel,null)),
            );

          }else if(verifyEmailModel.userExists == 1){
            SharedPrefs.setUserLoggedIn(true);
            SharedPrefs.saveUserMobile(verifyEmailModel.user);
            UserModel user = UserModel();
            user.fullName = verifyEmailModel.user.fullName;
            user.email = verifyEmailModel.user.email;
            user.phone = verifyEmailModel.user.phone;
            user.id = verifyEmailModel.user.id;
            SharedPrefs.saveUser(user);
            Navigator.pop(context);
          }
        }else{
          Utils.showToast("Something went wrong while login!", false);
          Utils.hideProgressDialog(context);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        Utils.showToast("Login cancelled", false);
        break;
      case FacebookLoginStatus.error:
        Utils.showToast("Something went wrong ${result.errorMessage}", false);
        break;
    }
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
        padding: EdgeInsets.only(right: 0),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            decoration: new BoxDecoration(
              color: appThemeSecondary,
              borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
              border: new Border.all(
                color: Colors.white,
                width: 1.0,
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            width: Utils.getDeviceWidth(context),
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
      padding: EdgeInsets.only(top:10 ,bottom: 0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: RichText(
          text: TextSpan(
            text: 'Don\'t have an account?',
            style: TextStyle(
                fontFamily: 'Medium', fontSize: 16, color:Colors.grey),
            children: [
              TextSpan(
                  text: ' Sign Up',
                  style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: appThemeSecondary),
                  recognizer: (TapGestureRecognizer()
                    ..onTap = () {

                    }
                    )
              ),
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
