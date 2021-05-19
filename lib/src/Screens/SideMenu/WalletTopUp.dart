import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CreateOrderData.dart';
import 'package:restroapp/src/models/RazorPayOnlineTopUp.dart';
import 'package:restroapp/src/models/RazorPayTopUP.dart';
import 'package:restroapp/src/models/RazorpayOrderData.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/models/WalleModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class WalletTopUp extends StatefulWidget {
  WalletTopUp(this.store, {Key key}) : super(key: key);
  StoreModel store;

  @override
  _WalletTopUpState createState() {
    return _WalletTopUpState();
  }
}

class _WalletTopUpState extends State<WalletTopUp> {
  WalleModel walleModel;
  final _enterMoney = new TextEditingController();

  Razorpay _razorpay;
  List _paymentMethod = ['Razor Pay', 'Paytm'];

  @override
  void initState() {
    super.initState();
    initRazorPay();
    ApiController.getUserWallet().then((response) {
      setState(() {
        this.walleModel = response;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white70,
      // appBar: AppBar(
      //   elevation: 0,
      //  backgroundColor: appTheme,
      //   // title: Text(
      //   //   "Wallet Balance",
      //   //   style: TextStyle(
      //   //     color: Colors.white,
      //   //   ),
      //   // ),
      //  // centerTitle: true,
      //  //  leading: IconButton(
      //  //    icon: Icon(Icons.arrow_back,color: Colors.black,),
      //  //    onPressed: () => Navigator.pop(context),
      //  //  ),
      // ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            Utils.hideKeyboard(context);
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                          //height: 180,
                          color: appTheme,
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.all(0),
                                    //iconSize: 15,
                                    alignment: Alignment.topLeft,
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
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
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "images/walletbalancegreaphics.png",
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.fromLTRB(30, 172, 30, 0),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.370,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            //width: 200,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Text(
                                  'TopUp amount',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.grey[400]),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 0, 0, 0),
                                        child: Text(
                                          AppConstant.currency,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Flexible(
                                      child: Container(
                                        width: 100,
                                        //margin: EdgeInsets.fromLTRB(0,0,0,0),
                                        child: TextFormField(
                                          style: TextStyle(fontSize: 20),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onChanged: (text) {
                                            print(text);
                                          },
                                          controller: _enterMoney,
                                          textAlign: TextAlign.left,
                                          decoration: InputDecoration(
                                            focusedBorder: InputBorder.none,
                                            hintStyle: TextStyle(fontSize: 20),
                                            hintText: widget
                                                .store
                                                .walletSettings
                                                .defaultTopUpAmount,
                                            border: InputBorder.none,
                                            errorBorder: InputBorder.none,
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
                                SizedBox(
                                  height: 250,
                                ),
                                Container(
                                  width: 180,
                                  child: ElevatedButton(
                                    onPressed: () {

                                      print(_enterMoney.text);
                                      setState(() {
                                        checkTopUpCondition(_enterMoney);
                                      });
                                    },
                                    child: Text('Submit'),
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              appTheme),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkTopUpCondition(TextEditingController enterMoney)  async{
    StoreModel storeObject = await SharedPrefs.getStore();
    double wallet_balance = double.parse(walleModel.data.userWallet);
    print(wallet_balance);
    double topupAmount = double.parse(enterMoney.text);
    double min = double.parse(widget.store.walletSettings.minTopUpAmount);
    double max = double.parse(widget.store.walletSettings.maxTopUpAmount);
    double max_topUp_limit =
        double.parse(widget.store.walletSettings.maxTopUpHoldAmount);

    if (topupAmount < min) {
      print("Min top Up amount is ${min}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Min top Up amount is ${widget.store.walletSettings.minTopUpAmount}'),
        ),
      );
    }
    else if (topupAmount > max) {
      print("Maximum topup limit is ${max}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum topup limit is ${widget.store.walletSettings.maxTopUpAmount}'),
        ),
      );
    }
    else if (max_topUp_limit < topupAmount + wallet_balance) {
      print(
          "you can only topup if your topup amount is less than ${enterMoney.text + walleModel.data.userWallet}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('you can only topup if your topup amount is less than ${enterMoney.text + walleModel.data.userWallet}'),
        ),
      );
    }
    else {
      print("done");
      // showModalBottomSheet<void>(
      //     backgroundColor: Colors.transparent,
      //     context: context,
      //     builder: (BuildContext context) {
      //       return Container(
      //         decoration: BoxDecoration(
      //           borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight:Radius.circular(15) ),
      //           color: Colors.white,
      //         ),
      //         height: 200,
      //
      //         child: ListView.builder(
      //             itemCount: _paymentMethod.length,
      //             itemBuilder: (context, index)
      //             {
      //               return Container(
      //                 color:(_paymentMethod.contains(index)) ? Colors.blue.withOpacity(0.5) : Colors.transparent,
      //                 child: ListTile(
      //                   onTap: (){
      //                     if(! _paymentMethod.contains(index)){
      //                       setState(() {
      //                         _paymentMethod.add(index);
      //
      //                       });
      //                     }
      //                   },
      //                   title: Text('${_paymentMethod[index]}'),
      //                 ),
      //               );
      //             }
      //         ) ,
      //
      //       );
      //     },);

      callCreateToken(enterMoney.text.trim(), storeObject);
    }
  }

  //-----------------------------------------------------------------------------------------------
  //RazorPay Code Start
  callCreateToken(String mPrice, StoreModel store) {
    Utils.showProgressDialog(context);
    //TODO: amount--- Number 1
    ApiController.razorpayCreateOrderApi(
//            mPrice, orderJson, detailsModel.orderDetails)
            mPrice,
            "",
            "")
        .then((response) {
      CreateOrderData model = response;

      if (model != null && response.success) {
        print("----razorpayCreateOrderApi----${response.data.id}--");
            Utils.hideProgressDialog(context);
        //TODO: Hit Walltet Api -createOnlineTopUP---Number 2
        ApiController.createOnlineTopUPApi(
            mPrice, model.data.id )
            .then((response) {
          RazorPayTopUP modelPay = response;
          if (modelPay != null && response.success) {
            openCheckout(store,mPrice);
          } else {
            Utils.showToast("${model.message}", true);
            Utils.hideProgressDialog(context);
          }
        });
        //TODO: orderID
//        model.data.id
      } else {
        Utils.showToast("${model.message}", true);
        Utils.hideProgressDialog(context);
      }
    });
  }

  //TODO: This Method is used for opening RazorPay Gateway--- Number 3
  void openCheckout(
      StoreModel storeObject,String mprice) async {
    Utils.hideProgressDialog(context);
    UserModel user = await SharedPrefs.getUser();
    //double price = totalPrice ;
    var options = {
      'key': '${storeObject.paymentSetting.apiKey}',
      'currency': "INR",

      'amount': (double.parse(mprice) * 100),
      /*'external': {
        'wallets': ['paytm']
      }*/
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
    ApiController.razorpayVerifyTransactionApi(responseObj.orderId)
        .then((response) {
      print("----razorpayVerifyTransactionApi----${response}--");
      if (response != null) {
        RazorpayOrderData model = response;
        if (model.success) {
          //TODO: Remove loading After implementing WalletApi
         // Utils.hideProgressDialog(context);
          //TODO: hit here Wallet Api -onlineTopUP-- Number 4
          ApiController.onlineTopUP( responseObj.paymentId, model.data.id, model.data.amount
          )
              .then((response) {
            RazorPayOnlineTopUp modelPay = response;
            print(modelPay);

          });

        }else{
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
    Fluttertoast.showToast(msg: response.message, timeInSecForIosWeb: 4);
    print("----_handlePaymentError--message--${response.message}--");
    print("----_handlePaymentError--code--${response.code.toString()}--");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    /*print("----ExternalWalletResponse----${response.walletName}--");
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);*/
  }

//Razor Code End
//-----------------------------------------------------------------------------------------------

}
