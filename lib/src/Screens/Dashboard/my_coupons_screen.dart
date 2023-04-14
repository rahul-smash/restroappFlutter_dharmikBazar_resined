
import 'package:flutter/material.dart';

import 'package:restroapp/src/Screens/Dashboard/offer_detail_screen.dart';

import 'package:restroapp/src/apihandler/ApiController.dart';

import 'package:restroapp/src/models/StoreOffersResponse.dart';

import 'package:restroapp/src/utils/Utils.dart';


class MyCouponScreen extends StatefulWidget {
  MyCouponScreen();

  @override
  State<StatefulWidget> createState() {
    return _MyCouponState();
  }
}

class _MyCouponState extends State<MyCouponScreen> {

  bool isLoading = true;
  StoreOffersResponse storeOffersResponse = new StoreOffersResponse();

  @override
  initState() {
    super.initState();
    getOfferDetail();
  }

  void getOfferDetail() async {
    ApiController.storeOfferApiRequest().then((value) {
      storeOffersResponse = value;
      setState(() {
        isLoading  = false;
      });
    }).catchError((error) {
      print(error);
      setState(() {
        isLoading = false;
      });
    });
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
            Container(
              margin: EdgeInsets.only(top: 160),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 0),
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

                  (isLoading || storeOffersResponse.offers == null) ? Container(
                      child: Center(
                          child: Utils.showSpinner())
                  ) : ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10),
                    itemBuilder: (context, index) {
                      return getCouponView(index);
                    },
                    itemCount: storeOffersResponse.offers.length,
                    separatorBuilder:
                        (BuildContext context, int index) {
                      return Divider(
                        color: Colors.grey,
                      );
                    },
                  ),
                ],
              ),
            ),

            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 180,
                  child: Image.asset("images/my_coupon.png",
                    fit: BoxFit.fill,
                  ),
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
                        style: TextStyle(color: Colors.black, fontSize: 20,fontWeight: FontWeight.w600),
                      ),
                    ),
                    /*Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        "my coupons aenean\n net vec leo",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),*/
                  ],
                ),
              ],
            ),
          ],
          clipBehavior: Clip.none,
        ),

      ],
    );
  }

  Widget getCouponView(int index) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0,right: 10),
      width: Utils.getDeviceWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(storeOffersResponse.offers[index].name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          SizedBox(height: 10,),
          Text(getDiscountTest(storeOffersResponse.offers[index]),
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
                        OfferDetailScreen(offerID : storeOffersResponse.offers[index].id),
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

  String getDiscountTest(OfferModel offer) {
    String couponCode = 'Use code ${offer.couponCode} and get ';
    String discount = (offer.discount_type == "3" || offer.discount_type == "4") ? '${offer.discount} % ' : '' ;
    String afterUpto = 'upto Rs ${offer.discount_upto} on orders above Rs. ${offer.minimumOrderAmount}';
    return couponCode+discount+afterUpto;
  }

}
