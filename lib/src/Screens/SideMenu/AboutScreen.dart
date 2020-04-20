import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen(BuildContext context);

  @override
  State<StatefulWidget> createState() {
    return _AboutScreenState();
  }
}

class _AboutScreenState extends State<AboutScreen> {
  String aboutUs;

  @override
  void initState() {
    super.initState();
    _aboutUsData();
  }

  _aboutUsData() async {
    StoreModel store = await SharedPrefs.getStore();
    setState(() {
      aboutUs = store.aboutUs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('About Us'),
        centerTitle: true,
      ),
      body: new Container(
        child: SingleChildScrollView(
          child: aboutUs == null
              ? Container()
              : Html(
                  data: aboutUs,
                  padding: EdgeInsets.all(10.0),
                ),
        ),
      ),
    );
  }
}
