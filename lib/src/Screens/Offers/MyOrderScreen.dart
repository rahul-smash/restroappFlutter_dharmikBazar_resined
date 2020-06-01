import 'package:flutter/material.dart';
import 'package:restroapp/src/UI/CardOrderHistoryItems.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/Utils.dart';

class MyOrderScreen extends StatefulWidget {
  MyOrderScreen(BuildContext context);

  @override
  _MyOrderScreen createState() => new _MyOrderScreen();
}

class _MyOrderScreen extends State<MyOrderScreen> {

  List<OrderData> ordersList = List();
  bool isLoading ;

  @override
  void initState() {
    super.initState();
    getOrderListApi();
  }

  @override
  Widget build(BuildContext context) {

    eventBus.on<refreshOrderHistory>().listen((event) {
      //print("<---refreshOrderHistory------->");
      setState(() {
        getOrderListApi();
      });
    });

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: new Text('Order History'),
        centerTitle: true,
      ),
      //body: projectWidget(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ordersList == null
          ? SingleChildScrollView(child:Center(child: Text("Something went wrong!")))
          : ListView.builder(
          itemCount: ordersList.length,
          itemBuilder: (context, index) {
            OrderData orderHistoryData = ordersList[index];
            return CardOrderHistoryItems(orderHistoryData);
          }
      ),
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
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: orders.length,
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
              return Utils.getEmptyView2("No data found");
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

  void getOrderListApi() {
    isLoading = true;
    ApiController.getOrderHistory().then((respone){
      setState(() {
        isLoading = false;
        ordersList = respone.orders;
      });

    });
  }

}
