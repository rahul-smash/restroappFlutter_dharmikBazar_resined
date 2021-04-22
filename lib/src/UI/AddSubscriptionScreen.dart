import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:intl/intl.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/Screens/Address/StoreLocationScreenWithMultiplePick.dart';
import 'package:restroapp/src/Screens/Offers/AvailableOffersList.dart';
import 'package:restroapp/src/Screens/Offers/RedeemPointsScreen.dart';
import 'package:restroapp/src/Screens/SideMenu/SubscriptionHistory.dart';
import 'package:restroapp/src/UI/PickUpBottomSheet.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CreateOrderData.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/DeliveryTimeSlotModel.dart';
import 'package:restroapp/src/models/OrderDetailsModel.dart';
import 'package:restroapp/src/models/PickUpModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/models/SubscriptionOrderDetailsModel.dart';
import 'package:restroapp/src/models/SubscriptionTaxCalculationResponse.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/models/ValidateCouponsResponse.dart';
import 'package:restroapp/src/models/WalleModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/BaseState.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProductSubcriptonTileView.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restroapp/src/models/RazorpayOrderData.dart';

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
  Area areaObject;
  bool isCouponsApplied = false;
  List<Product> cartListFromDB = List();

  bool isLoading = true;

  WalleModel userWalleModel;

  String shippingCharges = '0';

  SubscriptionTaxCalculation taxModel;

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
  List<String> _deliveryOptions = List();

  String _selectedDeliveryOption = '';

  PickUpModel storeArea;
  UserModel user;

  bool yearlySubscriptionPack = false;

  getProfileData() async {
    try {
      user = await SharedPrefs.getUser();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getProfileData();
    _deliveryOptions.add('Delivery');
    _deliveryOptions.add('Pick Up');
    _selectedDeliveryOption = _deliveryOptions.first;
    initRazorPay();
    checkLoyalityPointsOption();
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
        this.areaObject = event.areaObject;
      });
