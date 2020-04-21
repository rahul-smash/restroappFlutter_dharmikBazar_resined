import 'package:flutter/material.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';
import 'package:restroapp/src/utils/AppConstants.dart';

class OfferDetailScreen extends StatefulWidget {
  final OfferModel offer;

  OfferDetailScreen(this.offer);

  @override
  State<StatefulWidget> createState() {
    return _offerDetailScreen(offer);
  }
}

class _offerDetailScreen extends State<OfferDetailScreen> {
  OfferModel offer;

  _offerDetailScreen(this.offer);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text(
            offer.couponCode,
            style: new TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Form(
          child: offerDetailUI(),
        ));
  }

  Widget offerDetailUI() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(children: <Widget>[
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
            alignment: Alignment.center,
            child: new Image.asset(
              'images/app_icon.png',
              alignment: Alignment.center,
              fit: BoxFit.fill,
              width: 200.0,
              height: 200.0,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                    AppConstant.txt_valid_form +
                        offer.validFrom +
                        ' to ' +
                        offer.validTo,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(AppConstant.txt_usage_Limit + offer.usageLimit,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                    AppConstant.txt_minimum_Amount + offer.minimumOrderAmount,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(AppConstant.txt_Discount + offer.discount,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(AppConstant.txt_Coupon + offer.couponCode,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                    AppConstant.txt_terms_condition + offer.offerTermCondition,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              /*new Divider(

                  color: Colors.black
              )*/
            ]),
          ),
        ]),
      ),
    );
  }
}
