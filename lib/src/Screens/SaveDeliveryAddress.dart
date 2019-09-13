import 'package:flutter/material.dart';

class SaveDeliveryAddress extends StatefulWidget {

  @override
  _SaveDeliveryAddressState createState() => _SaveDeliveryAddressState();
}

class _SaveDeliveryAddressState extends State<SaveDeliveryAddress> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Back Button Example'),
      ),
      body: WillPopScope(
        //Wrap out body with a `WillPopScope` widget that handles when a user is cosing current route
        onWillPop: () async {
          //Future.value(false);
          //return a `Future` with false value so this route cant be popped or closed.

          print("WillPopScope");
          return new Future(() => false);
        },
        child: Center(
          child: Text('Back Button dont work on this Screen'),
        ),
      ),
    );
  }
}


