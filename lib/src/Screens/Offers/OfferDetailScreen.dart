import 'package:flutter/material.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';

class OfferDetailScreen extends StatefulWidget {
  OfferModel offer;

  OfferDetailScreen(this.offer);

  @override
  State<StatefulWidget> createState() {
    print("---------OfferDetailScreen---------");

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
          title: new Text(offer.couponCode),
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
            alignment: Alignment.center,
            child: new Image.asset(
              'images/placeholder.png',
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                    'Valid From :' +
                        offer.validFrom +
                        'to' +
                        offer.validTo,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Usage Limit :' + offer.usageLimit,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                    'Minimum Order Amount :' + offer.minimumOrderAmount,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Discount :' + offer.discount,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Coupon Code :' + offer.couponCode,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                    'Terms n Condition :' + offer.offerTermCondition,
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
