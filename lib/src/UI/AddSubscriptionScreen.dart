import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/Screens/Offers/AvailableOffersList.dart';
import 'package:restroapp/src/Screens/Offers/RedeemPointsScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/DeliveryTimeSlotModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/models/SubscriptionTaxCalculationResponse.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/models/ValidateCouponsResponse.dart';
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
  OrderType deliveryType = OrderType.Delivery;
  List<Product> cartList = new List();

  Variant selectedVariant;

  String quantity;

  AddSubscriptionScreen(
      this.product, this.model, this.quantity, this.selectedVariant);

  @override
  _AddSubscriptionScreenState createState() {
    return _AddSubscriptionScreenState();
  }
}

class _AddSubscriptionScreenState extends BaseState<AddSubscriptionScreen> {
  TextEditingController controllerStartDate = TextEditingController();
  TextEditingController controllerEndDate = TextEditingController();
  DatabaseHelper databaseHelper = new DatabaseHelper();

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
  List<Product> cartListFromDB = List();

  bool isLoading = true;

  WalleModel userWalleModel;

  String shippingCharges = '0';

  SubscriptionTaxCalculation taxModel;

  bool isComingFromPickUpScreen = false;

  String pin = '';

  String userDeliveryAddress = '';

  int totalDeliveries = 1;

  String cartSaving = '0';

  String selectedTimeSlotString = '';
  bool isOrderVariations = false;
  List<OrderDetail> responseOrderDetail = List();
  bool isloyalityPointsEnabled = false;
  List<String> appliedCouponCodeList = List();
  List<String> appliedReddemPointsCodeList = List();
  String couponCodeApplied = '';

  bool hideRemoveCouponFirstTime = false;

  @override
  void initState() {
    super.initState();
    hideRemoveCouponFirstTime = true;
    widget.product.quantity = widget.quantity;
    widget.product.variantId = widget.selectedVariant == null
        ? widget.product.variantId
        : widget.selectedVariant.id;
    widget.product.weight = widget.selectedVariant == null
        ? widget.product.weight
        : widget.selectedVariant.weight;
    widget.product.mrpPrice = widget.selectedVariant == null
        ? widget.product.mrpPrice
        : widget.selectedVariant.mrpPrice;
    widget.product.price = widget.selectedVariant == null
        ? widget.product.price
        : widget.selectedVariant.price;
    widget.product.discount = widget.selectedVariant == null
        ? widget.product.discount
        : widget.selectedVariant.discount;
    widget.product.isUnitType = widget.selectedVariant == null
        ? widget.product.isUnitType
        : widget.selectedVariant.unitType;
    widget.cartList.add(widget.product);
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
      multiTaxCalculationApi(couponCode: couponCodeApplied);
    });
    eventBus.on<onSubscribeProduct>().listen((event) {
      if (event != null && event.product != null) {
        widget.cartList.first = event.product;
        widget.cartList.first.quantity = event.quanity;
      }
      setState(() {});
      multiTaxCalculationApi(couponCode: couponCodeApplied);
    });

