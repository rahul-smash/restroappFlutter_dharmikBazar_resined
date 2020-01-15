import 'package:flutter/material.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';
import 'package:restroapp/src/models/orderHistory/GetOrderHistory.dart';


class OrderView extends StatefulWidget {
  //OrderData orderViewItems;
  List<OrderItems> orderItems;

  OrderView(this.orderItems);

  @override
  State<StatefulWidget> createState() {
    print("---------OrderViewScreen---${orderItems.length}------");

    return _orderView(orderItems);
  }
}

class _orderView extends State<OrderView> {

   List<OrderItems> orderItems;


  _orderView(this.orderItems);

  // _orderView();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return new Scaffold(
        appBar: AppBar(
          title: new Text('OrderDetails'),
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
            /*new Container(
            alignment: Alignment.center,
            child: new Image.asset(
              'images/placeholder.png',
              alignment: Alignment.topCenter,
              fit: BoxFit.fitWidth,
            ),
          ),*/
            ListView.builder(
              padding: EdgeInsets.only(bottom: 3),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: orderItems.length,

              itemBuilder: (context, index) {
               return new Card(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(orderItems[index].productName),
                            subtitle: Text(orderItems[index].price),

                          ),
                          ListTile(
                            title: Text(orderItems[index].status),
                            subtitle: Text(orderItems[index].quantity),

                          ),

                        ]

                    )

                );




              },

            )

          ]


          ),

        ),

      );

    }
  }

