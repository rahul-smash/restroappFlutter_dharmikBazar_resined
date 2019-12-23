import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/BookNowData.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';

class BookNowScreen extends StatefulWidget {
  BookNowScreen(BuildContext context);

  @override
  State<StatefulWidget> createState() {
    print("---------BookNowScreen---------");

    return _bookNowScreen();
  }
}

class _bookNowScreen extends State<BookNowScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _validate = false;

  final name_Controller = new TextEditingController();
  final mobile_Controller = new TextEditingController();
  final city_Controller = new TextEditingController();
  final email_Controller = new TextEditingController();
  final dateTime_Controller = new TextEditingController();
  final messageBox_contrller = new TextEditingController();
  BookNowData_ bookNowData=new BookNowData_();
  @override


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
              autovalidate: true,
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
                      bookNowData._name = val;
                    },
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter a phone number',
                      labelText: 'Phone',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (val) => val.isEmpty ? 'Phone is required' : null,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    onSaved: (val) {
                      bookNowData._phoneBumber = val;
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
                      bookNowData._email = val;
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
                      bookNowData._city = val;
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
                      bookNowData.message = val;
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
    } else {
      form.save();
      ProgressDialog pr;
      //For normal dialog
      pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal,
          isDismissible: false,
          showLogs: false);
      pr.show();

       ApiController.setStoreQuery(bookNowData._name, bookNowData._email,bookNowData._phoneBumber,
         bookNowData._city, bookNowData._dateTime,bookNowData._message).then((response){
        print('--------BookNowData--------..');
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

class BookNowData_ {
  String _name = "";
  String _email = '';
  String _phoneBumber = '';
  String _city = '';
  String _dateTime = '';
  String _message = '';

  String get name => _name;

  set name(String value) {
    _name = value;
  }


  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get phoneBumber => _phoneBumber;

  set phoneBumber(String value) {
    _phoneBumber = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get dateTime => _dateTime;

  set dateTime(String value) {
    _dateTime = value;
  }

  String get message => _message;

  set message(String value) {
    _message = value;
  }

}
