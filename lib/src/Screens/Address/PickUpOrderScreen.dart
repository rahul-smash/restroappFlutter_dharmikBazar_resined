import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/Screens/LoginSignUp/RegisterScreen.dart';
import 'package:restroapp/src/UI/SocialLoginTabs.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:flutter/gestures.dart';


class PickUpOrderScreen extends StatefulWidget {
  @override
  _PickUpOrderScreen createState() => _PickUpOrderScreen();
}

class _PickUpOrderScreen extends State<PickUpOrderScreen> {
  final cityController = TextEditingController();
  final areaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle:true ,
        title: new Text('Place Order',style: new TextStyle(
          color: Colors.white,

        ),),
      ),
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 0),
        child: Column(
          children: <Widget>[
            Stack(
              fit: StackFit.loose,
              children: [ addLoginFields()],
            ),
            SocialLoginTabs(),
          ],
        ),
      ),
    );
  }

/*  Widget addPageHeader() {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
    *//*  decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/loginbackground.png'),
          fit: BoxFit.cover,
        ),
      ),*//*
      child: Center(
        child: SizedBox(
          child: Image.asset('images/logo.png'),
          width: 250,
          height: 250,
        ),
      ),
    );
  }*/

  Widget addLoginFields() {
    return Container(
      margin: EdgeInsets.only(top: 185),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          TextFormField(
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Medium',
              color: colorInputText,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              labelText: 'Select your city',
              labelStyle: TextStyle(
                fontFamily: 'Medium',
                color: colorText,
                fontSize: 14,
              ),
            ),
            controller: cityController,
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Medium',
              color: colorInputText,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(0),
              labelText: 'Select your area',
              labelStyle: TextStyle(
                fontFamily: 'Medium',
                color: colorText,
                fontSize: 14,
              ),
            ),
            keyboardType: TextInputType.text,
            controller: areaController,
            obscureText: true,
          ),
          SizedBox(height: 15),
          SizedBox(height: 10),
        ],
      ),
    );
  }


  Widget addSignUpButton() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: RichText(
            text: TextSpan(
              text: 'New User?',
              style: TextStyle(
                  fontFamily: 'Medium', fontSize: 16, color: appTheme),
              children: [
                TextSpan(
                    text: ' Sign Up',
                    style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appTheme),
                    recognizer: (TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterUser()),
                        );
                      })),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
