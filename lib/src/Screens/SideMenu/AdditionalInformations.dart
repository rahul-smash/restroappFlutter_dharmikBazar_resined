import 'package:flutter/material.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/Utils.dart';

import 'AboutScreen.dart';
import 'FAQScreen.dart';
import 'HtmlDisplayScreen.dart';

class AdditionalInformation extends StatefulWidget {
  final StoreModel store;

  AdditionalInformation(this.store);

  @override
  _AdditionalInformationState createState() {
    return _AdditionalInformationState();
  }
}

class _AdditionalInformationState extends State<AdditionalInformation> {
  List<dynamic> _drawerItems = List();

  @override
  void initState() {
    super.initState();
    _drawerItems.add(AdditionChildItem(
        AdditionItemsConstants.TERMS_CONDITIONS, "images/about_image.png"));
    _drawerItems.add(AdditionChildItem(
        AdditionItemsConstants.PRIVACY_POLICY, "images/about_image.png"));
    _drawerItems.add(AdditionChildItem(
        AdditionItemsConstants.REFUND_POLICY, "images/about_image.png"));
    _drawerItems.add(AdditionChildItem(
        AdditionItemsConstants.ABOUT_US, "images/about_image.png"));
    _drawerItems.add(AdditionChildItem(
        AdditionItemsConstants.FAQ, "images/about_image.png"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: new Text('Additional Information'),
            centerTitle: true,
            actions: [    InkWell(
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Padding(
                padding:
                EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0, right: 10),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),],
          ),
          body: SafeArea(
            child: ListView.separated(
                separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: Color(0xFFDBDCDD),
                    ),
                padding: EdgeInsets.zero,
                itemCount: _drawerItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return createItem(index, context);
                }),
          )),
    );
  }

  Widget createItem(int index, BuildContext context) {
    var item = _drawerItems[index];
    return Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text(item.title,
              style: TextStyle(color: Colors.black, fontSize: 18)),
          onTap: () {
            _openPageForIndex(item, index, context);
          },
        ));
  }

  _openPageForIndex(
      AdditionChildItem item, int pos, BuildContext context) async {
    switch (item.title) {
      case AdditionItemsConstants.ABOUT_US:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen(widget.store)),
        );
        Map<String, dynamic> attributeMap = new Map<String, dynamic>();
        attributeMap["ScreenName"] = "AboutScreen";
        Utils.sendAnalyticsEvent("Clicked AboutScreen", attributeMap);
        break;
      case AdditionItemsConstants.TERMS_CONDITIONS:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HtmlDisplayScreen(AdditionItemsConstants.TERMS_CONDITIONS)),
        );
        Map<String, dynamic> attributeMap = new Map<String, dynamic>();
        attributeMap["ScreenName"] = "TERMS_CONDITIONS";
        Utils.sendAnalyticsEvent("Clicked TERMS_CONDITIONS", attributeMap);
        break;
      case AdditionItemsConstants.PRIVACY_POLICY:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HtmlDisplayScreen(AdditionItemsConstants.PRIVACY_POLICY)),
        );
        Map<String, dynamic> attributeMap = new Map<String, dynamic>();
        attributeMap["ScreenName"] = "PRIVACY_POLICY";
        Utils.sendAnalyticsEvent("Clicked PRIVACY_POLICY", attributeMap);
        break;
      case AdditionItemsConstants.REFUND_POLICY:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HtmlDisplayScreen(AdditionItemsConstants.REFUND_POLICY)),
        );
        Map<String, dynamic> attributeMap = new Map<String, dynamic>();
        attributeMap["ScreenName"] = "REFUND_POLICY";
        Utils.sendAnalyticsEvent("Clicked REFUND_POLICY", attributeMap);
        break;

      case AdditionItemsConstants.FAQ:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FAQScreen(widget.store)),
        );
        Map<String, dynamic> attributeMap = new Map<String, dynamic>();
        attributeMap["ScreenName"] = "FAQ";
        Utils.sendAnalyticsEvent("Clicked FAQ", attributeMap);
        break;
    }
  }
}

class AdditionChildItem {
  String title;
  String icon;

  AdditionChildItem(this.title, this.icon);
}
