import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restroapp/src/Screens/BookOrder/ConfirmOrderScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CreateOrderData.dart';
import 'package:restroapp/src/models/RazorpayError.dart';
import 'package:restroapp/src/models/WalletOnlineTopUp.dart';
import 'package:restroapp/src/models/RazorPayTopUP.dart';
import 'package:restroapp/src/models/RazorpayOrderData.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/models/WalleModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/Utils.dart';

class WalletTopUp extends StatefulWidget {
  WalleModel walleModel;

  WalletTopUp(this.store, this.walleModel, {Key key}) : super(key: key);
  StoreModel store;

  @override
  _WalletTopUpState createState() {
    return _WalletTopUpState(walleModel);
  }
}

class _WalletTopUpState extends State<WalletTopUp> {
  WalleModel walleModel;
  final _enterMoney = new TextEditingController();

  Razorpay _razorpay;
  StoreModel storeModel;

  bool isPayTmSelected = false;
  bool isAnotherOnlinePaymentGatwayFound = false;
  bool isPayTmActive = false;

  _WalletTopUpState(this.walleModel,);

  @override
  void initState() {
    super.initState();
    initRazorPay();

    ApiController.getUserWallet().then((response) {
      setState(() {
        this.walleModel = response;
      });
    });

    //event bus
    eventBus.on<onPayTMPageFinished>().listen((event) {
      print(event.amount);
      callWalletOnlineTopApi(event.orderId, event.txnId, event.amount, 'paytm');

    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future(() => false);
      },
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SafeArea(
              child: GestureDetector(
                onTap: () {
                  Utils.hideKeyboard(context);
                },
                child: Container(
                  child: Column(
                    children: [
                      Container(
                          color: appTheme,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Wallet Balance",
                                    style: TextStyle(
                                        color: Colors.grey[400], fontSize: 16),
                                  ),
                                  walleModel == null
                                      ? Container()
                                      : Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              child: Text(
                                                  "${AppConstant.currency}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16)),
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 1, 0, 0),
                                            ),
                                            Text(
                                                "${walleModel.data.userWallet}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24)),
                                          ],
                                        ),
                                  SizedBox(
                                    height: 50,
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  "images/walletbalancegreaphics.png",
                                  width: 200,
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(height: 50, color: appTheme),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Text(
                                            'TopUp amount',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey[400],
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      30, 0, 0, 0),
                                                  child: Text(
                                                    AppConstant.currency,
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Flexible(
                                                child: Container(
                                                  width: 100,
                                                  //margin: EdgeInsets.fromLTRB(0,0,0,0),
                                                  child: TextFormField(
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      new LengthLimitingTextInputFormatter(
                                                          4),
                                                    ],
                                                    onChanged: (text) {
                                                      print(text);
                                                      print(
                                                          '${_enterMoney.text}');
                                                    },
                                                    controller: _enterMoney,
                                                    textAlign: TextAlign.left,
                                                    decoration: InputDecoration(
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      hintStyle: TextStyle(
                                                          fontSize: 20),
                                                      hintText: widget
                                                          .store
                                                          .walletSettings
                                                          .defaultTopUpAmount,
                                                      border: InputBorder.none,
                                                      errorBorder:
                                                          InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                            height: 1.8,
                                            indent: 60,
                                            endIndent: 60,
                                          ),
                                          // SizedBox(height: 250,),
                                        ],
                                      ),
                                      Visibility(
                                        visible: widget.store.walletSettings
                                                    .status ==
                                                '1' &&
                                            widget.store.walletSettings
                                                    .customerWalletTopUpStatus ==
                                                '1',
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 50),
                                          width: 180,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              print(
                                                  'Button pressed ${_enterMoney.text}');
                                              setState(() {
                                                checkTopUpCondition(
                                                    _enterMoney);
                                              });
                                            },
                                            child: Text('Submit'),
                                            style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(appTheme),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkTopUpCondition(TextEditingController enterMoney) async {
    //If user not entered his own amount then pick default amount
      String amount = enterMoney.text.trim().isNotEmpty
          ? enterMoney.text.trim()
          : widget.store.walletSettings.defaultTopUpAmount;

    StoreModel storeObject = await SharedPrefs.getStore();
    double wallet_balance = double.parse(walleModel.data.userWallet);

    double topupAmount = double.parse(amount);
    double minTopUpLimit =
        double.parse(widget.store.walletSettings.minTopUpAmount);
    double maxTopUpLimit =
        double.parse(widget.store.walletSettings.maxTopUpAmount);
    double maxWalletHoldingLimit =
        double.parse(widget.store.walletSettings.maxTopUpHoldAmount);
//minTopUpLimit
    if (topupAmount < 1) {
      print("Min top Up amount is ${minTopUpLimit}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Min top Up amount is ${widget.store.walletSettings.minTopUpAmount}'),
        ),
      );
    } else if (topupAmount > maxTopUpLimit) {
      print("Maximum topup limit is ${maxTopUpLimit}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Maximum topup limit is ${widget.store.walletSettings.maxTopUpAmount}'),
        ),
      );
    } else if (maxWalletHoldingLimit < (topupAmount + wallet_balance)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Your total wallet holding capacity is ${widget.store.walletSettings.maxTopUpHoldAmount}'),
        ),
      );
    } else {
      //callRazorPayToken(amount, storeObject);
     showModalBottomSheet<void>(
       backgroundColor: Colors.transparent,
       context: context,
       builder: (BuildContext context) {
         return Container(
           decoration: BoxDecoration(
             borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(15), topRight: Radius.circular(20)),
             color: Colors.white,
           ),
           height: 170,
           child: ListView.builder(
               itemCount: widget.store.paymentGatewaySettings.length,
               itemBuilder: (context, index) {
                 PaymentGatewaySettings paymentGatewaySettings =
                     widget.store.paymentGatewaySettings[index];
                 return Container(
                   decoration: BoxDecoration(
                     color: appTheme,
                     border: Border.all(
                       color: appTheme,
                       width: 0.5,
                     ),
                     borderRadius: BorderRadius.circular(12),
                   ),
                   margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                   child: ListTile(
                     onTap: () {
                       if (paymentGatewaySettings.paymentGateway
                           .toLowerCase()
                           .contains('paytm')) {
                         Navigator.pop(context);
                         callPayTmApi(amount, storeObject);
                       } else if (paymentGatewaySettings.paymentGateway
                           .toLowerCase()
                           .contains('razorpay')) {
                         Navigator.pop(context);
                         callRazorPayToken(amount, storeObject);
                       }
                     },
                     title: Text(
                       '* ${paymentGatewaySettings.paymentGateway}',
                       style: TextStyle(
                           fontSize: 18,
                           color: Colors.white,
                           fontWeight: FontWeight.bold),
                     ),
                   ),
                 );
               }),
         );
       },
     );
    }
  }

  //-----------------------------------------------------------------------------------------------
  //RazorPay Code Start
  callRazorPayToken(String mPrice, StoreModel store) {
    double price = double.parse(mPrice); //totalPrice ;
    print("=======1===${price}===total==${mPrice}======");
    price = price * 100;
    print("=======2===${price}===========");
    String mPriceUpdated =
        price.toString().substring(0, price.toString().indexOf('.'));
    Utils.showProgressDialog(context);
    ApiController.razorpayCreateOrderApi(mPriceUpdated, "", "",
            isWalletTopUP: true)
        .then((response) {
      CreateOrderData model = response;
      if (model != null && response.success) {
        print("----razorpayCreateOrderApi----${response.data.id}--");
        print("----razorpayCreateOrderApi----${response}--");
        // Hit createOnlineTopUpApi
        ApiController.createOnlineTopUPApi(mPrice, model.data.id)
            .then((response) {
          RazorPayTopUP modelPay = response;
          Utils.hideProgressDialog(context);
          if (modelPay != null && response.success) {
            //Opening Gateway
            openCheckout(store, mPrice, model.data.id);
          } else {
            Utils.showToast("${model.message}", true);
            Utils.hideProgressDialog(context);
          }
        });
      } else {
        print('def123');
        Utils.showToast("${model.message}", true);
        Utils.hideProgressDialog(context);
      }
    });
  }

  void openCheckout(
      StoreModel storeObject, String mprice, String razorPayID) async {
    Utils.hideProgressDialog(context);
    UserModel user = await SharedPrefs.getUser();
    print('${double.parse(mprice) * 100}');
    var options = {
      'key': '${storeObject.paymentSetting.apiKey}',
      'currency': 'INR',
      'order_id': razorPayID,
      'amount': (double.parse(mprice).round() * 100),
      'name': '${storeObject.storeName}',
      'description': '',
      'prefill': {
        'contact': '${user.phone}',
        'email': '${user.email}',
        'name': '${user.fullName}'
      },
    };
    try {
      //open payment gateway
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void initRazorPay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse responseObj) {
    //Show Loading....
    Utils.showProgressDialog(context);
    print(' razorpay------------------------- $responseObj');
    ApiController.razorpayVerifyTransactionApi(responseObj.orderId)
        .then((response) {
      print("----razorpayVerifyTransactionApi----${response}--");
      if (response != null) {
        RazorpayOrderData model = response;
        if (model.success) {
          double amount = model.data.amount / 100;
          callWalletOnlineTopApi(responseObj.paymentId, model.data.id,
              amount.toString(), 'razorpay');
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
    _showFailedDialog();
    try{
     String string= response.message;
    RazorpayError error =jsonDecode(string);
     Fluttertoast.showToast(msg: error.error.description, timeInSecForIosWeb: 4);

    }catch(e){

    }
    print("----_handlePaymentError--message--${response.message}--");
    print("----_handlePaymentError--code--${response.code.toString()}--");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    /*print("----ExternalWalletResponse----${response.walletName}--");
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);*/
  }

  Future<void> _showFailedDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: const Text(
            'Sorry!',
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Center(child: Text('Your transaction has failed.')),
                Center(child: Text('Please go back and try again.')),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    child: ElevatedButton(
                      child: Text('Ok'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(appTheme),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showSuccessDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: AlertDialog(
            title: Center(
                child: const Text(
              'Successful!',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Center(child: Text('Your transaction is successful.')),
                ],
              ),
            ),
            actions: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        child: Text('Ok'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(appTheme),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void callWalletOnlineTopApi(String paymentId, String paymentRequestId,
      String amount, String paymentType) {
    ApiController.onlineTopUP(paymentId, paymentRequestId, amount, paymentType)
        .then((response) {
      WalletOnlineTopUp modelPay = response;

      Utils.hideProgressDialog(context);
      _showSuccessDialog().then((value) => Navigator.pop(context, true));
    });
  }

//Razor Code End
//-----------------------------------------------------------------------------------------------
//Paytm Api

  void callPayTmApi(String mPrice, StoreModel store) async {
    DatabaseHelper databaseHelper = new DatabaseHelper();
    String address = "NA", pin = "NA";
    double amount = databaseHelper.roundOffPrice(double.parse(mPrice), 2);
    print("----amount----- ${amount}");
    Utils.showProgressDialog(context);
    ApiController.createPaytmTxnToken(address, pin, amount, "", "")
        .then((value) async {
      if (value != null && value.success) {
        ApiController.createOnlineTopUPApi(mPrice, value.orderid)
            .then((response) {
          RazorPayTopUP modelPay = response;
          print(response);
          Utils.hideProgressDialog(context);
          if (modelPay != null && response.success) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PaytmWebView(value, storeModel, amount: mPrice)),
            );
          } else {
            Utils.hideProgressDialog(context);
          }
        });
      } else {
        Utils.hideProgressDialog(context);
        Utils.showToast("Api Error", false);
      }
    });
  }
}
