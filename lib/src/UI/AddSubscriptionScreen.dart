import 'package:flutter/material.dart';
import 'package:restroapp/src/utils/BaseState.dart';

class AddSubscriptionScreen extends StatefulWidget {

  AddSubscriptionScreen();

  @override
  _AddSubscriptionScreenState createState() {
    return _AddSubscriptionScreenState();
  }
}

class _AddSubscriptionScreenState extends BaseState<AddSubscriptionScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Subscription"),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}