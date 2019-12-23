import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/Screens/SaveDeliveryAddress.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/CartData.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class ConfirmOrder extends StatefulWidget {

  DeliveryAddressData mArea;
  bool runOnlyOnce = false;
  double fixed_discount_amount = 0.0;

  ConfirmOrder(this.mArea);

  ConfirmOrderState addressState = new ConfirmOrderState();
  @override
  ConfirmOrderState createState() => addressState;
}

class ConfirmOrderState extends State<ConfirmOrder> {

  ProceedBottomBar proceedBottomBar = new ProceedBottomBar();
  DatabaseHelper databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {

    /*if(widget.runOnlyOnce == false){
      DatabaseHelper databaseHelper = new DatabaseHelper();
      databaseHelper.getCartItemsListToJson().then((json){
        ApiController.multipleTaxCalculationRequest(widget.fixed_discount_amount.toString(),
            "0", "0.00", "0", json).then((response){
          widget.runOnlyOnce = true;
        });
      });
    }*/

    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      appBar: AppBar(
          title: Text("Confirm Order"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Divider(color: Colors.white, height: 2.0),
              Container(
                child: InkWell(
                  onTap: () {
                    print("on click message");
                  },
                  child: FutureBuilder(
                    future: databaseHelper.getCartItemList(),
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState == ConnectionState.none &&
                          projectSnap.hasData == null) {
                        //print('project snapshot data is: ${projectSnap.data}');
                        return Container(color: const Color(0xFFFFE306));
                      } else {
                        if (projectSnap.hasData) {
                          //print('---projectSnap.Data-length-${projectSnap.data.length}---');
                          proceedBottomBar.state.checkForDeliverAdresses(projectSnap.data.length, widget.mArea);
                          return ListView.separated(
                            separatorBuilder: (BuildContext context, int index) => Divider(),
                            shrinkWrap: true,
                            primary: false,
                            //Your Column doesn't know how much height it will take. use this
                            itemCount: projectSnap.data.length,
                            itemBuilder: (context, index) {
                              CartProductData cartProductData =
                              projectSnap.data[index];
                              //print('-------ListView.builder-----${index}');
                              return Column(
                                children: <Widget>[
                                  new ListTileItem(cartProductData, proceedBottomBar),
                                ],
                              );
                            },
                          );
                        } else {
                          //print('-------CircularProgressIndicator----------');
                          return Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.black26,
                                valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black26)),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          )
      ),
      //body: ,
      bottomNavigationBar: proceedBottomBar,
    );
  }
}

//============================Cart List Item widget=====================================
class ListTileItem extends StatefulWidget {
  CartProductData cartProductData;
  ProceedBottomBar proceedBottomBar;

  ListTileItem(this.cartProductData, this.proceedBottomBar);

  @override
  _ListTileItemState createState() => new _ListTileItemState(proceedBottomBar);
}

//============================Cart List Item State=====================================
class _ListTileItemState extends State<ListTileItem> {
  ProceedBottomBar bottomBar;
  int counter = 0;
  double itemTotalPrice = 0;
  DatabaseHelper databaseHelper = new DatabaseHelper();

  _ListTileItemState(this.bottomBar);

  @override
  Widget build(BuildContext context) {
    //print("---_Widget build--${widget.subCatProducts.title}-and discount-${widget.subCatProducts.variants[0].discount}");
    Row row;
    String discount = widget.cartProductData.discount;
    if (discount == "0.00" || discount == "0" || discount == "0.0") {
      row = new Row(
        children: <Widget>[
          Text("Price: \$${widget.cartProductData.price}",style: TextStyle(
              fontSize: 16)),
        ],
      );
    } else {
      row = new Row(
        children: <Widget>[
          Text("Price:",style: TextStyle(fontSize: 16)),
          Text("\$${widget.cartProductData.discount}",
              style: TextStyle(decoration: TextDecoration.lineThrough,fontSize: 16)),
          Text(" "),
          Text("\$${widget.cartProductData.price}",style: TextStyle(fontSize: 16)),
        ],
      );
    }
    try {
      itemTotalPrice = int.parse(widget.cartProductData.quantity) * double.parse(widget.cartProductData.price);
    } catch (e) {
      print(e);
    }

    return new ListTile(
      title: new Text(widget.cartProductData.product_name,
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              color: Colors.deepOrange)),
      //subtitle: new Text("\$${widget.subCatProducts.variants[0].price}"),
      subtitle: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Quantity: ${widget.cartProductData.quantity}",style: TextStyle(
                fontSize: 16)),
          ),
          row,
        ],
      ),
      trailing: Text("${Utils.roundOffPrice(itemTotalPrice, 2)} ",style: TextStyle(
          fontSize: 18)),
    );
  }

}

