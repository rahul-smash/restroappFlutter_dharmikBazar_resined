import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'dart:convert';

class BookNowScreen extends StatefulWidget {
  BookNowScreen();

  @override
  State<StatefulWidget> createState() {
    return BookNowState();
  }
}

class BookNowState extends State<BookNowScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  BookNowModel model = BookNowModel();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text("Book Now"),
        centerTitle: true,
      ),
      body: Container(
        child: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter your first and last name',
                      labelText: 'Name',
                    ),
                    inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                    validator: (val) => val.isEmpty ? 'Name is required' : null,
                    onSaved: (val) {
                      model.name = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (val) =>
                        val.isEmpty ? 'Phone is required' : null,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onSaved: (val) {
                      model.phoneNumber = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter a email address',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => isValidEmail(value)
                        ? null
                        : 'Please enter a valid email address',
                    onSaved: (val) {
                      model.email = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'enter City',
                      labelText: 'City',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) => val.isEmpty ? 'City is required' : null,
                    onSaved: (val) {
                      model.city = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: ' Type Message here',
                      labelText: 'enter Message here',
                    ),
                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) => val.isEmpty ? 'enter message' : null,
                    onSaved: (val) {
                      model.message = val;
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
    if (!form.validate()) {
    } else {
      form.save();
      Utils.showProgressDialog(context);

      String queryString = json.encode({
        "name": model.name,
        "email": model.email,
        "mobile": model.phoneNumber,
        "city": model.city,
        "datetime": "30-03-2020 15:36:00",
        "message": model.message
      });

      ApiController.setStoreQuery(queryString).then((response) {
        Utils.hideProgressDialog(context);
        if (response.success) {
          Navigator.pop(context);
        }
      });
    }
  }
}

class BookNowModel {
  String name = '';
  String email = '';
  String phoneNumber = '';
  String city = '';
  String dateTime = '';
  String message = '';
}
