import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:restroapp/src/UI/ProgressBar.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/CancelOrderModel.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

class OrderDetailScreenVersion2 extends StatefulWidget {
  final OrderData orderHistoryData;

  OrderDetailScreenVersion2(this.orderHistoryData);

  @override
  _OrderDetailScreenVersion2State createState() =>
      _OrderDetailScreenVersion2State();
}

class _OrderDetailScreenVersion2State extends State<OrderDetailScreenVersion2> {
  var screenWidth;

  var mainContext;
  String deliverySlotDate = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deliverySlotDate = _generalizedDeliverySlotTime(widget.orderHistoryData);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    mainContext = context;
    String itemText = widget.orderHistoryData.orderItems.length > 1
        ? '${widget.orderHistoryData.orderItems.length} Items, '
        : '${widget.orderHistoryData.orderItems.length} Item, ';
    String orderFacility = widget.orderHistoryData.orderFacility != null
        ? '${widget.orderHistoryData.orderFacility}, '
        : '';
    return new Scaffold(
      backgroundColor: Color(0xffDCDCDC),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Order - ${widget.orderHistoryData.displayOrderId}',
              style: TextStyle(),
              textAlign: TextAlign.left,
            ),
            Text(
              '$orderFacility$itemText${AppConstant.currency} ${widget.orderHistoryData.total}',
              style: TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
        centerTitle: false,
        actions: <Widget>[
          Visibility(
            visible: showCancelButton(widget.orderHistoryData.status),
            child: InkWell(
                onTap: () async {
                  var results = await DialogUtils.displayDialog(context,
                      "Cancel Order?", AppConstant.cancelOrder, "Cancel", "OK");
                  if (results == true) {
                    Utils.showProgressDialog(context);
                    CancelOrderModel cancelOrder =
                        await ApiController.orderCancelApi(
                            widget.orderHistoryData.orderId);
                    if (cancelOrder != null && cancelOrder.success) {
                      setState(() {
                        widget.orderHistoryData.status = '6';
                      });
                    }
                    try {
                      Utils.showToast("${cancelOrder.data}", false);
                    } catch (e) {
                      print(e);
                    }
                    Utils.hideProgressDialog(context);
                    eventBus.fire(refreshOrderHistory());
                  }
                },
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.only(right: 16, left: 16),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      )),
                )),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xffDCDCDC),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                firstRow(widget.orderHistoryData),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 10),
                  width: Utils.getDeviceWidth(context),
                  height: 200,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget firstRow(OrderData orderHistoryData) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Delivery Address',
            style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7A7C80),
                fontWeight: FontWeight.w300),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Text(
                    _getAddress(orderHistoryData),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  width: 80,
                ),
                Container(
                    margin: EdgeInsets.only(left: 3),
                    padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffD7D7D7)),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Text('${orderHistoryData.orderFacility}',
                        style:
                            TextStyle(color: Color(0xFF968788), fontSize: 13))),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Text(
                    deliverySlotDate,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                Visibility(
                  visible: orderHistoryData.paymentMethod != null &&
                      orderHistoryData.paymentMethod.trim().isNotEmpty,
                  child: Container(
                      margin: EdgeInsets.only(left: 6),
                      padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE6E6E6)),
                        color: Color(0xFFE6E6E6),
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: Text(
                          '${orderHistoryData.paymentMethod.trim().toUpperCase()}',
                          style: TextStyle(
                              color: Color(0xFF39444D), fontSize: 13))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  secondRow(OrderItems item) {
    return Container();
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
                              "${AppConstant.currency} ${widget.orderHistoryData.checkout}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.orderHistoryData.discount == "0.00" &&
                              widget.orderHistoryData.shippingCharges == "0.00"
                          ? false
                          : true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: sheetDeviderLine(),
                      ),
                    ),
                    Visibility(
                      visible: widget.orderHistoryData.discount == "0.00"
                          ? false
                          : true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Discount : ',
                                style: TextStyle(
                                    color: Color(0xFF737879), fontSize: 18)),
                            Text(
                                "${AppConstant.currency} ${widget.orderHistoryData.discount}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.orderHistoryData.shippingCharges == "0.00"
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
                                "${AppConstant.currency} ${widget.orderHistoryData.shippingCharges}",
                                style: TextStyle(
                                    color: Color(0xFF749A00),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          widget.orderHistoryData.tax == "0.00" ? false : true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Tax: ',
                                style: TextStyle(
                                    color: Color(0xFF737879), fontSize: 18)),
                            Text(
                                "${AppConstant.currency} ${widget.orderHistoryData.tax}",
                                style: TextStyle(
                                    color: Color(0xFF749A00),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.orderHistoryData.cartSaving != null &&
                              widget.orderHistoryData.cartSaving.isNotEmpty
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
                                "${AppConstant.currency} ${widget.orderHistoryData.cartSaving}",
                                style: TextStyle(
                                    color: Color(0xFF749A00),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.orderHistoryData.couponCode != null &&
                              widget.orderHistoryData.couponCode.isNotEmpty
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
                            Text("${widget.orderHistoryData.couponCode}",
                                style: TextStyle(
                                    color: Color(0xFF749A00),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.orderHistoryData.orderFacility == "Pickup"
                          ? false
                          : true,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                        child: bottomDeviderView(),
                      ),
                    ),
                    Visibility(
                      visible: widget.orderHistoryData.orderFacility == "Pickup"
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
                      visible: widget.orderHistoryData.orderFacility == "Pickup"
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
                              " ${AppConstant.currency} ${widget.orderHistoryData.total}",
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
    if (widget.orderHistoryData.deliveryAddress != null &&
        widget.orderHistoryData.deliveryAddress.isNotEmpty)
      return '${widget.orderHistoryData.address} '
          '${widget.orderHistoryData.deliveryAddress.first.areaName} '
          '${widget.orderHistoryData.deliveryAddress.first.city} '
          '${widget.orderHistoryData.deliveryAddress.first.state}';
    else
      return widget.orderHistoryData.address;
  }

  String _getAddress(OrderData orderHistoryData) {
    String name = '${orderHistoryData.deliveryAddress.first.firstName}';
    String address = ', ${orderHistoryData.address}';
    String area = ', ${orderHistoryData.deliveryAddress.first.areaName}';
    String city = ', ${orderHistoryData.deliveryAddress.first.city}';
    String ZipCode = ', ${orderHistoryData.deliveryAddress.first.zipcode}';
    return '$name$address$area$city$ZipCode';
  }

  String _generalizedDeliverySlotTime(OrderData orderHistoryData) {
    if (orderHistoryData.deliveryTimeSlot != null &&
        orderHistoryData.deliveryTimeSlot.isNotEmpty) {
      int dateEndIndex = orderHistoryData.deliveryTimeSlot.indexOf(' ');
      String date =
          orderHistoryData.deliveryTimeSlot.substring(0, dateEndIndex);
      String convertedDate = convertOrderDateTime(date);
      String returnedDate =
          orderHistoryData.deliveryTimeSlot.replaceFirst(' ', ' | ');
      return returnedDate.replaceAll(date, convertedDate);
    } else {
      return '';
    }
  }

  String convertOrderDateTime(String date) {
    String formatted = date;
    try {
      DateFormat format = new DateFormat("yyyy-MM-dd");
      //UTC time true
      DateTime time = format.parse(date, true);
      time = time.toLocal();
      //print("time.toLocal()=   ${time.toLocal()}");
      DateFormat formatter = new DateFormat('dd MMM yyyy');
      formatted = formatter.format(time.toLocal());
    } catch (e) {
      print(e);
    }

    return formatted;
  }
}
