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
  List _paymentMethod = ["Razor Pay", "PayTm"];

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
               child: Container(
                 child: Column(
                   children: [
                     Container(
                         color: appTheme,
                         padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                         child: Row(
                           mainAxisAlignment:
                           MainAxisAlignment.spaceBetween,
                           children: [
                             Column(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   "Wallet Balance",
                                   style: TextStyle(
                                       color: Colors.grey[400],
                                       fontSize: 16),
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
                                       padding:
                                       EdgeInsets.fromLTRB(
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
                           Container(
                             margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                             child: Container(
                               width: MediaQuery.of(context).size.width,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(5),
                                 color: Colors.white,
                               ),
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
                                   crossAxisAlignment:
                                       CrossAxisAlignment.center,
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
                                             print('${_enterMoney.text}');
                                           },
                                           controller: _enterMoney,
                                           textAlign: TextAlign.left,
                                           decoration: InputDecoration(
                                             focusedBorder: InputBorder.none,
                                             hintStyle:
                                                 TextStyle(fontSize: 20),
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

                                 ],
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
             Container(
               margin: EdgeInsets.only(bottom: 50),
               width: 180,
               child: ElevatedButton(
                 onPressed: () {
                   print(
                       'Button pressed ${_enterMoney.text}');
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
         //SafeArea(
        //   child: GestureDetector(
        //     onTap: () {
        //       Utils.hideKeyboard(context);
        //     },
        //     child: SingleChildScrollView(
        //       scrollDirection: Axis.vertical,
        //       child: Container(
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Stack(
        //               children: [
        //                 Container(
        //                     //height: 180,
        //                     color: appTheme,
        //                     padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        //                     child: Row(
        //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                       children: [
        //                         Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           mainAxisAlignment: MainAxisAlignment.start,
        //                           children: [
        //                             // IconButton(
        //                             //   padding: EdgeInsets.all(0),
        //                             //   //iconSize: 15,
        //                             //   alignment: Alignment.topLeft,
        //                             //   icon: Icon(
        //                             //     Icons.arrow_back,
        //                             //     color: Colors.white,
        //                             //   ),
        //                             //   onPressed: () => Navigator.pop(context,false),
        //                             // ),
        //                             Text(
        //                               "Wallet Balance",
        //                               style: TextStyle(
        //                                   color: Colors.grey[400],
        //                                   fontSize: 16),
        //                             ),
        //                             walleModel == null
        //                                 ? Container()
        //                                 : Row(
        //                                     crossAxisAlignment:
        //                                         CrossAxisAlignment.start,
        //                                     children: [
        //                                       Padding(
        //                                         child: Text(
        //                                             "${AppConstant.currency}",
        //                                             style: TextStyle(
        //                                                 color: Colors.white,
        //                                                 fontSize: 16)),
        //                                         padding: EdgeInsets.fromLTRB(
        //                                             0, 1, 0, 0),
        //                                       ),
        //                                       Text(
        //                                           "${walleModel.data.userWallet}",
        //                                           style: TextStyle(
        //                                               color: Colors.white,
        //                                               fontSize: 24)),
        //                                     ],
        //                                   ),
        //                             SizedBox(
        //                               height: 50,
        //                             )
        //                           ],
        //                         ),
        //                         Align(
        //                           alignment: Alignment.center,
        //                           child: Image.asset(
        //                             "images/walletbalancegreaphics.png",
        //                             width: 200,
        //                             height: 200,
        //                           ),
        //                         ),
        //                       ],
        //                     )),
        //                 Container(
        //                   margin: EdgeInsets.fromLTRB(30, 172, 30, 0),
        //                   child: Align(
        //                     alignment: Alignment.bottomCenter,
        //                     child: Container(
        //                       width: MediaQuery.of(context).size.width,
        //                       height:
        //                           MediaQuery.of(context).size.height / 1.370,
        //                       decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(5),
        //                         color: Colors.white,
        //                       ),
        //                       //width: 200,
        //                       child: Column(
        //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           Column(
        //                             children: [
        //                               SizedBox(
        //                                 height: 50,
        //                               ),
        //                               Text(
        //                                 'TopUp amount',
        //                                 style: TextStyle(
        //                                     fontSize: 20, color: Colors.grey[400]),
        //                               ),
        //                               SizedBox(
        //                                 height: 15,
        //                               ),
        //                               Row(
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.center,
        //                                 mainAxisAlignment: MainAxisAlignment.center,
        //                                 mainAxisSize: MainAxisSize.min,
        //                                 children: [
        //                                   Container(
        //                                       margin:
        //                                           EdgeInsets.fromLTRB(30, 0, 0, 0),
        //                                       child: Text(
        //                                         AppConstant.currency,
        //                                         style: TextStyle(
        //                                             fontSize: 22,
        //                                             fontWeight: FontWeight.bold),
        //                                       )),
        //                                   SizedBox(
        //                                     width: 5,
        //                                   ),
        //                                   Flexible(
        //                                     child: Container(
        //                                       width: 100,
        //                                       //margin: EdgeInsets.fromLTRB(0,0,0,0),
        //                                       child: TextFormField(
        //                                         style: TextStyle(fontSize: 20),
        //                                         keyboardType: TextInputType.number,
        //                                         inputFormatters: [
        //                                           FilteringTextInputFormatter
        //                                               .digitsOnly
        //                                         ],
        //                                         onChanged: (text) {
        //                                           print(text);
        //                                           print('${_enterMoney.text}');
        //                                         },
        //                                         controller: _enterMoney,
        //                                         textAlign: TextAlign.left,
        //                                         decoration: InputDecoration(
        //                                           focusedBorder: InputBorder.none,
        //                                           hintStyle:
        //                                               TextStyle(fontSize: 20),
        //                                           hintText: widget
        //                                               .store
        //                                               .walletSettings
        //                                               .defaultTopUpAmount,
        //                                           border: InputBorder.none,
        //                                           errorBorder: InputBorder.none,
        //                                         ),
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ],
        //                               ),
        //                               Divider(
        //                                 color: Colors.grey,
        //                                 height: 1.8,
        //                                 indent: 60,
        //                                 endIndent: 60,
        //                               ),
        //                             ],
        //                           ),
        //                           Container(
        //                             margin: EdgeInsets.only(bottom: 100),
        //                             width: 180,
        //                             child: ElevatedButton(
        //                               onPressed: () {
        //                                 print(
        //                                     'Button pressed ${_enterMoney.text}');
        //                                 setState(() {
        //                                   checkTopUpCondition(_enterMoney);
        //                                 });
        //                               },
        //                               child: Text('Submit'),
        //                               style: ButtonStyle(
        //                                 foregroundColor:
        //                                 MaterialStateProperty.all<Color>(
        //                                     Colors.white),
        //                                 backgroundColor:
        //                                 MaterialStateProperty.all<Color>(
        //                                     appTheme),
        //                                 shape: MaterialStateProperty.all<
        //                                     RoundedRectangleBorder>(
        //                                   RoundedRectangleBorder(
        //                                     borderRadius:
        //                                     BorderRadius.circular(20),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
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

    if (topupAmount < minTopUpLimit) {
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

      showModalBottomSheet<void>(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight:Radius.circular(20) ),
                color: Colors.white,
              ),
              height: 200,
              child: ListView.builder(
                  itemCount: _paymentMethod.length,
                  itemBuilder: (context, index)
                  {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(
                          //color: Colors.blue,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        onTap: (){
                          if(index == 0){
                            Navigator.pop(context);
                            callCreateToken(amount, storeObject);
                          }
                          else{
                            print('Choose Paytm');

                          }
                        },
                        title: Text('* ${_paymentMethod[index]}',style: TextStyle(fontSize: 18,),),
                      ),
                    );
                  }
              ) ,
            );
          },);
    }
  }

  //-----------------------------------------------------------------------------------------------
  //RazorPay Code Start
  callCreateToken(String mPrice, StoreModel store) {
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
          double amount= model.data.amount/100;
          ApiController.onlineTopUP(
                  responseObj.paymentId, model.data.id, amount.toString())
              .then((response)  {
            RazorPayOnlineTopUp modelPay = response;
            print(modelPay);
            Utils.hideProgressDialog(context);
            Navigator.pop(context);
            _showSuccessDialog();
          });
        } else {
          _showFailedDialog();
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
    Fluttertoast.showToast(msg: response.message, timeInSecForIosWeb: 4);
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
          title: Center(child: const Text('Sorry!',style: TextStyle(fontWeight: FontWeight.bold),)),
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
                      child:  Text('Ok'),
                      style: ButtonStyle(
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
  Future<void> _showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Successful!',style: TextStyle(fontWeight: FontWeight.bold),)),
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
                      child:  Text('Ok'),
                      style: ButtonStyle(
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
//Razor Code End
//-----------------------------------------------------------------------------------------------

}
