import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => new _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ProfileData profileData = new ProfileData();
  String userName = "",email="",phone="",is_referer_fn_enable="",bl_device_id_unique="";

  final  name_Controller=new TextEditingController();

  final email_Controller=new TextEditingController();

  final phone_Controller=new TextEditingController();


  @override
  initState() {
    super.initState();
    print("---initState ProfileAS---");
    _initProfileData();
  }

  _initProfileData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(()  {
      ///DO MY Logic CALLS

      userName = prefs.getString(AppConstant.USER_NAME);
      email=prefs.get(AppConstant.USER_EMAIL);
      phone=prefs.get(AppConstant.USER_PHONE);
      print("---initState userName---$userName");
      print("---initState email---$email");
      print("---initState phone---$phone");
      name_Controller.text=userName;
      email_Controller.text=email;
      phone_Controller.text=phone;
      /*is_referer_fn_enable=prefs.getString(AppConstant.IS_REFERNCE_FN_ENABLE);
      bl_device_id_unique= prefs.getString(AppConstant.BL_DEVICE_ID_UNIQUE);
      print("---@@@@---$is_referer_fn_enable");
      print("---@@@@---$bl_device_id_unique");*/

    });
  }
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return new Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: new Text('My Profile'),
        centerTitle: true,

      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/offer_bg.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: new Form(
            key: _formKey,
            autovalidate: true,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    // Tell your textfield which controller it owns
                      controller: name_Controller,
                      // Every single time the text changes in a
                      // TextField, this onChanged callback is called
                      // and it passes in the value.
                      //
                      // Set the text of your controller to
                      // to the next value.
                      onChanged: (v) => name_Controller.text = v,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      )),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    // Tell your textfield which controller it owns
                      controller: email_Controller,
                      // Every single time the text changes in a
                      // TextField, this onChanged callback is called
                      // and it passes in the value.
                      //
                      // Set the text of your controller to
                      // to the next value.
                      onChanged: (v) => email_Controller.text = v,
                      decoration: InputDecoration(
                        labelText: 'EmailId',
                      )),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    // Tell your textfield which controller it owns
                      controller: phone_Controller,
                      // Every single time the text changes in a
                      // TextField, this onChanged callback is called
                      // and it passes in the value.
                      //
                      // Set the text of your controller to
                      // to the next value.
                      onChanged: (v) => phone_Controller.text = v,
                      decoration: InputDecoration(
                        labelText: 'PhoneNumber',
                      )),
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
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _submitForm,
                          color: Colors.deepOrange,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  _handleDrawer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(()  {
      ///DO MY Logic CALLS

      userName = prefs.getString(AppConstant.USER_NAME);
      if(userName == null){
        userName = "";
      }


    });
  }
  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
    } else {
      form.save();
      ProgressDialog pr;
      //For normal dialog
      pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false);
      pr.show();

      ApiController.profileRequest(profileData._name, profileData._email,profileData._phoneBumber).then((response){
        print('--------Profile to back end.--------..');
        if(response != null){
          print("${response.message}");
          if(response.success){
            Navigator.pop(context);
          }
        }
        pr.hide();
      });
    }
  }
}

class ProfileData {
  String _name = "";
  String _email = '';
  String _phoneBumber = '';
  String _is_referer_fn_enable = '';
  String bl_device_id_unique = '';

  String get is_referer_fn_enable => _is_referer_fn_enable;

  set is_referer_fn_enable(String value) {
    _is_referer_fn_enable = value;
  }

  String get phoneBumber => _phoneBumber;

  set phoneBumber(String value) {
    _phoneBumber = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}
///////////////////////////////////////////////////////////
/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => new _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  ProfileData profileData = new ProfileData();
  String userName = "",email="",phone="";

  TextEditingController name_=new TextEditingController();

  TextEditingController email_=new TextEditingController();

  TextEditingController phone_=new TextEditingController();


  @override
  initState() {
    super.initState();
    print("---initState ProfileAS---");
    _initProfileData();
  }

  _initProfileData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(()  {
      ///DO MY Logic CALLS

      userName = prefs.getString(AppConstant.USER_NAME);
      email=prefs.get(AppConstant.USER_EMAIL);
      phone=prefs.get(AppConstant.USER_PHONE);
      print("---initState userName---$userName");
      print("---initState email---$email");
      print("---initState phone---$phone");


    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: new Text('My Profile'),
        centerTitle: true,

      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/offer_bg.png"), fit: BoxFit.cover),
        ),
        child: SafeArea(
          top: false,
          bottom: false,
          child: new Form(
            key: _formKey,
            autovalidate: true,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                  child: Row(
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(userName),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                  child: Row(
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(email),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                  child: Row(
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(phone),
                      ),
                    ],
                  ),
                ),

                *//*new TextFormField(

                  decoration: const InputDecoration(

                      hintText: 'Type here', labelText: 'Name'),

                  inputFormatters: [new LengthLimitingTextInputFormatter(30)],

                  validator: (val) => val.isEmpty ? 'Name is required' : null,
                  controller: name_,

                  onSaved: (val) {
                    profileData._name = val;
                  },
                ),
                new TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Type here', labelText: 'Email Id'),
                    keyboardType: TextInputType.emailAddress,

                    validator: (value) => isValidEmail(value)
                        ? null
                        : 'Please enter a valid email address',
                    onSaved: (val) {
                      profileData._email = val;
                    },
                  *//**//*  validator: (value) =>
                        value.isEmpty ? 'Email Id is required' : null,
                    onSaved: (val) {
                      profileData._email = val;
                    }*//**//*),
                new TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Type here', labelText: 'Phone Number'),
                    validator: (value) =>
                        value.isEmpty ? 'Phone-Number Id is required' : null,
                    onSaved: (val) {
                      profileData._phoneBumber = val;
                    }),
                new TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Type here', labelText: 'Reference Code'),
                    onSaved: (val) {
                      profileData._is_referer_fn_enable = val;
                    }),*//*
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
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: _submitForm,
                          color: Colors.deepOrange,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }



  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  _handleDrawer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(()  {
      ///DO MY Logic CALLS

      userName = prefs.getString(AppConstant.USER_NAME);
      if(userName == null){
        userName = "";
      }


    });
  }
  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
    } else {
      form.save();
      ProgressDialog pr;
      //For normal dialog
      pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false);
      pr.show();

      ApiController.profileRequest(profileData._name, profileData._email,profileData._phoneBumber).then((response){
        print('--------Profile to back end.--------..');
        if(response != null){
          print("${response.message}");
          if(response.success){
            Navigator.pop(context);
          }
        }
        pr.hide();
      });
    }
  }
}

class ProfileData {
  String _name = "";
  String _email = '';
  String _phoneBumber = '';
  String _is_referer_fn_enable = '';
  String bl_device_id_unique = '';

  String get is_referer_fn_enable => _is_referer_fn_enable;

  set is_referer_fn_enable(String value) {
    _is_referer_fn_enable = value;
  }

  String get phoneBumber => _phoneBumber;

  set phoneBumber(String value) {
    _phoneBumber = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}*/
