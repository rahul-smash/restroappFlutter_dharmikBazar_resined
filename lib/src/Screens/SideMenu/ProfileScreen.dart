import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';

class ProfileScreen extends StatefulWidget {

  bool isComingFromOtpScreen;
  String id;
  ProfileScreen(this.isComingFromOtpScreen,this.id);

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  UserModel user;

  final nameController = new TextEditingController();
  final emailController = new TextEditingController();
  final phoneController = new TextEditingController();

  @override
  initState() {
    super.initState();
    if(!widget.isComingFromOtpScreen){
      getProfileData();
    }
  }

  getProfileData() async {
    user = await SharedPrefs.getUser();
    setState(() {
      nameController.text = user.fullName;
      emailController.text = user.email;
      phoneController.text = user.phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(widget.isComingFromOtpScreen == true ? 'SignUp' : "My Profile"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        /*decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/offer_bg.png"), fit: BoxFit.cover),
        ),*/
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
                      controller: nameController,
                      // Every single time the text changes in a
                      // TextField, this onChanged callback is called
                      // and it passes in the value.
                      //
                      // Set the text of your controller to
                      // to the next value.
                      //onChanged: (v) => nameController.text = v,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                      controller: emailController,
                     // onChanged: (v) => emailController.text = v,
                      decoration: InputDecoration(
                        labelText: 'EmailId',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                      controller: phoneController,
                     // onChanged: (v) => phoneController.text = v,
                      decoration: InputDecoration(
                        labelText: 'PhoneNumber',
                      )),
                ),
                new Container(
                  height: 20.0,
                ),
                new Container(
                  height: 40.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new RaisedButton(
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _submitForm,
                        color: appTheme,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
    if (!form.validate()) {
    } else {
      form.save();
      Utils.showProgressDialog(context);
      ApiController.updateProfileRequest(nameController.text, emailController.text,
          phoneController.text,widget.isComingFromOtpScreen,widget.id).then((response) {
        Utils.hideProgressDialog(context);
        if (response.success) {
          if(widget.isComingFromOtpScreen){

            UserModel user = UserModel();
            user.fullName =  nameController.text.trim();
            user.email =  emailController.text.trim();
            user.phone =  phoneController.text.trim();
            Utils.showToast(response.message, true);
            SharedPrefs.saveUser(user);
            SharedPrefs.setUserLoggedIn(true);
            Navigator.pop(context);

          }else{
            user.fullName =  nameController.text.trim();
            user.email =  emailController.text.trim();
            user.phone =  phoneController.text.trim();
            Utils.showToast(response.message, true);
            SharedPrefs.saveUser(user);
            Navigator.pop(context);
          }
        }

      });

    }
  }
}
