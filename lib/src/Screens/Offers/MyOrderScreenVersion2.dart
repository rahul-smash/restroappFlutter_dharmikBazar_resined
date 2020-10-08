import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/Offers/OrderDetailScreenVersion2.dart';
import 'package:restroapp/src/UI/CardOrderHistoryItems.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:flutter_pull_to_refresh/flutter_pull_to_refresh.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'OrderDetailScreen.dart';

class MyOrderScreenVersion2 extends StatefulWidget {
  StoreModel store;

  MyOrderScreenVersion2(this.store);

  @override
  _MyOrderScreenVersion2 createState() => new _MyOrderScreenVersion2();
}

class _MyOrderScreenVersion2 extends State<MyOrderScreenVersion2> {
  List<OrderData> ordersList = List();
  bool isLoading;

  double _rating = 1;

  @override
  void initState() {
    super.initState();
    getOrderListApi();
  }

  @override
  Widget build(BuildContext context) {
    eventBus.on<refreshOrderHistory>().listen((event) {
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
      body: PullToRefreshView(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ordersList == null
                ? SingleChildScrollView(
                    child: Center(child: Text("Something went wrong!")))
                : ordersList.isEmpty
                    ? Utils.getEmptyView2("No data found!")
                    : SafeArea(
                        child: ListView.separated(
                            itemCount: ordersList.length,
                            separatorBuilder: (context, index) => Container(
                                  height: 8,
                                  color: Color(0xFFDBDCDD),
                                ),
                            itemBuilder: (context, index) {
                              OrderData orderHistoryData = ordersList[index];
                              return listItem(context, orderHistoryData);
                            }),
                      ),
        onRefresh: () {
          print("calleddd");
          return getOrderListApi();
        },
      ),
    );
  }

  Widget listItem(BuildContext context, OrderData cardOrderHistoryItems) {
    bool showOrderType = true;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreenVersion2(cardOrderHistoryItems),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            firstRow(cardOrderHistoryItems, showOrderType),
            secondRow(cardOrderHistoryItems, showOrderType),
            thirdRow(cardOrderHistoryItems, showOrderType),
          ],
        ),
      ),
    );
  }

  firstRow(OrderData cardOrderHistoryItems, bool showOrderType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text('Order - ${cardOrderHistoryItems.displayOrderId}',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 18)),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(Utils.convertOrderDateTime(cardOrderHistoryItems.orderDate),
                style: TextStyle(
                  color: Color(0xFF818387),
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                )),
          ],
        )
      ],
    );
  }

  secondRow(OrderData cardOrderHistoryItems, bool showOrderType) {
    String itemText = cardOrderHistoryItems.orderItems.length > 1
        ? '${cardOrderHistoryItems.orderItems.length} Items '
        : '${cardOrderHistoryItems.orderItems.length} Item ';
    return Padding(
      padding: EdgeInsets.only(bottom: 0, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                  child: Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(
                    itemText,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  Visibility(
                    visible: showOrderType,
                    child: Container(
                        margin: EdgeInsets.only(left: 3),
                        padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Text('${cardOrderHistoryItems.orderFacility}',
                            style: TextStyle(
                                color: Color(0xFF39444D), fontSize: 13))),
                  ),
                  Visibility(
                    visible: cardOrderHistoryItems.paymentMethod != null &&
                        cardOrderHistoryItems.paymentMethod.trim().isNotEmpty,
                    child: Container(
                        margin: EdgeInsets.only(left: 6),
                        padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE6E6E6)),
                          color: Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Text(
                            '${cardOrderHistoryItems.paymentMethod.trim().toUpperCase()}',
                            style: TextStyle(
                                color: Color(0xFF39444D), fontSize: 13))),
                  ),
                ],
              )),
              Text("${AppConstant.currency} ${cardOrderHistoryItems.total}",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500))
            ],
          ),
        ],
      ),
    );
  }

  thirdRow(OrderData cardOrderHistoryItems, bool showOrderType) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(children: <Widget>[
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: getStatusColor(cardOrderHistoryItems.status)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(getStatus(cardOrderHistoryItems.status),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  )
                ]),
                Visibility(visible: false,child:  Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(children: <Widget>[
                    RatingBar(
                      initialRating: _rating,
                      minRating: 1,
                      itemSize: 26,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: orangeColor,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 6),
                        padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFE6E6E6)),
                          color: Color(0xFFE6E6E6),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        child: Text('${_rating}',
                            style: TextStyle(
                                color: Color(0xFF39444D), fontWeight: FontWeight.w500,fontSize: 13)))
                  ]),
                ),)
              ],
            ),
          ),
          Wrap(children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
              decoration: BoxDecoration(
                  color: Color(0xFFFD5401),
                  borderRadius: BorderRadius.circular(5)),
              child: Text(
                "View Order",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ])
        ],
      ),
    );
  }

// 0 => 'pending' ,  1 =>'processing', 2 =>'rejected',
  // 4 =>'shipped', 5 =>'delivered', 6 => 'cancel'
  String getStatus(status) {
    if (status == "0") {
      return 'Pending';
    } else if (status == "1") {
      return 'Processing';
    }
    if (status == "2") {
      return 'Rejected';
    }
    if (status == "4") {
      return 'Shipped';
    }
    if (status == "5") {
      return 'Delivered';
    }
    if (status == "6") {
      return 'Cancelled';
    } else {
      return "Waiting";
    }
  }

  bool showCancelButton(status) {
    bool showCancelButton;
    // 0 => 'pending' ,  1 =>'processing', 2 =>'rejected',
// 4 =>'shipped', 5 =>'delivered', 6 => 'cancel'
    //Remove cancel button on processing status
    if (/*status == "1" || status == "4" ||*/ status == "0") {
      showCancelButton = true;
    } else {
      showCancelButton = false;
    }
    return showCancelButton;
  }

  Color getOrderTypeColor(status) {
    if (status == "Pickup") {
      return orangeColor;
    } else {
      return Color(0xFFA0C057);
    }
  }

  Color getStatusColor(status) {
    // 0 => 'pending' ,  1 =>'processing', 2 =>'rejected',
    // 4 =>'shipped', 5 =>'delivered', 6 => 'cancel'
    // status 1, 4, 0     =>show cancel btn
    if (status == "0") {
      return Color(0xFFA1BF4C);
    } else {
      return status == "1" ? Color(0xFFA0C057) : Color(0xFFCF0000);
    }
  }

  Future<Null> getOrderListApi() {
    isLoading = true;
    return ApiController.getOrderHistory().then((respone) {
      setState(() {
        isLoading = false;
        ordersList = respone.orders;
        if (ordersList.isEmpty) {
          //Utils.showToast("No data found!", false);
        }
      });
    });
  }
}
