import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderData orderHistoryData;

  OrderDetailScreen(this.orderHistoryData);

  var screenWidth;
  var mainContext;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    mainContext = context;

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: new Text('My Orders'),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Padding(
              padding:
                  EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0, right: 10),
              child: Icon(
                Icons.home,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: projectWidget()),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 50,
          color: appTheme,
          child: InkWell(
            onTap: () {
              bottomSheet(mainContext);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, top: 4.0, bottom: 4),
                    child: Text(
                      "View Details",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(width: 6),
                  Image.asset(
                    "images/topArrow.png",
                    width: 15,
                    height: 15,
                  ),
                ]),
                Padding(
                  padding: EdgeInsets.only(
                    right: 10.0,
                  ),
                  child: Text(
                    " ${AppConstant.currency} ${orderHistoryData.total}",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  projectWidget() {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: orderHistoryData.orderItems.length,
      itemBuilder: (BuildContext ctx, int index) {
        final item = orderHistoryData.orderItems[index];
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              firstRow(item),
              Padding(
                padding: EdgeInsets.only(left: 12.0, top: 5.0, right: 10.0),
                child: Row(
                  children: <Widget>[
                    Text('QTY : ',
                        style:
                            TextStyle(color: Color(0xFF7D8185), fontSize: 17)),
                    Padding(
                      padding: EdgeInsets.only(left: 75.0),
                      child: Text("${item.quantity}",
                          style: TextStyle(
                              color: Color(0xFF15282F),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
              ),
              secondRow(item),
              deviderLine(),
            ],
          ),
        );
      },
    );
  }

  firstRow(OrderItems item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        LimitedBox(
          maxWidth: screenWidth - 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 12.0, top: 20.0, right: 10.0),
                child: Row(
                  children: <Widget>[
                    Text('Product Name : ',
                        style:
                            TextStyle(color: Color(0xFF7D8185), fontSize: 17)),
                    Flexible(
                      child: Text("${item.productName}",
                          style: TextStyle(
                              color: Color(0xFF15282F),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 12.0, top: 5.0, right: 10.0),
                child: Row(
                  children: <Widget>[
                    Text('Price : ',
                        style:
                            TextStyle(color: Color(0xFF7D8185), fontSize: 17)),
                    Padding(
                      padding: EdgeInsets.only(left: 70.0),
                      child: Text("${AppConstant.currency} ${item.price}",
                          style: TextStyle(
                              color: Color(0xFF15282F),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0, right: 12.0),
          child: SizedBox(
            width: 80,
            //height: 35,
            child: FlatButton(
              onPressed: () {},
              child: Padding(
                padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                child: Text(
                  item.weight,
                  style: TextStyle(
                    color: Color(0xFF15282F),
                    fontSize: 13,
                  ),
                ),
              ),
              color: item.weight.isEmpty ? whiteColor : Color(0xFFEAEEEF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0),
              ),
            ),
          ),
        )
      ],
    );
  }

  secondRow(OrderItems item) {
    return Visibility(
      visible: true,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10, top: 20),
        child: Visibility(
          visible: item.status == "2" ? true : false,
          child: Padding(
            padding: EdgeInsets.only(left: 12.0, top: 5.0, right: 10.0),
            child: Row(
              children: <Widget>[
                Text('Status : ',
                    style: TextStyle(color: Color(0xFF7D8185), fontSize: 17)),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: getStatusColor(item.status)),
                  ),
                ),
                Visibility(
                  visible: item.status == "2" ? true : false,
                  child: Padding(
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text(getStatus(item.status),
                        style: TextStyle(
                            color: Color(0xFF15282F),
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bottomSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Wrap(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth - 40, top: 5, bottom: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(mainContext);
                        },
                        child: Image.asset('images/close.png'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('Item Price : ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                          Text(
                              "${AppConstant.currency} ${orderHistoryData.checkout}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: orderHistoryData.discount == "0.00" &&
                              orderHistoryData.shippingCharges == "0.00"
                          ? false
                          : true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: sheetDeviderLine(),
                      ),
                    ),
                    Visibility(
                      visible:
                          orderHistoryData.discount == "0.00" ? false : true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Discount : ',
                                style: TextStyle(
                                    color: Color(0xFF737879), fontSize: 18)),
                            Text(
                                "${AppConstant.currency} ${orderHistoryData.discount}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: orderHistoryData.shippingCharges == "0.00"
                          ? false
                          : true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Delivery Fee: ',
                                style: TextStyle(
                                    color: Color(0xFF737879), fontSize: 18)),
                            Text(
                                "${AppConstant.currency} ${orderHistoryData.shippingCharges}",
                                style: TextStyle(
                                    color: Color(0xFF749A00),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: orderHistoryData.tax == "0.00" ? false : true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Tax: ',
                                style: TextStyle(
                                    color: Color(0xFF737879), fontSize: 18)),
                            Text(
                                "${AppConstant.currency} ${orderHistoryData.tax}",
                                style: TextStyle(
                                    color: Color(0xFF749A00),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: orderHistoryData.cartSaving != null &&
                              orderHistoryData.cartSaving.isNotEmpty
                          ? true
                          : false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Cart Discount: ',
                                style: TextStyle(
                                    color: Color(0xFF737879), fontSize: 18)),
                            Text(
                                "${AppConstant.currency} ${orderHistoryData.cartSaving}",
                                style: TextStyle(
                                    color: Color(0xFF749A00),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: orderHistoryData.couponCode != null &&
                              orderHistoryData.couponCode.isNotEmpty
                          ? true
                          : false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Coupon Code Appied: ',
                                style: TextStyle(
                                    color: Color(0xFF737879), fontSize: 18)),
                            Text(
                                "${orderHistoryData.couponCode}",
                                style: TextStyle(
                                    color: Color(0xFF749A00),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: orderHistoryData.orderFacility == "Pickup"
                          ? false
                          : true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: bottomDeviderView(),
                      ),
                    ),
                    Visibility(
                      visible: orderHistoryData.orderFacility == "Pickup"
                          ? false
                          : true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Text('Delivery Address',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ),
                    ),
                    Visibility(
                      visible: orderHistoryData.orderFacility == "Pickup"
                          ? false
                          : true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 20),
                        child: Text(getDeliveryAddress(),
                            style: TextStyle(
                                color: Color(0xFF737879), fontSize: 16)),
                      ),
                    ),
                    Container(
                      height: 50,
                      color: appTheme,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15.0, top: 4.0, bottom: 4),
                              child: Text(
                                "View Details",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(width: 6),
                            Image.asset(
                              "images/topArrow.png",
                              width: 15,
                              height: 15,
                            ),
                          ]),
                          Padding(
                            padding: EdgeInsets.only(
                              right: 10.0,
                            ),
                            child: Text(
                              " ${AppConstant.currency} ${orderHistoryData.total}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          );
        });
  }

  bottomDeviderView() {
    return Container(
      width: MediaQuery.of(mainContext).size.width,
      height: 10,
      color: Color(0xFFDBDCDD),
    );
  }

  deviderLine() {
    return Divider(
      color: Color(0xFFDBDCDD),
      height: 1,
      thickness: 1,
      indent: 12,
      endIndent: 12,
    );
  }

  sheetDeviderLine() {
    return Divider(
      color: Color(0xFFDBDCDD),
      height: 1,
      thickness: 1,
      indent: 0,
      endIndent: 0,
    );
  }

  String getStatus(status) {
    print("---${status}---");
    /*0 =pending ,
    1= active,
    2 = rejected = show view only for this else hide status.*/
    if (status == "0") {
      return 'Pending';
    } else if (status == "1") {
      return 'Active';
    }
    if (status == "2") {
      return 'Rejected';
    } else {}
  }

  Color getStatusColor(status) {
    return status == "0"
        ? Color(0xFFA1BF4C)
        : status == "1" ? Color(0xFFA0C057) : Color(0xFFCF0000);
  }

  String getDeliveryAddress() {
    if (orderHistoryData.deliveryAddress != null &&
        orderHistoryData.deliveryAddress.isNotEmpty)
      return '${orderHistoryData.address} '
          '${orderHistoryData.deliveryAddress.first.areaName} '
          '${orderHistoryData.deliveryAddress.first.city} '
          '${orderHistoryData.deliveryAddress.first.state}';
    else
      return orderHistoryData.address;
  }
}
