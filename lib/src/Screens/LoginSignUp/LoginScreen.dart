import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/Screens/RegisterScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/ui/social.dart';
import 'package:restroapp/src/utils/AppColor.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/loginbackground.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: SizedBox(
                        child: Image.asset('images/logo.png'),
                        width: 250,
                        height: 250,
                      ),
                    ),
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
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(30)
                          ],
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
              onTap: () {
                print("Login click method ");
                _performLogin();
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
                  InkWell(
                    onTap: () {
                      print("--------onTap----------");
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterUser()),
                      );
                    },
                    child: Padding(
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
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _performLogin() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    print('login attempt: $username with $password');
    ProgressDialog pr;
    //For normal dialog
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.show();

    ApiController.loginApiRequest(username, password).then((response) {
      if (response != null) {
        print("${response.data.id}");
        if (response.success) {
          Navigator.pop(context);
        }
        pr.hide();
      }
    });
  }
}
