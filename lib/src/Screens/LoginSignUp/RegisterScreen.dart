import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  UserData userData = new UserData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
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
              child: Form(
                  key: _formKey,
                  autovalidate: true,
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          labelText: 'Name',
                        ),
                        inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                        validator: (val) =>
                        val.isEmpty ? AppConstant.enterName : null,
                        onSaved: (val) {
                          userData.name = val.trim();
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.phone),
                          labelText: 'Phone',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (val) =>
                        val.isEmpty ? AppConstant.enterPhone : null,
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                        ],
                        onSaved: (val) {
                          userData.phone = val.trim();
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.email),
                          labelText: 'Email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        //'Please enter a valid email address'
                        validator: (value) => value.trim().isEmpty
                            ? AppConstant.enterEmail
                            : isValidEmail(value.trim())? null: AppConstant.enterValidEmail,
                        onSaved: (val) {
                          userData.email = val.trim();
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.lock),
                          labelText: 'Password',
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (val) =>
                        val.isEmpty ? AppConstant.enterPassword : null,
                        onSaved: (val) {
                          userData.password = val.trim();
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: const Icon(Icons.lock),
                          labelText: 'Confirm Password',
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (val) =>
                        val.isEmpty ? AppConstant.enterConfirmPassword : null,
                        onSaved: (val) {
                          userData.confirmPassword = val.trim();
                        },
                      ),
                      Container(height: 20.0),
                      Container(
                        height: 40.0,
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ButtonTheme(
                                minWidth: 150,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: _submitForm,
                                  color: orangeColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
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

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      form.save(); //This invokes each onSaved event

      if (userData.confirmPassword.trim() != userData.password.trim()) {
        Utils.showToast(AppConstant.passwordMatch, true);
      } else {
        Utils.isNetworkAvailable().then((isNetworkAvailable) async {
          if (isNetworkAvailable) {
            Utils.showProgressDialog(context);
            ApiController.registerApiRequest(userData)
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
}

class UserData {
  String name;
  String password;
  String confirmPassword;
  String phone;
  String email;
}
