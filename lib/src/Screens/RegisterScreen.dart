import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:progress_dialog/progress_dialog.dart';

class RegisterUser extends StatefulWidget {

  RegisterUser({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RegisterUserState createState() => new _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  UserData userData = new UserData();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Sign Up"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/offer_bg.png"), fit: BoxFit.cover),
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
                      hintText: 'Enter your first and last name',
                      labelText: 'Name',
                    ),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) => val.isEmpty ? 'Name is required' : null,
                    onSaved: (val) {
                      userData._name = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.phone),
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (val) => val.isEmpty ? 'Phone is required' : null,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    onSaved: (val) {
                      userData._phone = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.email),
                      hintText: 'Enter a email address',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => isValidEmail(value)
                        ? null
                        : 'Please enter a valid email address',
                    onSaved: (val) {
                      userData._email = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: 'enter password',
                      labelText: 'Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) => val.isEmpty ? 'Password is required' : null,
                    onSaved: (val) {
                      userData._password = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: 'enter password',
                      labelText: 'Confirm Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) => val.isEmpty ? 'Confirm Password is required' : null,
                    onSaved: (val) {
                      userData.confirmPassword = val;
                    },
                  ),
                  new Container(
                    height: 20.0,
                  ),
                  new Container(
                    height: 40.0,
                    child: InkWell(
                      onTap: () {
                        print("on click message");
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        new RaisedButton(
                          child: const Text('Submit',style: TextStyle(color: Colors.white),),
                          onPressed: _submitForm,
                          color: Colors.deepOrange,
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
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      //Utils.showToast('"Confirm Password should match password".',true);
    } else {
      form.save(); //This invokes each onSaved event
      //print('Form save called, newContact is now up to date...');
      //print("${equals(userData._confirmPassword, userData._password)}");

      if(!equals(userData._confirmPassword, userData._password)){

        Utils.showToast('"Confirm Password should match password".',true);

      }else{

        /*FutureBuilder(future: ApiController.registerApiRequest(userData.name,
            userData._password,userData._phone, userData._email),
          builder: ,
        );*/
        ProgressDialog pr;
        //For normal dialog
        pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
        pr.show();

        ApiController.registerApiRequest(userData.name, userData._password,
            userData._phone, userData._email).then((response){
          print('Submited to back end...');
          if(response != null){
            print("${response.data.id}");
            if(response.success){
              Navigator.pop(context);
            }
          }
          pr.hide();
        });
      }
      /*print('name: ${userData.name}');
      print('Phone: ${userData.phone}');
      print('Email: ${userData.email}');
      print('_password: ${userData._password}');
      print('_confirmPassword: ${userData._confirmPassword}');
      print('========================================');
      print('TODO - we will write the submission part next...');*/
    }
  }

  equals(String confirmation, String password) {
    print('_password: ${password}');
    print('confirmation: ${confirmation}');
    if(confirmation == password){

      return true;
    }else{
      return false;
    }
  }


}

class UserData {
  String _name="";
  String _password;
  String _confirmPassword;
  String _phone = '';
  String _email = '';

  String get confirmPassword => _confirmPassword;

  set confirmPassword(String value) {
    _confirmPassword = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }
}
