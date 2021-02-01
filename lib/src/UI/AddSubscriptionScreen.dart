import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/Screens/Offers/AvailableOffersList.dart';
import 'package:restroapp/src/Screens/Offers/RedeemPointsScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/DeliveryTimeSlotModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/models/SubscriptionTaxCalculationResponse.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/models/WalleModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/BaseState.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'ProductSubcriptonTileView.dart';

class AddSubscriptionScreen extends StatefulWidget {
  StoreModel model;
  Product product;

  AddSubscriptionScreen(this.product, this.model);

  @override
  _AddSubscriptionScreenState createState() {
    return _AddSubscriptionScreenState();
  }
}

class _AddSubscriptionScreenState extends BaseState<AddSubscriptionScreen> {
  TextEditingController controllerStartDate = TextEditingController();
  TextEditingController controllerEndDate = TextEditingController();

  bool isDeliveryResponseFalse = false;
  DeliveryTimeSlotModel deliverySlotModel;
  int selctedTag, selectedTimeSlot;
  List<Timeslot> timeslotList;
  bool isSlotSelected = false;

  //Store provides instant delivery of the orders.
  bool isInstantDelivery = false;
  double totalPrice = 0.00;
  double totalSavings = 0.00;
  double totalMRpPrice = 0.0;
  String totalSavingsText = "";
  int selecteddays = -1;
  DateTime selectedStartDate, selectedEndDate;
  EventList<Event> _markedDateMap;
  TextEditingController couponCodeController = TextEditingController();
  DeliveryAddressData addressData;
  bool isCouponsApplied = false;

  bool isLoading=true;

  WalleModel userWalleModel;

  String shippingCharges='0';

  SubscriptionTaxCalculation taxModel;

