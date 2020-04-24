import 'package:flutter/material.dart';
import 'package:restroapp/src/UI/CardOrderHistoryItems.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/utils/Utils.dart';

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
      body: projectWidget(),
    );
  }

  Widget projectWidget() {
    return FutureBuilder(
      future: ApiController.getOrderHistory(),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container();
        } else {
          if (projectSnap.hasData) {
            GetOrderHistory response = projectSnap.data;

            if (response.success) {
              List<OrderData> orders = response.orders;
              if (orders.isEmpty) {
                return Utils.getEmptyView("No data found");
              } else {
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
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: orders.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 2.0, color: Colors.black),
                            itemBuilder: (context, index) {
                              OrderData orderHistoryData = orders[index];
                              return CardOrderHistoryItems(orderHistoryData);
                            },
                          )),
                    ],
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
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)),
            );
          }
        }
      },
    );
  }
}
