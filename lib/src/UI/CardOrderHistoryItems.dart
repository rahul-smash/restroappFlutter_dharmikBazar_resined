import 'package:flutter/material.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';

class CardOrderHistoryItems extends StatefulWidget {
  final OrderData orderHistoryData;
  CardOrderHistoryItems(this.orderHistoryData);

  @override
  State<StatefulWidget> createState() {
    return CardOrderHistoryState(orderHistoryData);
  }
}

class CardOrderHistoryState extends State<CardOrderHistoryItems> {
  OrderData cardOrderHistoryItems;
  String renderUrl;
  String status = "";
  OrderItems orderItems;

  CardOrderHistoryState(this.cardOrderHistoryItems);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Padding(padding: EdgeInsets.only(top: 20, left: 10, bottom: 20), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Order Number: " + cardOrderHistoryItems.orderId),
          Text("Order date: " +
              cardOrderHistoryItems.orderDate +
              '\n' +
              "Order total: " +
              cardOrderHistoryItems.total +
              '\n' +
              "Status : ${getStatus(cardOrderHistoryItems.status)}"),
        ],
      )),
    );
  }

  String getStatus(status) {
    if (cardOrderHistoryItems.status == "0") {
      return 'Pending';
    } else if (cardOrderHistoryItems.status == "1") {
      return 'Order';
    } else {
      return "Waiting";
    }
  }
}
