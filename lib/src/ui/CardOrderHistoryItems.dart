import 'package:flutter/material.dart';
import 'package:restroapp/src/OrderDetailScreen/OrderView.dart';
import 'package:restroapp/src/Screens/HomeScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreData.dart';
import 'package:restroapp/src/models/orderHistory/GetOrderHistory.dart';
import 'package:restroapp/src/models/store_list.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardOrderHistoryItems extends StatefulWidget {
  OrderData orderHistoryData;
  //OrderItems orderItems;

  CardOrderHistoryItems(this.orderHistoryData);

  @override
  State<StatefulWidget> createState() {
    print('@@orderHistoryData=============+$orderHistoryData');
    return CardOrderHistoryItems_(orderHistoryData);
  }
}

class CardOrderHistoryItems_ extends State<CardOrderHistoryItems> {
  OrderData cardOrderHistoryItems;
  String renderUrl;
  String status = "";
  OrderItems orderItems;

  CardOrderHistoryItems_(this.cardOrderHistoryItems);

  Widget get storeCard {
    return new Card(
      /*   child: new Column(
        children: <Widget>[

          new Align(
            child: new Text(
              " Order Number : " + cardOrderHistoryItems.orderId,
             // style: new TextStyle(fontSize: 40.0),
            ), //so big text
            alignment: FractionalOffset.topLeft,
          ),
         */ /* new Divider(
            color: Colors.blue,
          ),*/ /*
          new Align(
            child: new Text(" Order date : " +
                cardOrderHistoryItems.orderDate +
                '\n' +
                " Order total :" +
                cardOrderHistoryItems.total),
            alignment: FractionalOffset.topLeft,
          ),
         */ /* new Divider(
            color: Colors.blue,
          ),*/ /*
          new Align(

            child: new Text(" Status :"+cardOrderHistoryItems.status),

            alignment: FractionalOffset.topLeft,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              //add some actions, icons...etc
              new FlatButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrderView(cardOrderHistoryItems)),
                    );

                  },
                  child: new Text(
                    "View",
                    style: new TextStyle(color: Colors.redAccent),
                  )),
              new FlatButton(
                  onPressed: () {

                  },
                  child: new Text(
                    "Reorder",
                    style: new TextStyle(color: Colors.redAccent),
                  )),
              new FlatButton(onPressed: () {},
                  child: new Text("Cancel",
                    style: new TextStyle(color: Colors.redAccent),))
            ],
          ),
        ],
      ),*/
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text("Order Number : " + cardOrderHistoryItems.orderId),
            subtitle: Text("Order date : " +
                cardOrderHistoryItems.orderDate +
                '\n' +
                "Order total :" +
                cardOrderHistoryItems.total +
                '\n' +
                "Status :" +
                ""),
            contentPadding: EdgeInsets.all(5.0),
            /* onTap: () {
          Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => OrderView(cardOrderHistoryItems)),
                              );

        },*/
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              //add some actions, icons...etc
              new FlatButton(
                  onPressed: () {
                    /*if (orderItems != null &&
                        cardOrderHistoryItems.orderItems.isNotEmpty) {*/
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OrderView(cardOrderHistoryItems.orderItems)),
                      );
                   /* }
                    else {
                      Utils.showToast("Order Items is Empty", true);
                    }*/
                  },
                  child: new Text(
                    "View",
                    style: new TextStyle(color: Colors.redAccent),
                  )),
              new FlatButton(
                  onPressed: () {},
                  child: new Text(
                    "Reorder",
                    style: new TextStyle(color: Colors.redAccent),
                  )),
              new FlatButton(
                  onPressed: () {},
                  child: new Text(
                    "Cancel",
                    style: new TextStyle(color: Colors.redAccent),
                  ))
            ],
          ),
        ],
      ),

/*
      new ButtonTheme.bar(
          // make buttons use the appropriate styles for cards
          child: new ButtonBar(children: <Widget>[
        new FlatButton(
          child: const Text('View'),
          onPressed: () {
            print('@@View Order');
            */ /*Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ContactScreen()),
                              );*/ /*
          },
        ),
        new FlatButton(
          child: const Text('Reorder'),
          onPressed: () {
            print('@@Reorder Order');
          },
        ),
        new FlatButton(
          child: const Text('Cancel'),
          onPressed: () {
            print('@@Cancel Order');
          },
        ),
      ]))*/
      //])
    );
  }

  Widget _status(status) {
    if (cardOrderHistoryItems.status == 0) {
      return Text('Pending');
    } else if (cardOrderHistoryItems.status == 0) {
      return Text('Order');
    } else {
      return Text("Waiting");
    }
  }

  _orderStatus() {
    if (cardOrderHistoryItems.status == 0) {
      print('@@Condition__1');
      status = 'Pending';
    } else if (cardOrderHistoryItems.status == 1) {
      print('@@Condition__2');

      status = 'Approved';
    }
  }

  /* @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('@@initState');

    _orderStatus();
  }*/
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: storeCard,
    );
  }
}
