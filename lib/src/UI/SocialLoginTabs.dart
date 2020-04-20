import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            color: Color(0xffe9eaec),
            height: 2,
            width: 100,
          ),
          SizedBox(width: 10),
          Text(
            'Social Login',
            style: TextStyle(
              fontFamily: 'Medium',
              fontSize: 15,
              color: Color(0xffe9eaec),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: 100,
            color: Color(0xffe9eaec),
            height: 2,
          )
        ],
      ),
      SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff1346b4),
                  Color(0xff0cb2eb),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.facebookF,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xffff4645),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                FontAwesomeIcons.google,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      )
    ]);
  }
}
