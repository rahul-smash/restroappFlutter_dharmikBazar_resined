import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restroapp/src/Screens/Offers/AvailableOffersList.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CreateOrderData.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/RazorpayOrderData.dart';
import 'package:restroapp/src/models/StoreRadiousResponse.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class ConfirmOrderScreen extends StatefulWidget {

  bool isComingFromPickUpScreen;
  DeliveryAddressData address;
  String paymentMode; // 2 = COD, 3 = Online Payment
  String areaId;
  double shippingCharges = 0.0;

  ConfirmOrderScreen(this.address, this.paymentMode,this.isComingFromPickUpScreen,this.areaId);

  @override
  ConfirmOrderState createState() => ConfirmOrderState();
}

class ConfirmOrderState extends State<ConfirmOrderScreen> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  double totalPrice = 0.00;
  TaxCalculationModel taxModel;
  TextEditingController noteController = TextEditingController();
  String shippingCharges = "0";
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    try {
      if(widget.address != null){
            if(widget.address.areaCharges != null){
              shippingCharges = widget.address.areaCharges;
            }
          }
    } catch (e) {
      print(e);
    }

    databaseHelper.getTotalPrice().then((mTotalPrice) {
      setState(() {
        totalPrice = mTotalPrice;
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Text("Confirm Order"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Column(children: [
        Padding(
            padding: EdgeInsets.all(5),
            child: Container(
                height: 45,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                  border: new Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: noteController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    hintText: "Enter note",
                    border: InputBorder.none,
                  ),
                ))),
        Expanded(child: FutureBuilder(
          future: databaseHelper.getCartItemList(),
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.none &&
                projectSnap.hasData == null) {
              return Container();
            } else {
              if (projectSnap.hasData) {

                return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(color: Colors.grey, height: 1),
                  shrinkWrap: true,
                  itemCount: projectSnap.data.length + 1,
                  itemBuilder: (context, index) {
                    return index == projectSnap.data.length
                        ? addItemPrice(): addProductCart(projectSnap.data[index]);
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.black26,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.black26)),
                );
              }
            }
          },
        ))
      ]),
      bottomNavigationBar: Container(
        height: 125,
        color: Colors.white,
        child: Column(
          children: [addTotalPrice(), addCouponCodeRow(), addConfirmOrder()],
        ),
      ),
    );
  }

  Widget addProductCart(Product product) {
    return Container(
        padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(product.title,
                        style: TextStyle(fontWeight: FontWeight.bold))),
                Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text("Quantity: " + product.quantity)),
                Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 30),
                    child: Text("Price: " + "\$${product.price}")),
              ],
            ),
            Text(
                "\$${databaseHelper.roundOffPrice(int.parse(product.quantity) * double.parse(product.price), 2)}",
                style: TextStyle(fontSize: 16, color: Colors.black45)),
          ],
        ));
  }

  Widget addItemPrice() {

    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: 1,
            color: Colors.black45,
            width: MediaQuery.of(context).size.width),
        Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Items Price", style: TextStyle(color: Colors.black54)),
                Text("\$${databaseHelper.roundOffPrice(totalPrice, 2)}",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
        ),
        Visibility(
          visible: widget.address == null? false : true,
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Shipping Charges:", style: TextStyle(color: Colors.black54)),
                Text("\$${widget.address == null? "0" : widget.address.areaCharges}",
                    style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ),

      ]),
    );
  }


  Widget addTotalPrice() {
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            height: 1,
            color: Colors.black45,
            width: MediaQuery.of(context).size.width),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total",style:TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text("\$${databaseHelper.roundOffPrice(taxModel == null ? totalPrice : double.parse(taxModel.total), 2)+int.parse(shippingCharges)}",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ))
      ]),
    );
  }


  Widget addCouponCodeRow() {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: Row(
          children: <Widget>[
            new Flexible(
                child: Container(
                    width: 155.0,
                    height: 40.0,
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      border: new Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: Center(child: Text(
                        taxModel == null ? 'Coupon Code:' : taxModel.couponCode ?? "")))
                ),
            Container(
              width: 130.0,
              height: 40.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: RaisedButton(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: () {
                    if (taxModel != null) {
                      removeCoupon();
                    }
                  },
                  child: new Text(
                      taxModel == null ? "Apply Coupon" : "Remove Coupon",
                      softWrap: true),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AvailableOffersDialog(
                      widget.address, widget.paymentMode ,widget.isComingFromPickUpScreen,widget.areaId,(model) {
                        setState(() {
                          taxModel = model;
                        });
                  }),
                );
              },
              child: Text("Available\nOffers",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF0D47A1),
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
          ],
        ));
  }


  Widget addConfirmOrder() {
    return Container(
      height: 45.0,
      color: appTheme,
      child: InkWell(
        onTap: () {
          print("----paymentMod----${widget.paymentMode}--");
          if(widget.paymentMode == "3"){
            callOrderIdApi();
          }else{
            placeOrderApiCall("","","");
          }

        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Confirm Order",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  void removeCoupon() {
    Utils.showProgressDialog(context);
    databaseHelper.getCartItemsListToJson().then((json) {
      ApiController.multipleTaxCalculationRequest("", "0", "0", json)
          .then((response) {
        Utils.hideProgressDialog(context);
        setState(() {
          taxModel = null;
        });
      });
    });
  }


  String razorpay_orderId = "";
  void openCheckout(String razorpay_order_id) async {
    Utils.hideProgressDialog(context);
    UserModel user = await SharedPrefs.getUser();
    double price = totalPrice + int.parse(shippingCharges);
    razorpay_orderId = razorpay_order_id;
    var options = {
      'key': 'rzp_test_kc9p3xCAsk7Sl9',
      'currency': "INR",
      'order_id': razorpay_order_id,
      'amount': taxModel == null ? (price * 100) : (double.parse(taxModel.total) * 100),
      'name': '${user.fullName}',
      'description': '${noteController.text}',
      'prefill': {'contact': '${user.phone}', 'email': '${user.email}'},
      'external': {
        'wallets': ['paytm']
      }
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
    ApiController.razorpayVerifyTransactionApi(responseObj.orderId).then((response){
      print("----razorpayVerifyTransactionApi----${response}--");
      if(response != null){

        RazorpayOrderData model = response;
        if(model.success){
          placeOrderApiCall(responseObj.orderId,model.data.id,"razorpay");
        }else{
          Utils.showToast("Something went wrong!", true);
          Utils.hideProgressDialog(context);
        }
      }else{
        Utils.hideProgressDialog(context);
      }
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg:response.message,timeInSecForIos: 4);
    print("----_handlePaymentError--message--${response.message}--");
    print("----_handlePaymentError--code--${response.code.toString()}--");

  }

  void _handleExternalWallet(ExternalWalletResponse response) {

    /*print("----ExternalWalletResponse----${response.walletName}--");

    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);*/
  }

  void callOrderIdApi() {
    Utils.showProgressDialog(context);
    double price = totalPrice + int.parse(shippingCharges);
    print("=======1===${price}===========");
    price = price * 100;
    print("=======2===${price}===========");
    String mPrice = price.toString().substring(0 , price.toString().indexOf('.'));
    print("=======mPrice===${mPrice}===========");
    ApiController.razorpayCreateOrderApi(mPrice).then((response){
      print("----razorpayCreateOrderApi----${response.data.id}--");

      CreateOrderData model = response;
      if(model != null && response.success){

        openCheckout(model.data.id);

      }else{
        Utils.showToast("Something went wrong!", true);
        Utils.hideProgressDialog(context);
      }
    });
  }



  void placeOrderApiCall(String razorpay_order_id, String razorpay_payment_id, String onlineMethod) {
    Utils.isNetworkAvailable().then((isNetworkAvailable) async {
      if (isNetworkAvailable == true) {
        Utils.showProgressDialog(context);
        databaseHelper.getCartItemsListToJson().then((json) {

          ApiController.placeOrderRequest(shippingCharges,noteController.text, totalPrice.toString(),
              widget.paymentMode, taxModel, widget.address, json ,
              widget.isComingFromPickUpScreen,widget.areaId ,
              razorpay_order_id,razorpay_payment_id,onlineMethod)
              .then((response) {
            Utils.hideProgressDialog(context);
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                      title: new Text("Thank you!"),
                      content: Text(response.success
                          ? AppConstant.orderAdded
                          : response.message),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("Ok"),
                          onPressed: () async{

                            await databaseHelper.deleteTable(DatabaseHelper.CART_Table);

                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                        ),
                      ]);
                });
          });
        });
      } else {
        Utils.showToast(AppConstant.noInternet, false);
      }
    });
  }
}
