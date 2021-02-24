import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/DeliveryTimeSlotModel.dart';
import 'package:restroapp/src/models/GetOrderHistory.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubscriptionDataResponse.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/Utils.dart';

class SubscriptionHistoryDetails extends StatefulWidget {
  SubscriptionOrderData orderHistoryData;
  bool isRatingEnable=false;

  DeliveryTimeSlotModel deliverySlotModel;
  int selctedTag, selectedTimeSlot;
  List<Timeslot> timeslotList;

  //Store provides instant delivery of the orders.
  bool isInstantDelivery = false;
  bool isDeliveryResponseFalse = false;
  bool isSlotSelected = false;
  String initSelectedTimeSlotString = '';
  StoreModel store;
  String orderHistoryDataId = '';

  SubscriptionHistoryDetails(
      {this.orderHistoryData,
      this.isRatingEnable=false,
      this.deliverySlotModel,
      this.selctedTag,
      this.selectedTimeSlot,
      this.timeslotList,
      this.isInstantDelivery,
      this.isDeliveryResponseFalse,
      this.isSlotSelected,
      this.initSelectedTimeSlotString,
      this.store,
      this.orderHistoryDataId});

  @override
  _SubscriptionHistoryDetailsState createState() =>
      _SubscriptionHistoryDetailsState();
}

