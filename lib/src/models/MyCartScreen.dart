import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/AddDeliveryAddressScreen.dart';

class MyCart extends StatelessWidget {

  ProceedBottomBar proceedBottomBar = new ProceedBottomBar();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: Text("My Cart"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Column(
          children: <Widget>[
            Divider(color: Colors.white, height: 2.0),
            Container(

            ),
          ],
        ),
        bottomNavigationBar: proceedBottomBar,
      ),
    );
  }
}

class ProceedBottomBar extends StatefulWidget {
  final _ProceedBottomBarState state = new _ProceedBottomBarState();

  @override
  _ProceedBottomBarState createState() => state;
}

class _ProceedBottomBarState extends State<ProceedBottomBar> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 50.0,
      color: Colors.deepOrange,
      child: InkWell(
        onTap: () {
          //print("on click message");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDeliveryAddress()),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Proceed",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ],
        ),
      ),

    );
  }
}