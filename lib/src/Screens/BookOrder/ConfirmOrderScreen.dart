import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restroapp/src/Screens/Offers/AvailableOffersList.dart';
import 'package:restroapp/src/Screens/Offers/RedeemPointsScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CreateOrderData.dart';
import 'package:restroapp/src/models/CreatePaytmTxnTokenResponse.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/DeliveryTimeSlotModel.dart';
import 'package:restroapp/src/models/OrderDetailsModel.dart';
import 'package:restroapp/src/models/PickUpModel.dart';
import 'package:restroapp/src/models/PromiseToPayUserResponse.dart';
import 'package:restroapp/src/models/RazorpayOrderData.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/StripeCheckOutModel.dart';
import 'package:restroapp/src/models/StripeVerifyModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/models/ValidateCouponsResponse.dart';
import 'package:restroapp/src/models/WalleModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../singleton/app_version_singleton.dart';

class ConfirmOrderScreen extends StatefulWidget {
  StoreModel storeModel;
  bool isComingFromPickUpScreen;
  DeliveryAddressData address;
  String paymentMode = "2"; // 2 = COD, 3 = Online Payment, //4 =promise to pay
  String areaId;
  OrderType deliveryType;
  Area areaObject;
  List<Product> cartList = new List.empty(growable: true);
  PaymentType _selectedPaymentTypeValue = PaymentType.COD;

  ConfirmOrderScreen(this.address, this.isComingFromPickUpScreen, this.areaId,
      this.deliveryType,
      {this.areaObject, this.paymentMode = "2", this.storeModel});

  @override
  ConfirmOrderState createState() => ConfirmOrderState(storeModel: storeModel);
}

