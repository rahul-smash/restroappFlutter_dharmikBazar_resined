import 'package:flutter/material.dart';
import 'package:restroapp/src/utils/color.dart';

class HeaderLogo extends StatelessWidget {
  const HeaderLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        /*Positioned(
          right: 0,
          top: 0,
          child: SizedBox(
            child: Image.asset('images/logo.png'),
            width: 150,
            height: 150,
          ),
        ),*/
        Center(
          child: SizedBox(
            child: Image.asset('images/logo.png'),
            width: 250,
            height: 250,
          ),
        ),
      ],
    );
  }
}