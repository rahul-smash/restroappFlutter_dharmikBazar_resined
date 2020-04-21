import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/Screens/LoginSignUp/RegisterScreen.dart';
import 'package:restroapp/src/UI/SocialLoginTabs.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:flutter/gestures.dart';
import 'package:restroapp/src/utils/BaseState.dart';


class PickUpOrderScreen extends StatefulWidget {
  @override
  _PickUpOrderScreen createState() => _PickUpOrderScreen();
}

class _PickUpOrderScreen extends BaseState<PickUpOrderScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text("PickUp Order"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min, // <-- notice 'min' here. Important
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff000000),width: 1,)
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child:Row(
                      children: <Widget>[
                        Text("Select City:",style: TextStyle(color: infoLabel, fontSize: 18.0),),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                          child: InkWell(
                            onTap: () {
                            },
                            child: Container(
                              child: Text("City",
                                style: TextStyle( color: Colors.black, fontSize: 20.0, ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Row(
                      children: <Widget>[
                        Text("Select Area:",style: TextStyle(color: infoLabel, fontSize: 18.0),),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                          child: InkWell(
                            onTap: () {
                            },
                            child: Container(
                              child: Text("Area",
                                style: TextStyle( color: Colors.black, fontSize: 20.0, ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

}
