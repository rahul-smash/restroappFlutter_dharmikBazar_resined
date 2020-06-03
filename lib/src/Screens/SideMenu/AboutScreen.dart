import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen();

  @override
  State<StatefulWidget> createState() {
    return _AboutScreenState();
  }
}

class _AboutScreenState extends State<AboutScreen> {

  String aboutUs;
  WebViewController _controller;

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
      /*body: Container(
        child: SingleChildScrollView(
          child: aboutUs == null
              ? Container()
              : Html(
            data: aboutUs,
            padding: EdgeInsets.all(10.0),
          ),
        ),
      ),*/
      body: WebView(
        initialUrl: 'about:blank',
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),
    );
  }

  _loadHtmlFromAssets() async {
    _controller.loadUrl(Uri.dataFromString(aboutUs,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }
}