  @override
  void initState() {
    super.initState();
    selecteddays = -1;
    _markedDateMap = new EventList<Event>(
      events: {},
    );
    callDeliverySlotsApi();
    eventBus.on<onAddressSelected>().listen((event) {
      print("<---onAddressSelected------->");
      setState(() {
        this.addressData = event.addressData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Subscription"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: [
                addressData == null
                    ? Container(
                        height: 60.0,
                        color: Colors.grey[200],
                        child: InkWell(
                          onTap: () {
                            if (AppConstant.isLoggedIn) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DeliveryAddressList(
                                        true, OrderType.SubScription)),
                              );
                              Map<String, dynamic> attributeMap =
                                  new Map<String, dynamic>();
                              attributeMap["ScreenName"] =
                                  "DeliveryAddressList";
                              Utils.sendAnalyticsEvent(
                                  "Clicked DeliveryAddressList", attributeMap);
                            } else {
                              Utils.showLoginDialog(context);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 30.0,
                                ),
                                Text(
                                  "Add Delivery Address",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Deliver To",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            "${addressData.firstName}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "${addressData.address}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 35.0,
                              margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                              color: appTheme,
                              child: ButtonTheme(
                                minWidth: 80,
                                child: RaisedButton(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  textColor: Colors.grey[600],
                                  color: Colors.grey[300],
                                  onPressed: () async {
                                    if (AppConstant.isLoggedIn) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DeliveryAddressList(true,
                                                    OrderType.SubScription)),
                                      );
                                      Map<String, dynamic> attributeMap =
                                          new Map<String, dynamic>();
                                      attributeMap["ScreenName"] =
                                          "DeliveryAddressList";
                                      Utils.sendAnalyticsEvent(
                                          "Clicked DeliveryAddressList",
                                          attributeMap);
                                    } else {
                                      Utils.showLoginDialog(context);
                                    }
                                  },
                                  child: Text(
                                    "Change",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  height: addressData == null ? 0 : 1,
                  color: Colors.grey,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Text(
                            "When do you want to start the subscription?",
                            style: TextStyle(fontSize: 16),
                          )),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Stack(
                                children: [
                                  Text(
                                    "Start Date",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: TextField(
                                        controller: controllerStartDate,
                                        onTap: () async {
                                          selectedStartDate = await selectDate(
                                              context,
                                              isStartIndex: true);
                                          if (selectedStartDate != null) {
                                            String date =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(selectedStartDate);
                                            setState(() {
                                              controllerStartDate.text = date;
                                            });
                                          }
                                        },
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              icon: Icon(
                                                Icons.calendar_today,
                                              ),
                                              onPressed: () {}),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: Container(
                              child: Stack(
                                children: [
                                  Text(
                                    "End Date",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: TextField(
                                        controller: controllerEndDate,
                                        onTap: () async {
                                          selectedEndDate = await selectDate(
                                              context,
                                              isStartIndex: true);
                                          if (selectedEndDate != null) {
                                            String date =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(selectedEndDate);
                                            setState(() {
                                              controllerEndDate.text = date;
                                            });
                                          }
                                        },
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                              icon: Icon(
                                                Icons.calendar_today,
                                              ),
                                              onPressed: () {
                                                //_controllerx.text = '';
                                              }),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                showDeliverySlot(),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  height: 5,
                  color: Colors.grey[400],
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 10, 15, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                          child: Text(
                            "How often do you want to receive this product?",
                            style: TextStyle(fontSize: 16),
                          )),
                      GridView.count(
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 5),
                          physics: NeverScrollableScrollPhysics(),
                          // to disable GridView's scrolling
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: List.generate(
                              widget.model.subscription.cycleType.length,
                              (index) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              color: Colors.white,
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    if (selectedStartDate != null &&
                                        selectedEndDate != null) {
                                      //print("label=${widget.model.subscription.cycleType[index].label}");
                                      //print("days=${widget.model.subscription.cycleType[index].days}");
                                      int days = int.parse(widget.model
                                          .subscription.cycleType[index].days);
                                      //final difference = selectedEndDate.difference(selectedStartDate).inDays;
                                      //print("difference.inDays=${difference}");

                                      if (days == 1) {
                                        List<DateTime> getDatesInBeteween =
                                            Utils.getDatesInBeteween(
                                                selectedStartDate,
                                                selectedEndDate);
                                        _markedDateMap.clear();
                                        for (var i = 0;
                                            i < getDatesInBeteween.length;
                                            i++) {
                                          _markedDateMap.add(
                                              getDatesInBeteween[i],
                                              Event(
                                                date: getDatesInBeteween[i],
                                                title:
                                                    '${getDatesInBeteween[i].day.toString()}',
                                                icon: _presentIcon(
                                                    getDatesInBeteween[i]
                                                        .day
                                                        .toString()),
                                              ));
                                        }
                                        setState(() {
                                          selecteddays = index;
                                        });
                                      } else {
                                        _markedDateMap.clear();
                                        List<DateTime> getDatesInBeteween =
                                            Utils.getDatesInBeteween(
                                                selectedStartDate,
                                                selectedEndDate);
                                        for (var i = 0;
                                            i < getDatesInBeteween.length;
                                            i++) {
                                          if (i % days == 0) {
                                            _markedDateMap.add(
                                                getDatesInBeteween[i],
                                                Event(
                                                  date: getDatesInBeteween[i],
                                                  title:
                                                      '${getDatesInBeteween[i].day.toString()}',
                                                  icon: _presentIcon(
                                                      getDatesInBeteween[i]
                                                          .day
                                                          .toString()),
                                                ));
                                          }
                                        }
                                        setState(() {
                                          selecteddays = index;
                                        });
                                      }
                                    } else if (selectedStartDate == null) {
                                      Utils.showToast(
                                          "Please select Start Date", false);
                                    } else if (selectedEndDate == null) {
                                      Utils.showToast(
                                          "Please select End Date", false);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      selecteddays == index
                                          ? Icon(
                                              Icons.radio_button_checked,
                                              color: appTheme,
                                            )
                                          : Icon(
                                              Icons.radio_button_unchecked,
                                              color: appTheme,
                                            ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(widget.model.subscription
                                          .cycleType[index].label),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })),
                    ],
                  ),
                ),
                Container(
                  child: Center(child: Text("Preview")),
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
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                  height: 1,
                  color: Colors.grey,
                ),
                ProductSubcriptonTileView(
                    widget.product, () {}, ClassType.SubCategory),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  height: 1,
                  color: Colors.grey,
                ),
                addItemPrice(),
                addTotalPrice(),
                addEnterCouponCodeView(),
                addCouponCodeRow()
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Wrap(
                children: [addSubscriptionBtn()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addSubscriptionBtn() {
    return Container(
      height: 50.0,
      color: appTheme,
      child: InkWell(
        onTap: () async {},
        child: ButtonTheme(
          minWidth: Utils.getDeviceWidth(context),
          child: RaisedButton(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            textColor: Colors.white,
            color: appTheme,
            onPressed: () async {},
            child: Text(
              "Subscribe",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }

  void callDeliverySlotsApi() {
    if (widget.model.deliverySlot == "1") {
      ApiController.deliveryTimeSlotApi().then((response) {
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
        });
      });
    }
  }

  Widget showDeliverySlot() {
    Color selectedSlotColor, textColor;
    if (deliverySlotModel == null) {
      return Container();
    } else {
      //print("--length = ${deliverySlotModel.data.dateTimeCollection.length}----");
      if (deliverySlotModel.data != null &&
          deliverySlotModel.data.dateTimeCollection != null &&
          deliverySlotModel.data.dateTimeCollection.isNotEmpty) {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
//                    child: Text("When would you like your service?"),
//                  ),
//                  Padding(
//                    padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
//                    child: Text("${Utils.getDate()}"),
//                  ),
//                  Container(
//                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
//                      height: 1,
//                      width: MediaQuery.of(context).size.width,
//                      color: Color(0xFFBDBDBD)),
//                  Container(
//                    //margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
//                    height: 50.0,
//                    child: ListView.builder(
//                      itemCount:
//                          deliverySlotModel.data.dateTimeCollection.length,
//                      scrollDirection: Axis.horizontal,
//                      itemBuilder: (context, index) {
//                        DateTimeCollection slotsObject =
//                            deliverySlotModel.data.dateTimeCollection[index];
//                        if (selctedTag == index) {
//                          selectedSlotColor = Color(0xFFEEEEEE);
//                          textColor = Color(0xFFff4600);
//                        } else {
//                          selectedSlotColor = Color(0xFFFFFFFF);
//                          textColor = Color(0xFF000000);
//                        }
//                        return Container(
//                          color: selectedSlotColor,
//                          margin: EdgeInsets.fromLTRB(15, 0, 10, 0),
//                          child: InkWell(
//                            onTap: () {
//                              print("${slotsObject.timeslot.length}");
//                              setState(() {
//                                selctedTag = index;
//                                timeslotList = slotsObject.timeslot;
//                                isSlotSelected = false;
//                                //selectedTimeSlot = 0;
//                                //print("timeslotList=${timeslotList.length}");
//                                for (int i = 0; i < timeslotList.length; i++) {
//                                  //print("isEnable=${timeslotList[i].isEnable}");
//                                  Timeslot timeslot = timeslotList[i];
//                                  if (timeslot.isEnable) {
//                                    selectedTimeSlot = i;
//                                    isSlotSelected = true;
//                                    break;
//                                  }
//                                }
//                              });
//                            },
//                            child: Container(
//                              child: Center(
//                                child: Text(
//                                    ' ${Utils.convertStringToDate(slotsObject.label)} ',
//                                    style: TextStyle(color: textColor)),
//                              ),
//                            ),
//                          ),
//                        );
//                      },
//                    ),
//                  ),
//                  Container(
//                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                      height: 1,
//                      width: MediaQuery.of(context).size.width,
//                      color: Color(0xFFBDBDBD)),
                  Container(
                    //margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    height: 50.0,
                    child: ListView.builder(
                      itemCount: timeslotList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Timeslot slotsObject = timeslotList[index];
                        //print("----${slotsObject.label}-and ${selctedTag}--");

                        //selectedTimeSlot
                        Color textColor;
                        if (!slotsObject.isEnable) {
                          textColor = Color(0xFFBDBDBD);
                        } else {
                          textColor = Color(0xFF000000);
                        }
                        if (selectedTimeSlot == index &&
                            (slotsObject.isEnable)) {
                          textColor = Color(0xFFff4600);
                        }

                        return Container(
                          //color: selectedSlotColor,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: InkWell(
                            onTap: () {
                              print("${slotsObject.label}");
                              if (slotsObject.isEnable) {
                                setState(() {
                                  selectedTimeSlot = index;
                                });
                              } else {
                                Utils.showToast(slotsObject.innerText, false);
                              }
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                    '${slotsObject.isEnable == true ? slotsObject.label : "${slotsObject.label}(${slotsObject.innerText})"}',
                                    style: TextStyle(color: textColor)),
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
        );
      } else {
        return Container();
      }
    }
  }

  Widget addItemPrice() {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: 1,
            color: Colors.black45,
            width: MediaQuery.of(context).size.width),
        Visibility(
          visible: /*widget.address == null ? false :*/ true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery charges:",
                    style: TextStyle(color: Colors.black54)),
                Text(
                    "${AppConstant.currency}${/*widget.address == null ? "0" : widget.address.areaCharges*/ "0"}",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ),
        Visibility(
          visible: /* taxModel == null ? false :*/ true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discount:", style: TextStyle(color: Colors.black54)),
                Text(
                    "${AppConstant.currency}${/*taxModel == null ? "0" : taxModel.discount*/ '0'}",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Items Price", style: TextStyle(color: Colors.black)),
              Text(
                  "${AppConstant.currency}${'0' /*taxModel == null ? databaseHelper.roundOffPrice((totalPrice - int.parse(shippingCharges)), 2).toStringAsFixed(2) : taxModel.itemSubTotal*/}",
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
      ]),
    );
  }

  Widget addCouponCodeRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
      child: Container(
        child: Wrap(
          children: <Widget>[
            Visibility(
              visible: true /*isloyalityPointsEnabled == true ? true : false*/,
              child: InkWell(
                onTap: () async {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      decoration: BoxDecoration(
                        color: whiteColor,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          /* appliedReddemPointsCodeList.isEmpty
                              ?*/
                          "Redeem Loyality Points"
                          /*  : "${taxModel.couponCode} Applied"*/,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  /*appliedCouponCodeList.isEmpty
                                  ? isCouponsApplied
                                  ? appTheme.withOpacity(0.5)
                                  : appTheme
                                  : */
                                  appTheme.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    Icon(
                        /*appliedReddemPointsCodeList.isNotEmpty
                        ? Icons.cancel
                        : */
                        Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: true /* isloyalityPointsEnabled == true ? true : false*/,
              child: Utils.showDivider(context),
            ),
            InkWell(
              onTap: () {
                /*  print(
                    "appliedCouponCodeList = ${appliedCouponCodeList.length}");
                print(
                    "appliedReddemPointsCodeList = ${appliedReddemPointsCodeList.length}");
                if (isCouponsApplied) {
                  Utils.showToast(
                      "Please remove Applied Coupon to Avail Offers", false);
                  return;
                }
                if (appliedReddemPointsCodeList.isNotEmpty) {
                  Utils.showToast(
                      "Please remove Applied Coupon to Avail Offers", false);
                  return;
                }
                if (taxModel != null && appliedCouponCodeList.isNotEmpty) {
                  removeCoupon();
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AvailableOffersDialog(
                        widget.address,
                        widget.paymentMode,
                        widget.isComingFromPickUpScreen,
                        widget.areaId, (model) async {
                      await updateTaxDetails(model);
                      setState(() {
                        hideRemoveCouponFirstTime = false;
                        taxModel = model;
//                        double taxModelTotal = double.parse(taxModel.total) +
//                            int.parse(shippingCharges);
//                        taxModel.total = taxModelTotal.toString();
                        appliedCouponCodeList.add(model.couponCode);
                        print("===couponCode=== ${model.couponCode}");
                        print("taxModel.total=${taxModel.total}");
                      });
                    }, appliedCouponCodeList, isOrderVariations,
                        responseOrderDetail, shippingCharges),
                  );
                }*/
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        /*  isloyalityPointsEnabled ? 0 :*/
                        0,
                        0,
                        0,
                        0),
                    height: 40,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: new BoxDecoration(
                      color: whiteColor,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          /*appliedCouponCodeList.isEmpty
                              ? */
                          "Available Offers"
                          /* : "${taxModel.couponCode} Applied"*/,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  /* appliedReddemPointsCodeList.isEmpty
                                  ? isCouponsApplied
                                  ? appTheme.withOpacity(0.5)
                                  : appTheme
                                  : */
                                  appTheme.withOpacity(0.5))),
                    ),
                  ),
                  Icon(
                      /*appliedCouponCodeList.isNotEmpty
                      ? Icons.cancel
                      : */
                      Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateTaxDetails(TaxCalculationModel taxModel) async {
//    widget.cartList = await databaseHelper.getCartItemList();
    for (int i = 0; i < taxModel.taxDetail.length; i++) {
      Product product = Product();
      product.taxDetail = taxModel.taxDetail[i];
//      widget.cartList.add(product);
    }
    for (var i = 0; i < taxModel.fixedTax.length; i++) {
      Product product = Product();
      product.fixedTax = taxModel.fixedTax[i];
//      widget.cartList.add(product);
    }
  }

  Widget addEnterCouponCodeView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                border: new Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: couponCodeController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: "Coupon Code",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 40.0,
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                textColor: Colors.white,
                color: appTheme,
                onPressed: () async {},
                child: new Text(
                    isCouponsApplied ? "Remove Coupon" : "Apply Coupon"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addMRPPrice() {
    if (totalSavings != 0.00)
      return Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.fromLTRB(15, 10, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("MRP Price",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 14)),
                  Text(
                      '${AppConstant.currency}${totalMRpPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 14)),
                ],
              )));
    else
      return Container();
  }

  Widget addTotalSavingPrice() {
    if (totalSavings != 0.00)
      return Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.fromLTRB(15, 5, 10, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cart Discount",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: appTheme,
                          fontSize: 16)),
                  Text('-${AppConstant.currency}$totalSavingsText',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: appTheme,
                          fontSize: 16)),
                ],
              )));
    else
      return Container();
  }

  Widget addTotalPrice() {
    return Container(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: 1,
            color: Colors.black45,
            width: MediaQuery.of(context).size.width),
        addMRPPrice(),
        addTotalSavingPrice(),
        Padding(
            padding: EdgeInsets.fromLTRB(15, totalSavings > 0 ? 5 : 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                    "${AppConstant.currency}${/*databaseHelper.roundOffPrice(taxModel == null ?*/ totalPrice /* : double.parse(taxModel.total),2)*/
                        .toStringAsFixed(2)}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ))
      ]),
    );
  }

  Widget _presentIcon(String day) => CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          day,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );

  Future<DateTime> selectDate(BuildContext context, {bool isStartIndex}) async {
    DateTime selectedDate = DateTime.now();
    if (isStartIndex != null) {
      selectedDate = selectedDate.add(Duration(days: 1));
    }
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(DateTime.now().year + 10));
    print(picked);
    if (picked != null)
      //dayName = DateFormat('DD-MM-yyyy').format(selectedDate);
      return picked;
  }

  Future<void> multiTaxCalculationApi() async {
    bool isNetworkAvailable = await Utils.isNetworkAvailable();
    if (!isNetworkAvailable) {
      Utils.showToast(AppConstant.noInternet, false);
      return;
    }
    isLoading = true;
    userWalleModel = await ApiController.getUserWallet();
    getCartItemList().then((cartList) {
      cartListFromDB = cartList;
      List jsonList = Product.encodeToJson(cartList);
      String encodedDoughnut = jsonEncode(jsonList);
      ApiController.subscriptionMultipleTaxCalculationRequest(
           couponCode:'',
           discount:"0",
           shipping:"$shippingCharges",
           orderJson:'',
           userAddressId:'',
           userAddress:'',
           total:'',
           checkout:'',
           deliveryTimeSlot:'',
           cartSaving:'',
           totalDeliveries:'')
          .then((response) async {
        //{"success":false,"message":"Some products are not available."}
        SubscriptionTaxCalculationResponse model = response;
        if (model.success) {
//          taxModel = model.data;
//          widget.cartList = await databaseHelper.getCartItemList();
//          for (int i = 0; i < model.taxCalculation.taxDetail.length; i++) {
//            Product product = Product();
//            product.taxDetail = model.data.taxDetail[i];
//            widget.cartList.add(product);
//          }
//          for (var i = 0; i < model.taxCalculation.fixedTax.length; i++) {
//            Product product = Product();
//            product.fixedTax = model.taxCalculation.fixedTax[i];
//            widget.cartList.add(product);
//          }
//          if (model.taxCalculation.orderDetail != null &&
//              model.taxCalculation.orderDetail.isNotEmpty) {
//            responseOrderDetail = model.taxCalculation.orderDetail;
//            bool someProductsUpdated = false;
//            isOrderVariations = model.taxCalculation.isChanged;
//            for (int i = 0; i < responseOrderDetail.length; i++) {
//              if (responseOrderDetail[i]
//                  .productStatus
//                  .compareTo('out_of_stock') ==
//                  0 ||
//                  responseOrderDetail[i]
//                      .productStatus
//                      .compareTo('price_changed') ==
//                      0) {
//                someProductsUpdated = true;
//                break;
//              }
//            }
//            if (someProductsUpdated) {
//              DialogUtils.displayCommonDialog(
//                  context,
//                  widget.model == null ? "" : widget.model.storeName,
//                  "Some Cart items were updated. Please review the cart before procceeding.",
//                  buttonText: 'Procceed');
//              constraints();
//            }
//          }
//
//          calculateTotalSavings();
//          setState(() {
//            isLoading = false;
//          });
        } else {
          var result = await DialogUtils.displayCommonDialog(
              context,
              widget.model == null ? "" : widget.model.storeName,
              "${model.message}");
          if (result != null && result == true) {

            eventBus.fire(updateCartCount());
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      });
    });
  }

  Future<List<Product>> getCartItemList() {

  }
}
