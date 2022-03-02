import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:restroapp/src/UI/ProductTileView.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CartTableData.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../singleton/app_version_singleton.dart';

class OfferDetailScreen extends StatefulWidget {
  OfferDetailScreen();

  @override
  State<StatefulWidget> createState() {
    return _OfferDetailState();
  }
}

class _OfferDetailState extends State<OfferDetailScreen> {
  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getProductDetailsView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

// add Product Details top view 
  Widget getProductDetailsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "images/coupon_detail_graphic.png",
                    fit: BoxFit.fill,
                  ),
                ),
                getCouponView(),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 24),
                    child: Center(
                      child: Text("Offer Details",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ],
            ),
          ],
          overflow: Overflow.clip,
        ),
      ],
    );
  }

  Widget getCouponView() {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0, right: 10),
      width: Utils.getDeviceWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Text("Terms and Conditions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(
            height: 10,
          ),
          Text(
              "s simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard ",
              style: TextStyle(fontSize: 16)),
          SizedBox(
            height: 10,
          ),
          addDividerView(),
          SizedBox(
            height: 10,
          ),
          Text("Offer Validity",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("• "),
                Expanded(
                  child: Text('Monday to Thursday : 9am to 9 pm'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("• "),
                Expanded(
                  child: Text('Friday : 9am to 5 pm'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("• "),
                Expanded(
                  child: Text('Saturday : 9am to 2 pm'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("Offer eligibility",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("• "),
                Expanded(
                  child: Text('letters, as opposed to using Content here'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("• "),
                Expanded(
                  child: Text(
                      'Letraset sheets containing Lorem Ipsum passages, and more recently with desktop'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("• "),
                Expanded(
                  child: Text(
                      'Letraset sheets containing Lorem Ipsum passages, and more recently with desktop'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addDividerView() {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width,
      color: grayColor,
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0, left: 20, right: 20),
    );
  }
}
