import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:restroapp/src/Screens/Dashboard/offer_detail_screen.dart';
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

class MyCouponScreen extends StatefulWidget {
  MyCouponScreen();

  @override
  State<StatefulWidget> createState() {
    return _MyCouponState();
  }
}

class _MyCouponState extends State<MyCouponScreen> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  String imageUrl;
  Variant variant;
  String discount, price, variantId, weight, mrpPrice;
  int counter = 0;
  CartData cartData;
  bool showAddButton;
  int selctedTag;
  StoreModel _storeModel;
  bool isVisible = true;
  List<Product> _recommendedProducts = List.empty(growable: true);
  double totalPrice = 0.00;

  bool _isProductOutOfStock = false;

  int _current = 0;

  CarouselController _carouselController;

  var _pageController;
  OfferDetails offerDetails;

  @override
  initState() {
    super.initState();
  }


  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: Icon(Icons.arrow_back, color: Colors.white),
        //     onPressed: () {
        //       return Navigator.pop(context, variant);
        //     },
        //   ),
        // ),
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
                  child: Image.asset("images/my_coupon.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  padding:
                  EdgeInsets.only(top: 0.0, bottom: 30.0, left: 30.0, right: 30.0),
//              EdgeInsets.all(0),
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(onPressed: (){
                  Navigator.of(context).pop();
                }, icon: Icon(Icons.arrow_back_ios)),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                  child: Text(
                    "My Coupons",
                    style: TextStyle(color: Colors.black, fontSize: 22),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric( horizontal: 30),
                  child: Text(
                    "my coupons aenean\n net vec leo",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ),

                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 50),
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      //Icon(Icons.ac_unit,color: appThemeSecondary),
                      Image.asset("images/available_coupon_icon.png",
                        height: 22,
                        width: 22,
                        fit: BoxFit.fill,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text("Available coupons",
                              maxLines: 1,overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 16)),
                        ),
                      ),


                    ],
                  ),
                ),

                ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10),
                  itemBuilder: (context, index) {
                    return getCouponView();
                  },
                  itemCount: 5,
                  separatorBuilder:
                      (BuildContext context, int index) {
                    return Divider(
                      color: Colors.grey,
                    );
                  },
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
      margin: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0,right: 10),
      width: Utils.getDeviceWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Get 20% discount using Kotak Bank Credit card or Debit card",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 10,),
          Text("Use code KOTAK125 and get 20% discount upto Rs 125 on orders above Rs 500",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        OfferDetailScreen(),
                  ));
            },
            child: Text("VIEW T&C",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18, color: Colors.amber, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

}
