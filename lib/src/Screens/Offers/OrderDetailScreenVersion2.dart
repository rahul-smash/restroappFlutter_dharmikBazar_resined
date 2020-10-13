import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CancelOrderModel.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

class OrderDetailScreenVersion2 extends StatefulWidget {
  OrderData orderHistoryData;

  OrderDetailScreenVersion2(this.orderHistoryData);

  @override
  _OrderDetailScreenVersion2State createState() =>
      _OrderDetailScreenVersion2State();
}

class _OrderDetailScreenVersion2State extends State<OrderDetailScreenVersion2> {
  var screenWidth;

  var mainContext;
  String deliverySlotDate = '';

  String _totalCartSaving = '0', _totalPrice = '0';
  File _image;
  PersistentBottomSheetController _controller; // <------ Instance variable
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;

  String userId = ''; // <---- Another instance variable

  @override
  void initState() {
    super.initState();
    getOrderListApi();
  }

  Future<Null> getOrderListApi({bool isLoading = true}) async {
    this.isLoading = isLoading;
    UserModel user = await SharedPrefs.getUser();
    userId = user.id;

    return ApiController.getOrderDetail(widget.orderHistoryData.orderId)
        .then((respone) {
      setState(() {
        if (respone != null &&
            respone.success &&
            respone.orders != null &&
            respone.orders.isNotEmpty) {
          widget.orderHistoryData = respone.orders.first;
          deliverySlotDate =
              _generalizedDeliverySlotTime(widget.orderHistoryData);
          calculateSaving();
        }
        if (!isLoading) {
          Utils.hideProgressDialog(context);
        }
        setState(() {
          isLoading = false;
          this.isLoading = isLoading;
        });
      });
    });
  }

