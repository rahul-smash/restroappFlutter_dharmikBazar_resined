import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';

class FAQScreen extends StatefulWidget {
  StoreModel store;
  FAQScreen(this.store);

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  bool isLoadingApi=true;
  @override
  void initState() {
    super.initState();
    ApiController.getFAQRequest();

  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('FAQ'),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
