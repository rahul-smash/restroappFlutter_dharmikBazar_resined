import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/Offers/OfferDetailScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class MyOfferScreen extends StatefulWidget {
  MyOfferScreen(BuildContext context);

  @override
  MyOfferScreenState createState() => new MyOfferScreenState();
}

class MyOfferScreenState extends State<MyOfferScreen> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppConstant.txt_offers,
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: ApiController.myOffersApiRequest(),
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.none &&
                      projectSnap.hasData == null) {
                    return Container();
                  } else {
                    if (projectSnap.hasData) {
                      StoreOffersResponse response = projectSnap.data;
                      if (response.success) {
                        List<OfferModel> offerList = response.offers;
                        if(offerList.isEmpty){

                          return Utils.getEmptyView("No data found");
                        }else{
                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: offerList.length,
                              itemBuilder: (context, index) {
                                OfferModel offer = offerList[index];
                                return ListTile(
                                  title: Text(
                                    offer.name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                          AppConstant.txt_code+" ${offer.couponCode}", style: TextStyle(color: Colors.black
                                      )),
                                    ],
                                  ),
                                  trailing: Wrap(
                                    spacing: 12, // space between two icons
                                    children: <Widget>[
                                      Icon(Icons.arrow_right), // icon-2
                                    ],
                                  ),

                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OfferDetailScreen(offer),
                                        ));
                                  },

                                );
                              },

                            ),

                          );
                        }

                      } else {
                        return Container();
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.black26,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black26)),
                      );
                    }
                  }
                },
              ),

            ],
          ),
        ));
  }
}
