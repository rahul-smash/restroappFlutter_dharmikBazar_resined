import 'package:flutter/material.dart';
import 'package:restroapp/src/OrderDetailScreen/OrderView.dart';
import 'package:restroapp/src/Screens/Offers/OfferDetailScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/ui/CardOrderHistoryItems.dart';
import 'package:restroapp/src/utils/Utils.dart';

/*class OfferScreen extends StatefulWidget {
  OfferScreen(BuildContext context);

  @override
  _offerScreen createState() => new _offerScreen();
}

class _offerScreen extends State<OfferScreen> {
  @override
  Widget build(BuildContext context) {
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
class MyOrderScreen extends StatefulWidget {
  MyOrderScreen(BuildContext context);

  @override
  _MyOrderScreen createState() => new _MyOrderScreen();
}

class _MyOrderScreen extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Order History'),
        centerTitle: true,
      ),
      /* shape: RoundedRectangleBorder(
      ),*/
      body: projectWidget(),
    );
  }

  Widget projectWidget() {
    return FutureBuilder(
      future: ApiController.getOrderHistory(),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Container(color: const Color(0xFFFFE306));
        } else {
          if (projectSnap.hasData) {

            //print('---projectSnap.Data-length-${projectSnap.data.length}---');
            //return Container(color: const Color(0xFFFFE306));
            List<OrderData> areaList = projectSnap.data;
            print('---reaList.length-${areaList.length}---');
            //print(${areaList.length});
            //return dialogContent(context,areaList,widget.selectedRadio);


            return Container(
               decoration: new BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: const Offset(0.0, 10.0),
                  ),
                ],
              ),
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

                          OrderData orderHistoryData = areaList[index];
                          print('--------@@OrderData-------'+orderHistoryData.orderId);

                          //print('index: ${index}');
                          return CardOrderHistoryItems(orderHistoryData);////////////////////////////////////
                      /*    return ListTile(

                            title: Text(
                             "Order Number :" +orderHistoryData.orderId,
                              style: TextStyle(

                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                fontSize: 15.0
                              ),
                            ),
                            trailing: Container(
                              child: GestureDetector(
                                onTap: () {
                                  print('---@@ImageClickEvent--');
                                  print('_offers------');
                                  Route route = MaterialPageRoute(
                                      builder: (context) =>
                                          OrderView(orderHistoryData));
                                  Navigator.pushReplacement(context, route);
                                },
                                child: Container(

                                  child: new FlatButton( onPressed: () {
                                    *//*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactScreen()),
                    );*//*

                                  }, child: new Text(
                                    "View",
                                    style: new TextStyle(color: Colors.redAccent),
                                  )),




                                ),

                              ),

                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Order date : ${orderHistoryData.orderDate}",
                                    style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w900
                                    )

                                ),

                                Text("Order Price: ${orderHistoryData.total}",
                                    style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,

                                      fontWeight: FontWeight.w900
                                    )),
                              ],
                            ),


                          );*/
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