class ProceedBottomBar extends StatefulWidget {
  final _ProceedBottomBarState state = new _ProceedBottomBarState();
  int selectedRadio= 0;
  String applyCouponText = "Apply Coupon";
  String couponCodeValue = "Coupon code here..";

  @override
  _ProceedBottomBarState createState() => state;
}

class _ProceedBottomBarState extends State<ProceedBottomBar> {

  int mCount = 0;
  DeliveryAddressData mArea;
  DatabaseHelper databaseHelper = new DatabaseHelper();
  double totalPrice = 0.00;
  bool firstTime = false;

  checkForDeliverAdresses(int count,DeliveryAddressData area){
    this.mCount = count;
    this.mArea = area;
  }

  // Changes the selected value on 'onChanged' click on each radio button
  setSelectedRadio(int val) {
    setState(() {
      widget.selectedRadio = val;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (firstTime == false) {
      databaseHelper.getTotalPrice().then((mtotalPrice) {
        firstTime = true;
        setState(() {
          totalPrice = mtotalPrice;
        });
      });
    }

    return Wrap(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              // This goes to the build method
              Container(
                height: 10,
              ),

              new Row(
                children: <Widget>[
                  new Flexible(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: new Container(
                        width: 155.0,
                        height: 40.0,
                        child: TextField(
                          readOnly: true,
                          textAlign: TextAlign.center,
                          //controller: _textFieldController,
                          decoration: InputDecoration(
                            //Add th Hint text here.
                            contentPadding: EdgeInsets.all(10.0),
                            hintText: "${widget.couponCodeValue}",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Container(
                    width: 130.0,
                    height: 40.0,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: new RaisedButton(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () {
                          print("onPressed ${widget.applyCouponText}");
                          if(widget.applyCouponText == "Remove Coupon"){

                            Utils.showProgressDialog(context);
                            DatabaseHelper databaseHelper = new DatabaseHelper();

                            databaseHelper.getCartItemsListToJson().then((json){

                              ApiController.multipleTaxCalculationRequest("0".toString(),
                                  "0", "0.00", "0", json).then((response){
                                    print("Calculation ${response.data.total}");
                                    Utils.hideProgressDialog(context);
                                    setState(() {
                                      totalPrice = double.parse(response.data.total);;
                                      widget.applyCouponText = "Apply Coupon";
                                      widget.couponCodeValue = "Coupon code here..";
                                    });
                              });
                            });
                          }
                        },
                        child: new Text("${widget.applyCouponText}",softWrap: true),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: (){
                      AvailableOffersDialog dialog = new AvailableOffersDialog(mArea,widget.selectedRadio);
                      showDialog(context: context,
                        builder: (BuildContext context) => dialog,
                      ).then((_) async {
                        setState((){
                          print("--------------showDialog setState-----${dialog.totalPrice}-------------");
                          if(dialog.totalPrice != 0.0){
                            totalPrice = dialog.totalPrice;
                            widget.applyCouponText = dialog.applyCouponText;
                            widget.couponCodeValue =dialog.couponCodeValue;
                          }
                        });
                      });
                    },
                    child:Text("Available Offers", textAlign: TextAlign.center,style: TextStyle(color: Colors.blue)) ,
                  ),
                ],
              ),

              Row(
                children: <Widget>[
                  Radio(
                    value: 0,
                    groupValue: widget.selectedRadio,
                    onChanged: (val) {
                      //print("Radio $val");
                      setSelectedRadio(val);
                    },
                  ),
                  new Text(
                    'Cash on Delivery',
                  ),
                  Radio(
                    value: 1,
                    groupValue: widget.selectedRadio,
                    onChanged: (val) {
                      //print("Radio $val");
                      setSelectedRadio(val);
                    },
                  ),
                  new Text(
                    'Online Payment'
                  ),
                ],
              ),

              Divider(color: Colors.black, thickness: 1.0,),

              Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: InkWell(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: new Text("Total",
                              style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                    Flexible(
                      child: InkWell(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: new Text("\$${totalPrice}",
                              style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  " *Tax extra if applicable.",
                  style: TextStyle(color: Colors.black,fontSize: 16),
                ),
              ),

              Container(
                height: 45.0,
                color: Colors.deepOrange,
                child: InkWell(
                  onTap: () {
                    print("on click message mCount = ${mCount} and address is = ${mArea.address}");

                    Utils.isNetworkAvailable().then((isNetworkAvailable){
                      if(isNetworkAvailable == true){

                        print("----NetworkAvailable == true-----ConfirmOrder_Pending");


                      }else{
                        Utils.showToast(AppConstant.N0_INTERNET, false);
                      }
                    });

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
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AvailableOffersDialog extends StatefulWidget{

  double totalPrice = 0.0;
  DeliveryAddressData area;
  int selectedRadio;
  String applyCouponText = "Apply Coupon";
  String couponCodeValue = "Coupon code here..";

  AvailableOffersState state = new AvailableOffersState();

  AvailableOffersDialog(this.area, this.selectedRadio);

  @override
  AvailableOffersState createState() => state;

}

class AvailableOffersState extends State<AvailableOffersDialog> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      //backgroundColor: Colors.transparent,
      //child: dialogContent(context),
      child: FutureBuilder(
        future: ApiController.storeOffersApiRequest(widget.area.areaId),
        builder: (context, projectSnap){
          if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container(color: const Color(0xFFFFE306));
          }else{
            if(projectSnap.hasData){
              //print('---projectSnap.Data-length-${projectSnap.data.length}---');
              //return Container(color: const Color(0xFFFFE306));
              List<OffersData> areaList  = projectSnap.data;
              //return dialogContent(context,areaList,widget.selectedRadio);
              return Container(
                decoration: new BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(Consts.padding),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Select Coupon",
                              style: TextStyle(color: Colors.black, fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: areaList.length,
                          itemBuilder: (context, index) {
                            OffersData offer = areaList[index];
                            return ListTile(
                              title: Text(offer.couponCode,
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("Min Order ${offer.minimumOrderAmount}"),
                                ],
                              ),
                              trailing: Container(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: new RaisedButton(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    textColor: Colors.white,
                                    color: Colors.blue,
                                    onPressed: () {
                                      print("onPressed");
                                      Utils.showProgressDialog(context);
                                      DatabaseHelper databaseHelper = new DatabaseHelper();

                                      databaseHelper.getCartItemsListToJson().then((json) {

                                        ApiController.validateOfferApiRequest(offer, widget.selectedRadio, json).then((response) {

                                          widget.applyCouponText = "Remove Coupon";
                                          widget.couponCodeValue = response.data.couponCode;

                                          ApiController.multipleTaxCalculationRequest(
                                              response.discountAmount.toString(),
                                              "0", "0.00", "0", json).then((response) {
                                            widget.totalPrice = double.parse(
                                                response.data.total);
                                            Utils.hideProgressDialog(context);
                                            Navigator.pop(context, true);
                                          });
                                        });
                                      });

                                    },
                                    child: new Text("Apply"),
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
              );
            }else {
              //print('-------CircularProgressIndicator----------');
              return Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.black26,
                    valueColor:AlwaysStoppedAnimation<Color>(Colors.black26)),
              );
            }
          }
        },
      ),
    );
  }


}
