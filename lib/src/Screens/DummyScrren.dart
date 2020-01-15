import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/Screens/RegisterScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/ui/social.dart';
import 'package:restroapp/src/utils/HeaderLogo.dart';
import 'package:restroapp/src/utils/color.dart';

class DummyScrren extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<DummyScrren> {

  final _usernameController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 0),
              child: Stack(
                fit: StackFit.loose,
                children: <Widget>[
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/loginbackground.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: HeaderLogo(),
                  ),
                  Container(
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
                        Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Bold',
                            fontSize: 24,
                            color: colorText,
                          ),
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
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              fontFamily: 'Medium',
                              color: colorText,
                              fontSize: 14,
                            ),
                          ),
                          inputFormatters: [new LengthLimitingTextInputFormatter(30)],
                          controller: _usernameController,
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
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontFamily: 'Medium',
                              color: colorText,
                              fontSize: 14,
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passwordController,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontFamily: 'Medium',
                              fontSize: 14,
                              color: colorBlueText,
                            ),
                          ),
                          alignment: Alignment.centerRight,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                print("Login click method ");
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    color: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                    ),
                    width: 200,
                    margin: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Bold',
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 20,
            ),
            Expanded(
              flex: 1,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                  ),
                  InkWell(
                    onTap: (){
                      print("--------onTap----------");
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterUser()),
                      );
                    },

                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}

