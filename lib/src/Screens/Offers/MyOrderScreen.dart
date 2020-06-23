import 'package:flutter/material.dart';
import 'package:restroapp/src/UI/CardOrderHistoryItems.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:flutter_pull_to_refresh/flutter_pull_to_refresh.dart';

class MyOrderScreen extends StatefulWidget {

  StoreModel store;
  MyOrderScreen(this.store);

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
        title: new Text('My Orders'),
        centerTitle: true,
      ),
      //body: projectWidget(),
      body: PullToRefreshView(
        child:  isLoading ? Center(child: CircularProgressIndicator())
            : ordersList == null
            ? SingleChildScrollView(child:Center(child: Text("Something went wrong!")))
            : ordersList.isEmpty ? Utils.getEmptyView2("No data found!")
            :SafeArea(
          child: ListView.builder(
              itemCount: ordersList.length,
              itemBuilder: (context, index) {
                //print("<---refreshOrderHistory------->");
                OrderData orderHistoryData = ordersList[index];
                return  CardOrderHistoryItems(orderHistoryData,widget.store);
              }
          ),
        ),
        onRefresh:  ()  {
          print("calleddd");
         return getOrderListApi();
        },
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
                        offset: Offset(0.0, 10.0),
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
                              return CardOrderHistoryItems(orderHistoryData,widget.store);

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

  Future<Null> getOrderListApi() {
    isLoading = true;
    return ApiController.getOrderHistory().then((respone){
      setState(() {
        isLoading = false;
        ordersList = respone.orders;
        if(ordersList.isEmpty){
          //Utils.showToast("No data found!", false);
        }
      });
    });
  }

}