  calculateSaving() {
    try {
      double _cartSaving = widget.orderHistoryData.cartSaving != null
          ? double.parse(widget.orderHistoryData.cartSaving)
          : 0;
      double _couponDiscount = widget.orderHistoryData.discount != null
          ? double.parse(widget.orderHistoryData.discount)
          : 0;
      double _totalSaving = _cartSaving + _couponDiscount;
      _totalCartSaving =
          _totalSaving != 0 ? _totalSaving.toStringAsFixed(2) : '0';
      double _totalPriceVar =
          double.parse(widget.orderHistoryData.total) + _totalSaving;

      _totalPrice = _totalPriceVar.toString();
    } catch (e) {
      double _totalPriceVar = double.parse(widget.orderHistoryData.total);

      _totalPrice = _totalPriceVar.toString();
      print(e.toString());
    }
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
    return isLoading
        ? Scaffold(
            appBar: AppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Order Details',
                    style: TextStyle(),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              centerTitle: false,
            ),
            body: Center(child: CircularProgressIndicator()),
          )
        : new Scaffold(
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
                        var results = await DialogUtils.displayDialog(
                            context,
                            "Cancel Order?",
                            AppConstant.cancelOrder,
                            "Cancel",
                            "OK");
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
//                          Utils.hideProgressDialog(context);
                          eventBus.fire(refreshOrderHistory());
                          getOrderListApi(isLoading: false);
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
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.all(16),
                        width: Utils.getDeviceWidth(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Track Order',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _getTrackWidget(),
                            SizedBox(
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                      secondRow(widget.orderHistoryData)
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

  secondRow(OrderData orderHistoryData) {
    String itemText = orderHistoryData.orderItems.length > 1
        ? '${orderHistoryData.orderItems.length} Items '
        : '${orderHistoryData.orderItems.length} Item ';
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            itemText,
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
          SizedBox(
            height: 16,
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orderHistoryData.orderItems.length,
              itemBuilder: (context, index) {
                return listItem(context, orderHistoryData, index);
              }),
          Container(
            height: 3,
            color: Color(0xFFE1E1E1),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 0, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 0, bottom: 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Text('Total',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                              Text("${AppConstant.currency} ${_totalPrice}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500))
                            ],
                          )),
                      Visibility(
                          visible: orderHistoryData.cartSaving != null &&
                              (orderHistoryData.cartSaving != '0.00'),
                          child: Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Text('MRP Discount',
                                        style: TextStyle(
                                          color: Color(0xff74BA33),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  Text(
                                      "${AppConstant.currency} ${orderHistoryData.cartSaving != null ? orderHistoryData.cartSaving : '0.00'}",
                                      style: TextStyle(
                                          color: Color(0xff74BA33),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500))
                                ],
                              ))),
                      Visibility(
                          visible: orderHistoryData.discount != '0.00',
                          child: Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Text('Coupon Discount',
                                        style: TextStyle(
                                          color: Color(0xff74BA33),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  Text(
                                      "${AppConstant.currency} ${orderHistoryData.discount != null ? orderHistoryData.discount : '0.00'}",
                                      style: TextStyle(
                                          color: Color(0xff74BA33),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500))
                                ],
                              ))),
                      Visibility(
                          visible: orderHistoryData.shippingCharges == "0.00"
                              ? false
                              : true,
                          child: Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Text('Delivery Chargers',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  Text(
                                      "${AppConstant.currency} ${orderHistoryData.shippingCharges}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500))
                                ],
                              ))),
                      Visibility(
                          visible:
                              orderHistoryData.tax == "0.00" ? false : true,
                          child: Padding(
                              padding: EdgeInsets.only(top: 16, bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Flexible(
                                    child: Text('Tax',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  Text(
                                      "${AppConstant.currency} ${orderHistoryData.tax}",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500))
                                ],
                              ))),
                      Container(
                        margin: EdgeInsets.only(top: 16, bottom: 16),
                        color: Color(0xFFE1E1E1),
                        height: 1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                            child: Text('Payable Amount',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                )),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                  "${AppConstant.currency} ${orderHistoryData.total}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500)),
                              Visibility(
                                visible:
                                    !(_totalCartSaving.compareTo('0') == 0),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: Text(
                                      "Cart Saving ${AppConstant.currency} ${_totalCartSaving}",
                                      style: TextStyle(
                                          color: Color(0xff74BA33),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listItem(
      BuildContext context, OrderData cardOrderHistoryItems, int index) {
    double findRating = _findRating(cardOrderHistoryItems, index);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Text(
                    '${cardOrderHistoryItems.orderItems[index].productName}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16)),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 3),
                      padding: EdgeInsets.fromLTRB(8, 1, 8, 1),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFFE6E6E6)),
                        color: Color(0xFFE6E6E6),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Text(
                          '${cardOrderHistoryItems.orderItems[index].quantity}',
                          style: TextStyle(color: Colors.black, fontSize: 12))),
                  Text('X ${cardOrderHistoryItems.orderItems[index].price}',
                      style: TextStyle(
                        color: Color(0xFF818387),
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      )),
                ],
              ),
            ],
          ),
          Padding(
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
                      child: Text(
                          'Weight: ${cardOrderHistoryItems.orderItems[index].weight}',
                          style: TextStyle(
                            color: Color(0xFF818387),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          )),
                    ),
                    Text(
                        "${AppConstant.currency} ${int.parse(cardOrderHistoryItems.orderItems[index].quantity) * double.parse(cardOrderHistoryItems.orderItems[index].price)}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: true,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: InkWell(
                            child: RatingBar(
                              initialRating: findRating,
                              minRating: 0,
                              itemSize: 26,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 2.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: orangeColor,
                              ),
                              ignoreGestures: true,
                              onRatingUpdate: (rating) {},
                            ),
                            onTap: () {
                              if (findRating == 0)
                                bottomSheet(
                                    context, cardOrderHistoryItems, index);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Visibility(
            visible: index != cardOrderHistoryItems.orderItems.length - 1,
            child: Container(
              color: Color(0xFFE1E1E1),
              height: 1,
            ),
          )
        ],
      ),
    );
  }

  bottomSheet(context, OrderData cardOrderHistoryItems, int index) async {
    double _rating = 0;
    _image = null;
    final commentController = TextEditingController();
    _controller = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Container(
                  child: Wrap(children: <Widget>[
                    Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                              child: Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Text(
                            "Rating",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          "(Select a start amount)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          color: orangeColor,
                          width: 50,
                          height: 3,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            "Product Name",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff797C82),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "${cardOrderHistoryItems.orderItems[index].productName}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RatingBar(
                          initialRating: _rating,
                          minRating: 0,
                          itemSize: 35,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: orangeColor,
                          ),
                          onRatingUpdate: (rating) {
                            _rating = rating;
                          },
                        ),
                        Container(
                          height: 120,
                          margin: EdgeInsets.fromLTRB(20, 15, 20, 20),
                          decoration: new BoxDecoration(
                            color: grayLightColor,
                            borderRadius:
                                new BorderRadius.all(new Radius.circular(3.0)),
//                          border: new Border.all(
//                            color: Colors.grey,
//                            width: 1.0,
//                          ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: TextField(
                              textAlign: TextAlign.left,
                              maxLength: 250,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              textCapitalization: TextCapitalization.sentences,
                              controller: commentController,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10.0),
                                  border: InputBorder.none,
                                  fillColor: grayLightColor,
                                  hintText: 'Write your Review...'),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 0, bottom: 16, left: 16, right: 16),
                          color: Color(0xFFE1E1E1),
                          height: 1,
                        ),
                        Container(
                          width: double.maxFinite,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                  onTap: () {
                                    showAlertDialog(context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 0, bottom: 6, left: 16, right: 16),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "images/placeHolder.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    height: 100,
                                    width: 120,
                                    child: _image != null
                                        ? Image.file(
                                            _image,
                                            fit: BoxFit.scaleDown,
                                          )
                                        : null,
                                  )),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 0, left: 18, bottom: 30),
                                child: Text(
                                  "File Size limit - 1MB",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                width: 130,
                                child: FlatButton(
                                  child: Text('Submit'),
                                  color: orangeColor,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    if (_rating == 0) {
                                      Utils.showToast(
                                          'Please give some rating .', true);
                                      return;
                                    }
                                    Utils.hideKeyboard(context);
                                    Navigator.pop(context);
                                    postRating(
                                        cardOrderHistoryItems, index, _rating,
                                        desc: commentController.text.trim(),imageFile:_image);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                )),
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

  Widget _getTrackWidget() {
    // 0 => 'pending' ,  1 =>'processing', 2 =>'rejected',
    // 4 =>'shipped', 5 =>'delivered', 6 => 'cancel'

    switch (widget.orderHistoryData.status) {
      case '0':
        return Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 25,
                  margin: EdgeInsets.only(left: 4, top: 5),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Placed',
                      style: TextStyle(fontSize: 16),
                    )),
                    Text(
                        '${Utils.convertOrderDate(widget.orderHistoryData.orderDate)}')
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 30,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 0,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: grayLightColorSecondary),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Confirmed',
                      style: TextStyle(
                          fontSize: 16, color: grayLightColorSecondary),
                    )),
                    Text(
                      'Pending',
                      style: TextStyle(
                          color: grayLightColorSecondary, fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 30,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 0,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: grayLightColorSecondary),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Shipped',
                      style: TextStyle(
                          fontSize: 16, color: grayLightColorSecondary),
                    )),
                    Text(
                      'Pending',
                      style: TextStyle(
                          color: grayLightColorSecondary, fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 15,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 0,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: grayLightColorSecondary),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Delivered',
                      style: TextStyle(
                          fontSize: 16, color: grayLightColorSecondary),
                    )),
                    Text(
                      'Pending',
                      style: TextStyle(
                          color: grayLightColorSecondary, fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ],
        );
        break;
      case '1':
        return Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 25,
                  margin: EdgeInsets.only(left: 4, top: 5),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Placed',
                      style: TextStyle(fontSize: 16),
                    )),
                    Text(
                        '${Utils.convertOrderDate(widget.orderHistoryData.orderDate)}')
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 30,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Confirmed',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
                    Text(
                      'Done',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 30,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 0,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: grayLightColorSecondary),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Shipped',
                      style: TextStyle(
                          fontSize: 16, color: grayLightColorSecondary),
                    )),
                    Text(
                      'Pending',
                      style: TextStyle(
                          color: grayLightColorSecondary, fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 15,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 0,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: grayLightColorSecondary),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Delivered',
                      style: TextStyle(
                          fontSize: 16, color: grayLightColorSecondary),
                    )),
                    Text(
                      'Pending',
                      style: TextStyle(
                          color: grayLightColorSecondary, fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ],
        );
        break;
      case '2':
        return Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 25,
                  margin: EdgeInsets.only(left: 4, top: 5),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Placed',
                      style: TextStyle(fontSize: 16),
                    )),
                    Text(
                        '${Utils.convertOrderDate(widget.orderHistoryData.orderDate)}')
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 15,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: Colors.red),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Rejected',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )),
                  ],
                )
              ],
            ),
          ],
        );
        break;
      case '4':
      case '7':
        return Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 25,
                  margin: EdgeInsets.only(left: 4, top: 5),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Placed',
                      style: TextStyle(fontSize: 16),
                    )),
                    Text(
                        '${Utils.convertOrderDate(widget.orderHistoryData.orderDate)}')
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 30,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Confirmed',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
                    Text(
                      'Done',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 30,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Shipped',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
                    Text(
                      'Done',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 15,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 0,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: grayLightColorSecondary),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Delivered',
                      style: TextStyle(
                          fontSize: 16, color: grayLightColorSecondary),
                    )),
                    Text(
                      'Pending',
                      style: TextStyle(
                          color: grayLightColorSecondary, fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ],
        );
        break;
      case '5':
        return Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 25,
                  margin: EdgeInsets.only(left: 4, top: 5),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Placed',
                      style: TextStyle(fontSize: 16),
                    )),
                    Text(
                        '${Utils.convertOrderDate(widget.orderHistoryData.orderDate)}')
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 30,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Confirmed',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
                    Text(
                      'Done',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 30,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Shipped',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    )),
                    Text(
                      'Done',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 15,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Delivered',
                      style: TextStyle(fontSize: 16),
                    )),
                    Text(
                      'Done',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                )
              ],
            ),
          ],
        );
        break;
      case '6':
        return Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 25,
                  margin: EdgeInsets.only(left: 4, top: 5),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(appTheme),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: appTheme),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Placed',
                      style: TextStyle(fontSize: 16),
                    )),
                    Text(
                        '${Utils.convertOrderDate(widget.orderHistoryData.orderDate)}')
                  ],
                )
              ],
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: 15,
                  margin: EdgeInsets.only(
                    left: 4,
                  ),
                  width: 2,
                  child: LinearProgressIndicator(
                    backgroundColor: grayLightColorSecondary,
                    value: 100,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10 / 2),
                          color: Colors.red),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text(
                      'Order Cancelled',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )),
                  ],
                )
              ],
            ),
          ],
        );
        break;
    }

    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              height: 25,
              margin: EdgeInsets.only(left: 4, top: 5),
              width: 2,
              child: LinearProgressIndicator(
                backgroundColor: grayLightColorSecondary,
                value: 100,
                valueColor: AlwaysStoppedAnimation<Color>(appTheme),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10 / 2),
                      color: appTheme),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text(
                  'Order Placed',
                  style: TextStyle(fontSize: 16),
                )),
                Text(
                    '${Utils.convertOrderDate(widget.orderHistoryData.orderDate)}')
              ],
            )
          ],
        ),
        Stack(
          children: <Widget>[
            Container(
              height: 30,
              margin: EdgeInsets.only(
                left: 4,
              ),
              width: 2,
              child: LinearProgressIndicator(
                backgroundColor: grayLightColorSecondary,
                value: 0,
                valueColor: AlwaysStoppedAnimation<Color>(appTheme),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10 / 2),
                      color: grayLightColorSecondary),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text(
                  'Order Confirmed',
                  style:
                      TextStyle(fontSize: 16, color: grayLightColorSecondary),
                )),
                Text(
                  'Pending',
                  style:
                      TextStyle(color: grayLightColorSecondary, fontSize: 16),
                )
              ],
            )
          ],
        ),
        Stack(
          children: <Widget>[
            Container(
              height: 30,
              margin: EdgeInsets.only(
                left: 4,
              ),
              width: 2,
              child: LinearProgressIndicator(
                backgroundColor: grayLightColorSecondary,
                value: 0,
                valueColor: AlwaysStoppedAnimation<Color>(appTheme),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10 / 2),
                      color: grayLightColorSecondary),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text(
                  'Order Shipped',
                  style:
                      TextStyle(fontSize: 16, color: grayLightColorSecondary),
                )),
                Text(
                  'Pending',
                  style:
                      TextStyle(color: grayLightColorSecondary, fontSize: 16),
                )
              ],
            )
          ],
        ),
        Stack(
          children: <Widget>[
            Container(
              height: 15,
              margin: EdgeInsets.only(
                left: 4,
              ),
              width: 2,
              child: LinearProgressIndicator(
                backgroundColor: grayLightColorSecondary,
                value: 0,
                valueColor: AlwaysStoppedAnimation<Color>(appTheme),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10 / 2),
                      color: grayLightColorSecondary),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Text(
                  'Order Delivered',
                  style:
                      TextStyle(fontSize: 16, color: grayLightColorSecondary),
                )),
                Text(
                  'Pending',
                  style:
                      TextStyle(color: grayLightColorSecondary, fontSize: 16),
                )
              ],
            )
          ],
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context) {
    SimpleDialog dialog = SimpleDialog(
      title: const Text('Choose option'),
      children: <Widget>[
        SimpleDialogOption(
          child: Text(
            'Camera',
            style: TextStyle(fontSize: 16.0),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            var image =
                await ImagePicker().getImage(source: ImageSource.camera);
            _controller.setState(() {
              if (image == null) {
                print("---image == null----");
              } else {
                _image = File(image.path);
              }
            });
            setState(() {});
          },
        ),
        SimpleDialogOption(
          child: Text(
            'Gallery',
            style: TextStyle(fontSize: 16.0),
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            var image =
                await ImagePicker().getImage(source: ImageSource.gallery);
            _controller.setState(() {
              if (image == null) {
                print("---image == null----");
              } else {
                print("---image.length----${image.path}");
                _image = File(image.path);
              }
            });
          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  double _findRating(OrderData cardOrderHistoryItems, int index) {
    double foundRating = 0;
    List<Review> reviewList = cardOrderHistoryItems.orderItems[index].review;

    if (reviewList != null && reviewList.isNotEmpty) {
      for (int i = 0; i < reviewList.length; i++) {
        if (userId.compareTo(reviewList[i].userId) == 0) {
          foundRating = double.parse(reviewList[i].rating);
        }
      }
    }
    return foundRating;
  }

  void postRating(OrderData cardOrderHistoryItems, int index, double _rating,
      {String desc = "",File imageFile}) {
    Utils.showProgressDialog(context);
    ApiController.postProductRating(
            cardOrderHistoryItems.orderId,
            cardOrderHistoryItems.orderItems[index].productId,
            _rating.toString(),
            desc: desc,imageFile: imageFile)
        .then((value) {
      if (value != null && value.success) {
        //Hit event Bus
        eventBus.fire(refreshOrderHistory());
        getOrderListApi(isLoading: false);
      }
    });
  }
}
