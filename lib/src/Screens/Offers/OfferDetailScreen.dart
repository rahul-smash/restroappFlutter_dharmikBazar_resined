import 'package:flutter/material.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';


class OfferDetailScreen extends StatefulWidget {
  OffersData storeData;

  OfferDetailScreen(this.storeData);

  @override
  State<StatefulWidget> createState() {
    print("---------OfferDetailScreen---------");

    return _offerDetailScreen(storeData);
  }
}

class _offerDetailScreen extends State<OfferDetailScreen> {
  OffersData offersData;

  _offerDetailScreen(this.offersData);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text(offersData.couponCode),
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
                        offersData.validFrom +
                        'to' +
                        offersData.validTo,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Usage Limit :' + offersData.usageLimit,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                    'Minimum Order Amount :' + offersData.minimumOrderAmount,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Discount :' + offersData.discount,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Coupon Code :' + offersData.couponCode,
                    style: TextStyle(fontSize: 18, color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                    'Terms n Condition :' + offersData.offerTermCondition,
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
    ;
  }
}
