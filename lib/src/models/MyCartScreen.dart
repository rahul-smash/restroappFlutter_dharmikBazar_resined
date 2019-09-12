import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/AddDeliveryAddressScreen.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/CartData.dart';

class MyCart extends StatelessWidget {

  ProceedBottomBar proceedBottomBar = new ProceedBottomBar();
  DatabaseHelper databaseHelper = new DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: Text("My Cart"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Column(
          children: <Widget>[
            Divider(color: Colors.white, height: 2.0),
            FutureBuilder(
              future: databaseHelper.getCartItemList(),
              builder: (context, projectSnap) {
                if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
                  //print('project snapshot data is: ${projectSnap.data}');
                  return Container(color: const Color(0xFFFFE306));
                } else {
                  if(projectSnap.hasData){
                    print('---projectSnap.Data-length-${projectSnap.data.length}---');
                    return ListView.builder(
                      shrinkWrap: true, //Your Column doesn't know how much height it will take. use this
                      itemCount: projectSnap.data.length,
                      itemBuilder: (context, index) {
                        CartProductData cartProductData = projectSnap.data[index];
                        //print('-------ListView.builder-----${index}');
                        return Column(
                          children: <Widget>[
                            new ListTileItem(cartProductData,proceedBottomBar),
                          ],
                        );
                      },
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
          ],
        ),
        bottomNavigationBar: proceedBottomBar,
      ),
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
  DatabaseHelper databaseHelper = new DatabaseHelper();

  _ListTileItemState(this.bottomBar);

  @override
  initState() {
    super.initState();
    print("---initState product_id---${widget.cartProductData.product_id}-");
    databaseHelper.getProductQuantitiy(int.parse(widget.cartProductData.product_id)).then((count){
      //print("---getProductQuantitiy---${count}");
      counter = int.parse(count);
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("---_Widget build--${widget.subCatProducts.title}-and discount-${widget.subCatProducts.variants[0].discount}");
    Row row;
    String discount = widget.cartProductData.discount;
    if(discount == "0.00" || discount == "0" || discount == "0.0"){
      row = new Row(
        children: <Widget>[
          Text("\$${widget.cartProductData.price}"),
        ],
      );
    }else{
      row = new Row(
        children: <Widget>[
          Text("\$${widget.cartProductData.discount}", style: TextStyle(decoration: TextDecoration.lineThrough)),
          Text(" "),
          Text("${widget.cartProductData.price}"),
        ],
      );
    }

    return new ListTile(
      title: new Text(widget.cartProductData.product_name,style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 20.0, color:Colors.deepOrange)),
      //subtitle: new Text("\$${widget.subCatProducts.variants[0].price}"),
      subtitle: row,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          counter != 0?IconButton(icon: new Icon(Icons.remove),
            //onPressed: ()=> setState(()=> counter--),
            onPressed: (){
              setState(()=> counter--);
              //print("--remove-onPressed-${counter}--");
              if(counter == 0){
                // delete from cart table
                removeFromCartTable(widget.cartProductData.product_id);
              }else{
                // insert/update to cart table
                insertInCartTable(widget.cartProductData,counter);
              }
            },
          ):new Container(),

          Text("${counter}"),

          IconButton(icon: Icon(Icons.add),
            highlightColor: Colors.black,
            onPressed: (){
              setState(()=> counter++);
              //print("--add-onPressed-${counter}--");
              if(counter == 0){
                // delete from cart table
                removeFromCartTable(widget.cartProductData.product_id);
              }else{
                // insert/update to cart table
                insertInCartTable(widget.cartProductData,counter);
              }
            },
          ),
        ],
      ),
    );
  }
  void insertInCartTable(CartProductData subCatProducts, int quantity) {
    //print("--insertInCartTable-${counter}--");
    String id = subCatProducts.product_id;
    String variantsId = subCatProducts.variant_id;
    String productId = subCatProducts.product_id;
    String weight = subCatProducts.weight;
    String mrp_price = subCatProducts.mrp_price;
    String price = subCatProducts.price;
    String discount = subCatProducts.discount;
    String productQuantity = quantity.toString();
    String isTaxEnable = subCatProducts.isTaxEnable;
    String title = subCatProducts.product_name;
    var mId = int.parse(id);
    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.ID : mId,
      DatabaseHelper.VARIENT_ID  : variantsId,
      DatabaseHelper.PRODUCT_ID : productId,
      DatabaseHelper.WEIGHT : weight,
      DatabaseHelper.MRP_PRICE : mrp_price,
      DatabaseHelper.PRICE : price,
      DatabaseHelper.DISCOUNT : discount,
      DatabaseHelper.QUANTITY : productQuantity,
      DatabaseHelper.IS_TAX_ENABLE : isTaxEnable,
      DatabaseHelper.Product_Name : title,
    };

    databaseHelper.checkIfProductsExistInCart(DatabaseHelper.CART_Table, mId).then((count){
      //print("------checkProductsExist-----${count}");
      if(count == 0){
        //print("------Products NOT ExistInCart-----${count}");
        databaseHelper.addProductToCart(row).then((count){
          //print("--addProductToCart-${count}--");
          bottomBar.state.updateTotalPrice();
          //Utils.showToast("Product added in Cart", false);
        });
      }else{
        //Utils.showToast("Product already Exist in Cart", false);
        databaseHelper.updateProductInCart(row, mId).then((count){
          //print("-----updateProductInCart----${count}--");
          bottomBar.state.updateTotalPrice();
        });
      }
    });


  }

  void removeFromCartTable(String product_id) {
    //print("--removeFromCartTable-${counter}--");
    try {
      databaseHelper.delete(DatabaseHelper.CART_Table, int.parse(product_id)).then((count){
        bottomBar.state.updateTotalPrice();
      });
    } catch (e) {
      print(e);
    }
  }
}

class ProceedBottomBar extends StatefulWidget {

  final _ProceedBottomBarState state = new _ProceedBottomBarState();

  @override
  _ProceedBottomBarState createState() => state;
}

class _ProceedBottomBarState extends State<ProceedBottomBar> {

  double totalPrice = 0.00;
  DatabaseHelper databaseHelper = new DatabaseHelper();
  bool xyz = false;

  updateTotalPrice(){
    databaseHelper.getTotalPrice().then((mtotalPrice){
      setState(() {
        totalPrice = mtotalPrice;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(xyz == false){
      databaseHelper.getTotalPrice().then((mtotalPrice){
        xyz = true;
        setState(() {
          totalPrice = mtotalPrice;
        });
      });
    }

    return Container(
      height: 50.0,
      color: Colors.deepOrange,
      child: InkWell(
        onTap: () {
          //print("on click message");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDeliveryAddress()),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Proceed ${databaseHelper.roundOffPrice(totalPrice,2)}",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ],
        ),
      ),

    );
  }
}