//      Utils.showProgressDialog(context);
      multiTaxCalculationApi(couponCode: couponCodeApplied);
    });
    eventBus.on<onSubscribeProduct>().listen((event) {
      if (event != null && event.product != null) {
        widget.cartList.first = event.product;
        widget.cartList.first.quantity = event.quanity;
      }
      setState(() {});
      Utils.showProgressDialog(context);
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

    ApiController.getStorePickupAddress().then((response) {
      Utils.hideProgressDialog(context);
      storeArea = response;

      print('---PickUpModel---${storeArea.data.length}--');
      setState(() {});
    });
  }

  Future<bool> couponAppliedCheck(Product product, String quanity) async {
    setState(() {});
    if (taxModel != null &&
        taxModel.discount != null &&
        taxModel.discount.isNotEmpty) {
      return await DialogUtils.displayDialog(
          context,
          'Are you sure?',
          'Your Applied Coupon code will be removed!',
          'No',
          'Yes', button2: () {
        if (product != null) {
          widget.cartList.first = product;
          widget.cartList.first.quantity = quanity;
        }
        setState(() {
          hideRemoveCouponFirstTime = true;
          appliedCouponCodeList.clear();
          appliedReddemPointsCodeList.clear();
          isCouponsApplied = false;
          couponCodeController.text = "";
        });
        Navigator.of(context).pop(true);
      }, button1: () {
        Navigator.of(context).pop(false);
      });
    } else {
      return Future(() => true);
    }
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
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Delivery'),
                        value: 'Delivery',
                        activeColor: appTheme,
                        groupValue: _selectedDeliveryOption,
                        onChanged: (String value) async {
                          bool proceed = await couponAppliedCheck(
                              widget.cartList.first,
                              widget.cartList.first.quantity);
                          if (proceed) {
                            setState(() {
                              _selectedDeliveryOption = value;
                              widget.deliveryType = OrderType.Delivery;
                              multiTaxCalculationApi(
                                  couponCode: couponCodeApplied);
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Pick Up'),
                        value: 'Pick Up',
                        activeColor: appTheme,
                        groupValue: _selectedDeliveryOption,
                        onChanged: (String value) async {
                          bool proceed = await couponAppliedCheck(
                              widget.cartList.first,
                              widget.cartList.first.quantity);
                          if (!proceed) return;
                          multiTaxCalculationApi(couponCode: couponCodeApplied);
                          setState(() {
                            _selectedDeliveryOption = value;
                            widget.deliveryType = OrderType.PickUp;
                          });
                          if (storeArea == null ||
                              (storeArea != null && storeArea.data.isEmpty)) {
                            Utils.showToast("No pickup data found!", true);
                          } else {
                            PickUpBottomSheet.showBottomSheet(
                                context, storeArea, OrderType.PickUp);
                          }
                        },
                      ),
                    )
                  ],
                ),
                Container(
                  height: 1,
                  color: Colors.grey,
                ),
                _selectedDeliveryOption == 'Delivery'
                    ? addressData == null
                        ? Container(
                            child: InkWell(
                              onTap: () async {
                                if (AppConstant.isLoggedIn) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DeliveryAddressList(
                                                true, OrderType.SubScription)),
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
                              child: Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 25.0,
                                    ),
                                    Text(
                                      "Add Delivery Address",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Deliver To",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                          "${addressData.address} ${addressData.address2.isNotEmpty ? ', ' + addressData.address2 : ''}",
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
                                                    DeliveryAddressList(
                                                        true,
                                                        OrderType
                                                            .SubScription)),
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
                          )
                    : Container(
                        padding: EdgeInsets.only(left: 12, right: 12),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    if (storeArea == null ||
                                        (storeArea != null &&
                                            storeArea.data.isEmpty)) {
                                      Utils.showToast(
                                          "No pickup data found!", true);
                                    } else {
                                      PickUpBottomSheet.showBottomSheet(
                                          context, storeArea, OrderType.PickUp);
                                    }
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Pick-Up Address",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 16)),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Text(
                                            areaObject != null
                                                ? "${areaObject.pickupAdd}"
                                                : "Add Pick Address",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                      ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  height: 1,
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
                                            yearlySubscriptionPack = false;
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
                                            isStartIndex: true,
                                            isEndIndex: true,
                                          );
                                          if (selectedEndDate != null) {
                                            _markedDateMap.clear();
                                            yearlySubscriptionPack = false;
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
                widget.deliveryType != OrderType.PickUp
                    ? Column(
                        children: [
                          showDeliverySlot(),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                            height: 5,
                            color: Colors.grey[400],
                          ),
                        ],
                      )
                    : Container(),
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
                                        yearlySubscriptionPack = false;
                                        int year =
                                            getDatesInBeteween.first.year;
                                        for (var i = 0;
                                            i < getDatesInBeteween.length;
                                            i++) {
                                          if (getDatesInBeteween[i].year !=
                                              year) {
                                            yearlySubscriptionPack = true;
                                          }
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
//                                        Utils.showProgressDialog(context);
                                        multiTaxCalculationApi(
                                            couponCode: couponCodeApplied);
                                        setState(() {
                                          selecteddays = index;
                                        });
                                      } else {
                                        _markedDateMap.clear();
                                        yearlySubscriptionPack = false;
                                        List<DateTime> getDatesInBeteween =
                                            Utils.getDatesInBeteween(
                                                selectedStartDate,
                                                selectedEndDate);
                                        int year =
                                            getDatesInBeteween.first.year;
                                        for (var i = 0;
                                            i < getDatesInBeteween.length;
                                            i++) {
                                          if (i % days == 0) {
                                            if (getDatesInBeteween[i].year !=
                                                year) {
                                              yearlySubscriptionPack = true;
                                            }
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
//                                        Utils.showProgressDialog(context);
                                        multiTaxCalculationApi(
                                            couponCode: couponCodeApplied);
                                        setState(() {
                                          selecteddays = index;
                                        });
                                      }
                                    } else if (selectedStartDate == null) {
                                      DialogUtils.displayErrorDialog(
                                          context, "Please select Start Date");
                                    } else if (selectedEndDate == null) {
                                      DialogUtils.displayErrorDialog(
                                          context, "Please select End Date");
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
                    widget.selectedVariant,
                    couponAppliedCheck),
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
              if (_selectedDeliveryOption == 'Delivery' &&
                  addressData == null) {
                DialogUtils.displayErrorDialog(
                    context, 'Please Select Delivery Address');
              } else if (_selectedDeliveryOption
                      .toLowerCase()
                      .contains('pick') &&
                  areaObject == null) {
                DialogUtils.displayErrorDialog(
                    context, 'Please Select Pick Up Address');
              } else if (taxModel == null) {
                DialogUtils.displayErrorDialog(
                    context, 'Calculation are not done yet, Please try again');
              } else if (selectedTimeSlotString.isEmpty) {
                DialogUtils.displayErrorDialog(
                    context, 'Please Select time slot');
              } else if (selectedStartDate == null) {
                DialogUtils.displayErrorDialog(
                    context, 'Please Select Start Subscription Date');
              } else if (selectedEndDate == null) {
                DialogUtils.displayErrorDialog(
                    context, 'Please Select End Subscription Date');
              } else if (_markedDateMap.events.isEmpty) {
                DialogUtils.displayErrorDialog(
                    context, 'Please Select Variant Dates');
              } else if (widget.cartList.isEmpty) {
                DialogUtils.displayErrorDialog(
                    context, 'Please add product to Subscription cart');
              } else if (widget.cartList.first.quantity == '0') {
                DialogUtils.displayErrorDialog(context, 'Please add Quantity');
              } else if (double.parse(
                      widget.model.subscription.minimumOrderDaily) >
                  double.parse(taxModel.singleDayTotal) -
                      double.parse(shippingCharges)) {
                DialogUtils.displayErrorDialog(
                  context,
                  'Your Daily Minimum Order is very less for Subscription.',
                );
              } else {
                bottomSheet(context);
              }
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
            builder: (BuildContext context, setStateBottomSheet) {
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
                        Stack(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: Image.asset('images/bg_subscription.jpg',
                                    fit: BoxFit.cover)),
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
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
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  child: Text(
                                    "Your Total${widget.deliveryType == OrderType.Delivery ? ' deliveries' : ' Pick-ups'}",
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
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                          child: Text(
                            "Date",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff797C82),
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/calendargreyicon.png',
                                fit: BoxFit.scaleDown,
                                height: 15,
                                width: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  subscribedDatesBottomSheet(context);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Center(
                                    child: Text('Delivery slots',
                                        style: TextStyle(
                                          color: appTheme,
                                          decoration: TextDecoration.underline,
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        widget.deliveryType == OrderType.Delivery
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    child: Text(
                                      "Time",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xff797C82),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'images/timegreyicon.png',
                                          fit: BoxFit.scaleDown,
                                          height: 15,
                                          width: 15,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Center(
                                            child: Text(
                                                '${selectedTimeSlotString}',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 0,
                                        bottom: 16,
                                        left: 16,
                                        right: 16),
                                    color: Color(0xFFE1E1E1),
                                    height: 1,
                                  ),
                                ],
                              )
                            : SizedBox(
                                height: 10,
                              ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.deliveryType ==
                                                OrderType.Delivery
                                            ? "Address"
                                            : "Pick Up Address",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Row(
                                          children: [
                                            Text(
                                              "${_selectedDeliveryOption == 'Delivery' ? addressData.firstName : user.fullName}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        _selectedDeliveryOption == 'Delivery'
                                            ? "${addressData.address}${addressData.address2.isNotEmpty ? ', ' + addressData.address2 : ""}"
                                            : areaObject.pickupAdd,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          color: Color(0xFFE1E1E1),
                          height: 3,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 15, 3),
                          child: Text(
                            widget.deliveryType == OrderType.Delivery
                                ? 'Your total deliveries amount is:'
                                : 'Your total amount is:',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(25, 0, 15, 0),
                          child: Text(
                              '${AppConstant.currency}${taxModel.total}',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 24)),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 0, bottom: 16, left: 16, right: 16),
                          color: Color(0xFFE1E1E1),
                          height: 1,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 5, 15, 10),
                          child: Row(
                            children: [
                              Icon(
                                Icons.radio_button_checked,
                                color: appTheme,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Image.asset(
                                'images/onlinepayicon.png',
                                color: appTheme,
                                fit: BoxFit.scaleDown,
                                height: 30,
                                width: 30,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Center(
                                  child: Text('Online Pay Full Amount',
                                      style: TextStyle(
                                        color: Colors.black,
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                        Visibility(
                          visible:
                              widget.model.wallet_setting == "1" ? true : false,
                          child: Container(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 0, top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                      child: Icon(
                                        Icons.done,
                                        color: appTheme,
                                        size: 30,
                                      ),
                                    ),
                                    Image.asset(
                                      'images/walleticon.png',
                                      color: appTheme,
                                      fit: BoxFit.scaleDown,
                                      height: 30,
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("My Wallet",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              taxModel == null
                                                  ? "Remaining Balance: ${AppConstant.currency}"
                                                  : "Remaining Balance: ${AppConstant.currency} ${getUserRemaningWallet()}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: 5, top: 0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("You Used",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16)),
                                          Text(
                                              "${AppConstant.currency} ${taxModel == null ? "0.00" : databaseHelper.roundOffPrice(double.parse(taxModel.walletRefund.toString()), 2).toStringAsFixed(2)}",
                                              style: TextStyle(
                                                  color: appTheme,
                                                  fontSize: 15)),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(26, 16, 26, 16),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Container(
                                decoration: new BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(5.0)),
                                ),
                                child: FlatButton(
                                  child: Text(
                                    'Place Order',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  color: appTheme,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    //todo:hit api
                                    callOrderIdApi(widget.model);
                                  },
                                ),
                              ))
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

  subscribedDatesBottomSheet(context) async {
    Map<String, List<String>> datesMap = Map();
    if (_markedDateMap.events.isNotEmpty) {
      var monthYearFormatter = new DateFormat('MMMM yyyy');

      String monthYear =
          monthYearFormatter.format(_markedDateMap.events.keys.first);

      try {
        for (DateTime event in _markedDateMap.events.keys) {
          String monthYearLocal = monthYearFormatter.format(event);
          if (monthYear != monthYearLocal) {
            monthYear = monthYearLocal;
          }
          var formatter = new DateFormat('dd-MM-yyyy');
          String formatted = formatter.format(event);

          if (datesMap[monthYear] == null) {
            List<String> selectedDatesList = List();
            selectedDatesList.add(formatted);
            datesMap.putIfAbsent(monthYear, () => selectedDatesList);
          } else {
            List<String> selectedDatesList = datesMap[monthYear];
            selectedDatesList.add(formatted);
            datesMap[monthYear] = selectedDatesList;
          }
        }
      } catch (e) {
        print(e);
      }
    }

    await showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        enableDrag: false,
        builder: (BuildContext bc) {
          return StatefulBuilder(
            builder: (BuildContext context, setStateBottomSheet) {
              return SafeArea(
                  child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 15, 15, 5),
                            child: Image.asset(
                              'images/cancelicon.png',
                              fit: BoxFit.scaleDown,
                              height: 16,
                              width: 16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 20, 15),
                        child: Text(
                          'Selected Dates',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color(0xFFBDBDBF),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: datesMap.keys
                              .map((e) => Container(
                                    margin: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              'images/calendargreyicon.png',
                                              fit: BoxFit.scaleDown,
                                              height: 14,
                                              color: Color(0xFFBDBDBF),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Text(
                                              '${e}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),

//                                      Wrap()
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Wrap(
                                          spacing: 15,
                                          children: datesMap[e]
                                              .map((z) => Container(
                                                    margin: EdgeInsets.all(10),
                                                    child: Text(
                                                      z,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ))
                                              .toList(),
                                        )
                                      ],
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(26, 16, 26, 16),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              decoration: new BoxDecoration(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(5.0)),
                              ),
                              child: FlatButton(
                                child: Text(
                                  'Place Order',
                                  style: TextStyle(fontSize: 17),
                                ),
                                color: appTheme,
                                textColor: Colors.white,
                                onPressed: () {
                                  //todo:hit api
                                  callOrderIdApi(widget.model);
                                },
                              ),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
            },
          );
        });
  }

  String getUserRemaningWallet() {
    double balance = (double.parse(userWalleModel.data.userWallet) -
        double.parse(taxModel.walletRefund.toString()) -
        double.parse(taxModel.shipping));
    //print("balance=${balance}");
    if (balance > 0.0) {
      // USer balance is greater than zero.
      return databaseHelper.roundOffPrice(balance, 2).toStringAsFixed(2);
    } else {
      // USer balance is less than or equal to zero.
      return "0.00";
    }
    //return "${userWalleModel == null ? "" : userWalleModel.data.userWallet}";
  }

  void callOrderIdApi(StoreModel storeObject) async {
    Utils.showProgressDialog(context);
    bool isFullPaymentFromWallet = checkFullPaymentFromWallet();
    double price = double.parse(taxModel.total); //totalPrice ;
    print("=======1===${price}===total==${taxModel.total}======");
    price = price * 100;
    print("=======2===${price}===========");
    String mPrice =
        price.toString().substring(0, price.toString().indexOf('.'));
    print("=======mPrice===${mPrice}===========");
    UserModel user = await SharedPrefs.getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    //new changes
    List jsonList = Product.encodeToJson(widget.cartList);

    String encodedDoughnut = jsonEncode(jsonList);
    String storeAddress = "";
    try {
      storeAddress = "${widget.model.storeName}, ${widget.model..location},"
          "${widget.model.city}, ${widget.model.state}, ${widget.model.country}, ${widget.model.zipcode}";
    } catch (e) {
      print(e);
    }

    List<String> selectedDatesList = List();
    try {
      for (DateTime event in _markedDateMap.events.keys) {
        var formatter = new DateFormat('yyyy-MM-dd');
        String formatted = formatter.format(event);
        selectedDatesList.add(formatted);
      }
    } catch (e) {
      print(e);
    }

    String encodedDateList = jsonEncode(selectedDatesList);
    String start_date = '',
        end_date = '',
        single_day_shipping_charges = taxModel.singleDayShipping,
        single_day_total = taxModel.singleDayTotal,
        single_day_discount = taxModel.singleDayDiscount,
        single_day_tax = taxModel.singleDayTax,
        single_day_checkout = taxModel.singleDayTotal,
        subscription_type =
            widget.model.subscription.cycleType[selecteddays].key,
        delivery_dates = encodedDateList,
        total_deliveries = totalDeliveries.toString();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(selectedStartDate);
    start_date = formatted;
    formatted = formatter.format(selectedEndDate);
    end_date = formatted;

    String userId = user.id;

    SubscriptionOrderDetailsModel detailsModel = SubscriptionOrderDetailsModel(
      shippingCharges,
      '',
      totalPrice.toString(),
      '3',
      taxModel,
      addressData,
      _selectedDeliveryOption != 'Delivery',
      _selectedDeliveryOption == 'Delivery'
          ? addressData.areaId
          : areaObject.areaId,
      widget.deliveryType,
      "",
      "",
      deviceId,
      isFullPaymentFromWallet ? "Razorpay" : 'wallet',
      userId,
      deviceToken,
      storeAddress,
      widget.deliveryType == OrderType.PickUp ? '' : selectedTimeSlotString,
      totalSavingsText,
      start_date: start_date,
      end_date: end_date,
      single_day_shipping_charges: single_day_shipping_charges,
      single_day_total: single_day_total,
      single_day_discount: single_day_discount,
      single_day_tax: single_day_tax,
      single_day_checkout: single_day_checkout,
      subscription_type: subscription_type,
      delivery_dates: delivery_dates,
      total_deliveries: total_deliveries,
    );

    if (isFullPaymentFromWallet) {
      Utils.hideProgressDialog(context);
      placeOrderApi(
          payment_request_id: '',
          payment_id: '',
          isFullPaymentFromWallet: isFullPaymentFromWallet);
    } else {
      ApiController.subscriptionRazorpayCreateOrderApi(
              mPrice, encodedDoughnut, detailsModel.orderDetails)
          .then((response) {
        CreateOrderData model = response;
        if (model != null && response.success) {
          print("----razorpayCreateOrderApi----${response.data.id}--");
          openCheckout(model.data.id, storeObject);
        } else {
          Utils.hideProgressDialog(context);
          DialogUtils.displayErrorDialog(
              context, model.message ?? "${model.message}");
        }
      });
    }
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
                                DialogUtils.displayErrorDialog(
                                    context, slotsObject.innerText);
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
          visible:
              widget.deliveryType == OrderType.Delivery && addressData == null
                  ? false
                  : true,
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
        Visibility(
          visible: taxModel != null &&
              taxModel.taxDetail != null &&
              taxModel.taxDetail.isNotEmpty &&
              taxModel.taxDetail.first.tax.isNotEmpty,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    taxModel == null
                        ? ''
                        : taxModel.taxDetail != null &&
                                taxModel.taxDetail.isNotEmpty
                            ? taxModel.taxDetail.first.label
                            : '',
                    style: TextStyle(color: Colors.black)),
                Text(
                    "${AppConstant.currency}${taxModel == null ? '0' : taxModel.taxDetail != null && taxModel.taxDetail.isNotEmpty ? taxModel.taxDetail.first.tax : '0'}",
                    style: TextStyle(color: Colors.black)),
              ],
            ),
          ),
        ),
        addFixedTax(),
        addMRPPrice(),
        addTotalSavingPrice(),
        Visibility(
          visible: widget.model.wallet_setting == "1" ? true : false,
          child: Container(
            child: Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
//                    Padding(
//                      padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
//                      child: Icon(
//                        Icons.done,
//                        color: appTheme,
//                        size: 30,
//                      ),
//                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("My Wallet",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              taxModel == null
                                  ? "Remaining Balance: ${AppConstant.currency}"
                                  : "Remaining Balance: ${AppConstant.currency} ${getUserRemaningWallet()}",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("You Used",
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                        Text(
                            "${AppConstant.currency} ${taxModel == null ? "0.00" : databaseHelper.roundOffPrice(double.parse(taxModel.walletRefund.toString()), 2).toStringAsFixed(2)}",
                            style: TextStyle(color: appTheme, fontSize: 15)),
                      ],
                    ),
                  ],
                )),
          ),
        ),
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
                  if (selectedStartDate == null) {
                    DialogUtils.displayErrorDialog(
                        context, 'Please Select Start Subscription Date');
                    return;
                  } else if (selectedEndDate == null) {
                    DialogUtils.displayErrorDialog(
                        context, 'Please Select End Subscription Date');
                    return;
                  } else if (_markedDateMap.events.isEmpty) {
                    DialogUtils.displayErrorDialog(
                        context, 'Please Select Variant Dates');
                    return;
                  } else if (widget.cartList.first.quantity == '0') {
                    DialogUtils.displayErrorDialog(
                        context, 'Please add some quantity!');
                    return;
                  }
                  if (isCouponsApplied) {
                    DialogUtils.displayErrorDialog(
                      context,
                      "Please remove Applied Coupon to Redeem Loyality Points",
                    );
                    return;
                  }
                  if (appliedCouponCodeList.isNotEmpty) {
                    DialogUtils.displayErrorDialog(context,
                        "Please remove Applied Coupon to Redeem Points");
                    return;
                  }
                  if (taxModel != null &&
                      appliedReddemPointsCodeList.isNotEmpty) {
                    removeCoupon();
                  } else {
                    if (widget.deliveryType == OrderType.Delivery &&
                            addressData == null ||
                        widget.deliveryType == OrderType.PickUp &&
                            areaObject == null) {
                      DialogUtils.displayErrorDialog(
                          context, "Please select Address");
                      return;
                    }

                    List jsonList = Product.encodeToJson(widget.cartList);
                    String encodedDoughnut = jsonEncode(jsonList);
                    Map<String, String> subcriptionMap = Map();
                    subcriptionMap.putIfAbsent(
                        'orderJson', () => encodedDoughnut);
                    subcriptionMap.putIfAbsent(
                        'userAddressId',
                        () => widget.deliveryType == OrderType.Delivery
                            ? addressData == null
                                ? ''
                                : addressData.areaId
                            : areaObject == null
                                ? ''
                                : areaObject.areaId);
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
                              widget.deliveryType != OrderType.Delivery,
                              widget.deliveryType == OrderType.Delivery
                                  ? addressData.areaId
                                  : areaObject.areaId,
                              (model) async {},
                              appliedReddemPointsCodeList,
                              isOrderVariations,
                              responseOrderDetail,
                              shippingCharges,
                              isSubcriptionScreen: true,
                              subcriptionMap: subcriptionMap,
                              subcriptionCallback: (model) async {
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
                              ? "Redeem Loyality Points"
                              : "${taxModel.couponCode} Applied",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: appliedCouponCodeList.isEmpty
                                  ? isCouponsApplied
                                      ? appTheme.withOpacity(0.5)
                                      : appTheme
                                  : appTheme.withOpacity(0.5)),
                        ),
                      ),
                    ),
                    Icon(appliedReddemPointsCodeList.isNotEmpty
                        ? Icons.cancel
                        : Icons.keyboard_arrow_right),
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
                if (selectedStartDate == null) {
                  DialogUtils.displayErrorDialog(
                      context, 'Please Select Start Subscription Date');
                  return;
                } else if (selectedEndDate == null) {
                  DialogUtils.displayErrorDialog(
                      context, 'Please Select End Subscription Date');
                  return;
                } else if (_markedDateMap.events.isEmpty) {
                  DialogUtils.displayErrorDialog(
                      context, 'Please Select Variant Dates');
                  return;
                } else if (widget.cartList.first.quantity == '0') {
                  DialogUtils.displayErrorDialog(
                      context, 'Please add some quantity!');
                  return;
                }
                print(
                    "appliedCouponCodeList = ${appliedCouponCodeList.length}");
                print(
                    "appliedReddemPointsCodeList = ${appliedReddemPointsCodeList.length}");
                if (isCouponsApplied) {
                  DialogUtils.displayErrorDialog(
                      context, "Please remove Applied Coupon to Avail Offers");
                  return;
                }
                if (appliedReddemPointsCodeList.isNotEmpty) {
                  DialogUtils.displayErrorDialog(
                      context, "Please remove Applied Coupon to Avail Offers");
                  return;
                }
                if (taxModel != null && appliedCouponCodeList.isNotEmpty) {
                  removeCoupon();
                } else {
                  if (widget.deliveryType == OrderType.Delivery &&
                          addressData == null ||
                      widget.deliveryType == OrderType.PickUp &&
                          areaObject == null) {
                    DialogUtils.displayErrorDialog(
                        context, "Please select Address");
                    return;
                  }

                  List jsonListCouponProduct =
                      encodeToJsonForCoupon(widget.cartList);
                  String encodedCouponProduct =
                      jsonEncode(jsonListCouponProduct);

                  List jsonList = Product.encodeToJson(widget.cartList);
                  String encodedDoughnut = jsonEncode(jsonList);
                  Map<String, String> subcriptionMap = Map();
                  subcriptionMap.putIfAbsent(
                      'orderJson', () => encodedDoughnut);
                  subcriptionMap.putIfAbsent(
                      'jsonListCouponProduct', () => encodedCouponProduct);
                  subcriptionMap.putIfAbsent(
                      'userAddressId',
                      () => widget.deliveryType != OrderType.Delivery
                          ? areaObject.areaId
                          : addressData.areaId);
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
                        widget.deliveryType != OrderType.Delivery,
                        widget.deliveryType == OrderType.Delivery
                            ? addressData.areaId
                            : areaObject.areaId,
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
      DialogUtils.displayErrorDialog(context, AppConstant.noInternet);
      return;
    }
    Utils.showProgressDialog(context);
    multiTaxCalculationApi(couponCode: '', isRemovedOffer: true);
  }

  Future<void> updateTaxDetails(SubscriptionTaxCalculation taxModel) async {
//    widget.cartList = await databaseHelper.getCartItemList();
//    for (int i = 0; i < taxModel.taxDetail.length; i++) {
//      Product product = Product();
//      product.taxDetail = taxModel.taxDetail[i];
//      widget.cartList.add(product);
//    }
//    for (var i = 0; i < taxModel.fixedTax.length; i++) {
//      Product product = Product();
//      product.fixedTax = taxModel.fixedTax[i];
//      widget.cartList.add(product);
//    }
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
                  if (selectedStartDate == null) {
                    DialogUtils.displayErrorDialog(
                        context, 'Please Select Start Subscription Date');
                    return;
                  } else if (selectedEndDate == null) {
                    DialogUtils.displayErrorDialog(
                        context, 'Please Select End Subscription Date');
                    return;
                  } else if (_markedDateMap.events.isEmpty) {
                    DialogUtils.displayErrorDialog(
                        context, 'Please Select Variant Dates');
                    return;
                  } else if (couponCodeController.text.trim().isEmpty) {
                    return;
                  } else {
                    if (widget.deliveryType == OrderType.Delivery &&
                            addressData == null ||
                        widget.deliveryType == OrderType.PickUp &&
                            areaObject == null) {
                      DialogUtils.displayErrorDialog(
                          context, 'Please select address');
                      return;
                    }

                    print(
                        "--${appliedCouponCodeList.length}-and -${appliedReddemPointsCodeList.length}---");
                    if (appliedCouponCodeList.isNotEmpty ||
                        appliedReddemPointsCodeList.isNotEmpty) {
                      DialogUtils.displayErrorDialog(
                          context, "Please remove the applied coupon first!");
                      return;
                    }
                    if (isCouponsApplied) {
                      removeCoupon();
                    } else {
                      String couponCode = couponCodeController.text;
                      Utils.showProgressDialog(context);
                      Utils.hideKeyboard(context);
                      List jsonList = encodeToJsonForCoupon(widget.cartList);
                      String encodedDoughnut = jsonEncode(jsonList);
                      ValidateCouponResponse couponModel =
                          await ApiController.validateOfferApiRequest(
                              couponCodeController.text, '3', encodedDoughnut,widget.deliveryType==OrderType.PickUp?'1':'2');
                      if (couponModel.success) {
                        print("---success----");
                        Utils.hideProgressDialog(context);
                        DialogUtils.displayErrorDialog(
                            context, "${couponModel.message}");
                        List jsonList = Product.encodeToJson(widget.cartList);
                        String encodedDoughnut = jsonEncode(jsonList);
                        SubscriptionTaxCalculationResponse modelResponse =
                            await ApiController
                                .subscriptionMultipleTaxCalculationRequest(
                                    couponCode: couponCode,
                                    discount: couponModel.discountAmount,
                                    shipping: shippingCharges,
                                    orderJson: encodedDoughnut,
                                    userAddressId: widget.deliveryType !=
                                            OrderType.Delivery
                                        ? areaObject == null
                                            ? ''
                                            : areaObject.areaId
                                        : addressData == null
                                            ? ''
                                            : addressData.areaId,
                                    userAddress: userDeliveryAddress,
                                    deliveryTimeSlot:
                                        widget.deliveryType == OrderType.PickUp
                                            ? ''
                                            : selectedTimeSlotString,
                                    cartSaving: cartSaving,
                                    totalDeliveries:
                                        totalDeliveries.toString());
                        Utils.hideProgressDialog(context);
                        if (modelResponse != null && !modelResponse.success) {
                          DialogUtils.displayErrorDialog(
                              context, modelResponse.message);
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        } else {
                          await updateTaxDetails(modelResponse.data);
                          if (modelResponse.data.orderDetail != null &&
                              modelResponse.data.orderDetail.isNotEmpty) {
                            responseOrderDetail =
                                modelResponse.data.orderDetail;
                            bool someProductsUpdated = false;
                            isOrderVariations = modelResponse.data.isChanged;
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
                        Utils.hideProgressDialog(context);
                        DialogUtils.displayErrorDialog(
                            context, "${couponModel.message}");
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
        backgroundColor: appTheme,
        child: Text(
          day,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );

  Future<DateTime> selectDate(
    BuildContext context, {
    bool isStartIndex,
    bool isEndIndex,
  }) async {
    DateTime selectedDate = DateTime.now();
    if (isStartIndex != null) {
      selectedDate = selectedDate.add(Duration(days: 1));
    }
    if (isEndIndex != null) {
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
    String couponCode = '',
    bool isRemovedOffer = false,
  }) async {
    constraints();
    bool isNetworkAvailable = await Utils.isNetworkAvailable();
    if (!isNetworkAvailable) {
      DialogUtils.displayErrorDialog(context, AppConstant.noInternet);
      return;
    }
    userDeliveryAddress = '';
    pin = '';
    if (addressData != null && widget.deliveryType == OrderType.Delivery) {
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
    } else if (areaObject != null && widget.deliveryType == OrderType.PickUp) {
      userDeliveryAddress = areaObject.pickupAdd;
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
            shipping: widget.deliveryType == OrderType.PickUp
                ? ''
                : shippingCharges,
            orderJson: encodedDoughnut,
            userAddressId: widget.deliveryType == OrderType.Delivery
                ? addressData == null
                    ? ''
                    : addressData.areaId
                : areaObject == null
                    ? ''
                    : areaObject.areaId,
            userAddress: userDeliveryAddress,
            deliveryTimeSlot: widget.deliveryType == OrderType.PickUp
                ? ''
                : selectedTimeSlotString,
            cartSaving: cartSaving,
            totalDeliveries: totalDeliveries.toString())
        .then((response) async {
      //{"success":false,"message":"Some products are not available."}
      SubscriptionTaxCalculationResponse model = response;
      Utils.hideProgressDialog(context);
      Utils.hideKeyboard(context);
      if (model != null && model.success) {
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
        if (isRemovedOffer) {
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
            "Something went wrong");
//            "${model.message}");
        if (result != null && result == true) {
          eventBus.fire(updateCartCount());
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    });
//    });
  }

  Razorpay _razorpay;

  void initRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse responseObj) {
    //Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
    Utils.showProgressDialog(context);
    ApiController.subscriptionRazorpayVerifyTransactionApi(responseObj.orderId)
        .then((response) {
      //print("----razorpayVerifyTransactionApi----${response}--");
      if (response != null) {
        RazorpayOrderData model = response;
        if (model.success) {
          placeOrderApi(
            payment_request_id: responseObj.orderId,
            payment_id: model.data.id,
          );
        } else {
          Utils.hideProgressDialog(context);
          DialogUtils.displayErrorDialog(
              context, model.message ?? "Something went wrong!");
        }
      } else {
        Utils.hideProgressDialog(context);
        DialogUtils.displayErrorDialog(context, "Something went wrong!");
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
//    DialogUtils.displayErrorDialog(context, response.message);
    DialogUtils.displayErrorDialog(context, 'Payment cancelled');
    print("----_handlePaymentError--message--${response.message}--");
    print("----_handlePaymentError--code--${response.code.toString()}--");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    /*print("----ExternalWalletResponse----${response.walletName}--");
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);*/
  }

  String razorpay_orderId = "";

  void openCheckout(String razorpay_order_id, StoreModel storeObject) async {
    Utils.hideProgressDialog(context);
    UserModel user = await SharedPrefs.getUser();
    //double price = totalPrice ;
    razorpay_orderId = razorpay_order_id;
    var options = {
      'key': '${storeObject.paymentSetting.apiKey}',
      'currency': "INR",
      'order_id': razorpay_order_id,
      //'amount': taxModel == null ? (price * 100) : (double.parse(taxModel.total) * 100),
      'amount': (double.parse(taxModel.total) * 100),
      'name': '${widget.model.storeName}',
      'description': '',
      'prefill': {
        'contact': '${user.phone}',
        'email': '${user.email}',
        'name': '${user.fullName}'
      },
      /*'external': {
        'wallets': ['paytm']
      }*/
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  Future<void> placeOrderApi(
      {String payment_request_id = '',
      String payment_id = '',
      bool isFullPaymentFromWallet = false}) async {
    bool isNetworkAvailable = await Utils.isNetworkAvailable();
    if (!isNetworkAvailable) {
      DialogUtils.displayErrorDialog(context, AppConstant.noInternet);
      return;
    }
    Utils.showProgressDialog(context);
    List<String> selectedDatesList = List();
    try {
      for (DateTime event in _markedDateMap.events.keys) {
        var formatter = new DateFormat('yyyy-MM-dd');
        String formatted = formatter.format(event);
        selectedDatesList.add(formatted);
      }
    } catch (e) {
      print(e);
    }

    String encodedDateList = jsonEncode(selectedDatesList);
    String start_date = '',
        end_date = '',
        single_day_shipping_charges = taxModel.singleDayShipping,
        single_day_total = taxModel.singleDayTotal,
        single_day_discount = taxModel.singleDayDiscount,
        single_day_tax = taxModel.singleDayTax,
        single_day_checkout = taxModel.singleDayTotal,
        subscription_type =
            widget.model.subscription.cycleType[selecteddays].key,
        delivery_dates = encodedDateList,
        total_deliveries = totalDeliveries.toString();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(selectedStartDate);
    start_date = formatted;
    formatted = formatter.format(selectedEndDate);
    end_date = formatted;
    userDeliveryAddress = '';
    pin = '';
    if (addressData != null && widget.deliveryType == OrderType.Delivery) {
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
    } else if (widget.deliveryType == OrderType.PickUp && areaObject != null) {
      userDeliveryAddress = areaObject.pickupAdd;
    }
    isLoading = true;
    userWalleModel = await ApiController.getUserWallet();

    List jsonList = Product.encodeToJson(widget.cartList);
    String encodedDoughnut = jsonEncode(jsonList);

    ApiController.subscriptionPlaceOrderRequest(
      shippingCharges,
      '',
      taxModel.total,
      '3',
      taxModel,
      addressData,
      encodedDoughnut,
      widget.deliveryType != OrderType.Delivery,
      widget.deliveryType == OrderType.Delivery
          ? addressData.areaId
          : areaObject.areaId,
      widget.deliveryType,
      payment_request_id,
      payment_id,
      isFullPaymentFromWallet ? 'Razorpay' : 'wallet',
      widget.deliveryType == OrderType.PickUp ? '' : selectedTimeSlotString,
      cart_saving: totalSavings.toStringAsFixed(2),
      start_date: start_date,
      end_date: end_date,
      single_day_shipping_charges: single_day_shipping_charges,
      single_day_total: single_day_total,
      single_day_discount: single_day_discount,
      single_day_tax: single_day_tax,
      single_day_checkout: single_day_checkout,
      subscription_type: subscription_type,
      delivery_dates: delivery_dates,
      total_deliveries: total_deliveries,
    ).then((response) async {
      Utils.hideProgressDialog(context);
      if (response != null && response.success) {
        eventBus.fire(updateCartCount());
        print("${widget.deliveryType}");
        DialogUtils.displaySubscriptionCompleteDialog(context,
            button1: () {
              eventBus.fire(updateCartCount());
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SubscriptionHistory(
                          widget.model,
                        )),
              );
            },
            buttonText1: 'Track Your Subscription',
            cancelButton: () {
              eventBus.fire(updateCartCount());
              Navigator.of(context).popUntil((route) => route.isFirst);
            });
      }
    });
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
              if (addressData.isShippingMandatory == '0') {
                shippingCharges = "0";
                addressData.areaCharges = "0";
              }
            });
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> checkMinOrderPickAmount() async {
    if (widget.deliveryType == OrderType.PickUp && areaObject != null) {
      print("----minAmount=${areaObject.minOrder}");
      print("----notAllow=${areaObject.notAllow}");
      print("--------------------------------------------");
      int minAmount = 0;
      try {
        try {
          if (areaObject.minOrder.isNotEmpty)
            minAmount = double.parse(areaObject.minOrder).toInt();
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

  bool checkFullPaymentFromWallet() {
    bool isFullPaymentFromWallet = false;
    if (taxModel != null) {
      double walletRefund = double.parse(taxModel.walletRefund);
      double total = double.parse(taxModel.total);
      if (walletRefund != 0 && total == 0) {
        isFullPaymentFromWallet = true;
      }
    }
    return isFullPaymentFromWallet;
  }

  List encodeToJsonForCoupon(List<Product> cartList) {
    List jsonList = List();
    cartList
        .map((item) => jsonList.add({
              "product_id": item.id,
              "product_name": item.title,
              "variant_id": item.variantId,
              "isTaxEnable": item.isTaxEnable,
              "quantity":
                  (totalDeliveries * double.parse(item.quantity)).toString(),
              "price": item.price,
              "weight": item.weight,
              "mrp_price": item.mrpPrice,
              "unit_type": item.isUnitType,
            }))
        .toList();
    return jsonList;
  }

  Widget addFixedTax() {
    return Visibility(
      visible: taxModel != null &&
          taxModel.fixedTax != null &&
          taxModel.fixedTax.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 10, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                taxModel == null
                    ? ''
                    : taxModel.fixedTax != null && taxModel.fixedTax.isNotEmpty
                        ? taxModel.fixedTax.first.fixedTaxLabel
                        : '',
                style: TextStyle(color: Colors.black)),
            Text(
                "${AppConstant.currency}${taxModel == null ? '0' : taxModel.fixedTax != null && taxModel.fixedTax.isNotEmpty ? taxModel.fixedTax.first.fixedTaxAmount : '0'}",
                style: TextStyle(
                  color: Colors.black,
                )),
          ],
        ),
      ),
    );
  }
}