class _SubscriptionHistoryDetailsState
    extends State<SubscriptionHistoryDetails> {
  var screenWidth;

  var mainContext;
  String deliverySlotDate = '';

  String _totalCartSaving = '0', _totalPrice = '0';
  File _image;

  bool isLoading = true;

  String userId = ''; // <---- Another instance variable

  DeliveryTimeSlotModel deliverySlotModel;
  int selctedTag, selectedTimeSlot;
  List<Timeslot> timeslotList;

  //Store provides instant delivery of the orders.
  bool isInstantDelivery = false;
  bool isDeliveryResponseFalse = false;
  bool isSlotSelected = false;
  String initSelectedTimeSlotString = '';
  EventList<Event> _markedDateMap;

  @override
  void initState() {
    super.initState();
    _markedDateMap = new EventList<Event>(
      events: {},
    );
    getOrderListApi();
  }

  Future<Null> getOrderListApi({bool isLoading = true}) async {
    this.isLoading = isLoading;
    UserModel user = await SharedPrefs.getUser();
    userId = user.id;

    return ApiController.getSubscriptionDetailHistory(
            widget.orderHistoryData != null
                ? widget.orderHistoryData.subscriptionOrderId
                : widget.orderHistoryDataId)
        .then((respone) {
      if (respone != null &&
          respone.success &&
          respone.data != null &&
          respone.data.isNotEmpty) {
        widget.orderHistoryData = respone.data.first;

      }

      if (deliverySlotModel != null) {
        Utils.hideProgressDialog(context);
        deliverySlotModel = widget.deliverySlotModel;
        selctedTag = widget.selctedTag;
        selectedTimeSlot = widget.selectedTimeSlot;
        timeslotList = widget.timeslotList;
        isInstantDelivery = widget.isInstantDelivery;
        isDeliveryResponseFalse = widget.isDeliveryResponseFalse;
        isSlotSelected = widget.isSlotSelected;
        initSelectedTimeSlotString = widget.initSelectedTimeSlotString;

        deliverySlotDate =
            _generalizedDeliverySlotTime(widget.orderHistoryData);
        calculateSaving();
        //events add
        addEvents();

        if (!isLoading) {
          Utils.hideProgressDialog(context);
        }
        isLoading = false;
        this.isLoading = isLoading;
        if (mounted) {
          setState(() {});
        }

      } else {
        ApiController.deliveryTimeSlotApi().then((response) {
          Utils.hideProgressDialog(context);
          setState(() {
            if (!response.success) {
              isDeliveryResponseFalse = true;
              return;
            }
            deliverySlotModel = response;
            print(
                "deliverySlotModel.data.is24X7Open =${deliverySlotModel.data.is24X7Open}");
            isInstantDelivery = deliverySlotModel.data.is24X7Open == "1";
            for (int i = 0;
                i < deliverySlotModel.data.dateTimeCollection.length;
                i++) {
              timeslotList =
                  deliverySlotModel.data.dateTimeCollection[i].timeslot;
              for (int j = 0; j < timeslotList.length; j++) {
                Timeslot timeslot = timeslotList[j];
                if (timeslot.isEnable) {
                  selectedTimeSlot = j;
                  isSlotSelected = true;
                  break;
                }
              }
              if (isSlotSelected) {
                selctedTag = i;
                break;
              }
            }
            if (selectedTimeSlot != null && selctedTag != null) {
              initSelectedTimeSlotString = deliverySlotModel
                  .data
                  .dateTimeCollection[selctedTag]
                  .timeslot[selectedTimeSlot]
                  .label;
            }
            deliverySlotDate =
                _generalizedDeliverySlotTime(widget.orderHistoryData);
            calculateSaving();
            //events add
            addEvents();
            if (!isLoading) {
              Utils.hideProgressDialog(context);
            }
            isLoading = false;
            this.isLoading = isLoading;
            if (mounted) {
              setState(() {});
            }
          });
        });
      }
    });
  }

  Future<Null> updateSubscriptionStatus(
      String subscriptionOrderId, String status) {
    Utils.showProgressDialog(context);
    return ApiController.subscriptionStatusUpdate(subscriptionOrderId, status)
        .then((respone) {
      Utils.hideProgressDialog(context);
      if (respone != null && respone.success) {
        if (mounted)
          setState(() {
            getOrderListApi(isLoading: false);
          });
      }
    });
  }

  Future<Null> updateSubscriptionOrderDeliverySlots(
      String subscriptionOrderId, String deliverySlot) {
    Utils.showProgressDialog(context);
    return ApiController.subscriptionOrderUpdate(
            subscriptionOrderId, deliverySlot)
        .then((respone) {
      if (respone != null && respone.success) {
        if (mounted)
          setState(() {
            getOrderListApi(isLoading: false);
          });
      }
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
      if (_totalSaving != 0)
        _totalPrice = _totalPriceVar.toStringAsFixed(2);
      else {
        _totalPrice = widget.orderHistoryData.total;
      }
    } catch (e) {
      _totalPrice = widget.orderHistoryData.total;
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> choices = List();
    if(widget.orderHistoryData!=null){
      screenWidth = MediaQuery.of(context).size.width;
      mainContext = context;
      switch (widget.orderHistoryData.status) {
        case '0':
        case '2':
        case '5':
        case '6':
        case '10':
          break;
        case '1':
          choices.add('Order Stop');
          choices.add('Pause');
        if(!widget.orderHistoryData.orderFacility.toLowerCase().contains('pick'))
          choices.add('Change Delivery Slots');
          break;
        case '9':
          choices.add('Order Stop');
          choices.add('Active');
          if(!widget.orderHistoryData.orderFacility.toLowerCase().contains('pick'))
            choices.add('Change Delivery Slots');
          break;
      }
    }
    return isLoading
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Text(
                'Detail',
                style: TextStyle(),
                textAlign: TextAlign.left,
              ),
              centerTitle: true,
            ),
            body: Center(child: CircularProgressIndicator()),
          )
        : new Scaffold(
            backgroundColor: Color(0xffDCDCDC),
            appBar: AppBar(
              title: Text(
                'Detail',
                style: TextStyle(),
                textAlign: TextAlign.left,
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  color: Color(0xffDCDCDC),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        width: Utils.getDeviceWidth(context),
                        padding: EdgeInsets.only(left: 16, right: 6, top: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Text(
                                    "#${widget.orderHistoryData.displaySubscriptionId} (${widget.orderHistoryData.orderItems.length} ${widget.orderHistoryData.orderItems.length > 1 ? 'Items' : 'Item'})",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Container(
                                color: Colors.white,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_outline,
                                      size: 16,
                                      color: _getSubscriptionStatusColor(
                                          widget.orderHistoryData),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Order ${_getSubscriptionStatus(widget.orderHistoryData)}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _getSubscriptionStatusColor(
                                            widget.orderHistoryData),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    choices.length > 0
                                        ? PopupMenuButton(
                                            padding: EdgeInsets.zero,
                                            child: Icon(
                                              Icons.more_vert,
                                            ),
                                            elevation: 0,
                                            onSelected: (choice) {
                                              if (choice ==
                                                  'Change Delivery Slots') {
                                                deliverySlotBottomSheet(
                                                    context,
                                                    widget.orderHistoryData,
                                                    true);
                                                return;
                                              }

                                              String status = '1';
                                              switch (choice) {
                                                case 'Order Stop':
                                                  status = '6';
                                                  break;
                                                case 'Pause':
                                                  status = '9';
                                                  break;
                                                case 'Active':
                                                  status = '1';
                                                  break;
                                              }
                                              //hit api
//                                              Utils.showProgressDialog(context);
                                              updateSubscriptionStatus(
                                                  widget.orderHistoryData
                                                      .subscriptionOrderId,
                                                  status);
                                            },
                                            onCanceled: () {
                                              print(
                                                  'You have not chossed anything');
                                            },
                                            itemBuilder:
                                                (BuildContext context) {
                                              return choices
                                                  .map((String choice) {
                                                return PopupMenuItem(
                                                  value: choice,
                                                  child: Text(choice),
                                                );
                                              }).toList();
                                            },
                                          )
                                        : Container()
                                  ],
                                ),
                              )
                            ]),
                      ),
                      Container(
//                        color: Color(0xFFDBDCDD),
                        color: Colors.white,
                        child: Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 10),
                          height: 1,
                          color: Color(0xffEBECED),
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Amount',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 6),
                                            child: Text(
                                              '${AppConstant.currency}${widget.orderHistoryData.total}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: appTheme,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Visibility(
                                            visible: widget.orderHistoryData
                                                        .paymentMethod !=
                                                    null &&
                                                widget.orderHistoryData
                                                    .paymentMethod
                                                    .trim()
                                                    .isNotEmpty,
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 6),
                                                padding: EdgeInsets.fromLTRB(
                                                    8, 3, 8, 3),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Color(0xFFE6E6E6)),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              15.0)),
                                                ),
                                                child: Text(
                                                    '${widget.orderHistoryData.paymentMethod.trim().toUpperCase()}',
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF39444D),
                                                        fontSize: 10))),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: false,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Paid Amount',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      Text(
                                        '${AppConstant.currency}${widget.orderHistoryData.total}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: appTheme,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.only(left: 3),
                                    padding: EdgeInsets.fromLTRB(8, 3, 8, 3),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xffD7D7D7)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    child: Text(
                                        '${widget.orderHistoryData.orderFacility}',
                                        style: TextStyle(
                                            color: Color(0xFF968788),
                                            fontSize: 13))),
                              ],
                            ),
                            Visibility(
                              visible: false,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Pending Amount',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Pay Pending Amount',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.green,
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${AppConstant.currency}${widget.orderHistoryData.total}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: appTheme,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
//                        color: Color(0xFFDBDCDD),
                        color: Colors.white,
                        child: Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 0),
                          height: 1,
                          color: Color(0xffEBECED),
                        ),
                      ),
                      firstRow(widget.orderHistoryData),
                      Container(
                        color: Colors.white,
                        child: Center(child: Text(!widget.orderHistoryData.orderFacility.toLowerCase().contains('pick')?"Deliveries Dates":"Subscribed Dates")),
                      ),
                      Container(
                        color: Colors.white,
                        child: CalendarCarousel<Event>(
                          childAspectRatio: 1.5,
                          height: 330,
                          markedDatesMap: _markedDateMap,
                          headerMargin: EdgeInsets.all(0),
                          customGridViewPhysics: NeverScrollableScrollPhysics(),
                          isScrollable: true,
                          weekendTextStyle: TextStyle(
                            color: Colors.black,
                          ),
                          todayButtonColor: Colors.white,
                          todayTextStyle: TextStyle(
                            color: Colors.black,
                          ),
                          markedDateShowIcon: false,
                          shouldShowTransform: false,
                          weekdayTextStyle: TextStyle(
                            color: Colors.black,
                          ),
                          markedDateIconMaxShown: 1,
                          headerTextStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          markedDateMoreShowTotal: null,
                          // null for not showing hidden events indicator
                          markedDateIconBuilder: (event) {
                            return event.icon;
                          },
                        ),
                      ),
                      Container(
//                        color: Color(0xFFDBDCDD),
                        color: Colors.white,
                        child: Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 0),
                          height: 1,
                          color: Color(0xffEBECED),
                        ),
                      ),
                      Container(
//                        color: Color(0xFFDBDCDD),
                        padding: EdgeInsets.all(16),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    width: 7.5,
                                    height: 7.5,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Completed Order Date"),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 7.5,
                                  height: 7.5,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, color: appTheme),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Pending Order Date"),
                              ],
                            )
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

  String _getSubscriptionStatus(SubscriptionOrderData cardOrderHistoryItems) {
//    0 -> Due
//    1-> Active
//    2-> Reject
//    5-> Completed
//    6-> Cancel by customer
//    9->Pause by customer
//    10-> Pause by store Admin
    String title = "Due";
    switch (cardOrderHistoryItems.status) {
      case '0':
        title = 'Due';
        break;
      case '1':
        title = 'Active';
        break;
      case '2':
        title = 'Rejected';
        break;
      case '5':
        title = 'Completed';
        break;
      case '6':
        title = 'Cancelled';
        break;
      case '9':
        title = 'Paused';
        break;
      case '10':
        title = 'Paused by Admin';
        break;
    }
    return title;
  }

  Color _getSubscriptionStatusColor(
      SubscriptionOrderData cardOrderHistoryItems) {
//    0 -> Due
//    1-> Active
//    2-> Reject
//    5-> Completed
//    6-> Cancel by customer
//    9->Pause by customer
//    10-> Pause by store Admin
    Color statusColor = Colors.black;
    switch (cardOrderHistoryItems.status) {
      case '0':
      case '1':
      case '5':
        statusColor = Color(0xff799A3F);
        break;
      case '2':
      case '6':
        statusColor = Colors.red;
        break;
      case '9':
      case '10':
        statusColor = Colors.yellow;
        break;
    }
    return statusColor;
  }

  Widget firstRow(SubscriptionOrderData orderHistoryData) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Date and Time of Booking Request',
            style: TextStyle(
                fontSize: 14,
                color: Color(0xFFA0A3A5),
                fontWeight: FontWeight.w300),
          ),
          Padding(
            padding: EdgeInsets.only(top: 7, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: Text(
                    convertOrderDateTime(orderHistoryData.orderDate,
                        pattern: 'dd MMM, yyyy | hh:mm'),
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  width: 80,
                ),
              ],
            ),
          ),
