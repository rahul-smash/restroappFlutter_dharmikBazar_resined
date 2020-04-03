import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen(BuildContext context);

  @override
  State<StatefulWidget> createState() {
    print("---------AboutScreen---------");

    return _aboutScreen();
  }
}

class _aboutScreen extends State<AboutScreen> {
  String aboutUs;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('About Us'),
        centerTitle: true,
      ),
      body: new Container(
        child: SingleChildScrollView(
          child: Html(
            data: aboutUs,
            padding: EdgeInsets.all(3.0),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _aboutUsData();
  }

  _aboutUsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      ///DO MY Logic CALLS
      aboutUs = prefs.getString(AppConstant.ABOUT_US);
      print('--@@aboutUs' + aboutUs);
    });
  }

  Future<void> loadHtmlFromAssets(String filename, controller) async {
 //   String fileText = await rootBundle.loadString(filename);
    controller
        .loadUrl(
            Uri.dataFromString('<html><body>hello world</body></html>',
                    mimeType: 'text/html')
                .toString(),
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'))
        .toString();
  }
}