//    databaseHelper
//        .getProductQuantitiy(widget.product.variantId,
//            isSubscriptionTable: true)
//        .then((cartDataObj) {
//      totalDeliveries = cartDataObj.QUANTITY;
//
//    });
    multiTaxCalculationApi(
      couponCode: '',
    );
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
                          onTap: () async {
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
                                            _markedDateMap.clear();
                                            selecteddays = -1;
                                            if (selectedEndDate != null) {
                                              bool isBefore = selectedStartDate
                                                  .isBefore(selectedEndDate);
                                              if (!isBefore) {
                                                setState(() {
                                                  selectedEndDate = null;
                                                  controllerEndDate.text = '';
                                                });
                                              }
                                            }
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
                                            _markedDateMap.clear();
                                            selecteddays = -1;
                                            if (selectedStartDate != null) {
                                              bool isBefore = selectedStartDate
                                                  .isBefore(selectedEndDate);
                                              if (!isBefore) {
                                                setState(() {
                                                  selectedEndDate = null;
                                                  controllerEndDate.text = '';
                                                });
                                                return;
                                              }
                                            }

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
                                        totalDeliveries =
                                            _markedDateMap.events.length;
                                        multiTaxCalculationApi(
                                            couponCode: couponCodeApplied);
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
                                        totalDeliveries =
                                            _markedDateMap.events.length;
                                        multiTaxCalculationApi(
                                            couponCode: couponCodeApplied);
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
                    widget.cartList.first,
                    () {},
                    ClassType.SubCategory,
                    widget.cartList.first.quantity,
                    widget.selectedVariant),
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
            onPressed: () async {
              //TODO: show bottomsheet
              bottomSheet(context);
            },
            child: Text(
              "Subscribe",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }

  bottomSheet(context) async {
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
                      child: Wrap(children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(0.0),
                                  child: Image.asset('images/bg_subscription.jpg',
                                      fit: BoxFit.cover)),
                              Column(children: [ Align(
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
                                    "Your Total deliveries",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                                  child: Text(
                                    "${totalDeliveries}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],),
                            ],),

                            Container(
                              margin: EdgeInsets.only(top: 5),
                              color: appThemeSecondary,
                              width: 50,
                              height: 3,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 5,bottom: 5),
                              child: Text(
                                "Date",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff797C82),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Row(children: [  Icon(
                                    Icons.calendar_today,
                                  ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Center(
                                  child: Text(
                                      'Delivery slots',
                                      style: TextStyle(color: appTheme,decoration: TextDecoration
                                          .underline,)),
                                ),
                              )
                            ],),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 0, bottom: 16, left: 16, right: 16),
                              color: Color(0xFFE1E1E1),
                              height: 1,
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
          if (selectedTimeSlot != null && selctedTag != null) {
            selectedTimeSlotString = deliverySlotModel
                .data
                .dateTimeCollection[selctedTag]
                .timeslot[selectedTimeSlot]
                .label;
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
                                  if (selectedTimeSlot != null &&
                                      selctedTag != null) {
                                    selectedTimeSlotString = deliverySlotModel
                                        .data
                                        .dateTimeCollection[selctedTag]
                                        .timeslot[selectedTimeSlot]
                                        .label;
                                  }
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
          visible: addressData == null ? false : true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery charges:",
                    style: TextStyle(color: Colors.black54)),
                Text(
                    "${AppConstant.currency}${addressData == null ? "0" : addressData.areaCharges}",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ),
        Visibility(
          visible: taxModel == null ? false : true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discount:", style: TextStyle(color: Colors.black54)),
                Text(
                    "${AppConstant.currency}${taxModel == null ? "0" : taxModel.discount.isNotEmpty ? taxModel.discount : '0'}",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Items Price", style: TextStyle(color: Colors.black)),
              Text(
                  "${AppConstant.currency}${taxModel == null ? databaseHelper.roundOffPrice((totalPrice - int.parse(shippingCharges)), 2).toStringAsFixed(2) : taxModel.singleDayItemSubTotal}",
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        addMRPPrice(),
        addTotalSavingPrice(),
      ]),
    );
  }

  void checkLoyalityPointsOption() {
    //1 - enable, 0 means disable
    try {
      print("====-loyality===== ${widget.model.loyality}--");
      if (widget.model.loyality != null && widget.model.loyality == "1") {
        this.isloyalityPointsEnabled = true;
      } else {
        this.isloyalityPointsEnabled = false;
      }
    } catch (e) {
      print(e);
    }
  }

  Widget addCouponCodeRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
      child: Container(
        child: Wrap(
          children: <Widget>[
            Visibility(
              visible: isloyalityPointsEnabled == true ? true : false,
              child: InkWell(
                onTap: () async {
                       //print("appliedCouponCodeList = ${appliedCouponCodeList.length}");
                  //print("appliedReddemPointsCodeList = ${appliedReddemPointsCodeList.length}");
                  if (isCouponsApplied) {
                    Utils.showToast(
                        "Please remove Applied Coupon to Redeem Loyality Points",
                        false);
                    return;
                  }
                  if (appliedCouponCodeList.isNotEmpty) {
                    Utils.showToast(
                        "Please remove Applied Coupon to Redeem Points", false);
                    return;
                  }
                  if (taxModel != null &&
                      appliedReddemPointsCodeList.isNotEmpty) {
                    removeCoupon();
                  } else {

                    if (addressData == null) {
                      Utils.showToast(
                          "Please select Address", false);
                      return;
                    }

                    List jsonList = Product.encodeToJson(widget.cartList);
                    String encodedDoughnut = jsonEncode(jsonList);
                    Map<String, String> subcriptionMap = Map();
                    subcriptionMap.putIfAbsent(
                        'orderJson', () => encodedDoughnut);
                    subcriptionMap.putIfAbsent('userAddressId',
                            () => addressData == null ? '' : addressData.areaId);
                    subcriptionMap.putIfAbsent(
                        'userAddress', () => userDeliveryAddress);
                    subcriptionMap.putIfAbsent(
                        'deliveryTimeSlot', () => selectedTimeSlotString);
                    subcriptionMap.putIfAbsent('cartSaving', () => cartSaving);
                    subcriptionMap.putIfAbsent(
                        'totalDeliveries', () => totalDeliveries.toString());
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => RedeemPointsScreen(
                              addressData,
                              "",
                             false,
                              addressData.areaId, (model) async {},
                              appliedReddemPointsCodeList, isOrderVariations,
                              responseOrderDetail, shippingCharges,
                              isSubcriptionScreen: true,
                              subcriptionMap: subcriptionMap,
                              subcriptionCallback: (model) async{
                                await updateTaxDetails(model);
                                setState(() {
                                  hideRemoveCouponFirstTime = false;
                                  taxModel = model;
                                  double taxModelTotal =
                                      double.parse(taxModel.total) +
                                          int.parse(shippingCharges);
                                  taxModel.total = taxModelTotal.toString();
                                  appliedReddemPointsCodeList.add(model.couponCode);
                                  print("===discount=== ${model.discount}");
                                  print("taxModel.total=${taxModel.total}");
                                });
                              }),
                          fullscreenDialog: true,
                        ));
                  }
                },
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
                           appliedReddemPointsCodeList.isEmpty
                              ?
                          "Redeem Loyality Points"
                            : "${taxModel.couponCode} Applied",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  appliedCouponCodeList.isEmpty
                                  ? isCouponsApplied
                                  ? appTheme.withOpacity(0.5)
                                  : appTheme
                                  :
                                  appTheme.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    Icon(
                        appliedReddemPointsCodeList.isNotEmpty
                        ? Icons.cancel
                        :
                        Icons.keyboard_arrow_right),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isloyalityPointsEnabled == true ? true : false,
              child: Utils.showDivider(context),
            ),
            InkWell(
              onTap: () {
                print(
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
                  if (addressData == null) {
                    Utils.showToast(
                        "Please select Address", false);
                    return;
                  }

                  List jsonList = Product.encodeToJson(widget.cartList);
                  String encodedDoughnut = jsonEncode(jsonList);
                  Map<String, String> subcriptionMap = Map();
                  subcriptionMap.putIfAbsent(
                      'orderJson', () => encodedDoughnut);
                  subcriptionMap.putIfAbsent('userAddressId',
                      () => addressData == null ? '' : addressData.areaId);
                  subcriptionMap.putIfAbsent(
                      'userAddress', () => userDeliveryAddress);
                  subcriptionMap.putIfAbsent(
                      'deliveryTimeSlot', () => selectedTimeSlotString);
                  subcriptionMap.putIfAbsent('cartSaving', () => cartSaving);
                  subcriptionMap.putIfAbsent(
                      'totalDeliveries', () => totalDeliveries.toString());
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AvailableOffersDialog(
                        addressData,
                        '3',
                        false,
                        addressData.areaId,
                        (model) async {},
                        appliedCouponCodeList,
                        isOrderVariations,
                        responseOrderDetail,
                        shippingCharges,
                        isSubcriptionScreen: true,
                        subcriptionMap: subcriptionMap,
                        subcriptionCallback: (model) async {
                      taxModel = model;
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
                    }),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        isloyalityPointsEnabled ? 0 : 0, 0, 0, 0),
                    height: 40,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: new BoxDecoration(
                      color: whiteColor,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          appliedCouponCodeList.isEmpty
                              ? "Available Offers"
                              : "${taxModel.couponCode} Applied",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: appliedReddemPointsCodeList.isEmpty
                                  ? isCouponsApplied
                                      ? appTheme.withOpacity(0.5)
                                      : appTheme
                                  : appTheme.withOpacity(0.5))),
                    ),
                  ),
                  Icon(appliedCouponCodeList.isNotEmpty
                      ? Icons.cancel
                      : Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> removeCoupon() async {
    bool isNetworkAvailable = await Utils.isNetworkAvailable();
    if (!isNetworkAvailable) {
      Utils.showToast(AppConstant.noInternet, false);
      return;
    }
    Utils.showProgressDialog(context);
    multiTaxCalculationApi(couponCode: '',isRemovedOffer: true);
  }

  Future<void> updateTaxDetails(SubscriptionTaxCalculation taxModel) async {
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
                onPressed: () async {
                  print("---Apply Coupon----");
                  if (couponCodeController.text.trim().isEmpty) {
                  } else {
                    if(addressData==null){
                      Utils.showToast('Please select address', false);
                      return;
                    }

                    print(
                        "--${appliedCouponCodeList.length}-and -${appliedReddemPointsCodeList.length}---");
                    if (appliedCouponCodeList.isNotEmpty ||
                        appliedReddemPointsCodeList.isNotEmpty) {
                      Utils.showToast(
                          "Please remove the applied coupon first!", false);
                      return;
                    }
                    if (isCouponsApplied) {
                      removeCoupon();
                    } else {
                      String couponCode = couponCodeController.text;
                      Utils.showProgressDialog(context);
                      Utils.hideKeyboard(context);
                      List jsonList = Product.encodeToJson(widget.cartList);
                      String encodedDoughnut = jsonEncode(jsonList);
                        ValidateCouponResponse couponModel =
                        await ApiController.validateOfferApiRequest(
                            couponCodeController.text,
                           '3',
                            encodedDoughnut);
                        if (couponModel.success) {
                          print("---success----");
                          Utils.showToast("${couponModel.message}", false);
                          SubscriptionTaxCalculationResponse modelResponse =
                          await ApiController.subscriptionMultipleTaxCalculationRequest(
                              couponCode: couponCode,
                              discount: couponModel.discountAmount,
                              shipping: shippingCharges,
                              orderJson: encodedDoughnut,
                              userAddressId: addressData == null ? '' : addressData.areaId,
                              userAddress: userDeliveryAddress,
                              deliveryTimeSlot: selectedTimeSlotString,
                              cartSaving: cartSaving,
                              totalDeliveries: totalDeliveries.toString()
                          );
                          Utils.hideProgressDialog(context);
                          if (modelResponse != null && !modelResponse.success) {
                            Utils.showToast(modelResponse.message, true);
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          } else {
                            await updateTaxDetails(modelResponse.data);
                            if (modelResponse.data.orderDetail != null &&
                                modelResponse.data.orderDetail.isNotEmpty) {
                              responseOrderDetail =
                                  modelResponse.data.orderDetail;
                              bool someProductsUpdated = false;
                              isOrderVariations =
                                  modelResponse.data.isChanged;
                              for (int i = 0;
                              i < responseOrderDetail.length;
                              i++) {
                                if (responseOrderDetail[i]
                                    .productStatus
                                    .compareTo('out_of_stock') ==
                                    0 ||
                                    responseOrderDetail[i]
                                        .productStatus
                                        .compareTo('price_changed') ==
                                        0) {
                                  someProductsUpdated = true;
                                  break;
                                }
                              }
                              if (someProductsUpdated) {
                                DialogUtils.displayCommonDialog(
                                    context,
                                    widget.model == null
                                        ? ""
                                        : widget.model.storeName,
                                    "Some Cart items were updated. Please review the cart before procceeding.",
                                    buttonText: 'Procceed');
                                constraints();
                              }
                            }
                            calculateTotalSavings();
                            setState(() {
                              taxModel = modelResponse.data;
                              isCouponsApplied = true;
                              couponCodeController.text = couponCode;
                            });
                          }
                        } else {
                          Utils.showToast("${couponModel.message}", false);
                          Utils.hideProgressDialog(context);
                          Utils.hideKeyboard(context);
                        }
                    }
                  }
                },
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
              padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
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
              padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
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
        Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                    "${AppConstant.currency}${databaseHelper.roundOffPrice(taxModel == null ? totalPrice : double.parse(taxModel.total), 2).toStringAsFixed(2)}",
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

  Future<void> multiTaxCalculationApi({
    String couponCode = '',bool isRemovedOffer=false
  }) async {
    constraints();
    bool isNetworkAvailable = await Utils.isNetworkAvailable();
    if (!isNetworkAvailable) {
      Utils.showToast(AppConstant.noInternet, false);
      return;
    }
    userDeliveryAddress = '';
    pin = '';
    if (addressData != null && !isComingFromPickUpScreen) {
      if (addressData.address2 != null && addressData.address2.isNotEmpty) {
        if (addressData.address != null && addressData.address.isNotEmpty) {
          userDeliveryAddress = addressData.address +
              ", " +
              addressData.address2 +
              " " +
              addressData.areaName +
              " " +
              addressData.city;
        } else {
          userDeliveryAddress = addressData.address2 +
              " " +
              addressData.areaName +
              " " +
              addressData.city;
        }
      } else {
        if (addressData.address != null && addressData.address.isNotEmpty) {
          userDeliveryAddress = addressData.address +
              " " +
              addressData.areaName +
              " " +
              addressData.city;
        }
      }

      if (addressData.zipCode != null && addressData.zipCode.isNotEmpty)
        pin = " " + addressData.zipCode;
    }
    isLoading = true;
    userWalleModel = await ApiController.getUserWallet();
//    databaseHelper.getCartItemList(isSubscriptionTable: true).then((cartList) {
//      cartListFromDB = cartList;
    List jsonList = Product.encodeToJson(widget.cartList);
    String encodedDoughnut = jsonEncode(jsonList);
    ApiController.subscriptionMultipleTaxCalculationRequest(
            couponCode: couponCode,
            discount: '',
            shipping: shippingCharges,
            orderJson: encodedDoughnut,
            userAddressId: addressData == null ? '' : addressData.areaId,
            userAddress: userDeliveryAddress,
            deliveryTimeSlot: selectedTimeSlotString,
            cartSaving: cartSaving,
            totalDeliveries: totalDeliveries.toString())
        .then((response) async {
      //{"success":false,"message":"Some products are not available."}
      SubscriptionTaxCalculationResponse model = response;
      Utils.hideProgressDialog(context);
      Utils.hideKeyboard(context);
      if (model!=null&& model.success) {
        taxModel = model.data;
//          widget.cartList =
//              await databaseHelper.getCartItemList(isSubscriptionTable: true);
//        for (int i = 0; i < model.data.taxDetail.length; i++) {
//          Product product = Product();
//          product.taxDetail = taxModel.taxDetail[i];
//          widget.cartList.add(product);
//        }
//        for (var i = 0; i < model.data.fixedTax.length; i++) {
//          Product product = Product();
//          product.fixedTax = taxModel.fixedTax[i];
//          widget.cartList.add(product);
//        }
        if (taxModel.orderDetail != null && taxModel.orderDetail.isNotEmpty) {
          responseOrderDetail = taxModel.orderDetail;
          bool someProductsUpdated = false;
          isOrderVariations = taxModel.isChanged;
          for (int i = 0; i < responseOrderDetail.length; i++) {
            if (responseOrderDetail[i]
                        .productStatus
                        .compareTo('out_of_stock') ==
                    0 ||
                responseOrderDetail[i]
                        .productStatus
                        .compareTo('price_changed') ==
                    0) {
              someProductsUpdated = true;
              break;
            }
          }
          if (someProductsUpdated) {
            DialogUtils.displayCommonDialog(
                context,
                widget.model == null ? "" : widget.model.storeName,
                "Some Cart items were updated. Please review the cart before procceeding.",
                buttonText: 'Procceed');
            constraints();
          }
        }

        calculateTotalSavings();
        setState(() {
          isLoading = false;
        });
        if(isRemovedOffer){
          setState(() {
            hideRemoveCouponFirstTime = true;
            appliedCouponCodeList.clear();
            appliedReddemPointsCodeList.clear();
            isCouponsApplied = false;
            couponCodeController.text = "";
          });
        }

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
//    });
  }

  void constraints() {
    try {
      if (addressData != null) {
        if (addressData.areaCharges != null) {
          if (responseOrderDetail.isNotEmpty && checkThatItemIsInStocks())
            shippingCharges = '0';
          else {
            shippingCharges = addressData.areaCharges;
          }
          //print("-shippingCharges--${widget.address.areaCharges}---");
        }
        //print("----minAmount=${widget.address.minAmount}");
        //print("----notAllow=${widget.address.notAllow}");
        checkMinOrderAmount();
      }
      checkMinOrderPickAmount();
    } catch (e) {
      print(e);
    }
    try {
      if (widget.deliveryType == OrderType.PickUp) {
        databaseHelper
            .getTotalPrice(
                isOrderVariations: isOrderVariations,
                responseOrderDetail: responseOrderDetail)
            .then((mTotalPrice) {
          setState(() {
            totalPrice = mTotalPrice;
          });
        });
      }
    } catch (e) {
      print(e);
    }
    if (responseOrderDetail.isNotEmpty &&
        checkThatItemIsInStocks() &&
        taxModel != null) {
      shippingCharges = '0';
      taxModel.total = '0';
      totalPrice = 0;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> checkMinOrderAmount() async {
    if (widget.deliveryType == OrderType.Delivery) {
      print("----minAmount=${addressData.minAmount}");
      print("----notAllow=${addressData.notAllow}");
      print("--------------------------------------------");
      int minAmount = 0;
      try {
        try {
          minAmount = double.parse(addressData.minAmount).toInt();
        } catch (e) {
          print(e);
        }
        double totalPrice = await databaseHelper.getTotalPrice(
            isOrderVariations: isOrderVariations,
            responseOrderDetail: responseOrderDetail);
        int mtotalPrice = totalPrice.round();

        print("----minAmount=${minAmount}");
        print("--Cart--mtotalPrice=${mtotalPrice}");
        print("----shippingCharges=${shippingCharges}");

        if (addressData.notAllow) {
          if (mtotalPrice <= minAmount) {
            print("---Cart-totalPrice is less than min amount----}");
            // then Store will charge shipping charges.
            minOrderCheck = false;
            setState(() {
              this.totalPrice = mtotalPrice.toDouble();
            });
          } else {
            minOrderCheck = true;
            setState(() {
              this.totalPrice = mtotalPrice.toDouble();
            });
          }
        } else {
          if (mtotalPrice <= minAmount) {
            print("---Cart-totalPrice is less than min amount----}");
            // then Store will charge shipping charges.
            setState(() {
              this.totalPrice = totalPrice + int.parse(shippingCharges);
            });
          } else {
            print("-Cart-totalPrice is greater than min amount---}");
            //then Store will not charge shipping.
            setState(() {
              this.totalPrice = totalPrice;
              shippingCharges = "0";
              addressData.areaCharges = "0";
            });
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> checkMinOrderPickAmount() async {
    if (widget.deliveryType == OrderType.PickUp && addressData != null) {
      print("----minAmount=${addressData.minAmount}");
      print("----notAllow=${addressData.notAllow}");
      print("--------------------------------------------");
      int minAmount = 0;
      try {
        try {
          if (addressData.minAmount.isNotEmpty)
            minAmount = double.parse(addressData.minAmount).toInt();
        } catch (e) {
          print(e);
        }
        double totalPrice = await databaseHelper.getTotalPrice(
            isOrderVariations: isOrderVariations,
            responseOrderDetail: responseOrderDetail);
        int mtotalPrice = totalPrice.round();

        print("----minAmount=${minAmount}");
        print("--Cart--mtotalPrice=${mtotalPrice}");
        //TODO:In Future check here "not allow".
        if (mtotalPrice <= minAmount) {
          print("---Cart-totalPrice is less than min amount----}");
          // then Store will charge shipping charges.
          minOrderCheck = false;
          setState(() {
            this.totalPrice = mtotalPrice.toDouble();
          });
        } else {
          minOrderCheck = true;
          setState(() {
            this.totalPrice = mtotalPrice.toDouble();
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  bool minOrderCheck = true;

  void calculateTotalSavings() {
    //calculate total savings
    totalMRpPrice = 0;
    totalSavings = 0;
    if (widget.cartList != null && widget.cartList.isNotEmpty) {
      for (Product product in widget.cartList) {
        if (product != null &&
            product.mrpPrice != null &&
            product.price != null &&
            product.quantity != null) {
          bool isProductOutOfStock = false;
          OrderDetail detail;
          //check product is out of stock of not
          if (isOrderVariations) {
            InnnerFor:
            for (int i = 0; i < responseOrderDetail.length; i++) {
              if (responseOrderDetail[i]
                          .productStatus
                          .compareTo('out_of_stock') ==
                      0 &&
                  responseOrderDetail[i].productId.compareTo(product.id) == 0 &&
                  responseOrderDetail[i]
                          .variantId
                          .compareTo(product.variantId) ==
                      0) {
                isProductOutOfStock = true;
                break InnnerFor;
              }
              if (responseOrderDetail[i]
                          .productStatus
                          .compareTo('price_changed') ==
                      0 &&
                  responseOrderDetail[i].productId.compareTo(product.id) == 0 &&
                  responseOrderDetail[i]
                          .variantId
                          .compareTo(product.variantId) ==
                      0) {
                detail = responseOrderDetail[i];
                break InnnerFor;
              }
            }
          }

          if (!isProductOutOfStock) {
            String mrpPrice =
                detail != null && detail.productStatus.contains('price_changed')
                    ? detail.newMrpPrice
                    : product.mrpPrice;
            String price =
                detail != null && detail.productStatus.contains('price_changed')
                    ? detail.newPrice
                    : product.price;
            totalSavings += (double.parse(mrpPrice) - double.parse(price)) *
                double.parse(product.quantity);
            totalMRpPrice +=
                (double.parse(mrpPrice) * double.parse(product.quantity));
          }
        }
      }
      //Y is P% of X
      //P% = Y/X
      //P= (Y/X)*100
      double totalSavedPercentage = (totalSavings / totalMRpPrice) * 100;
      totalSavingsText =
//          "${databaseHelper.roundOffPrice(totalSavings, 2).toStringAsFixed(2)} (${totalSavedPercentage.toStringAsFixed(2)}%)";
          "${databaseHelper.roundOffPrice(totalSavings, 2).toStringAsFixed(2)}";
      setState(() {});
    }
  }

  bool checkThatItemIsInStocks() {
    bool isAllItemsInOutOfStocks = true;
    for (int j = 0; j < widget.cartList.length; j++) {
      Product product = widget.cartList[j];
      if (product.id != null) {
        //check product is out of stock
        bool productOutOfStock = _checkIsProductISOutOfStock(product);
        if (!productOutOfStock) {
          isAllItemsInOutOfStocks = false;
          break;
        }
      }
    }
    return isAllItemsInOutOfStocks;
  }

  bool _checkIsProductISOutOfStock(Product product) {
    bool productOutOfStock = false;
    for (int i = 0; i < responseOrderDetail.length; i++) {
      if (product.id.compareTo(responseOrderDetail[i].productId) == 0 &&
          product.variantId.compareTo(responseOrderDetail[i].variantId) == 0) {
        if (responseOrderDetail[i].productStatus.compareTo('out_of_stock') ==
            0) {
          productOutOfStock = true;
        } else {
          productOutOfStock = false;
        }
        break;
      }
    }
    return productOutOfStock;
  }
}
