import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/Categories.dart';
import 'package:restroapp/src/models/SubCategories.dart';

class SubCategoryProducstScreen extends StatelessWidget {

  CategoriesData categoriesData;

  SubCategoryProducstScreen(this.categoriesData);
  List<String> titles = [];
  List<Tab> tabs = new List();
  TotalPriceBottomBar bottomBar = TotalPriceBottomBar();

  @override
  Widget build(BuildContext context) {
    //print("----- Tabs length----- ${categoriesData.subCategory.length}");

    if(categoriesData.subCategory.length == 1){
      //print("-ID's--${categoriesData.id}--Id=- ${categoriesData.subCategory[0].id}----");
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: ProductsListView(categoriesData,bottomBar),
          bottomNavigationBar: bottomBar,
        ),
      );
    }else{
      for (int i = 0; i< categoriesData.subCategory.length; i++) {
        tabs.add(new Tab(text: categoriesData.subCategory[i].title));
      }
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        debugShowCheckedModeBanner: false,
        home: Container(
          child: DefaultTabController(length: categoriesData.subCategory.length,
            child: Scaffold(
              appBar: AppBar(
                  title: Text(categoriesData.title),
                  centerTitle: true,
                  bottom:TabBar(
                    tabs: tabs,
                  ),
                  leading: IconButton(icon:Icon(Icons.arrow_back),
                    onPressed:() => Navigator.pop(context, false),
                  )
              ),
              body: TabBarView(
                children: new List.generate(categoriesData.subCategory.length, (int index){
                  //print(categoriesData.subCategory[index].title);
                  return getProductsWidget(categoriesData,categoriesData.subCategory[index].id,bottomBar);
                }),
              ),
              bottomNavigationBar: bottomBar,
            ),
          ),
        ),
      );
    }
  }
}

class ProductsListView extends StatefulWidget {

  CategoriesData categoriesData;
  TotalPriceBottomBar bottomBar;

  ProductsListView(this.categoriesData, this.bottomBar);

  @override
  _ProductsListViewState createState() => _ProductsListViewState(bottomBar);
}

class _ProductsListViewState extends State<ProductsListView> {
  TotalPriceBottomBar bottomBar;

  _ProductsListViewState(this.bottomBar);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoriesData.title),
          centerTitle: true,
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
          )
      ),
      body: getProductsWidget(widget.categoriesData, widget.categoriesData.subCategory[0].id,bottomBar),
    );
  }
}

Widget getProductsWidget(CategoriesData categoriesData,String catId, TotalPriceBottomBar bottomBar) {

  return FutureBuilder(
    future: ApiController.getSubCategoryProducts(categoriesData.id,catId),
    builder: (context, projectSnap) {
      if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
        //print('project snapshot data is: ${projectSnap.data}');
        return Container(color: const Color(0xFFFFE306));
      } else {
        if(projectSnap.hasData){
          //print('---projectSnap.Data-length-${projectSnap.data.length}---');
          return ListView.builder(
            itemCount: projectSnap.data.length,
            itemBuilder: (context, index) {
              Product subCatProducts = projectSnap.data[index];
              //print('-------ListView.builder-----${index}');
              return Column(
                children: <Widget>[
                  new ListTileItem(subCatProducts,bottomBar),
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
  );
}

//============================Cart List Item widget=====================================
class ListTileItem extends StatefulWidget {

  Product subCatProducts;
  TotalPriceBottomBar bottomBar;

  ListTileItem(this.subCatProducts, this.bottomBar);

  @override
  _ListTileItemState createState() => new _ListTileItemState(bottomBar);
}
//============================Cart List Item State=====================================
class _ListTileItemState extends State<ListTileItem> {

  TotalPriceBottomBar bottomBar;
  DatabaseHelper databaseHelper = new DatabaseHelper();
  int counter = 0;

  _ListTileItemState(this.bottomBar);

  @override
  initState() {
    super.initState();
    //print("---initState initState----initState-");
    //bottomBar.state.updateTotalPrice();
    databaseHelper.getProductQuantitiy(int.parse(widget.subCatProducts.id)).then((count){
      //print("---getProductQuantitiy---${count}");
      counter = int.parse(count);
      //priceBottomBar.updateTotalPrice(9999);
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("---_Widget build--${widget.subCatProducts.title}-and discount-${widget.subCatProducts.variants[0].discount}");

    Row row;
    String discount = widget.subCatProducts.variants[0].discount.toString();
    if(discount == "0.00" || discount == "0" || discount == "0.0"){
      row = new Row(
        children: <Widget>[
          Text("\$${widget.subCatProducts.variants[0].price}"),
        ],
      );
    }else{
      row = new Row(
          children: <Widget>[
            Text("\$${widget.subCatProducts.variants[0].discount}", style: TextStyle(decoration: TextDecoration.lineThrough)),
            Text(" "),
            Text("${widget.subCatProducts.variants[0].price}"),
          ],
      );
    }

    return new ListTile(
      title: new Text(widget.subCatProducts.title,style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 20.0, color:Colors.deepOrange)),
      //subtitle: new Text("\$${widget.subCatProducts.variants[0].price}"),
      subtitle: row,
      leading: new Icon(
        Icons.favorite, color: Colors.grey,
      ),
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
                removeFromCartTable(widget.subCatProducts.id);
              }else{
                // insert/update to cart table
                insertInCartTable(widget.subCatProducts,counter);
              }
              bottomBar.state.updateTotalPrice();
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
                removeFromCartTable(widget.subCatProducts.id);
              }else{
                // insert/update to cart table
                insertInCartTable(widget.subCatProducts,counter);
              }
            },
          ),
        ],
      ),
    );
  }

  void insertInCartTable(Product subCatProducts, int quantity) {
    //print("--insertInCartTable-${counter}--");
    String id = subCatProducts.id;
    String variantsId = subCatProducts.variants[0].id;
    String productId = subCatProducts.id;
    String weight = subCatProducts.variants[0].weight;
    String mrp_price = subCatProducts.variants[0].mrpPrice;
    String price = subCatProducts.variants[0].price;
    String discount = subCatProducts.variants[0].discount;
    String productQuantity = quantity.toString();
    String isTaxEnable = subCatProducts.isTaxEnable;
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

class TotalPriceBottomBar extends StatefulWidget{

  final _PriceBottomBarState state = new _PriceBottomBarState();

  @override
  _PriceBottomBarState createState() => state;

}

class _PriceBottomBarState extends State<TotalPriceBottomBar>{

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
    //print("-------TotalPriceBottomBar---${totalPrice}----");
    if(xyz == false){
      databaseHelper.getTotalPrice().then((mtotalPrice){
        xyz = true;
        setState(() {
          totalPrice = mtotalPrice;
        });
      });
    }
    // TODO: implement build
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: SizedBox(
              height: 50,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () {
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Total",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
                      ),
                      Text("\$${totalPrice}",style: TextStyle(fontSize: 20),),
                      //Text("\$0.00",style: TextStyle(fontSize: 20),),
                      Expanded(child: SizedBox()),
                      new Expanded(
                        child: Text("Proceed To Order",
                            style: TextStyle(fontSize: 15,backgroundColor:Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double roundOffPrice(double val, int places){
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }
}

