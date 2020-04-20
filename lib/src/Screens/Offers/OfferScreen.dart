import 'package:flutter/material.dart';
//import 'package:restroapp/src/Screens/Offers/OfferDetailScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';

class OfferScreen extends StatefulWidget {
  OfferScreen(BuildContext context);

  @override
  _OfferState createState() => new _OfferState();
}

class _OfferState extends State<OfferScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Offer'),
        centerTitle: true,
      ),
      body: projectWidget(),
    );
  }

  Widget projectWidget() {
    return FutureBuilder(
      future: ApiController.storeOffersApiRequest(null),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container();
        } else {
          if (projectSnap.hasData) {
            StoreOffersResponse response = projectSnap.data;
            if (response.success) {
              return Container();
//              List<OfferModel> offerList = response.offers;
//              return Container(
//                  child: Column(
//                children: <Widget>[
//                  Expanded(
//                      child: ListView.separated(
//                    shrinkWrap: true,
//                    itemCount: offerList.length,
//                    separatorBuilder: (context, index) =>
//                        Divider(height: 2.0, color: Colors.black),
//                    itemBuilder: (context, index) {
//                      OfferModel offer = offerList[index];
//                      return ListTile(
//                          title: Text(
//                            offer.discount + " Off ",
//                            style: TextStyle(
//                                fontWeight: FontWeight.bold,
//                                color: Colors.black),
//                          ),
//                          subtitle: Column(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              Text(" code : ${offer.couponCode}",
//                                  style: new TextStyle(
//                                    color: Colors.blue[4050],
//                                    fontSize: 20.0,
//                                    /*fontWeight: FontWeight.w900*/
//                                  )),
//                            ],
//                          ),
//                          trailing: Container(
//                            child: GestureDetector(
//                                onTap: () {
//                                  Route route = MaterialPageRoute(
//                                      builder: (context) =>
//                                          OfferDetailScreen(offer));
//                                  Navigator.pushReplacement(context, route);
//                                },
//                                child: Container(
//                                  child: ClipRRect(
//                                    borderRadius: BorderRadius.circular(20.0),
//                                    child: Image.asset('images/arrow_right.png',
//                                        width: 30.0, height: 30.0),
//                                  ),
//                                )),
//                          ));
//                    },
//                  )),
//                ],
//              ));
            } else {
              return Container();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.black26,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)),
            );
          }
        }
      },
    );
  }
}
