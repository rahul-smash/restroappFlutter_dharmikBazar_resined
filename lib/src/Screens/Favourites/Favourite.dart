import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/BookOrder/MyCartScreen.dart';
import 'package:restroapp/src/UI/ProductTileView.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/Utils.dart';

class Favourites extends StatefulWidget {

  final VoidCallback callback;

  Favourites(this.callback);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {

  DatabaseHelper databaseHelper = new DatabaseHelper();
  double totalPrice = 0.00;

  @override
  void initState() {
    super.initState();
    updateTotalPrice();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text("MY Favourites"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          )),
      body: WillPopScope(
          child: Column(
            children: <Widget>[
              Divider(color: Colors.white, height: 2.0),
              FutureBuilder(
                future: databaseHelper.getFavouritesList(),
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.none &&
                      projectSnap.hasData == null) {
                    return Container();
                  } else {
                    if (projectSnap.hasData) {
                      if(projectSnap.data.length == 0){
                        return Container(
                          child: Expanded(
                            child: Center(
                              child: Text("No Favourites found!",
                                  overflow: TextOverflow.ellipsis,
                                  style: new TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  )),
                            ),
                          ),
                        );
                      }else{
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: projectSnap.data.length,
                            itemBuilder: (context, index) {

                              Product product = projectSnap.data[index];
                              Map<String, dynamic> map = jsonDecode(product.productJson);
                              Product productData = Product.fromJson(map);
                              //print("-1--Favs----ProductTileItem---------");
                              return ProductTileItem(productData, () {
                                //print("-2--Favs----updateTotalPrice---------");
                                updateTotalPrice();
                              },ClassType.Favourites);
                            },
                          ),
                        );
                      }

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
              ),
            ],
          ),
          onWillPop: () async {
            Navigator.pop(context);
            return new Future(() => false);
          }),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 55,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: RichText(
                      text: TextSpan(
                        text: "Total: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                        children: [
                          TextSpan(
                            text:
                            "${AppConstant.currency}${databaseHelper.roundOffPrice(totalPrice, 2).toStringAsFixed(2)}",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )),
              Container(
                  color: appTheme,
                  child: FlatButton(
                    child: Row(
                        children: <Widget>[
                          Image.asset("images/my_order.png", width: 25),
                          SizedBox(width: 5),
                          Text("Proceed To Order",style: TextStyle(fontSize: 12, color: Colors.white)),
                        ]),
                    onPressed: () {
                      if (totalPrice == 0.0) {
                        Utils.showToast(AppConstant.addItems, false);
                      } else {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (BuildContext context) => MyCartScreen(() {

                            })));
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }

  updateTotalPrice() {
    databaseHelper.getTotalPrice().then((mTotalPrice) {
      setState(() {
        totalPrice = mTotalPrice;
      });
    });
  }

}