//          Text(
//            orderHistoryData.orderFacility.toLowerCase().contains('pick')
//                ? 'PickUp Address'
//                : 'Delivery Address',
//            style: TextStyle(
//                fontSize: 14,
//                color: Color(0xFF7A7C80),
//                fontWeight: FontWeight.w300),
//          ),
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 35),
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
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Date and Time of Booking',
                  style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFA0A3A5),
                      fontWeight: FontWeight.w300),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 18,
                    color: Color(0xFF7A7C80),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    _checkSubscriptionKey(orderHistoryData.subscriptionType)
                        .label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF807D8C),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/calendargreyicon.png',
                          fit: BoxFit.scaleDown,
                          height: 16,
                          color: Color(0xFFBDBDBF),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${convertOrderDateTime(orderHistoryData.startDate.toString(), pattern: 'dd MMM, yyyy')} to\n ${convertOrderDateTime(orderHistoryData.endDate.toString(), pattern: 'dd MMM, yyyy')}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                     ! orderHistoryData.orderFacility.toLowerCase().contains('pick')?
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'images/timegreyicon.png',
                          fit: BoxFit.scaleDown,
                          height: 16,
                          color: Color(0xFFBDBDBF),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '${orderHistoryData.deliveryTimeSlot}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ):Container(height: 20,),
                  ],
                ),
              ),
              Visibility(
                visible: checkstatus(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Next Delivery Date',
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7A7C80),
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          'images/calendargreyicon.png',
                          fit: BoxFit.scaleDown,
                          height: 16,
                          color: Color(0xFFBDBDBF),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          _checkNextDeliveryDate(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
//                        color: Color(0xFFDBDCDD),
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.only(top: 16),
              height: 1,
              color: Color(0xffEBECED),
            ),
          ),
        ],
      ),
    );
  }

  secondRow(SubscriptionOrderData orderHistoryData) {
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
//                        color: Color(0xFFDBDCDD),
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.only(left: 16, right: 16, top: 0),
              height: 1,
              color: Color(0xffEBECED),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 0, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                          visible: orderHistoryData.walletRefund == "0.00"
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
                                    child: Text('(-)Wallet Amount',
                                        style: TextStyle(
                                          color: Color(0xff74BA33),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        )),
                                  ),
                                  Text(
                                      "${AppConstant.currency} ${orderHistoryData.walletRefund}",
                                      style: TextStyle(
                                          color: Color(0xff74BA33),
                                          fontSize: 14,
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
                                    child: Text('Delivery Charges',
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
                      Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 0),
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
                            child: Text('Amount paid',
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

  Widget listItem(BuildContext context,
      SubscriptionOrderData cardOrderHistoryItems, int index) {
    double findRating = _findRating(cardOrderHistoryItems, index);
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          cardOrderHistoryItems.orderItems[index].image == ""
              ? Container(
                  padding: EdgeInsets.only(left: 5, right: 20),
                  width: 70.0,
                  height: 70.0,
                  child: Utils.getImgPlaceHolder(),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 5, right: 20),
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    child: CachedNetworkImage(
                        imageUrl:
                            "${cardOrderHistoryItems.orderItems[index].image}",
                        fit: BoxFit.fill
                        //placeholder: (context, url) => CircularProgressIndicator(),
                        //errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                    /*child: Image.network(imageUrl,width: 60.0,height: 60.0,
                                          fit: BoxFit.cover),*/
                  )),
          Expanded(
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
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Weight: ${cardOrderHistoryItems.orderItems[index].weight}',
                                    style: TextStyle(
                                      color: Color(0xFF818387),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    )),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                          right: 3,
                                        ),
                                        padding:
                                            EdgeInsets.fromLTRB(8, 1, 8, 1),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xFFE6E6E6)),
                                          color: Color(0xFFE6E6E6),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),
                                        child: Text(
                                            '${cardOrderHistoryItems.orderItems[index].quantity}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12))),
                                    Text(
                                        'X ${cardOrderHistoryItems.orderItems[index].price}',
                                        style: TextStyle(
                                          color: Color(0xFF818387),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                  cardOrderHistoryItems
                                              .orderItems[index].status ==
                                          '2'
                                      ? "Rejected"
                                      : "${AppConstant.currency} ${(double.parse(cardOrderHistoryItems.orderItems[index].quantity) * double.parse(cardOrderHistoryItems.orderItems[index].price)).toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: cardOrderHistoryItems
                                                  .orderItems[index].status ==
                                              '2'
                                          ? Colors.red
                                          : Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              Visibility(
                                  visible: cardOrderHistoryItems
                                              .orderItems[index].refundStatus ==
                                          '2' ||
                                      cardOrderHistoryItems
                                              .orderItems[index].refundStatus ==
                                          '1',
                                  child: Text(
                                      cardOrderHistoryItems.orderItems[index]
                                                  .refundStatus ==
                                              '1'
                                          ? "Refund Pending"
                                          : "Refunded",
                                      style: TextStyle(
                                          color: cardOrderHistoryItems
                                                      .orderItems[index]
                                                      .refundStatus ==
                                                  '1'
                                              ? Colors.red
                                              : Colors.green,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)))
                            ],
                          ),
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
                              visible: widget.isRatingEnable &&
                                  cardOrderHistoryItems.status.contains('5'),
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
                                    ratingWidget: RatingWidget(
                                      full: Icon(
                                        Icons.star,
                                        color: appThemeSecondary,
                                      ),
                                      half: Icon(
                                        Icons.star_half,
                                        color: appThemeSecondary,
                                      ),
                                      empty: Icon(
                                        Icons.star_border,
                                        color: appThemeSecondary,
                                      ),
                                    ),
                                    ignoreGestures: true,
                                    onRatingUpdate: (rating) {},
                                  ),
                                  onTap: () {
                                    if (findRating == 0)
                                      bottomSheet(context,
                                          cardOrderHistoryItems, index);
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
          ),
        ],
      ),
    );
  }

  bottomSheet(
      context, SubscriptionOrderData cardOrderHistoryItems, int index) async {
    double _rating = 0;
    _image = null;
    final commentController = TextEditingController();
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
//                            Text(
//                              "(Select a star amount)",
//                              textAlign: TextAlign.center,
//                              style: TextStyle(
//                                  color: Colors.black,
//                                  fontSize: 16,
//                                  fontWeight: FontWeight.w400),
//                            ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          color: appThemeSecondary,
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
                          allowHalfRating: false,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          ratingWidget: RatingWidget(
                            full: Icon(
                              Icons.star,
                              color: appThemeSecondary,
                            ),
                            half: Icon(
                              Icons.star_half,
                              color: appThemeSecondary,
                            ),
                            empty: Icon(
                              Icons.star_border,
                              color: appThemeSecondary,
                            ),
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
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: TextField(
                              textAlign: TextAlign.left,
                              maxLength: 250,
                              keyboardType: TextInputType.text,
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
                                    showAlertDialog(context, setState);
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
                                        ? Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Image.file(
                                              _image,
                                              fit: BoxFit.cover,
                                            ))
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
                                  color: appThemeSecondary,
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
                                        desc: commentController.text.trim(),
                                        imageFile: _image);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ));
            },
          );
        });
  }

  deliverySlotBottomSheet(context, SubscriptionOrderData cardOrderHistoryItems,
      bool isEnable) async {
    String _selectedTimeSlotString = initSelectedTimeSlotString;
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                              padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                              child: Image.asset(
                                'images/cancelicon.png',
                                fit: BoxFit.scaleDown,
                                height: 15,
                                width: 15,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 15),
                          child: Text(
                            "Delivery Slots",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        deliverySlotModel == null
                            ? Container()
                            :
                            //print("--length = ${deliverySlotModel.data.dateTimeCollection.length}----");
                            deliverySlotModel.data != null &&
                                    deliverySlotModel.data.dateTimeCollection !=
                                        null &&
                                    deliverySlotModel
                                        .data.dateTimeCollection.isNotEmpty
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              //margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                              height: 50.0,
                                              child: ListView.builder(
                                                itemCount: timeslotList.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  Timeslot slotsObject =
                                                      timeslotList[index];
                                                  //print("----${slotsObject.label}-and ${selctedTag}--");
                                                  //selectedTimeSlot
                                                  Color textColor;
                                                  if (!slotsObject.isEnable) {
                                                    textColor =
                                                        Color(0xFFBDBDBD);
                                                  } else {
                                                    textColor =
                                                        Color(0xFF000000);
                                                  }
                                                  if (selectedTimeSlot ==
                                                          index &&
                                                      (slotsObject.isEnable)) {
                                                    textColor =
                                                        Color(0xFFff4600);
                                                  }

                                                  return Container(
                                                    //color: selectedSlotColor,
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 10, 0),
                                                    child: InkWell(
                                                      onTap: () {
                                                        print(
                                                            "${slotsObject.label}");
                                                        if (slotsObject
                                                            .isEnable) {
                                                          setState(() {
                                                            selectedTimeSlot =
                                                                index;
                                                            if (selectedTimeSlot !=
                                                                    null &&
                                                                selctedTag !=
                                                                    null) {
                                                              _selectedTimeSlotString =
                                                                  deliverySlotModel
                                                                      .data
                                                                      .dateTimeCollection[
                                                                          selctedTag]
                                                                      .timeslot[
                                                                          selectedTimeSlot]
                                                                      .label;
                                                            }
                                                          });
                                                        } else {
                                                          Utils.showToast(
                                                              slotsObject
                                                                  .innerText,
                                                              false);
                                                        }
                                                      },
                                                      child: Container(
                                                        child: Center(
                                                          child: Text(
                                                              '${slotsObject.isEnable == true ? slotsObject.label : "${slotsObject.label}(${slotsObject.innerText})"}',
                                                              style: TextStyle(
                                                                  color:
                                                                      textColor)),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                        Visibility(
                          visible: isEnable,
                          child: Container(
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(5.0)),
                            ),
                            child: FlatButton(
                              child: Text(
                                'Save',
                                style: TextStyle(fontSize: 17),
                              ),
                              color: orangeColor,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pop(context);
                                updateSubscriptionOrderDeliverySlots(
                                    cardOrderHistoryItems.subscriptionOrderId,
                                    _selectedTimeSlotString);
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
                ),
              ));
            },
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
      color: Color(0xffEBECED),
      height: 1,
      thickness: 1,
      indent: 12,
      endIndent: 12,
    );
  }

  sheetDeviderLine() {
    return Divider(
      color: Color(0xffEBECED),
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
        : status == "1"
            ? Color(0xFFA0C057)
            : Color(0xFFCF0000);
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

  String _getAddress(SubscriptionOrderData orderHistoryData) {
    if(orderHistoryData.orderFacility.toLowerCase().contains('pick')) {
      if (orderHistoryData.deliveryAddress != null &&
          orderHistoryData.deliveryAddress.isNotEmpty) {
        String name = '${orderHistoryData.deliveryAddress.first.firstName}';
        String address = '${orderHistoryData.deliveryAddress.first.address}';
        String address2 =
            '${orderHistoryData.deliveryAddress.first.address2.isEmpty
            ? ''
            : ',\n${orderHistoryData.deliveryAddress.first.address2}'}';
        String area = ',\n${orderHistoryData.deliveryAddress.first.areaName}';
        String city = ', ${orderHistoryData.deliveryAddress.first.city}';
        String ZipCode = orderHistoryData.deliveryAddress.first.zipcode
            .isNotEmpty
            ? ', ${orderHistoryData.deliveryAddress.first.zipcode}'
            : '';
        return '$name\n$address$address2$area$city$ZipCode';
      } else {
        String address = '${orderHistoryData.address}';
        return address;
      }
    }else{
      String address = '${orderHistoryData.address}';
      return address;
    }
  }

  String _generalizedDeliverySlotTime(SubscriptionOrderData orderHistoryData) {
    if (orderHistoryData.deliveryTimeSlot != null &&
        orderHistoryData.deliveryTimeSlot.isNotEmpty) {
      int dateEndIndex = orderHistoryData.deliveryTimeSlot.indexOf(' ');
      String date =
          orderHistoryData.deliveryTimeSlot.substring(0, dateEndIndex);
      String convertedDate = convertOrderDateTime(date);
      String returnedDate =
//          orderHistoryData.deliveryTimeSlot.replaceFirst(' ', ' | ');
          orderHistoryData.deliveryTimeSlot;
      return returnedDate.replaceAll(date, convertedDate);
    } else {
      return '';
    }
  }

  String convertOrderDateTime(String date, {String pattern = 'dd MMM yyyy'}) {
    String formatted = date;
    try {
      DateFormat format = new DateFormat("yyyy-MM-dd");
      //UTC time true
      DateTime time = format.parse(date, true);
      time = time.toLocal();
      //print("time.toLocal()=   ${time.toLocal()}");
      DateFormat formatter = new DateFormat(pattern);
      formatted = formatter.format(time.toLocal());
    } catch (e) {
      print(e);
    }

    return formatted;
  }

  showAlertDialog(BuildContext context, setState) {
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
            if (image == null) {
              print("---image == null----");
            } else {
              _image = File(image.path);
            }
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
            if (image == null) {
              print("---image == null----");
            } else {
              print("---image.length----${image.path}");
              _image = File(image.path);
            }
            setState(() {});
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

  double _findRating(SubscriptionOrderData cardOrderHistoryItems, int index) {
    double foundRating = 0;
//    List<Review> reviewList = cardOrderHistoryItems.orderItems[index].review;
    List<Review> reviewList = List();

    if (reviewList != null && reviewList.isNotEmpty) {
      for (int i = 0; i < reviewList.length; i++) {
        if (userId.compareTo(reviewList[i].userId) == 0) {
          foundRating = double.parse(reviewList[i].rating);
        }
      }
    }
    return foundRating;
  }

  void postRating(
      SubscriptionOrderData cardOrderHistoryItems, int index, double _rating,
      {String desc = "", File imageFile}) {
    Utils.showProgressDialog(context);
    ApiController.postProductRating(
            cardOrderHistoryItems.subscriptionOrderId,
            cardOrderHistoryItems.orderItems[index].productId,
            _rating.toString(),
            desc: desc,
            imageFile: imageFile)
        .then((value) {
      if (value != null && value.success) {
        //Hit event Bus
        eventBus.fire(refreshOrderHistory());
        getOrderListApi(isLoading: false);
      }
    });
  }

  CycleType _checkSubscriptionKey(String subscriptionType) {
    CycleType label = widget.store.subscription.cycleType.first;
    for (CycleType cycleType in widget.store.subscription.cycleType) {
      if (cycleType.key.contains(subscriptionType)) {
        label = cycleType;
        break;
      }
    }
    return label;
  }

  void addEvents() {
    int days = int.parse(
        _checkSubscriptionKey(widget.orderHistoryData.subscriptionType).days);
    //final difference = selectedEndDate.difference(selectedStartDate).inDays;
    //print("difference.inDays=${difference}");

    if (days == 1) {
      List<DateTime> getDatesInBeteween = Utils.getDatesInBeteween(
          widget.orderHistoryData.startDate, widget.orderHistoryData.endDate);
      _markedDateMap.clear();
      for (var i = 0; i < getDatesInBeteween.length; i++) {
        _markedDateMap.add(
            getDatesInBeteween[i],
            Event(
              date: getDatesInBeteween[i],
              title: '${getDatesInBeteween[i].day.toString()}',
              icon: _presentIcon(getDatesInBeteween[i]),
            ));
      }
//      totalDeliveries =
//          _markedDateMap.events.length;
//      multiTaxCalculationApi(
//          couponCode: couponCodeApplied);
      setState(() {
//        selecteddays = index;
      });
    } else {
      _markedDateMap.clear();
      List<DateTime> getDatesInBeteween = Utils.getDatesInBeteween(
          widget.orderHistoryData.startDate, widget.orderHistoryData.endDate);
      for (var i = 0; i < getDatesInBeteween.length; i++) {
        if (i % days == 0) {
          _markedDateMap.add(
              getDatesInBeteween[i],
              Event(
                date: getDatesInBeteween[i],
                title: '${getDatesInBeteween[i].day.toString()}',
                icon: _presentIcon(getDatesInBeteween[i]),
              ));
        }
      }
//      totalDeliveries =
//          _markedDateMap.events.length;
//      multiTaxCalculationApi(
//          couponCode: couponCodeApplied);
      setState(() {
//        selecteddays = index;
      });
    }
  }

  Widget _presentIcon(DateTime day) => CircleAvatar(
        backgroundColor: _checkCurrentDate(day) ? appTheme : Colors.grey,
        child: Text(
          day.day.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );

  _checkCurrentDate(DateTime day) {
    if (checkstatus()) {
      DateTime dateTime = DateTime.now();
      return day.isAfter(dateTime);
    } else {
      return false;
    }
  }

  String _checkNextDeliveryDate() {
    List<DateTime> getDatesInBeteween = Utils.getDatesInBeteween(
        widget.orderHistoryData.startDate, widget.orderHistoryData.endDate);
    DateTime deliveryDate = DateTime.now();
    for (DateTime day in getDatesInBeteween) {
      if (day.isAfter(deliveryDate)) {
        deliveryDate = day;
        break;
      }
    }

    String formatted = '';
    try {
      DateFormat formatter = new DateFormat('dd MMM, yyyy');
      formatted = formatter.format(deliveryDate.toLocal());
    } catch (e) {
      print(e);
    }
    return formatted;
  }

  bool checkstatus() {
    return widget.orderHistoryData.status == '1';
  }
}
