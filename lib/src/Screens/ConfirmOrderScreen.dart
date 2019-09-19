import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/Screens/SaveDeliveryAddress.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/CartData.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class ConfirmOrder extends StatefulWidget {

  _ConfirmOrderState addressState = new _ConfirmOrderState();

  DeliveryAddressData mArea;

  ConfirmOrder(this.mArea);

  @override
  _ConfirmOrderState createState() => addressState;
}

class _ConfirmOrderState extends State<ConfirmOrder> {

  ProceedBottomBar proceedBottomBar = new ProceedBottomBar();
  DatabaseHelper databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text("Confirm Order"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Column(
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
                      return ListView.separated(
                        separatorBuilder: (BuildContext context, int index) => Divider(),
                        shrinkWrap: true,
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
      ),
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

  @override
  _ProceedBottomBarState createState() => state;
}

class _ProceedBottomBarState extends State<ProceedBottomBar> {

  int mCount = 0;
  DeliveryAddressData mArea;
  checkForDeliverAdresses(int count,DeliveryAddressData area){
    this.mCount = count;
    this.mArea = area;
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
      height: 50.0,
      color: Colors.deepOrange,
      child: InkWell(
        onTap: () {
          print("on click message mCount = ${mCount} and address is = ${mArea.address}");

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
}
