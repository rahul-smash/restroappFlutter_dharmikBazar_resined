import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/CartTableData.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

class ProductTileItem extends StatefulWidget {
  final Product product;
  final VoidCallback callback;
  final ClassType classType;

  ProductTileItem(this.product, this.callback, this.classType);

  @override
  _ProductTileItemState createState() => new _ProductTileItemState();
}

class _ProductTileItemState extends State<ProductTileItem> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  int counter = 0;
  CartData cartData;
  Variant variant;

  @override
  initState() {
    super.initState();
    databaseHelper.getProductQuantitiy(widget.product.variantId).then((cartDataObj) {
      cartData = cartDataObj;
      counter = int.parse(cartData.QUANTITY);
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
    String discount,price,variantId,weight;
    variantId = variant == null ? widget.product.variantId : variant.id;
    if(variant == null){
      discount = widget.product.discount.toString();
      price = widget.product.price.toString();
      weight = widget.product.weight;
    }else{
      discount = variant.discount.toString();
      price = variant.price.toString();
      weight = variant.weight;
    }
    String imageUrl = widget.product.imageType == "0" ? widget.product.image10080: widget.product.imageUrl;
    bool variantsVisibility;
    variantsVisibility = widget.classType == ClassType.CART ? true : widget.product.variants != null && widget.product.variants.isNotEmpty &&
          widget.product.variants.length > 1 ? true : false;

    return Container(
      color: Colors.white,
      child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              InkWell(
                                onTap: () async {

                                  int count = await databaseHelper.checkProductsExistInFavTable
                                    (DatabaseHelper.Favorite_Table,widget.product.id);
                                  //print("--ProductFavValue-- ${count}");
                                  Product product = widget.product;
                                  if(count == 1){
                                    product.isFav = "0";
                                    //Utils.showToast(AppConstant.favsRemoved, true);
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
                                    //Utils.showToast(AppConstant.favsAdded, true);
                                    insertInFavTable(product,counter);
                                  }
                                  //print("--product.isFav-- ${product.isFav}");
                                  widget.callback();
                                  setState(() {
                                  });
                                },
                                child: Utils.showFavIcon(widget.product.isFav),
                                //child: Image.asset("images/myfav.png", width: 25),
                              ),
                              addVegNonVegOption(),
                              imageUrl == "" ? Container(): Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                    width: 60.0,
                                    height: 60.0,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      image: new DecorationImage(
                                        image: new NetworkImage(imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                      border: new Border.all(
                                        color: appTheme,
                                        width: 1.0,
                                      ),
                                    ),
                                  )),
                              Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.product.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0,color: appTheme,)),
                                      (discount == "0.00" || discount == "0" || discount == "0.0")
                                          ? Text("${AppConstant.currency}${price}"):
                                      Row(
                                        children: <Widget>[
                                          Text("${AppConstant.currency}${widget.product.discount}", style: TextStyle(decoration: TextDecoration.lineThrough)),
                                          Text(" "),
                                          Text("${AppConstant.currency}${widget.product.price}"),
                                          //Text('\u{20B9}'),
                                        ],
                                      ),
                                      Visibility(
                                        visible: variantsVisibility,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: InkWell(
                                            onTap: () async {
                                              //print("-variants.length--${widget.product.variants.length}");
                                              variant = await DialogUtils.displayVariantsDialog(context, "${widget.product.title}", widget.product.variants);
                                              if(variant != null){
                                                databaseHelper.getProductQuantitiy(variant.id).then((cartDataObj) {
                                                  //print("QUANTITY= ${cartDataObj.QUANTITY}");
                                                  cartData = cartDataObj;
                                                  counter = int.parse(cartData.QUANTITY);
                                                  setState(() {});
                                                });
                                              }
                                              },
                                            child: Row(
                                              children: <Widget>[
                                                Text("${weight}",style: TextStyle(color: Colors.black),),
                                                Visibility(
                                                  visible: widget.classType == ClassType.CART ? false : true,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(left: 5),
                                                    child: Icon(Icons.keyboard_arrow_down,color: Colors.black, size: 25),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          )),
                      addPlusMinusView()
                    ])
            ),
            Container(
                height: 1,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: Color(0xFFBDBDBD))
          ]),
    );
  }

  Widget addVegNonVegOption() {
    Color foodOption =
    widget.product.nutrient == "Non Veg" ? Colors.red : Colors.green;
    //print('@@product_nutrient'+widget.product.nutrient);
    //print("-product.variant--> ${widget.product.variants.length}");
    return Padding(
      padding: EdgeInsets.only(left: 7, right: 7),
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

  Widget addPlusMinusView() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(0.0),
              width: 30.0, // you can adjust the width as you need
              child: GestureDetector(onTap: () {
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
              }, child: Icon(Icons.remove, color: Colors.grey, size: 20)),
            ),
            Container(
              width: 40.0,
              height: 24.0,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(new Radius.circular(15.0)),
                border: new Border.all(
                  color: Color(0xFFBDBDBD),
                  width: 1.0,
                ),
              ),
              child: Center(child: Text("$counter")),
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
                }, child: Icon(Icons.add, color: Colors.grey, size: 20)),
            ),
          ],
        ));
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
        });
      } else {
        databaseHelper.updateProductInCart(row, variantId).then((count) {
          widget.callback();
        });
      }
    });
  }

  void removeFromCartTable(String variant_Id) {
    try {
      String variantId;
      variantId = variant == null ? variant_Id : variant.id;
      databaseHelper.delete(DatabaseHelper.CART_Table, variantId)
          .then((count) {
        widget.callback();
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
