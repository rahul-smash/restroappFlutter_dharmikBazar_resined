import 'package:flutter/material.dart';
import 'package:restroapp/src/ui/login.dart';
import 'package:restroapp/src/ui/social.dart';
import 'package:restroapp/src/utils/HeaderLogo.dart';
import 'package:restroapp/src/utils/color.dart';

class LoginScreen extends StatelessWidget {

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
                  Login()
                ],
              ),
            ),
            Padding(
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
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Color(0xffe9eaec),
                  height: 2,
                  width: 100,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Social Login',
                  style: TextStyle(
                    fontFamily: 'Medium',
                    fontSize: 15,
                    color: Color(0xffe9eaec),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 100,
                  color: Color(0xffe9eaec),
                  height: 2,
                )
              ],
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
                    child: Social(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: RichText(
                        text: TextSpan(
                          text: 'New User?',
                          style: TextStyle(
                              fontFamily: 'Medium',
                              fontSize: 16,
                              color: Colors.deepOrange),
                          children: [
                            TextSpan(
                              text: ' Sign Up',
                              style: TextStyle(
                                  fontFamily: 'Medium',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepOrange),
                            ),
                          ],
                        ),
                      ),
                    ),
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
