import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:restroapp/src/Screens/Dashboard/ContactScreen.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

import 'ContactUs.dart';

class AboutScreen extends StatefulWidget {
  StoreModel store;
  AboutScreen(this.store);

  @override
  State<StatefulWidget> createState() {
    return _AboutScreenState();
  }
}

class _AboutScreenState extends State<AboutScreen> {

  String aboutUs, aboutUsBanner="";

  @override
  void initState() {
    super.initState();
    try {
      print("aboutusBanner=${widget.store.aboutusBanner[0].image}");
      aboutUsBanner = widget.store.aboutusBanner[0].image;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('About Us'),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Visibility(
                child: CachedNetworkImage(
                    imageUrl: aboutUsBanner,
                    fit: BoxFit.fitWidth
                ),
                visible : widget.store.aboutusBanner == null ? false :true,
              ),
              widget.store.aboutUs == null
                  ? Container()
                  : Html(
                data: widget.store.aboutUs,
                padding: EdgeInsets.all(10.0),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: whiteColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: FlatButton(
                    child: Text('Contact Us'),
                    color: appThemeSecondary,
                    textColor: Colors.white,
                    onPressed: () {
                      //Navigator.pop(context, false);
                      if (AppConstant.isLoggedIn) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ContactUs()),
                        );
                      }else{
                        Utils.showToast(AppConstant.pleaseLogin, true);
                      }

                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: FlatButton(
                    child: Text('Locate Us',style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),),
                    color: Colors.white,
                    textColor: Colors.black,
                    onPressed: () {
                      try {
                        if (widget.store != null) {
                          String address = "${widget.store.storeName}, ${widget.store.location}"
                              "${widget.store.city}, ${widget.store.state}, ${widget.store.country}";
                          print("address= ${address}");
                          MapsLauncher.launchQuery(address);
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ),
              ],
            ),
        ),
      ),
    );
  }


}
