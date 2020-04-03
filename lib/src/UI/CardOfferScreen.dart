import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/HomeScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreData.dart';
import 'package:restroapp/src/models/offer/GetOfferData.dart';
import 'package:restroapp/src/models/store_list.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardOfferScreen extends StatefulWidget {

  GetOfferData store;

  CardOfferScreen(this.store);

  @override
  State<StatefulWidget> createState() {
    return CardOfferScreen_(store);
  }
}

class CardOfferScreen_ extends State<CardOfferScreen> {

  GetOfferData store;
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