class ConfirmOrderState extends State<ConfirmOrderScreen> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  double totalPrice = 0.00;
  double totalSavings = 0.00;
  String totalSavingsText = "";
  TaxCalculationModel taxModel;

  //TextEditingController noteController = TextEditingController();
  String shippingCharges = "0";
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  StoreModel storeModel;
  DeliveryTimeSlotModel deliverySlotModel;
  int selctedTag, selectedTimeSlot;
  List<Timeslot> timeslotList;
  bool isSlotSelected = false;

  //Store provides instant delivery of the orders.
  bool isInstantDelivery = false;
  bool minOrderCheck = true;
  bool isLoading = true;
  bool hideRemoveCouponFirstTime;
  List<String> appliedCouponCodeList = List();
  List<String> appliedReddemPointsCodeList = List();
  TextEditingController couponCodeController = TextEditingController();
  bool isCommentAdded = false;

  String comment = "";
  bool isDeliveryResponseFalse = false;
  bool ispaytmSelected = false;

  bool isPayTmActive = false, isPromiseToPay = false;

  double totalMRpPrice = 0.0;
  List<OrderDetail> responseOrderDetail = List.empty(growable: true);
  List<Product> cartListFromDB = List.empty(growable: true);

  bool isOrderVariations = false;

  bool showCOD = true;
  bool showOnline = true;

  bool isAnotherOnlinePaymentGatwayFound = false;

  String thirdOptionPGText = 'Paytm';

  ConfirmOrderState({this.storeModel});

  void callPaytmPayApi() async {
    String address = "NA", pin = "NA";
    if (widget.deliveryType == OrderType.Delivery) {
      if (widget.address.address2 != null &&
          widget.address.address2.isNotEmpty) {
        if (widget.address.address != null &&
            widget.address.address.isNotEmpty) {
          address = widget.address.address +
              ", " +
              widget.address.address2 +
              " " +
              widget.address.areaName +
              " " +
              widget.address.city;
        } else {
          address = widget.address.address2 +
              " " +
              widget.address.areaName +
              " " +
              widget.address.city;
        }
      } else {
        if (widget.address.address != null &&
            widget.address.address.isNotEmpty) {
          address = widget.address.address +
              " " +
              widget.address.areaName +
              " " +
              widget.address.city;
        }
      }

      if (widget.address.zipCode != null && widget.address.zipCode.isNotEmpty)
        pin = widget.address.zipCode;
    } else if (widget.deliveryType == OrderType.PickUp) {
      address = widget.areaObject.pickupAdd;
      pin = 'NA';
    }

    print(
        "amount ${databaseHelper.roundOffPrice(taxModel == null ? totalPrice : double.parse(taxModel.total), 2).toStringAsFixed(2)}"
        " address $address zipCode $pin");
    double amount = databaseHelper.roundOffPrice(
        taxModel == null ? totalPrice : double.parse(taxModel.total), 2);
    Utils.showProgressDialog(context);

    UserModel user = await SharedPrefs.getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    //new changes
    Utils.getCartItemsListToJson(
            isOrderVariations: isOrderVariations,
            responseOrderDetail: responseOrderDetail,
            cartList: cartListFromDB)
        .then((orderJson) {
      if (orderJson == null) {
        print("--orderjson == null-orderjson == null-");
        return;
      }
      String storeAddress = "";
      try {
        storeAddress = "${storeModel.storeName}, ${storeModel.location},"
            "${storeModel.city}, ${storeModel.state}, ${storeModel.country}, ${storeModel.zipcode}";
      } catch (e) {
        print(e);
      }

      String userId = user.id;
      OrderDetailsModel detailsModel = OrderDetailsModel(
          shippingCharges,
          comment,
          totalPrice.toString(),
          widget.paymentMode,
          taxModel,
          widget.address,
          widget.isComingFromPickUpScreen,
          widget.areaId,
          widget.deliveryType,
          "",
          "",
          deviceId,
          "Paytm",
          userId,
          deviceToken,
          storeAddress,
          selectedDeliverSlotValue,
          totalSavingsText);
      ApiController.createPaytmTxnToken(
              address, pin, amount, orderJson, detailsModel.orderDetails)
          .then((value) async {
        Utils.hideProgressDialog(context);
        if (value != null && value.success) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaytmWebView(value, storeModel)),
          );
        } else {
          Utils.hideProgressDialog(context);
          Utils.showToast("Api Error", false);
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetConnection();
    });
  }

  void checkInternetConnection() {
    Utils.isNetworkAvailable().then((value) {
      if (value == false) {
        DialogUtils.displayDialog(
            context, "Opps!!!", "No Internet Connection", "Cancel", "Retry",
            button2: () {
          Navigator.pop(context);
          checkInternetConnection();
        });
      } else {
        initialize();
      }
    });
  }

  void checkPromiseToPayForUser() async {
    bool isNetworkAvailable = await Utils.isNetworkAvailable();
    if (!isNetworkAvailable) {
      Utils.showToast(AppConstant.noInternet, true);
      return;
    }
    PromiseToPayUserResponse response =
        await ApiController.checkPromiseToPayForUser();
    if (response != null && response.success) {
      if (response.data.promiseToPay == "1") {
        isPromiseToPay = true;
        setState(() {});
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void initialize() {
    initRazorPay();
    listenWebViewChanges();
    checkPaytmActive();
    selctedTag = 0;
    hideRemoveCouponFirstTime = true;
    print("You are on confirm order screen");
    //print("-deliveryType--${widget.deliveryType}---");
    constraints();
    try {
      SharedPrefs.getStore().then((storeData) {
        storeModel = storeData;
        checkLoyalityPointsOption();
        if (widget.deliveryType == OrderType.Delivery) {
          if (storeModel.deliverySlot == "1") {
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
      });
    } catch (e) {
      print(e);
    }
    multiTaxCalculationApi();

    if (widget.storeModel != null) {
      if (widget.storeModel.areaWisePaymentOption == false ||
          widget.deliveryType != OrderType.Delivery) {
        if (widget.storeModel.cod == "1") {
          showCOD = true;
          widget.paymentMode = "2";
        } else if (widget.storeModel.cod == "0") {
          showCOD = false;
        }
        if (widget.storeModel.onlinePayment == "0") {
          showOnline = false;
        }
        if (widget.storeModel.onlinePayment == "0" &&
            widget.storeModel.cod == "0") {
          showCOD = true;
          widget.paymentMode = "2";
        }
        if (widget.storeModel.cod == "0" &&
            widget.storeModel.onlinePayment == "1") {
          widget._selectedPaymentTypeValue = PaymentType.ONLINE;
          widget.paymentMode = "3";
          if (widget.storeModel.onlinePayment.compareTo('1') == 0 &&
              isAnotherOnlinePaymentGatwayFound) {
            showOnline = true;
          }
          showOnline = true;
        }
      } else {
        if (widget.deliveryType == OrderType.Delivery) {
          if (widget.address.areaWisePaymentMethod == '1') {
            showCOD = true;
            if (widget.storeModel.onlinePayment != null &&
                widget.storeModel.onlinePayment.compareTo('1') == 0 &&
                isAnotherOnlinePaymentGatwayFound) {
              showOnline = true;
            } else {
              showOnline = false;
            }

            if (widget.address.defaultPaymentMethod == '1') {
              widget._selectedPaymentTypeValue = PaymentType.COD;
              widget.paymentMode = "2";
            } else {
              widget._selectedPaymentTypeValue = PaymentType.ONLINE;
              widget.paymentMode = "3";
            }
          } else if (widget.address.areaWisePaymentMethod == '2') {
            showCOD = true;
            widget._selectedPaymentTypeValue = PaymentType.COD;
            showOnline = false;
            widget.paymentMode = "2";
          } else {
            if (widget.storeModel.onlinePayment != null &&
                widget.storeModel.onlinePayment.compareTo('1') == 0 &&
                isAnotherOnlinePaymentGatwayFound) {
              showOnline = true;
            } else {
              showOnline = false;
            }
            widget._selectedPaymentTypeValue = PaymentType.NONE;
            widget.paymentMode = "0";
            showCOD = false;
          }
        }
      }
      //check Promise to pay
      if (widget.storeModel.promiseToPay == "1" &&
          widget.storeModel.promiseToPayForAll == "1") {
        isPromiseToPay = true;
      } else if (widget.storeModel.promiseToPay == "1" &&
          widget.storeModel.promiseToPayForAll == "0") {
        checkPromiseToPayForUser();
      } else {
        isPromiseToPay = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("Confirm Order"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context, false),
        ),
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(children: [
              Expanded(
                child: isLoading
                    ? Utils.getIndicatorView()
                    : widget.cartList == null
                        ? Text("")
                        : ListView(
                            children: <Widget>[
                              addCommentWidget(context),
                              showDeliverySlot(),
                              ListView.separated(
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  if (widget.cartList[index].taxDetail ==
                                          null ||
                                      widget.cartList[index].taxDetail ==
                                          null) {
                                    return Divider(
                                        color: Colors.grey, height: 1);
                                  } else {
                                    return Divider(
                                        color: Colors.white, height: 1);
                                  }
                                },
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: widget.cartList.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == widget.cartList.length) {
                                    return addItemPrice();
                                  } else {
                                    return addProductCart(
                                        widget.cartList[index]);
                                  }
                                },
                              ),
                            ],
                          ),
              ),
            ]),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Wrap(
                children: [
                  addTotalPrice(),
                  addEnterCouponCodeView(),
                  addCouponCodeRow(),
                  addPaymentOptions(),
                  //addConfirmOrder()
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: addConfirmOrder(),
    );
  }

  WalleModel userWalleModel;

  Future<bool> couponAppliedCheck() async {
    setState(() {});
    if (taxModel != null &&
        taxModel.discount != null &&
        taxModel.discount.isNotEmpty &&
        double.parse(taxModel.discount) > 0) {
      return await DialogUtils.displayDialog(
          context,
          'Are you sure?',
          'Your Applied Coupon code will be removed!',
          'No',
          'Yes', button2: () async {
        Navigator.of(context).pop(true);
        removeCoupon();
      }, button1: () {
        Navigator.of(context).pop(false);
      });
    } else {
      return Future(() => true);
    }
  }

  Future<void> multiTaxCalculationApi() async {
    bool isNetworkAvailable = await Utils.isNetworkAvailable();
    if (!isNetworkAvailable) {
      Utils.showToast(AppConstant.noInternet, false);
      return;
    }
    isLoading = true;
//    userWalleModel = await SharedPrefs.getUserWallet();
//    if (userWalleModel == null) {
    userWalleModel = await ApiController.getUserWallet();
//      userWalleModel = await SharedPrefs.getUserWallet();
//    }
//    databaseHelper.getCartItemsListToJson().then((json) {
    databaseHelper.getCartItemList().then((cartList) {
      cartListFromDB = cartList;
      List jsonList = Product.encodeToJson(cartList);
      String encodedDoughnut = jsonEncode(jsonList);
      ApiController.multipleTaxCalculationRequest(
              "", "0", "$shippingCharges", encodedDoughnut)
          .then((response) async {
        //{"success":false,"message":"Some products are not available."}
        TaxCalculationResponse model = response;
        if (model.success) {
          taxModel = model.taxCalculation;
          widget.cartList = await databaseHelper.getCartItemList();
          for (int i = 0; i < model.taxCalculation.taxDetail.length; i++) {
            Product product = Product();
            product.taxDetail = model.taxCalculation.taxDetail[i];
            widget.cartList.add(product);
          }
          for (var i = 0; i < model.taxCalculation.fixedTax.length; i++) {
            Product product = Product();
            product.fixedTax = model.taxCalculation.fixedTax[i];
            widget.cartList.add(product);
          }
          if (model.taxCalculation.orderDetail != null &&
              model.taxCalculation.orderDetail.isNotEmpty) {
            responseOrderDetail = model.taxCalculation.orderDetail;
            bool someProductsUpdated = false;
            isOrderVariations = model.taxCalculation.isChanged;
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
                  storeModel == null ? "" : storeModel.storeName,
                  "Some Cart items were updated. Please review the cart before procceeding.",
                  buttonText: 'Procceed');
              constraints();
            }
          }

          calculateTotalSavings();
          setState(() {
            isLoading = false;
          });
        } else {
          var result = await DialogUtils.displayCommonDialog(
              context,
              storeModel == null ? "" : storeModel.storeName,
              "${model.message}");
          if (result != null && result == true) {
            databaseHelper.deleteTable(DatabaseHelper.Favorite_Table);
            databaseHelper.deleteTable(DatabaseHelper.CART_Table);
            databaseHelper.deleteTable(DatabaseHelper.Products_Table);
            eventBus.fire(updateCartCount());
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        }
      });
    });
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
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text("When would you like your service?"),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Text("${Utils.getDate()}"),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xFFBDBDBD)),
                  Container(
                    //margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    height: 50.0,
                    child: ListView.builder(
                      itemCount:
                          deliverySlotModel.data.dateTimeCollection.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DateTimeCollection slotsObject =
                            deliverySlotModel.data.dateTimeCollection[index];
                        if (selctedTag == index) {
                          selectedSlotColor = Color(0xFFEEEEEE);
                          textColor = Color(0xFFff4600);
                        } else {
                          selectedSlotColor = Color(0xFFFFFFFF);
                          textColor = Color(0xFF000000);
                        }
                        return Container(
                          color: selectedSlotColor,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: InkWell(
                            onTap: () {
                              print("${slotsObject.timeslot.length}");
                              setState(() {
                                selctedTag = index;
                                timeslotList = slotsObject.timeslot;
                                isSlotSelected = false;
                                //selectedTimeSlot = 0;
                                //print("timeslotList=${timeslotList.length}");
                                for (int i = 0; i < timeslotList.length; i++) {
                                  //print("isEnable=${timeslotList[i].isEnable}");
                                  Timeslot timeslot = timeslotList[i];
                                  if (timeslot.isEnable) {
                                    selectedTimeSlot = i;
                                    isSlotSelected = true;
                                    break;
                                  }
                                }
                              });
                            },
                            child: Container(
                              child: Center(
                                child: Text(
                                    ' ${Utils.convertStringToDate(slotsObject.label)} ',
                                    style: TextStyle(color: textColor)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Color(0xFFBDBDBD)),
                  Container(
                    //margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    height: 50.0,
                    child: ListView.builder(
                      itemCount: timeslotList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Timeslot slotsObject = timeslotList[index];
                        print("----${slotsObject.label}-and ${selctedTag}--");

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

  Widget addProductCart(Product product) {
    //print("product_offer=${product.product_offer}");
    OrderDetail detail;
    if (product.id != null)
      for (int i = 0; i < responseOrderDetail.length; i++) {
        if (product.id.compareTo(responseOrderDetail[i].productId) == 0 &&
            product.variantId.compareTo(responseOrderDetail[i].variantId) ==
                0) {
          detail = responseOrderDetail[i];
          break;
        }
      }
    Color containerColor =
        detail != null && detail.productStatus.contains('out_of_stock')
            ? Colors.black12
            : Colors.transparent;
    String mrpPrice =
        detail != null && detail.productStatus.contains('price_changed')
            ? detail.newMrpPrice
            : product.mrpPrice;
    String price =
        detail != null && detail.productStatus.contains('price_changed')
            ? detail.newPrice
            : product.price;
    String imageUrl = product.imageType == "0"
        ? product.image == null
            ? product.image10080
            : product.image
        : product.imageUrl;
    if (product.taxDetail != null) {
      return Container(
        color: containerColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${product.taxDetail.label} (${product.taxDetail.rate}%)",
                  style: TextStyle(color: Colors.black54)),
              detail != null && detail.productStatus.contains('out_of_stock')
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 1),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          "Out of Stock",
                          style: TextStyle(color: Colors.red),
                        ),
                      ))
                  : Text("${AppConstant.currency}${product.taxDetail.tax}",
                      style: TextStyle(
                          color: detail != null &&
                                  detail.productStatus.contains('out_of_stock')
                              ? Colors.red
                              : Colors.black54)),
            ],
          ),
        ),
      );
    } else if (product.fixedTax != null) {
      return Container(
        color: containerColor,
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${product.fixedTax.fixedTaxLabel}",
                  style: TextStyle(color: Colors.black54)),
              detail != null && detail.productStatus.contains('out_of_stock')
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 1),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          "Out of Stock",
                          style: TextStyle(color: Colors.red),
                        ),
                      ))
                  : Text(
                      "${AppConstant.currency}${product.fixedTax.fixedTaxAmount}",
                      style: TextStyle(
                          color: detail != null &&
                                  detail.productStatus.contains('out_of_stock')
                              ? Colors.red
                              : Colors.black54)),
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: containerColor,
        padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            addVegNonVegOption(product),
            imageUrl == ""
                ? Container(
                    width: 70.0,
                    height: 80.0,
                    child: Utils.getImgPlaceHolder(),
                  )
                : Padding(
                    padding: EdgeInsets.only(left: 5, right: 20),
                    child: Container(
                      width: 70.0,
                      height: 80.0,
                      child: CachedNetworkImage(
                          imageUrl: "${imageUrl}", fit: BoxFit.fill
                          //placeholder: (context, url) => CircularProgressIndicator(),
                          //errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                      /*child: Image.network(imageUrl,width: 60.0,height: 60.0,
                                          fit: BoxFit.cover),*/
                    )),
            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: SizedBox(
                        width: (Utils.getDeviceWidth(context) - 150),
                        child: Container(
                          child: Text(product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: product.weight.isEmpty ? false : true,
                      child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "${product.weight}",
                            style: TextStyle(color: appThemeSecondary),
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 10),
                        child: Text(
                            "Quantity: ${product.quantity} X ${AppConstant.currency}${double.parse(price).toStringAsFixed(2)}")),
                    Visibility(
                      visible: AppVersionSingleton.instance.appVersion.store
                                      .product_coupon ==
                                  "1" &&
                              product.product_offer == 1
                          ? true
                          : false,
                      child: Container(
                        width: 60,
                        child: Center(
                            child: Text(
                          "OFFER",
                          style: TextStyle(color: Colors.white, fontSize: 10.0),
                        )),
                        margin: EdgeInsets.only(left: 5, top: 0, bottom: 15),
                        padding: EdgeInsets.all(5),
                        decoration: new BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: appThemeSecondary,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                    ),
                    //
                    /*Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 20),
                    child: Text("Price: " + "${AppConstant.currency}${double.parse(product.price).toStringAsFixed(2)}")
                ),*/
                  ],
                )),
            detail != null && detail.productStatus.contains('out_of_stock')
                ? Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 1),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        "Out of Stock",
                        style: TextStyle(color: Colors.red),
                      ),
                    ))
                : Text(
                    "${AppConstant.currency}${databaseHelper.roundOffPrice(int.parse(product.quantity) * double.parse(price), 2).toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 16,
                        color: detail != null &&
                                detail.productStatus.contains('out_of_stock')
                            ? Colors.red
                            : Colors.black45)),
          ],
        ),
      );
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
          visible: widget.address == null ? false : true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Delivery charges:",
                    style: TextStyle(color: Colors.black54)),
                Text(
                    "${AppConstant.currency}${widget.address == null ? "0" : widget.address.areaCharges}",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ),
        Visibility(
          visible: taxModel == null ? false : true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Discount:", style: TextStyle(color: Colors.black54)),
                Text(
                    "${AppConstant.currency}${taxModel == null ? "0" : taxModel.discount}",
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
//                  "${AppConstant.currency}${databaseHelper.roundOffPrice((totalPrice - int.parse(shippingCharges)), 2).toStringAsFixed(2)}",
                  "${AppConstant.currency}${taxModel == null ? databaseHelper.roundOffPrice((totalPrice - int.parse(shippingCharges)), 2).toStringAsFixed(2) : taxModel.itemSubTotal}",
                  style: TextStyle(color: Colors.black)),
            ],
          ),
        ),
        Container(
            height: 1,
            color: Colors.black45,
            width: MediaQuery.of(context).size.width),
        Visibility(
          visible: widget.storeModel.wallet_setting == "1" ? true : false,
          child: Container(
            child: Padding(
                padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
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
                    Padding(
                      padding: EdgeInsets.only(right: 5, top: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("You Used",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                          Text(
                              "${AppConstant.currency} ${taxModel == null ? "0.00" : databaseHelper.roundOffPrice(double.parse(taxModel.wallet_refund), 2).toStringAsFixed(2)}",
                              style: TextStyle(color: appTheme, fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ]),
    );
  }

  String getUserRemaningWallet() {
    double balance = (double.parse(userWalleModel.data.userWallet) -
        double.parse(taxModel.wallet_refund) -
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
                    "${AppConstant.currency}${databaseHelper.roundOffPrice(taxModel == null ? totalPrice : double.parse(taxModel.total), 2).toStringAsFixed(2)}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ))
      ]),
    );
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
                    var result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => RedeemPointsScreen(
                              widget.address,
                              "",
                              widget.isComingFromPickUpScreen,
                              widget.areaId, (model) async {
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
                          }, appliedReddemPointsCodeList, isOrderVariations,
                              responseOrderDetail, shippingCharges),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AvailableOffersDialog(
                      widget.address,
                      widget.paymentMode,
                      widget.isComingFromPickUpScreen,
                      widget.areaId,
                      (model) async {
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
                      },
                      appliedCouponCodeList,
                      isOrderVariations,
                      responseOrderDetail,
                      shippingCharges,
                      cartListFromDB: cartListFromDB,
                    ),
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

  Widget addPaymentOptions() {
    bool showOptions = false;
    if (widget.storeModel.onlinePayment != null) {
      if (widget.storeModel.onlinePayment == "1") {
        showOptions = true;
      } else {
        showOptions = false; //cod
      }
    } else {
      if (isPayTmActive) {
        showOptions = true;
      }
    }
    if (isPromiseToPay) {
      showOptions = true;
    }

    return Visibility(
      visible: showOptions,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 5),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Utils.showDivider(context),
            Container(
              child: Text("Select Payment",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appTheme,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            Visibility(
              visible: showCOD,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Radio(
                    value: PaymentType.COD,
                    groupValue: widget._selectedPaymentTypeValue,
                    activeColor: appTheme,
                    onChanged: (PaymentType value) async {
                      bool proceed = await couponAppliedCheck();
                      if (proceed) {
                        setState(() {
                          widget._selectedPaymentTypeValue = value;
                          if (value == PaymentType.COD) {
                            widget.paymentMode = "2";
                            ispaytmSelected = false;
                          }
                        });
                      }
                    },
                  ),
                  Text('COD',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            Visibility(
              visible: showOnline,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Radio(
                    value: PaymentType.ONLINE,
                    activeColor: appTheme,
                    groupValue: widget._selectedPaymentTypeValue,
                    onChanged: (PaymentType value) async {
                      bool proceed = await couponAppliedCheck();
                      if (proceed) {
                        setState(() {
                          widget._selectedPaymentTypeValue = value;
                          if (value == PaymentType.ONLINE) {
                            widget.paymentMode = "3";
                            ispaytmSelected = false;
                          }
                        });
                      }
                    },
                  ),
                  Text('Online',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            Visibility(
              visible: isPayTmActive,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Radio(
                    value: PaymentType.ONLINE_PAYTM,
                    activeColor: appTheme,
                    groupValue: widget._selectedPaymentTypeValue,
                    onChanged: (PaymentType value) async {
                      bool proceed = await couponAppliedCheck();
                      if (proceed) {
                        setState(() {
                          widget._selectedPaymentTypeValue = value;
                          if (value == PaymentType.ONLINE_PAYTM) {
                            widget.paymentMode = "3";
                            ispaytmSelected = true;
                          }
                        });
                      }
                    },
                  ),
                  Text(thirdOptionPGText,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
            Visibility(
              visible: isPromiseToPay,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Radio(
                    value: PaymentType.PROMISE_TO_PAY,
                    activeColor: appTheme,
                    groupValue: widget._selectedPaymentTypeValue,
                    onChanged: (PaymentType value) async {
                      bool proceed = await couponAppliedCheck();
                      if (proceed) {
                        setState(() {
                          widget._selectedPaymentTypeValue = value;
                          if (value == PaymentType.PROMISE_TO_PAY) {
                            widget.paymentMode = "4";
                          }
                        });
                      }
                    },
                  ),
                  Text("Promise To Pay",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isCouponsApplied = false;

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
                      databaseHelper
                          .getCartItemsListToJson(
                              isOrderVariations: isOrderVariations,
                              responseOrderDetail: responseOrderDetail)
                          .then((json) async {
                        ValidateCouponResponse couponModel =
                            await ApiController.validateOfferApiRequest(
                                couponCodeController.text,
                                widget.paymentMode,
                                json,
                                widget.deliveryType == OrderType.PickUp
                                    ? '1'
                                    : '2');
                        if (couponModel.success) {
                          print("---success----");
                          Utils.showToast("${couponModel.message}", false);
                          TaxCalculationResponse model =
                              await ApiController.multipleTaxCalculationRequest(
                                  couponCodeController.text,
                                  couponModel.discountAmount,
                                  shippingCharges,
                                  json);
                          Utils.hideProgressDialog(context);
                          if (model != null && !model.success) {
                            Utils.showToast(model.message, true);
                            databaseHelper
                                .deleteTable(DatabaseHelper.Favorite_Table);
                            databaseHelper
                                .deleteTable(DatabaseHelper.CART_Table);
                            databaseHelper
                                .deleteTable(DatabaseHelper.Products_Table);
                            eventBus.fire(updateCartCount());
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          } else {
                            await updateTaxDetails(model.taxCalculation);
                            if (model.taxCalculation.orderDetail != null &&
                                model.taxCalculation.orderDetail.isNotEmpty) {
                              responseOrderDetail =
                                  model.taxCalculation.orderDetail;
                              bool someProductsUpdated = false;
                              isOrderVariations =
                                  model.taxCalculation.isChanged;
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
                                    storeModel == null
                                        ? ""
                                        : storeModel.storeName,
                                    "Some Cart items were updated. Please review the cart before procceeding.",
                                    buttonText: 'Procceed');
                                constraints();
                              }
                            }
                            calculateTotalSavings();
                            setState(() {
                              taxModel = model.taxCalculation;
                              isCouponsApplied = true;
                              couponCodeController.text = couponCode;
                            });
                          }
                        } else {
                          Utils.showToast("${couponModel.message}", false);
                          Utils.hideProgressDialog(context);
                          Utils.hideKeyboard(context);
                        }
                      });
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

  Future<void> updateTaxDetails(TaxCalculationModel taxModel) async {
    widget.cartList = await databaseHelper.getCartItemList();
    for (int i = 0; i < taxModel.taxDetail.length; i++) {
      Product product = Product();
      product.taxDetail = taxModel.taxDetail[i];
      widget.cartList.add(product);
    }
    for (var i = 0; i < taxModel.fixedTax.length; i++) {
      Product product = Product();
      product.fixedTax = taxModel.fixedTax[i];
      widget.cartList.add(product);
    }
  }

  String selectedDeliverSlotValue = "";

  Widget addConfirmOrder() {
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
              actionConfirmOrder();
            },
            child: Text(
              "Confirm Order",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }

  performPlaceOrderOperation(StoreModel storeObject) async {
    String json = await databaseHelper.getCartItemsListToJson(
        isOrderVariations: isOrderVariations,
        responseOrderDetail: responseOrderDetail);
    if (json == null) {
      print("--json == null-json == null-");
      return;
    }

    String couponCode = taxModel == null ? "" : taxModel.couponCode;
    String discount = taxModel == null ? "0" : taxModel.discount;
    if (widget.deliveryType == OrderType.PickUp)
      Utils.showProgressDialog(context);

    TaxCalculationResponse response =
        await ApiController.multipleTaxCalculationRequest(
            "${couponCode}", "${discount}", shippingCharges, json);

    if (response != null && !response.success) {
      Utils.showToast(response.message, true);
      databaseHelper.deleteTable(DatabaseHelper.Favorite_Table);
      databaseHelper.deleteTable(DatabaseHelper.CART_Table);
      databaseHelper.deleteTable(DatabaseHelper.Products_Table);
      eventBus.fire(updateCartCount());
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    taxModel = response.taxCalculation;

    Map<String, dynamic> attributeMap = new Map<String, dynamic>();
    attributeMap["ScreenName"] = "Order Confirm Screen";
    attributeMap["action"] = "Place Order Request";
    attributeMap["totalPrice"] = "${totalPrice}";
    attributeMap["deliveryType"] = "${widget.deliveryType}";
    attributeMap["paymentMode"] = "${widget.paymentMode}";
    attributeMap["shippingCharges"] = "${shippingCharges}";
    Utils.sendAnalyticsEvent("Clicked Place Order button", attributeMap);

//    if (response.taxCalculation.orderDetail != null &&
//        response.taxCalculation.orderDetail.isNotEmpty) {
//      responseOrderDetail = response.taxCalculation.orderDetail;
//      bool someProductsUpdated = false;
//      bool previousValue=isOrderVariations;
//      isOrderVariations = response.taxCalculation.isChanged;
//      for (int i = 0; i < responseOrderDetail.length; i++) {
//        if (responseOrderDetail[i].productStatus.compareTo('out_of_stock') ==
//                0 ||
//            responseOrderDetail[i].productStatus.compareTo('price_changed') ==
//                0) {
//          someProductsUpdated = true;
//          break;
//        }
//      }
//      //check any variation made
//      if(previousValue){
//        //check current value=
//        if(!isOrderVariations){
//          someProductsUpdated=true;
//        }
//      }
//
//      if (someProductsUpdated) {
//        Utils.hideProgressDialog(context);
//        DialogUtils.displayCommonDialog(
//            context,
//            storeModel == null ? "" : storeModel.storeName,
//            "Some Cart items were updated. Please review the cart before procceeding.",
//            buttonText: 'ok');
//        constraints();
//        //remove coupon
//        setState(() {
//          hideRemoveCouponFirstTime = true;
//          taxModel = response.taxCalculation;
//          appliedCouponCodeList.clear();
//          appliedReddemPointsCodeList.clear();
//          isCouponsApplied = false;
//          couponCodeController.text = "";
//        });
//        return;
//      }
//    }
//    calculateTotalSavings();

    if (taxModel != null &&
        taxModel.wallet_refund != "0" &&
        double.parse(taxModel.total) == 0 &&
        widget.paymentMode != '2') {
      Utils.hideProgressDialog(context);
      Utils.showToast("Choose COD Method to Avail Wallet balance", false);
      return;
    }
    //Choose payment
    if (widget.paymentMode == "3") {
      Utils.hideProgressDialog(context);
      if (ispaytmSelected) {
        callPaymentGateWay("Paytmpay", storeObject);
      } else {
        String paymentGateway = storeObject.paymentGateway;
        if (storeObject.paymentGatewaySettings != null &&
            storeObject.paymentGatewaySettings.isNotEmpty) {
          //case only single gateway is comming
          if (storeObject.paymentGatewaySettings.length == 1) {
            paymentGateway =
                storeObject.paymentGatewaySettings.first.paymentGateway;
            callPaymentGateWay(paymentGateway, storeObject);
          } else {
            //remove paytm option
            int indexToRemove = -1;
            for (int i = 0;
                i < storeObject.paymentGatewaySettings.length;
                i++) {
              if (storeObject.paymentGatewaySettings[i].paymentGateway
                  .toLowerCase()
                  .contains('paytm')) {
                indexToRemove = i;
                break;
              }
            }
            if (indexToRemove != -1) {
              storeObject.paymentGatewaySettings.removeAt(indexToRemove);
            }
            if (storeObject.paymentGatewaySettings.length == 1) {
              paymentGateway =
                  storeObject.paymentGatewaySettings.first.paymentGateway;
              callPaymentGateWay(paymentGateway, storeObject);
            } else {
              String result =
                  await DialogUtils.displayMultipleOnlinePaymentMethodDialog(
                      context, storeObject);
              if (result.isEmpty) {
                Utils.hideProgressDialog(context);
                return;
              }
              paymentGateway = result;
              callPaymentGateWay(paymentGateway, storeObject);
            }
          }
          return;
        } else {
          //case payment gateway setting list empty
          callPaymentGateWay(paymentGateway, storeObject);
        }
      }
    } else if (widget.paymentMode == '0') {
      Utils.hideProgressDialog(context);
      DialogUtils.displayCommonDialog(
          context, "Alert", "Payment method not available!");
    } else {
      placeOrderApiCall("", "", "");
    }
  }

  callPaymentGateWay(String paymentGateway, StoreModel storeObject) {
    Utils.hideProgressDialog(context);
    switch (paymentGateway) {
      case "Razorpay":
        callOrderIdApi(storeObject);
        break;
      case "Stripe":
        callStripeApi();
        break;
      case "Paytmpay":
        callPaytmPayApi();
        break;
    }
  }

  checkDeliveryAreaDeleted(StoreModel storeObject, {String addressId = ""}) {
    Utils.showProgressDialog(context);
    ApiController.getAddressApiRequest().then((responses) async {
      int length = responses.data.length;
      List<DeliveryAddressData> list = await Utils.checkDeletedAreaFromStore(
          context, responses.data,
          showDialogBool: true, hitApi: false, id: addressId);
      if (length != responses.data.length) {
//        print("Area deleted list.length${list.length}");
        Navigator.of(context).pop();
      } else {
        performPlaceOrderOperation(storeObject);
      }
    });
  }

  Future<bool> removeCoupon() async {
    bool isNetworkAvailable = await Utils.isNetworkAvailable();
    if (!isNetworkAvailable) {
      Utils.showToast(AppConstant.noInternet, false);
      return Future(() => false);
    }
    Utils.showProgressDialog(context);
    databaseHelper
        .getCartItemsListToJson(
            isOrderVariations: isOrderVariations,
            responseOrderDetail: responseOrderDetail)
        .then((json) {
      ApiController.multipleTaxCalculationRequest(
              "", "0", "${shippingCharges}", json)
          .then((response) async {
        Utils.hideProgressDialog(context);
        Utils.hideKeyboard(context);
        if (response != null && !response.success) {
          Utils.showToast(response.message, true);
          databaseHelper.deleteTable(DatabaseHelper.Favorite_Table);
          databaseHelper.deleteTable(DatabaseHelper.CART_Table);
          databaseHelper.deleteTable(DatabaseHelper.Products_Table);
          eventBus.fire(updateCartCount());
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else {
          await updateTaxDetails(response.taxCalculation);
          if (response.taxCalculation.orderDetail != null &&
              response.taxCalculation.orderDetail.isNotEmpty) {
            responseOrderDetail = response.taxCalculation.orderDetail;
            bool someProductsUpdated = false;
            isOrderVariations = response.taxCalculation.isChanged;
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
                  storeModel == null ? "" : storeModel.storeName,
                  "Some Cart items were updated. Please review the cart before procceeding.",
                  buttonText: 'Procceed');
              constraints();
            }
          }
          calculateTotalSavings();

          setState(() {
            hideRemoveCouponFirstTime = true;
            taxModel = response.taxCalculation;
            appliedCouponCodeList.clear();
            appliedReddemPointsCodeList.clear();
            isCouponsApplied = false;
            couponCodeController.text = "";
          });
          return Future(() => true);
        }
      });
    });
  }

  Future<void> checkMinOrderAmount() async {
    if (widget.deliveryType == OrderType.Delivery) {
      print("----minAmount=${widget.address.minAmount}");
      print("----notAllow=${widget.address.notAllow}");
      print("--------------------------------------------");
      int minAmount = 0;
      try {
        try {
          minAmount = double.parse(widget.address.minAmount).toInt();
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

        if (widget.address.notAllow) {
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
              // if (widget.address.isShippingMandatory == '0') {
              //   shippingCharges = "0";
              //   widget.address.areaCharges = "0";
              // }
            });
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> checkMinOrderPickAmount() async {
    if (widget.deliveryType == OrderType.PickUp && widget.areaObject != null) {
      print("----minAmount=${widget.areaObject.minOrder}");
      print("----notAllow=${widget.areaObject.notAllow}");
      print("--------------------------------------------");
      int minAmount = 0;
      try {
        try {
          if (widget.areaObject.minOrder.isNotEmpty)
            minAmount = double.parse(widget.areaObject.minOrder).toInt();
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

  void callStripeApi() async {
    Utils.showProgressDialog(context);
    double price = double.parse(taxModel.total);
    price = price * 100;
    print("----taxModel.total----${taxModel.total}--");
    String mPrice =
        price.toString().substring(0, price.toString().indexOf('.')).trim();
    print("----mPrice----${mPrice}--");
    UserModel user = await SharedPrefs.getUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.deviceId);
    String deviceToken = prefs.getString(AppConstant.deviceToken);
    Utils.getCartItemsListToJson(
            isOrderVariations: isOrderVariations,
            responseOrderDetail: responseOrderDetail,
            cartList: cartListFromDB)
        .then((orderJson) {
      if (orderJson == null) {
        print("--orderjson == null-orderjson == null-");
        return;
      }
      String storeAddress = "";
      try {
        storeAddress = "${storeModel.storeName}, ${storeModel.location},"
            "${storeModel.city}, ${storeModel.state}, ${storeModel.country}, ${storeModel.zipcode}";
      } catch (e) {
        print(e);
      }

      String userId = user.id;
      OrderDetailsModel detailsModel = OrderDetailsModel(
          shippingCharges,
          comment,
          totalPrice.toString(),
          widget.paymentMode,
          taxModel,
          widget.address,
          widget.isComingFromPickUpScreen,
          widget.areaId,
          widget.deliveryType,
          "",
          "",
          deviceId,
          "Stripe",
          userId,
          deviceToken,
          storeAddress,
          selectedDeliverSlotValue,
          totalSavingsText);

      ApiController.stripePaymentApi(
              mPrice, orderJson, detailsModel.orderDetails,
              currencyAbbr: storeModel.currencyAbbr)
          .then((response) {
        Utils.hideProgressDialog(context);
        print("----stripePaymentApi------");
        if (response != null) {
          StripeCheckOutModel stripeCheckOutModel = response;
          if (stripeCheckOutModel.success) {
            //launchWebView(stripeCheckOutModel);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      StripeWebView(stripeCheckOutModel, storeModel)),
            );
          } else {
            Utils.showToast("${stripeCheckOutModel.message}!", true);
          }
        } else {
          Utils.showToast("Something went wrong!", true);
        }
      });
    });
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
      'name': '${storeModel.storeName}',
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

  void _handlePaymentSuccess(PaymentSuccessResponse responseObj) {
    //Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
    Utils.showProgressDialog(context);
    ApiController.razorpayVerifyTransactionApi(responseObj.orderId)
        .then((response) {
      //print("----razorpayVerifyTransactionApi----${response}--");
      if (response != null) {
        RazorpayOrderData model = response;
        if (model.success) {
          placeOrderApiCall(responseObj.orderId, model.data.id, "Razorpay");
        } else {
          Utils.showToast("Something went wrong!", true);
          Utils.hideProgressDialog(context);
        }
      } else {
        Utils.showToast("Something went wrong!", true);
        Utils.hideProgressDialog(context);
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: 'Payment Cancelled', timeInSecForIosWeb: 4);
    print("----_handlePaymentError--message--${response.message}--");
    print("----_handlePaymentError--code--${response.code.toString()}--");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    /*print("----ExternalWalletResponse----${response.walletName}--");
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);*/
  }

  void callOrderIdApi(StoreModel storeObject) async {
    Utils.showProgressDialog(context);
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
    Utils.getCartItemsListToJson(
            isOrderVariations: isOrderVariations,
            responseOrderDetail: responseOrderDetail,
            cartList: cartListFromDB)
        .then((orderJson) {
      if (orderJson == null) {
        print("--orderjson == null-orderjson == null-");
        Utils.hideProgressDialog(context);
        databaseHelper.deleteTable(DatabaseHelper.Favorite_Table);
        databaseHelper.deleteTable(DatabaseHelper.CART_Table);
        databaseHelper.deleteTable(DatabaseHelper.Products_Table);
        eventBus.fire(updateCartCount());
        Navigator.of(context).popUntil((route) => route.isFirst);
        Utils.showToast("something went wrong", false);
        return;
      }

      String storeAddress = "";
      try {
        storeAddress = "${storeModel.storeName}, ${storeModel.location},"
            "${storeModel.city}, ${storeModel.state}, ${storeModel.country}, ${storeModel.zipcode}";
      } catch (e) {
        print(e);
      }

      String userId = user.id;
      OrderDetailsModel detailsModel = OrderDetailsModel(
          shippingCharges,
          comment,
          totalPrice.toString(),
          widget.paymentMode,
          taxModel,
          widget.address,
          widget.isComingFromPickUpScreen,
          widget.areaId,
          widget.deliveryType,
          "",
          "",
          deviceId,
          "Razorpay",
          userId,
          deviceToken,
          storeAddress,
          selectedDeliverSlotValue,
          totalSavingsText);
      ApiController.razorpayCreateOrderApi(
              mPrice, orderJson, detailsModel.orderDetails)
          .then((response) {
        CreateOrderData model = response;
        if (model != null && response.success) {
          print("----razorpayCreateOrderApi----${response.data.id}--");
          openCheckout(model.data.id, storeObject);
        } else {
          Utils.showToast("${model.message}", true);
          Utils.hideProgressDialog(context);
        }
      });
    });
  }

  void placeOrderApiCall(
      String payment_request_id, String payment_id, String onlineMethod) {
    Utils.hideKeyboard(context);
    Utils.isNetworkAvailable().then((isNetworkAvailable) async {
      if (isNetworkAvailable == true) {
        /*databaseHelper
            .getCartItemsListToJson(
                isOrderVariations: isOrderVariations,
                responseOrderDetail: responseOrderDetail)
            .then((json) {*/
        Utils.getCartItemsListToJson(
                isOrderVariations: isOrderVariations,
                responseOrderDetail: responseOrderDetail,
                cartList: cartListFromDB)
            .then((json) {
          if (json == null) {
            print("--json == null-json == null-");
            return;
          }

//          String couponCode = taxModel == null ? "" : taxModel.couponCode;
//          String discount = taxModel == null ? "0" : taxModel.discount;
//          Utils.showProgressDialog(context);
//          ApiController.multipleTaxCalculationRequest(
//                  "${couponCode}", "${discount}", shippingCharges, json)
//              .then((response) {

          print("-paymentMode-${widget.paymentMode}");

          ApiController.placeOrderRequest(
                  shippingCharges,
                  comment,
                  totalPrice.toString(),
                  widget.paymentMode,
                  taxModel,
                  widget.address,
                  json,
                  widget.isComingFromPickUpScreen,
                  widget.areaId,
                  widget.deliveryType,
                  payment_request_id,
                  payment_id,
                  onlineMethod,
                  selectedDeliverSlotValue,
                  cart_saving: totalSavings.toStringAsFixed(2))
              .then((response) async {
            Utils.hideProgressDialog(context);
            if (response == null) {
              print("--response == null-response == null-");
              return;
            }
            eventBus.fire(updateCartCount());
            print("${widget.deliveryType}");
            //print("Location = ${storeModel.lat},${storeModel.lng}");
            if (widget.deliveryType == OrderType.PickUp) {
              bool result =
                  await DialogUtils.displayPickUpDialog(context, storeModel);
              if (result == true) {
                //print("==result== ${result}");
                await databaseHelper.deleteTable(DatabaseHelper.CART_Table);
                Navigator.of(context).popUntil((route) => route.isFirst);
                eventBus.fire(updateCartCount());
                DialogUtils.openMap(storeModel, double.parse(storeModel.lat),
                    double.parse(storeModel.lng));
              } else {
                //print("==result== ${result}");
                await databaseHelper.deleteTable(DatabaseHelper.CART_Table);
                eventBus.fire(updateCartCount());
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            } else {
              bool result = await DialogUtils.displayThankYouDialog(context,
                  response.success ? AppConstant.orderAdded : response.message);
              if (result == true) {
                await databaseHelper.deleteTable(DatabaseHelper.CART_Table);
                Navigator.of(context).popUntil((route) => route.isFirst);
                eventBus.fire(updateCartCount());
              }
            }
          });
        });
      } else {
        Utils.showToast(AppConstant.noInternet, false);
      }
    });
  }

  void initRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void listenWebViewChanges() {
    eventBus.on<onPageFinished>().listen((event) {
      print("<---onPageFinished------->");
      callStripeVerificationApi(event.url);
    });

    eventBus.on<onPayTMPageFinished>().listen((event) {
      print("Event Bus called");
      callPaytmApi(event.url, event.orderId, event.txnId);
    });
  }

  void callPaytmApi(String url, String orderId, String txnID) {
    Utils.showProgressDialog(context);
    placeOrderApiCall(orderId, txnID, 'paytm');
  }

  void callStripeVerificationApi(String payment_request_id) {
    Utils.showProgressDialog(context);
    ApiController.stripeVerifyTransactionApi(payment_request_id)
        .then((response) {
      Utils.hideProgressDialog(context);
      if (response != null) {
        StripeVerifyModel object = response;
        if (object.success) {
          placeOrderApiCall(payment_request_id, object.paymentId, "Stripe");
        } else {
          Utils.showToast(
              "Transaction is not completed, please try again!", true);
          Utils.hideProgressDialog(context);
        }
      } else {
        Utils.showToast("Something went wrong!", true);
        Utils.hideProgressDialog(context);
      }
    });
  }

  bool isloyalityPointsEnabled = false;

  void checkLoyalityPointsOption() {
    //1 - enable, 0 means disable
    try {
      print("====-loyality===== ${storeModel.loyality}--");
      if (storeModel.loyality != null && storeModel.loyality == "1") {
        this.isloyalityPointsEnabled = true;
      } else {
        this.isloyalityPointsEnabled = false;
      }
    } catch (e) {
      print(e);
    }
  }

  Widget addCommentWidget(BuildContext context) {
    return !isCommentAdded
        ? InkWell(
            onTap: () async {
              String result =
                  await DialogUtils.displayCommentDialog(context, comment);
              comment = result;
              if (comment != "") {
                setState(() {
                  isCommentAdded = !isCommentAdded;
                });
              }
            },
            child: Container(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Padding(
                      child: Icon(Icons.add, size: 18.0),
                      padding: EdgeInsets.only(right: 3),
                    ),
                    new Text(
                      "Add Comment",
                      style: new TextStyle(
                          fontSize: 16.0,
                          fontFamily: 'Medium',
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    )
                  ],
                ),
                color: grayLightColor),
          )
        : Container(
            padding: const EdgeInsets.all(20.0),
            child: getCommentedView(context),
            color: grayLightColor);
  }

  Widget getCommentedView(BuildContext context) {
    return Wrap(children: <Widget>[
      Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: new Text(
                "Your Comment",
                style: new TextStyle(
                    fontFamily: 'bold',
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )),
              InkWell(
                onTap: () async {
                  String result =
                      await DialogUtils.displayCommentDialog(context, comment);
                  comment = result;
                  setState(() {
                    if (comment != "") {
                      isCommentAdded = true;
                    } else {
                      isCommentAdded = false;
                    }
                  });
                },
                child: Padding(
                  child: Icon(
                    Icons.edit,
                    size: 18.0,
                  ),
                  padding: EdgeInsets.only(right: 5, left: 5),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    comment = "";
                    isCommentAdded = false;
                    Utils.showToast("Comment Deleted", true);
                  });
                },
                child: Padding(
                  child: Icon(Icons.delete, size: 18.0),
                  padding: EdgeInsets.only(right: 5, left: 5),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: new Text(
                    comment,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ],
      )
    ]);
  }

  void checkPaytmActive() {
    String paymentGateway = storeModel.paymentGateway;
    if (storeModel.paymentGatewaySettings != null &&
        storeModel.paymentGatewaySettings.isNotEmpty) {
      //case only single gateway is comming
      if (storeModel.paymentGatewaySettings.length == 1) {
        paymentGateway = storeModel.paymentGatewaySettings.first.paymentGateway;
        if (paymentGateway.toLowerCase().contains('paytm')) {
          isPayTmActive = true;
          thirdOptionPGText = 'Online';
        } else {
          isPayTmActive = false;
          isAnotherOnlinePaymentGatwayFound = true;
        }
      } else {
        for (int i = 0; i < storeModel.paymentGatewaySettings.length; i++) {
          paymentGateway = storeModel.paymentGatewaySettings[i].paymentGateway;
          if (paymentGateway.toLowerCase().contains('paytm')) {
            isPayTmActive = true;
          } else {
            isAnotherOnlinePaymentGatwayFound = true;
          }
        }
      }
    } else {
      if (paymentGateway.toLowerCase().contains('paytm')) {
        isPayTmActive = true;
      } else {
        isPayTmActive = false;
        isAnotherOnlinePaymentGatwayFound = false;
      }
    }
  }

  void constraints() {
    try {
      if (widget.address != null) {
        if (widget.address.areaCharges != null) {
          if (responseOrderDetail.isNotEmpty && checkThatItemIsInStocks())
            shippingCharges = '0';
          else {
            shippingCharges = widget.address.areaCharges;
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

  void actionConfirmOrder() async {
    StoreModel storeObject = await SharedPrefs.getStore();
    if (taxModel.storeStatus == "0") {
      Utils.showToast("${taxModel.storeMsg}", false);
      return;
    }
    bool status =
        Utils.checkStoreTaxOpenTime(taxModel, storeObject, widget.deliveryType);
    print("----checkStoreOpenTime----${status}--*****************");

    if (!status) {
      Utils.showToast("${taxModel.storeTimeSetting.closehoursMessage}", false);
      return;
    }
    if (widget.deliveryType == OrderType.Delivery && widget.address.notAllow) {
      if (!minOrderCheck) {
        Utils.showToast(
            "Your order amount is too low. Minimum order amount is ${widget.address.minAmount}",
            false);
        return;
      }
    }
    if (widget.deliveryType == OrderType.PickUp && widget.areaObject != null) {
      if (!minOrderCheck) {
        Utils.showToast(
            "Your order amount is too low. Minimum order amount is ${widget.areaObject.minOrder}",
            false);
        return;
      }
    }
    if (checkThatItemIsInStocks()) {
      DialogUtils.displayCommonDialog(
          context,
          storeModel == null ? "" : storeModel.storeName,
          "Some Cart items were updated. Please review the cart before procceeding.",
          buttonText: 'Ok');
      return;
    }
//              if (storeModel.onlinePayment == "1") {
//                var result = await DialogUtils.displayPaymentDialog(
//                    context, "Select Payment", "");
//                //print("----result----${result}--");
//                if (result == null) {
//                  return;
//                }
//                if (result == PaymentType.ONLINE) {
//                  widget.paymentMode = "3";
//                } else {
//                  widget.paymentMode = "2"; //cod
//                }
//              } else {
//                widget.paymentMode = "2"; //cod
//              }

    print("----paymentMod----${widget.paymentMode}--");
    print("-paymentGateway----${storeObject.paymentGateway}-}-");

    bool isNetworkAvailable = await Utils.isNetworkAvailable();
    if (!isNetworkAvailable) {
      Utils.showToast(AppConstant.noInternet, false);
      return;
    }

    if (widget.deliveryType == OrderType.Delivery) {
      if (storeObject.deliverySlot == "0") {
        selectedDeliverSlotValue = "";
      } else {
        //Store provides instant delivery of the orders.
        print(isInstantDelivery);
        if (isDeliveryResponseFalse) {
          selectedDeliverSlotValue = "";
        } else if (storeObject.deliverySlot == "1" && isInstantDelivery) {
          //Store provides instant delivery of the orders.
          selectedDeliverSlotValue = "";
        } else if (storeObject.deliverySlot == "1" &&
            !isSlotSelected &&
            !isInstantDelivery) {
          Utils.showToast("Please select delivery slot", false);
          return;
        } else {
          String slotDate =
              deliverySlotModel.data.dateTimeCollection[selctedTag].label;
          String timeSlot = deliverySlotModel.data
              .dateTimeCollection[selctedTag].timeslot[selectedTimeSlot].label;
          selectedDeliverSlotValue =
              "${Utils.convertDateFormat(slotDate)} ${timeSlot}";
          //print("selectedDeliverSlotValue= ${selectedDeliverSlotValue}");
        }
      }
    } else {
      selectedDeliverSlotValue = "";
    }

    if (widget.deliveryType == OrderType.Delivery) {
      //The "performPlaceOrderOperation" are called in below method
      checkDeliveryAreaDeleted(storeObject, addressId: widget.address.id);
    } else if (widget.deliveryType == OrderType.PickUp) {
      performPlaceOrderOperation(storeObject);
    }
  }

  Widget addVegNonVegOption(Product product) {
    Color foodOption =
        product.nutrient == "Non Veg" ? Colors.red : Colors.green;
    return Visibility(
      visible: product.nutrient != null && product.nutrient.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.only(left: 0, right: 7),
        child: product.nutrient == "None"
            ? Container()
            : Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: new Border.all(
                    color: foodOption,
                    width: 1.0,
                  ),
                ),
                width: 16,
                height: 16,
                child: Padding(
                  padding: EdgeInsets.all(3),
                  child: Container(
                      decoration: new BoxDecoration(
                    color: foodOption,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(5.0)),
                  )),
                )),
      ),
    );
  }
}

/*Code for ios*/
class StripeWebView extends StatefulWidget {
  StripeCheckOutModel stripeCheckOutModel;
  StoreModel storeModel;

  StripeWebView(this.stripeCheckOutModel, this.storeModel);

  @override
  _StripeWebViewState createState() {
    return _StripeWebViewState();
  }
}

class _StripeWebViewState extends State<StripeWebView> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //print("onWillPop onWillPop");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Used for removing back buttoon.
          title: Text('Payment'),
          centerTitle: true,
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: '${widget.stripeCheckOutModel.checkoutUrl}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              //print('=======NavigationRequest======= $request}');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              //print('======Page started loading======: $url');
            },
            onPageFinished: (String url) {
              print('======Page finished loading======: $url');
              if (url
                  .contains("api/stripeVerifyTransaction?response=success")) {
                eventBus.fire(onPageFinished(
                    widget.stripeCheckOutModel.paymentRequestId));
                Navigator.pop(context);
              } else if (url
                  .contains('stripeVerifyTransaction?response=error')) {
                Navigator.pop(context);
                Utils.showToast("Payment cancel", false);
              }
            },
            gestureNavigationEnabled: false,
          );
        }),
      ),
    );
  }
}

class PaytmWebView extends StatelessWidget {
  CreatePaytmTxnTokenResponse stripeCheckOutModel;
  StoreModel storeModel;
  String amount;
  Completer<WebViewController> _controller = Completer<WebViewController>();

  bool isPaytmPaymentSuccessed = false;

  PaytmWebView(this.stripeCheckOutModel, this.storeModel, {this.amount = ''});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //print("onWillPop onWillPop");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Used for removing back buttoon.
          title: Text('Payment'),
          centerTitle: true,
        ),
        body: Builder(builder: (BuildContext context) {
          return WebView(
            initialUrl: '${stripeCheckOutModel.url}',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              //print('=======NavigationRequest======= $request}');
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              //print('======Page started loading======: $url');
            },
            onPageFinished: (String url) {
              print('==2====onLoadStop======: $url');
              if (url.contains("/api/paytmPaymentResult/orderId:") &&
                  !isPaytmPaymentSuccessed) {
                isPaytmPaymentSuccessed = true;
                print('==2====onLoadStop======:isPaytmPaymentSuccessed $url');
                String txnId =
                    url.substring(url.indexOf("/TxnId:") + "/TxnId:".length);
                url = url.replaceAll("/TxnId:" + txnId, "");
                String orderId = url
                    .substring(url.indexOf("/orderId:") + "/orderId:".length);
                print(txnId);
                print(orderId);
                eventBus.fire(onPayTMPageFinished(
                    url, orderId = orderId, txnId = txnId,
                    amount: amount));
                Navigator.pop(context);
              } else if (url.contains("api/paytmPaymentResult/failure:")) {
                Navigator.pop(context);
                Utils.showToast("Payment Failed", false);
              }
            },
            gestureNavigationEnabled: false,
          );
        }),
      ),
    );
  }
}

/*Code for android*/
/*class StripeWebView extends StatefulWidget {
  StripeCheckOutModel stripeCheckOutModel;
  StoreModel storeModel;

  StripeWebView(this.stripeCheckOutModel, this.storeModel);

  @override
  _StripeWebViewState createState() {
    return _StripeWebViewState();
  }
}

class _StripeWebViewState extends State<StripeWebView> {
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //print("onWillPop onWillPop");
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Used for removing back buttoon.
          title: Text('Payment'),
          centerTitle: true,
        ),
        body: Builder(builder: (BuildContext context) {
          return InAppWebView(
            initialUrl: "${widget.stripeCheckOutModel.checkoutUrl}",
            initialHeaders: {},
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                    javaScriptEnabled: true,
                    javaScriptCanOpenWindowsAutomatically: true)),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              print('==1====onLoadStart======: $url');
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              if (url
                  .contains("api/stripeVerifyTransaction?response=success")) {
                eventBus.fire(onPageFinished(
                    widget.stripeCheckOutModel.paymentRequestId));
                Navigator.pop(context);
              }
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              //print('==3====onProgressChanged======: $progress');
            },
          );
        }),
      ),
    );
  }
}

class PaytmWebView extends StatelessWidget {
  CreatePaytmTxnTokenResponse stripeCheckOutModel;
  InAppWebViewController webView;
  StoreModel storeModel;

  PaytmWebView(this.stripeCheckOutModel, this.storeModel);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Used for removing back buttoon.
          title: Text('Payment'),
          centerTitle: true,
        ),
        body: Builder(builder: (BuildContext context) {
          return InAppWebView(
            initialUrl: "${stripeCheckOutModel.url}",
            initialHeaders: {},
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                    debuggingEnabled: true,
                    javaScriptEnabled: true,
                    javaScriptCanOpenWindowsAutomatically: true)),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              print('==1====onLoadStart======: $url');
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              print('==2====onLoadStop======: $url');
              if (url.contains("/api/paytmPaymentResult/orderId:")) {
                String txnId =
                    url.substring(url.indexOf("/TxnId:") + "/TxnId:".length);
                url = url.replaceAll("/TxnId:" + txnId, "");
                String orderId = url
                    .substring(url.indexOf("/orderId:") + "/orderId:".length);
                print(txnId);
                print(orderId);
                eventBus.fire(
                    onPayTMPageFinished(url, orderId = orderId, txnId = txnId));
                Navigator.pop(context);
              } else if (url.contains("api/paytmPaymentResult/failure:")) {
                Navigator.pop(context);
                Utils.showToast("Payment Failed", false);
              }
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              //print('==3====onProgressChanged======: $progress');
            },
          );
        }),
      ),
    );
  }
}*/
