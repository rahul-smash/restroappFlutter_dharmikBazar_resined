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

  bool isComingFromOtpScreen;
  RegisterUser(this.isComingFromOtpScreen);

  @override
  _RegisterUserState createState() => new _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  UserData userData = new UserData();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Sign Up'),
        centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, false),
          ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('images/offer_bg.png'), fit: BoxFit.cover),
        ),
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: true,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      labelText: 'Name',
                    ),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) =>
                        val.isEmpty ? AppConstant.enterName : null,
                    onSaved: (val) {
                      userData.name = val;
                    },
                  ),
                  new TextFormField(
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
                      userData.phone = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    //'Please enter a valid email address'
                    validator: (value) => value.isEmpty
                        ? AppConstant.enterEmail
                        : isValidEmail(value)
                            ? null
                            : AppConstant.enterValidEmail,
                    onSaved: (val) {
                      userData.email = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) =>
                        val.isEmpty ? AppConstant.enterPassword : null,
                    onSaved: (val) {
                      userData.password = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      labelText: 'Confirm Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) =>
                        val.isEmpty ? AppConstant.enterConfirmPassword : null,
                    onSaved: (val) {
                      userData.confirmPassword = val;
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
                          new RaisedButton(
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: _submitForm,
                            color: appTheme,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
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

      if (userData.confirmPassword != userData.password) {
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
                if(widget.isComingFromOtpScreen){
                  StoreModel store = await SharedPrefs.getStore();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(store)),
                  );
                }
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
