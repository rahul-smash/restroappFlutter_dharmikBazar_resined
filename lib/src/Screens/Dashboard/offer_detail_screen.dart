
import 'package:flutter/material.dart';

import 'package:restroapp/src/apihandler/ApiController.dart';

import 'package:restroapp/src/models/OfferDetailResponse.dart';

import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';


class OfferDetailScreen extends StatefulWidget {
  final String offerID;

  OfferDetailScreen({this.offerID = ''});

  @override
  State<StatefulWidget> createState() {
    return _OfferDetailState();
  }
}

class _OfferDetailState extends State<OfferDetailScreen> {
  OfferDetailResponse offerDetailResponse = OfferDetailResponse();
  bool isLoading = true;

  @override
  initState() {
    super.initState();

    getOfferDetail();
  }

  void getOfferDetail() async {
    ApiController.getOfferDetail(widget.offerID).then((value) {
      offerDetailResponse = value;
      setState(() {
        isLoading = false;
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
          clipBehavior: Clip.none,
        ),
      ],
    );
  }

  Widget getCouponView() {
    return (isLoading || offerDetailResponse == null)
        ? Container(child: Center(child: Utils.showSpinner()))
        : Container(
            margin:
                EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0, right: 10),
            width: Utils.getDeviceWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text("Terms and Conditions",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 10,
                ),
                Text(offerDetailResponse.data.offerTermCondition,
                    style: TextStyle(fontSize: 16)),
                SizedBox(
                  height: 10,
                ),
                addDividerView(),
                SizedBox(
                  height: 10,
                ),
                Text("Offer Validity",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("• "),
                      Expanded(
                        child: Text('Valid from : ${Utils.convertValidTillDate(offerDetailResponse.data.validFrom)}'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("• "),
                      Expanded(
                        child: Text('Valid to : ${Utils.convertValidTillDate(offerDetailResponse.data.validTo)}'),
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
