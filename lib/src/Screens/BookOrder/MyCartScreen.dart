import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/UI/CartBottomView.dart';
import 'package:restroapp/src/UI/ProductTileView.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/Utils.dart';

class MyCartScreen extends StatelessWidget {

  final VoidCallback callback;
  final CartTotalPriceBottomBar bottomBar = CartTotalPriceBottomBar(ParentInfo.cartList);
  final DatabaseHelper databaseHelper = new DatabaseHelper();

  MyCartScreen(this.callback);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("MY CART"),
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
                future: databaseHelper.getCartItemList(),
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.none &&
                      projectSnap.hasData == null) {
                    return Container();
                  } else {
                    if (projectSnap.hasData) {

                      print("--length---${projectSnap.data.length}----");

                      if(projectSnap.data.length == 0){

                        return Container(
                          child: Expanded(
                            child: Center(
                              child: Text("Empty Cart",
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
                              return ProductTileItem(product, () {
                                bottomBar.state.updateTotalPrice();
                              });
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
      bottomNavigationBar: bottomBar,
    );
  }
}
