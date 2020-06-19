import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:restroapp/src/UI/CartBottomView.dart';
import 'package:restroapp/src/UI/ProductTileView.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

class MyCartScreen extends StatefulWidget {

  final VoidCallback callback;

  MyCartScreen(this.callback);

  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {

  final CartTotalPriceBottomBar bottomBar = CartTotalPriceBottomBar(ParentInfo.cartList);
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Product> cartList = List();
  bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    getCartListFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("MY CART"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: IconButton(
              icon: Image.asset('images/cancel_cart.png', width: 25),
              onPressed: () async {
                var result = await DialogUtils.displayCommonDialog2(context, "Clear Cart?",
                    AppConstant.emptyCartMsg, "Cancel", "Yes");
                if(result == true){
                  print("Yes");
                  setState(() {
                    databaseHelper.deleteTable(DatabaseHelper.CART_Table);
                    getCartListFromDB();
                    eventBus.fire(updateCartCount());
                    bottomBar.state.updateTotalPrice();
                    widget.callback();
                  });

                }
              },
            ),
          ),
        ],
      ),
      body: WillPopScope(
          child: Column(
            children: <Widget>[
              Divider(color: Colors.white, height: 2.0),
              /*FutureBuilder(
                future: databaseHelper.getCartItemList(),
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.none &&
                      projectSnap.hasData == null) {
                    return Container();
                  } else {
                    if (projectSnap.hasData) {

                      //print("--length---${projectSnap.data.length}----");
                      eventBus.fire(updateCartCount());
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
                                widget.callback();
                              },ClassType.CART);
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
              ),*/
              isLoading ? Utils.getIndicatorView(): showCartList(),
            ],
          ),
          onWillPop: () async {
            Navigator.pop(context);
            return new Future(() => false);
          }),
      bottomNavigationBar: SafeArea(
        child: bottomBar,
      ),
    );
  }

  void getCartListFromDB() {
    isLoading = true;
    databaseHelper.getCartItemList().then((response){
      setState(() {
        cartList = response;
        isLoading = false;
      });
    });
  }

  Widget showCartList() {
    if(cartList.length == 0){
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
          itemCount: cartList.length,
          itemBuilder: (context, index) {
            Product product = cartList[index];
            return ProductTileItem(product, () {
              bottomBar.state.updateTotalPrice();
              widget.callback();
            },ClassType.CART);
          },
        ),
      );
    }
  }
}
