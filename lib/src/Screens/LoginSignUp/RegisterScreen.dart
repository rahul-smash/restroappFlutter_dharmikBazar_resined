import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:restroapp/src/Screens/Dashboard/HomeScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class RegisterUser extends StatefulWidget {

  RegisterUser();

  @override
  _RegisterUserState createState() => new _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {

  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  UserData userData = new UserData();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _referralCodeeController = TextEditingController();

  bool showReferralCodeView = false;
  StoreModel storeModel;

  @override
  void initState() {
    super.initState();
    _keyboardState = _keyboardVisibility.isKeyboardVisible;
    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardState = visible;
          print("_keyboardState= ${_keyboardState}");
        });
      },
    );

    SharedPrefs.getStore().then((store){
      this.storeModel = store;
      if(storeModel.isRefererFnEnable){
        showReferralCodeView = true;
      }else{
        showReferralCodeView = false;
      }
      setState(() {
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Utils.hideKeyboard(context);
            return Navigator.pop(context, false);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          /*Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: Utils.getDeviceWidth(context),
              child: AppConstant.isRestroApp ?
              Image.asset("images/login_restro_bg.jpg",fit: BoxFit.fitWidth,)
                  :Image.asset("images/login_img.jpg",fit: BoxFit.fitWidth,),
            ),
          ),*/
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                color: _keyboardState ? whiteColor : Colors.transparent,
                padding: EdgeInsets.only(left: 30,right: 30),
                child: Form(
                    key: _formKey,
                    autovalidate: true,
                    child: ListView(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      children: <Widget>[
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Name *',
                          ),
                          controller: _usernameController,
                          inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                          /*validator: (val) =>
                          val.isEmpty ? AppConstant.enterName : null,
                          onSaved: (val) {
                            userData.name = val.trim();
                          },*/
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Phone *',
                          ),
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          /*validator: (val) =>
                          val.isEmpty ? AppConstant.enterPhone : null,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                          ],
                          onSaved: (val) {
                            userData.phone = val.trim();
                          },*/
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email *',
                          ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          //'Please enter a valid email address'
                          /*validator: (value) => value.trim().isEmpty
                              ? AppConstant.enterEmail
                              : isValidEmail(value.trim())? null: AppConstant.enterValidEmail,
                          onSaved: (val) {
                            userData.email = val.trim();
                          },*/
                        ),
                        Visibility(
                          visible: showReferralCodeView,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Referral Code',
                            ),
                            controller: _referralCodeeController,
                            inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                            /*validator: (val) =>
                          val.isEmpty ? AppConstant.enterName : null,
                          onSaved: (val) {
                            userData.name = val.trim();
                          },*/
                          ),
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password *',
                          ),
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          /*validator: (val) =>
                          val.isEmpty ? AppConstant.enterPassword : null,
                          onSaved: (val) {
                            userData.password = val.trim();
                          },*/
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password *',
                          ),
                          controller: _confirmpasswordController,
                          keyboardType: TextInputType.visiblePassword,
                          /*validator: (val) =>
                          val.isEmpty ? AppConstant.enterConfirmPassword : null,
                          onSaved: (val) {
                            userData.confirmPassword = val.trim();
                          },*/
                        ),
                        Container(height: 20.0),
                        Container(
                          color: grayColor,
                          height: 40.0,
                          margin: EdgeInsets.only(left:0, right:0,bottom: 20),
                          child: ButtonTheme(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: _submitForm,
                              color: appThemeSecondary,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  Future<void> _submitForm() async {

    bool isNetworkAvailable = await Utils.isNetworkAvailable();
    if(!isNetworkAvailable){
      Utils.showToast(AppConstant.noInternet, false);
      return;
    }

    userData.name = _usernameController.text.trim();
    userData.phone = _phoneController.text.trim();
    userData.email = _emailController.text.trim();
    userData.password = _passwordController.text.trim();
    userData.confirmPassword = _confirmpasswordController.text.trim();
    if(userData.name.isEmpty){
      Utils.showToast("Please enter name", false);
      return;
    }
    if(userData.phone.isEmpty){
      Utils.showToast("Please enter phone", false);
      return;
    }
    if(userData.email.isEmpty){
      Utils.showToast("Please enter email", false);
      return;
    }
    if(!Utils.validateEmail(userData.email.trim())){
      Utils.showToast("Please enter valid email", true);
      return;
    }
    if(userData.password.isEmpty){
      Utils.showToast("Please enter password", false);
      return;
    }
    if(userData.confirmPassword.isEmpty){
      Utils.showToast("Please enter confirm password", false);
      return;
    }

    String referralCode;
    if(showReferralCodeView){
      referralCode = _referralCodeeController.text.trim();
    }else{
      referralCode = "";
    }

    if (userData.confirmPassword.trim() != userData.password.trim()) {
      Utils.showToast(AppConstant.passwordMatch, true);
    } else {
      Utils.isNetworkAvailable().then((isNetworkAvailable) async {
        if (isNetworkAvailable) {
          Utils.showProgressDialog(context);
          ApiController.registerApiRequest(userData,referralCode)
              .then((response) async {
            Utils.hideProgressDialog(context);
            if (response != null && response.success) {
              Navigator.pop(context);
            }
          });
        } else {
          Utils.showToast(AppConstant.noInternet, true);
        }
      });
    }
  }
}

class UserData {
  String name;
  String password;
  String confirmPassword;
  String phone;
  String email;
}
