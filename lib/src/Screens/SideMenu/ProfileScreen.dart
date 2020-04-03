import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreen createState() => new _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final nameController = new TextEditingController();
  final emailController = new TextEditingController();
  final phoneController = new TextEditingController();

  @override
  initState() {
    super.initState();
    _initProfileData();
  }

  _initProfileData() async {
    UserModel user = await SharedPrefs.getUser();
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
                      controller: nameController,
                      // Every single time the text changes in a
                      // TextField, this onChanged callback is called
                      // and it passes in the value.
                      //
                      // Set the text of your controller to
                      // to the next value.
                      onChanged: (v) => nameController.text = v,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                      // Tell your textfield which controller it owns
                      controller: emailController,
                      // Every single time the text changes in a
                      // TextField, this onChanged callback is called
                      // and it passes in the value.
                      //
                      // Set the text of your controller to
                      // to the next value.
                      onChanged: (v) => emailController.text = v,
                      decoration: InputDecoration(
                        labelText: 'EmailId',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                      // Tell your textfield which controller it owns
                      controller: phoneController,
                      // Every single time the text changes in a
                      // TextField, this onChanged callback is called
                      // and it passes in the value.
                      //
                      // Set the text of your controller to
                      // to the next value.
                      onChanged: (v) => phoneController.text = v,
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
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
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

      ApiController.profileRequest(
              nameController.text, emailController.text, phoneController.text)
          .then((response) {
        print('--------Profile to back end.--------..');
        if (response != null) {
          print("${response.message}");
          if (response.success) {
            Navigator.pop(context);
          }
        }
        pr.hide();
      });
    }
  }
}
