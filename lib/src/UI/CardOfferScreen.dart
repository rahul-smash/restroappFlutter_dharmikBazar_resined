import 'package:flutter/material.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';

class CardOfferScreen extends StatefulWidget {

  StoreOffersResponse store;

  CardOfferScreen(this.store);

  @override
  State<StatefulWidget> createState() {
    return CardOfferScreen_(store);
  }
}

class CardOfferScreen_ extends State<CardOfferScreen> {
  StoreOffersResponse store;
  String renderUrl;

  CardOfferScreen_(this.store);

  Widget get storeCard {


    return
      new Card(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('${store.message}:'),
                  subtitle: Text('${store.message}'),

                ),

              ]

          )
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child:  storeCard,
    );
  }



}

