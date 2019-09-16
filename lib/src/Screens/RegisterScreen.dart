import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/utils/Utils.dart';

class RegisterUser extends StatefulWidget {

  RegisterUser({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _RegisterUserState createState() => new _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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

                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: 'enter password',
                      labelText: 'Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) => val.isEmpty ? 'Name is required' : null,
                    onSaved: (val) {

                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: 'enter password',
                      labelText: 'Confirm Password',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) => val.isEmpty ? 'Name is required' : null,
                    onSaved: (val) {

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
      //Utils.showToast('Signup Data is not valid!  Please review and correct.',true);
    } else {
      form.save(); //This invokes each onSaved event

      /*print('Form save called, newContact is now up to date...');
      print('Email: ${newContact.name}');
      print('Dob: ${newContact.dob}');
      print('Phone: ${newContact.phone}');
      print('Email: ${newContact.email}');
      print('Favorite Color: ${newContact.favoriteColor}');
      print('========================================');
      print('Submitting to back end...');
      print('TODO - we will write the submission part next...');*/
    }
  }


}
