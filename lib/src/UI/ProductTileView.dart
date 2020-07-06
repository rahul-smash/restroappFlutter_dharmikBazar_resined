import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/Dashboard/ProductDetailScreen.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/CartTableData.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

class ProductTileItem extends StatefulWidget {
  Product product;
  VoidCallback callback;
  ClassType classType;

  ProductTileItem(this.product, this.callback, this.classType);

  @override
  _ProductTileItemState createState() => new _ProductTileItemState();
}

class _ProductTileItemState extends State<ProductTileItem> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  int counter = 0;
  CartData cartData;
  Variant variant;
  bool showAddButton;

  @override
  initState() {
    super.initState();
    showAddButton = false;
    //print("--_ProductTileItemState-- initState ${widget.classType}");
    getDataFromDB();
  }

  void getDataFromDB() {
    databaseHelper.getProductQuantitiy(widget.product.variantId).then((cartDataObj) {
      cartData = cartDataObj;
      counter = int.parse(cartData.QUANTITY);
      showAddButton = counter == 0 ? true : false;
      //print("-QUANTITY-${counter}=");
      setState(() {});
    });
    databaseHelper.checkProductsExistInFavTable(DatabaseHelper.Favorite_Table,widget.product.id).then((favValue){
      //print("--ProductFavValue-- ${favValue} and ${widget.product.isFav}");
      setState(() {
        widget.product.isFav = favValue.toString();
        //print("-isFav-${widget.product.isFav}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String discount,price,variantId,weight,mrpPrice;
    variantId = variant == null ? widget.product.variantId : variant.id;
    if(variant == null){
      //print("====-variant == null====");
      discount = widget.product.discount.toString();
      price = widget.product.price.toString();
      weight = widget.product.weight;
      mrpPrice = widget.product.mrpPrice;
    }else{
      //print("==else==-variant == null====");
      discount = variant.discount.toString();
      price = variant.price.toString();
      weight = variant.weight;
      mrpPrice = variant.mrpPrice;
    }
    String imageUrl = widget.product.imageType == "0" ? widget.product.image10080: widget.product.imageUrl;
    bool variantsVisibility;
    variantsVisibility = widget.classType == ClassType.CART ? true : widget.product.variants != null && widget.product.variants.isNotEmpty &&
          widget.product.variants.length >= 1 ? true : false;

    if(weight.isEmpty){
      variantsVisibility = false;
    }

    return Container(
      color: Colors.white,
      child: Column(
          children: [
            InkWell(
              onTap: () async {
                //print("----print-----");
                if(widget.classType != ClassType.CART){
                  var result = await Navigator.push(context, new MaterialPageRoute(
                    builder: (BuildContext context) => ProductDetailsScreen(widget.product),
                    fullscreenDialog: true,)
                  );
                  setState(() {
                    if(result != null){
                      variant = result;
                      discount = variant.discount.toString();
                      price = variant.price.toString();
                      weight = variant.weight;
                      variantId = variant.id;
                    }else{
                      variantId = widget.product.variantId;
                    }
                    databaseHelper.getProductQuantitiy(variantId).then((cartDataObj) {
                      setState(() {
                        cartData = cartDataObj;
                        counter = int.parse(cartData.QUANTITY);
                        showAddButton = counter == 0 ? true : false;
                        //print("-QUANTITY-${counter}=");
                      });
                    });
                    databaseHelper.checkProductsExistInFavTable(DatabaseHelper.Favorite_Table,variantId).then((favValue){
                      //print("--ProductFavValue-- ${favValue} and ${widget.product.isFav}");
                      setState(() {
                        widget.product.isFav = favValue.toString();
                      });
                    });
                    widget.callback();
                    eventBus.fire(updateCartCount());
                  });
                  //print("--ProductDetails--result---${result}");
                }
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                            child: Row(
                              children: [
                                SizedBox(width: 10),
                                Visibility(
                                  visible: AppConstant.isRestroApp,
                                  child: addVegNonVegOption(),
                                ),

                                imageUrl == "" ? Container(
                                  width: 70.0,
                                  height: 80.0,
                                  child: Utils.getImgPlaceHolder(),
                                )
                                    : Padding(
                                    padding: EdgeInsets.only(left: 5,right: 20),
                                    child: Container(
                                      width: 70.0,
                                      height: 80.0,
                                      child: CachedNetworkImage(
                                          imageUrl: "${imageUrl}",
                                          fit: BoxFit.fill
                                        //placeholder: (context, url) => CircularProgressIndicator(),
                                        //errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                      /*child: Image.network(imageUrl,width: 60.0,height: 60.0,
                                          fit: BoxFit.cover),*/
                                    )),

                                Flexible(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(widget.product.title,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 16.0,color: grayColorTitle,)
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                int count = await databaseHelper.checkProductsExistInFavTable
                                                  (DatabaseHelper.Favorite_Table,widget.product.id);


                                                Product product = widget.product;
                                                print("--product.count-- ${count}");
                                                if(count == 1){
                                                  product.isFav = "0";
                                                  await databaseHelper.deleteFav(DatabaseHelper.Favorite_Table,product.id);
                                                }else if(count == 0){
                                                  String variantId, weight, mrpPrice, price, discount, isUnitType;
                                                  variantId = variant == null ? widget.product.variantId : variant.id;
                                                  weight = variant == null ? widget.product.weight : variant.weight;
                                                  mrpPrice = variant == null ? widget.product.mrpPrice : variant.mrpPrice;
                                                  price = variant == null ? widget.product.price : variant.price;
                                                  discount = variant == null ? widget.product.discount : variant.discount;
                                                  isUnitType = variant == null ? widget.product.isUnitType : variant.unitType;

                                                  product.isFav = "1";
                                                  product.variantId = variantId;
                                                  product.weight = weight;
                                                  product.mrpPrice = mrpPrice;
                                                  product.price = price;
                                                  product.discount = discount;
                                                  product.isUnitType = isUnitType;
                                                  insertInFavTable(product,counter);
                                                }
                                                //print("--product.isFav-- ${product.isFav}");
                                                widget.callback();
                                                setState(() {
                                                });

                                              },
                                              child: Visibility(
                                                visible: widget.classType == ClassType.CART? false : true,
                                                child: Container(
                                                  height: 30,width: 30,
                                                  decoration: BoxDecoration(
                                                    color: widget.classType == ClassType.CART? Colors.white : favGrayColor,
                                                    border: Border.all(color: favGrayColor, width: 1,),
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(5.0)),
                                                  ),
                                                  margin: EdgeInsets.fromLTRB(0, 5, 20, 0),
                                                  child: Visibility(
                                                    visible: widget.classType == ClassType.CART? false : true,
                                                   /* child: widget.product.isFav == null ? Icon(Icons.favorite_border)
                                                        :Utils.showFavIcon(widget.product.isFav),*/
                                                    child: widget.classType == ClassType.Favourites ? Icon(Icons.favorite,color: orangeColor,)
                                                        : Utils.showFavIcon(widget.product.isFav),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: variantsVisibility == true? 0 : 20,
                                        ),
                                        Visibility(
                                          visible: variantsVisibility,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 20,bottom: 3),
                                            child: InkWell(
                                              onTap: () async {
                                                //print("-variants.length--${widget.product.variants.length}");
                                                if(widget.product.variants.length != null){
                                                  if(widget.product.variants.length == 1){
                                                    return;
                                                  }
                                                }
                                                variant = await DialogUtils.displayVariantsDialog(context, "${widget.product.title}", widget.product.variants);
                                                if(variant != null){
                                                  /*print("variant.weight= ${variant.weight}");
                                                  print("variant.discount= ${variant.discount}");
                                                  print("variant.mrpPrice= ${variant.mrpPrice}");
                                                  print("variant.price= ${variant.price}");*/
                                                  databaseHelper.getProductQuantitiy(variant.id).then((cartDataObj) {
                                                    //print("QUANTITY= ${cartDataObj.QUANTITY}");
                                                    cartData = cartDataObj;
                                                    counter = int.parse(cartData.QUANTITY);
                                                    showAddButton = counter == 0 ? true : false;
                                                    setState(() {});
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: orangeColor, width: 1,),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(5.0)),
                                                ),
                                                child: Wrap(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 5,right: 5,bottom: widget.classType == ClassType.CART ? 5 : 0),
                                                      child: Text("${weight}", textAlign: TextAlign.center,
                                                        style: TextStyle(color: orangeColor),),
                                                    ),
                                                    Visibility(
                                                      visible: widget.classType == ClassType.CART ? false : true,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Utils.showVariantDropDown(widget.classType,widget.product),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            (discount == "0.00" || discount == "0" || discount == "0.0")
                                                ? Text("${AppConstant.currency}${price}",
                                              style: TextStyle(color: grayColorTitle,fontWeight: FontWeight.w600),)
                                                :
                                            Row(
                                              children: <Widget>[
                                                Text("${AppConstant.currency}${price}",
                                                  style: TextStyle(color: grayColorTitle,fontWeight: FontWeight.w700),),
                                                Text(" "),
                                                Text("${AppConstant.currency}${mrpPrice}",
                                                    style: TextStyle(decoration: TextDecoration.lineThrough,
                                                        color: grayColorTitle,fontWeight: FontWeight.w400)),
                                              ],
                                            ),
                                            addQuantityView(),
                                          ],
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            )),
                      ]
                  )
              ),
            ),
            Container(height: 1,width: MediaQuery.of(context).size.width,color: Color(0xFFBDBDBD))
          ]),
    );
  }


  Widget addQuantityView() {
    return Container(
      //color: orangeColor,
      width: 100,
      height: 30,
      decoration: BoxDecoration(
        color: showAddButton == false ? whiteColor : orangeColor,
        //border: Border.all(color: showAddButton == false ? whiteColor : orangeColor, width: 0,),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
        child: showAddButton == true
            ? InkWell(onTap: (){
              //print("add onTap");
              setState(() {

              });
              counter ++ ;
              showAddButton = false;
              insertInCartTable(widget.product, counter);
              widget.callback();
          },
          child: Container(child: Center(child: Text("Add",style: TextStyle(color: whiteColor),),),),
        )
            : Visibility(
          visible: showAddButton == true ? false : true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(0.0),
                width: 30.0, // you can adjust the width as you need
                child: GestureDetector(
                    onTap: () {
                  if (counter != 0) {
                    setState(() => counter--);
                    if (counter == 0) {
                      // delete from cart table
                      removeFromCartTable(widget.product.variantId);
                    } else {
                      // insert/update to cart table
                      insertInCartTable(widget.product, counter);
                    }
                    widget.callback();
                  }
                },

                    child: Container(
                      width: 35,
                      height: 25,
                      decoration: BoxDecoration(
                        color: grayColor,
                        border: Border.all(color: grayColor, width: 1,),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0)),
                      ),
                      child: Icon(Icons.remove, color: Colors.white, size: 20),
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                width: 30.0,
                height: 30.0,
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
                  border: new Border.all(
                    color: Colors.white,
                    width: 1.0,
                  ),
                ),
                child: Center(child: Text("$counter",style: TextStyle(fontSize: 18),)),
              ),
              Container(
                padding: const EdgeInsets.all(0.0),
                width: 30.0, // you can adjust the width as you need
                child: GestureDetector(onTap: () {
                  setState(() => counter++);
                  if (counter == 0) {
                    // delete from cart table
                    removeFromCartTable(widget.product.variantId);
                  } else {
                    // insert/update to cart table
                    insertInCartTable(widget.product, counter);
                  }
                },
                  child: Container(
                      width: 35,
                      height: 25,
                      decoration: BoxDecoration(
                        color: orangeColor,
                        border: Border.all(color: orangeColor, width: 1,),
                        borderRadius: BorderRadius.all(
                            Radius.circular(5.0)),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 20)),
                ),
              ),
            ],
          ),
        ),
    );
  }


  Widget addVegNonVegOption() {
    Color foodOption =
    widget.product.nutrient == "Non Veg" ? Colors.red : Colors.green;
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 7),
      child: widget.product.nutrient == "None"? Container(): Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            border: new Border.all(
              color: foodOption,
              width: 1.0,
            ),
          ),
          width: 16,
          height: 16,
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Container(
                decoration: new BoxDecoration(
                  color: foodOption,
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                )),
          )),
    );
  }

  void insertInCartTable(Product product, int quantity) {
    String variantId, weight, mrpPrice, price, discount, isUnitType;
    variantId = variant == null ? widget.product.variantId : variant.id;
    weight = variant == null ? widget.product.weight : variant.weight;
    mrpPrice = variant == null ? widget.product.mrpPrice : variant.mrpPrice;
    price = variant == null ? widget.product.price : variant.price;
    discount = variant == null ? widget.product.discount : variant.discount;
    isUnitType = variant == null ? widget.product.isUnitType : variant.unitType;

    var mId = int.parse(product.id);
    //String variantId = product.variantId;

    Map<String, dynamic> row = {
      DatabaseHelper.ID: mId,
      DatabaseHelper.VARIENT_ID: variantId,
      DatabaseHelper.WEIGHT: weight,
      DatabaseHelper.MRP_PRICE: mrpPrice,
      DatabaseHelper.PRICE: price,
      DatabaseHelper.DISCOUNT: discount,
      DatabaseHelper.UNIT_TYPE: isUnitType,

      DatabaseHelper.PRODUCT_ID: product.id,
      DatabaseHelper.isFavorite: product.isFav,
      DatabaseHelper.QUANTITY: quantity.toString(),
      DatabaseHelper.IS_TAX_ENABLE: product.isTaxEnable,
      DatabaseHelper.Product_Name: product.title,
      DatabaseHelper.nutrient: product.nutrient,
      DatabaseHelper.description: product.description,
      DatabaseHelper.imageType: product.imageType,
      DatabaseHelper.imageUrl: product.imageUrl,
      DatabaseHelper.image_100_80: product.image10080,
      DatabaseHelper.image_300_200: product.image300200,
    };

    databaseHelper.checkIfProductsExistInDb(DatabaseHelper.CART_Table, variantId)
        .then((count) {
      //print("-count-- ${count}");
      if (count == 0) {
        databaseHelper.addProductToCart(row).then((count) {
          widget.callback();
          eventBus.fire(updateCartCount());
        });
      } else {
        databaseHelper.updateProductInCart(row, variantId).then((count) {
          widget.callback();
          eventBus.fire(updateCartCount());
        });
      }
    });
  }

  void removeFromCartTable(String variant_Id) {
    try {
      //print("------removeFromCartTable-------");
      String variantId;
      variantId = variant == null ? variant_Id : variant.id;
      databaseHelper.delete(DatabaseHelper.CART_Table, variantId).then((count) {
        widget.callback();
        eventBus.fire(updateCartCount());
      });
    } catch (e) {
      print(e);
    }
  }

  void insertInFavTable(Product product, int quantity) {
    var mId = int.parse(product.id);
    String productJson = JsonEncoder().convert(product.toJson());
    //print("${productJson}");

    Map<String, dynamic> row = {
      DatabaseHelper.ID: mId,
      DatabaseHelper.VARIENT_ID: product.variantId,
      DatabaseHelper.PRODUCT_ID: product.id,
      DatabaseHelper.WEIGHT: product.weight,
      DatabaseHelper.isFavorite: product.isFav,
      DatabaseHelper.Product_Json: productJson,
      DatabaseHelper.MRP_PRICE: product.mrpPrice,
      DatabaseHelper.PRICE: product.price,
      DatabaseHelper.DISCOUNT: product.discount,
      DatabaseHelper.QUANTITY: quantity.toString(),
      DatabaseHelper.IS_TAX_ENABLE: product.isTaxEnable,
      DatabaseHelper.Product_Name: product.title,
      DatabaseHelper.UNIT_TYPE: product.isUnitType,
      DatabaseHelper.nutrient: product.nutrient,
      DatabaseHelper.description: product.description,
      DatabaseHelper.imageType: product.imageType,
      DatabaseHelper.imageUrl: product.imageUrl,
      DatabaseHelper.image_100_80: product.image10080,
      DatabaseHelper.image_300_200: product.image300200,
    };

    databaseHelper.addProductToFavTable(row).then((count) {
      //print("-------count--------${count}-----");
    });
  }

}
