import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/OfferDetailScreen.dart';
import 'package:restroapp/src/Screens/SaveDeliveryAddress.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';
import 'package:restroapp/src/utils/Utils.dart';

/*class OfferScreen extends StatefulWidget {
  OfferScreen(BuildContext context);

  @override
  _offerScreen createState() => new _offerScreen();
}

class _offerScreen extends State<OfferScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Offer'),
        centerTitle: true,
      ),
    );
  }
}*/
/*class AvailableOffersDialog extends StatefulWidget{

  double totalPrice = 0.0;
  DeliveryAddressData area;
  int selectedRadio;
  String applyCouponText = "Apply Coupon";
  String couponCodeValue = "Coupon code here..";

  AvailableOffersState state = new AvailableOffersState();

  AvailableOffersDialog(this.area, this.selectedRadio);

  @override
  AvailableOffersState createState() => state;

}*/
class OfferScreen extends StatefulWidget {
  OfferScreen(BuildContext context);

  @override
  _offerScreen createState() => new _offerScreen();
}

class _offerScreen extends State<OfferScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Offer'),
        centerTitle: true,
      ),
      /* shape: RoundedRectangleBorder(
      ),*/
      body: projectWidget(),
    );
  }

  Widget projectWidget() {
    return FutureBuilder(
      future: ApiController.storeOffersApiRequest_(),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container(color: const Color(0xFFFFE306));
        } else {
          if (projectSnap.hasData) {
            //print('---projectSnap.Data-length-${projectSnap.data.length}---');
            //return Container(color: const Color(0xFFFFE306));
            List<OffersData> areaList = projectSnap.data;
            //return dialogContent(context,areaList,widget.selectedRadio);
            return Container(
             /* decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),*/
              child: Container(
                child: Column(
                  children: <Widget>[

                    Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: areaList.length,
                        separatorBuilder: (context, index) =>
                            Divider(height: 2.0, color: Colors.black),
                        itemBuilder: (context, index) {
                          OffersData offer = areaList[index];
                          return ListTile(
                            title: Text(
                              offer.discount + " Off ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(" code : ${offer.couponCode}",
                                    style: new TextStyle(
                                      color: Colors.blue[4050],
                                      fontSize: 20.0,
                                      /*fontWeight: FontWeight.w900*/
                                    )),
                              ],
                            ),
                            trailing: Container(
                              child: GestureDetector(
                                onTap: () {
                                  print('---@@ImageClickEvent--');
                                  print('_offers------');
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          OfferDetailScreen(offer));
                                  Navigator.pushReplacement(context, route);
                                },
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: Image.asset('images/arrow_right.png',
                                        width: 30.0, height: 30.0),

                                  ),


                                ),

                              ),

                            ),

                          );

                        },
                      ),

                    ),
                  ],

                ),
              ),

            );

          } else {
            //print('-------CircularProgressIndicator----------');
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
