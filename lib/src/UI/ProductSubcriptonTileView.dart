import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:restroapp/src/Screens/Dashboard/ProductDetailScreen.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CartTableData.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

import 'AddSubscriptionScreen.dart';

class ProductSubcriptonTileView extends StatefulWidget {
  Product product;
  VoidCallback callback;
  ClassType classType;
  String quantity = '';
  Variant globelVariant;
  Function addQuantityFunction;

  ProductSubcriptonTileView(this.product, this.callback, this.classType,
      this.quantity, this.globelVariant, this.addQuantityFunction);

  @override
  _ProductSubcriptonTileViewState createState() =>
      new _ProductSubcriptonTileViewState();
}

class _ProductSubcriptonTileViewState extends State<ProductSubcriptonTileView> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  int counter = 0;

//  CartData cartData;
  Variant variant;
  bool showAddButton;

  bool _isProductOutOfStock = false;

  @override
  initState() {
    super.initState();
    variant = widget.globelVariant;
    widget.product.variantId = widget.globelVariant == null
        ? widget.product.variantId
        : widget.globelVariant.id;
    widget.product.weight = widget.globelVariant == null
        ? widget.product.weight
        : widget.globelVariant.weight;
    widget.product.mrpPrice = widget.globelVariant == null
        ? widget.product.mrpPrice
        : widget.globelVariant.mrpPrice;
    widget.product.price = widget.globelVariant == null
        ? widget.product.price
        : widget.globelVariant.price;
    widget.product.discount = widget.globelVariant == null
        ? widget.product.discount
        : widget.globelVariant.discount;
    widget.product.isUnitType = widget.globelVariant == null
        ? widget.product.isUnitType
        : widget.globelVariant.unitType;
    counter = widget.quantity != null
        ? widget.quantity.isEmpty
            ? 0
            : int.parse(widget.quantity)
        : 0;
    showAddButton = false;
    //print("--_ProductTileItemState-- initState ${widget.classType}");
    getDataFromDB();
    _checkOutOfStock(findNext: true);
  }

  void getDataFromDB() {
    showAddButton = counter == 0 ? true : false;
//    databaseHelper
//        .getProductQuantitiy(widget.product.variantId,isSubscriptionTable: true)
//        .then((cartDataObj) {
//      cartData = cartDataObj;
//      counter = int.parse(cartData.QUANTITY);
//      showAddButton = counter == 0 ? true : false;
    //print("-QUANTITY-${counter}=");
//      setState(() {});
//    });
    databaseHelper
        .checkProductsExistInFavTable(
            DatabaseHelper.Favorite_Table, widget.product.id)
        .then((favValue) {
      //print("--ProductFavValue-- ${favValue} and ${widget.product.isFav}");
      setState(() {
        widget.product.isFav = favValue.toString();
        //print("-isFav-${widget.product.isFav}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String discount, price, variantId, weight, mrpPrice;
    variantId = variant == null ? widget.product.variantId : variant.id;
    if (variant == null) {
      //print("====-variant == null====");
      discount = widget.product.discount.toString();
      price = widget.product.price.toString();
      weight = widget.product.weight;
      mrpPrice = widget.product.mrpPrice;
    } else {
      //print("==else==-variant == null====");
      discount = variant.discount.toString();
      price = variant.price.toString();
      weight = variant.weight;
      mrpPrice = variant.mrpPrice;
    }
    String imageUrl = widget.product.imageType == "0"
        ? widget.product.image == null
            ? widget.product.image10080
            : widget.product.image
        : widget.product.imageUrl;
    bool variantsVisibility;
    variantsVisibility = widget.classType == ClassType.CART
        ? true
        : widget.product.variants != null &&
                widget.product.variants.isNotEmpty &&
                widget.product.variants.length >= 1
            ? true
            : false;

    if (weight.isEmpty) {
      variantsVisibility = false;
    }

    return Container(
      color: Colors.white,
      child: Column(children: [
        InkWell(
          onTap: () async {
            //print("----print-----");
            if (widget.classType != ClassType.CART) {
              var result = await Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ProductDetailsScreen(widget.product),
                    fullscreenDialog: true,
                  ));
              setState(() {
//                if (result != null) {
//                  variant = result;
//                  discount = variant.discount.toString();
//                  price = variant.price.toString();
//                  weight = variant.weight;
//                  variantId = variant.id;
//                } else {
//                  variantId =
//                      variant == null ? widget.product.variantId : variant.id;
//                }
//                _checkOutOfStock(findNext: false);
                //TODO: Counter Update
//                eventBus.fire(
//                    onSubscribeProduct(widget.product, counter.toString()));
//                databaseHelper
//                    .getProductQuantitiy(variantId)
//                    .then((cartDataObj) {
//                  setState(() {
//                    cartData = cartDataObj;
//                    counter = int.parse(cartData.QUANTITY);
//                    showAddButton = counter == 0 ? true : false;
//                    //print("-QUANTITY-${counter}=");
//                  });
//                });
                databaseHelper
                    .checkProductsExistInFavTable(
                        DatabaseHelper.Favorite_Table, widget.product.id)
                    .then((favValue) {
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
            padding: EdgeInsets.only(top: 0, bottom: 15),
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
                      Stack(
                        children: <Widget>[
                          imageUrl == ""
                              ? Container(
                                  width: 70.0,
                                  height: 80.0,
                                  child: Utils.getImgPlaceHolder(),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(left: 5, right: 20),
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
                          Visibility(
                            visible: (discount == "0.00" ||
                                    discount == "0" ||
                                    discount == "0.0")
                                ? false
                                : true,
                            child: Container(
                              child: Text(
                                "${discount.contains(".00") ? discount.replaceAll(".00", "") : discount}% OFF",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10.0),
                              ),
                              margin: EdgeInsets.only(left: 5),
                              padding: EdgeInsets.all(5),
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: appThemeSecondary,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0)),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _isProductOutOfStock,
                            child: Container(
                              height: 80.0,
                              color: Colors.white54,
                              child: Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.red, width: 1),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Text(
                                        "Out of Stock",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12),
                                      ),
                                    )),
                              ),
                            ),
                          )
                        ],
                      ),
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
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: grayColorTitle,
                                    )),
                              ),
                              InkWell(
                                onTap: () async {
                                  int count = await databaseHelper
                                      .checkProductsExistInFavTable(
                                          DatabaseHelper.Favorite_Table,
                                          widget.product.id);

                                  Product product = widget.product;
                                  print("--product.count-- ${count}");
                                  if (count == 1) {
                                    product.isFav = "0";
                                    await databaseHelper.deleteFav(
                                        DatabaseHelper.Favorite_Table,
                                        product.id);
                                  } else if (count == 0) {
                                    String variantId,
                                        weight,
                                        mrpPrice,
                                        price,
                                        discount,
                                        isUnitType;
                                    variantId = variant == null
                                        ? widget.product.variantId
                                        : variant.id;
                                    weight = variant == null
                                        ? widget.product.weight
                                        : variant.weight;
                                    mrpPrice = variant == null
                                        ? widget.product.mrpPrice
                                        : variant.mrpPrice;
                                    price = variant == null
                                        ? widget.product.price
                                        : variant.price;
                                    discount = variant == null
                                        ? widget.product.discount
                                        : variant.discount;
                                    isUnitType = variant == null
                                        ? widget.product.isUnitType
                                        : variant.unitType;

                                    product.isFav = "1";
                                    product.variantId = variantId;
                                    product.weight = weight;
                                    product.mrpPrice = mrpPrice;
                                    product.price = price;
                                    product.discount = discount;
                                    product.isUnitType = isUnitType;
                                    insertInFavTable(product, counter);
                                  }
                                  //print("--product.isFav-- ${product.isFav}");
                                  widget.callback();
                                  setState(() {});
                                },
                                child: Visibility(
                                  visible: widget.classType == ClassType.CART
                                      ? false
                                      : true,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: widget.classType == ClassType.CART
                                          ? Colors.white
                                          : favGrayColor,
                                      border: Border.all(
                                        color: favGrayColor,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 5, 20, 0),
                                    child: Visibility(
                                      visible:
                                          widget.classType == ClassType.CART
                                              ? false
                                              : true,
                                      /* child: widget.product.isFav == null ? Icon(Icons.favorite_border)
                                                        :Utils.showFavIcon(widget.product.isFav),*/
                                      child: widget.classType ==
                                              ClassType.Favourites
                                          ? Icon(
                                              Icons.favorite,
                                              color: appThemeSecondary,
                                            )
                                          : Utils.showFavIcon(
                                              widget.product.isFav),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: variantsVisibility == true ? 0 : 20,
                          ),
                          Visibility(
                            visible: variantsVisibility,
                            child: Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 10),
                              child: InkWell(
                                onTap: () async {
//                                  //print("-variants.length--${widget.product.variants.length}");
//                                  if (widget.product.variants.length != null) {
//                                    if (widget.product.variants.length == 1) {
//                                      return;
//                                    }
//                                  }
//                                  variant =
//                                      await DialogUtils.displayVariantsDialog(
//                                          context,
//                                          "${widget.product.title}",
//                                          widget.product.variants,
//                                          selectedVariant: variant);
//                                  if (variant != null) {
//                                    /*print("variant.weight= ${variant.weight}");
//                                                  print("variant.discount= ${variant.discount}");
//                                                  print("variant.mrpPrice= ${variant.mrpPrice}");
//                                                  print("variant.price= ${variant.price}");*/
//                                    //TODO: Counter Update
//                                    eventBus.fire(onSubscribeProduct(
//                                        widget.product, counter.toString()));
////                                    databaseHelper
////                                        .getProductQuantitiy(variant.id)
////                                        .then((cartDataObj) {
////                                      //print("QUANTITY= ${cartDataObj.QUANTITY}");
////                                      cartData = cartDataObj;
////                                      counter = int.parse(cartData.QUANTITY);
////                                      showAddButton =
////                                          counter == 0 ? true : false;
////                                      setState(() {});
////                                    });
//                                  }
//                                  _checkOutOfStock(findNext: false);
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: weight.trim() == ""
                                          ? whiteColor
                                          : appThemeSecondary,
                                      width: 1,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  child: Wrap(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 5, right: 5, bottom: 5),
                                        child: Text(
                                          "${weight}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: appThemeSecondary),
                                        ),
                                      ),
//                                      Visibility(
//                                        visible:
//                                            widget.classType == ClassType.CART
//                                                ? false
//                                                : true,
//                                        child: Padding(
//                                          padding: EdgeInsets.only(left: 10),
//                                          child: Utils.showVariantDropDown(
//                                              widget.classType, widget.product),
//                                        ),
//                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              (discount == "0.00" ||
                                      discount == "0" ||
                                      discount == "0.0")
                                  ? Text(
                                      "${AppConstant.currency}${price}",
                                      style: TextStyle(
                                          color: grayColorTitle,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : Row(
                                      children: <Widget>[
                                        Text(
                                          "${AppConstant.currency}${price}",
                                          style: TextStyle(
                                              color: grayColorTitle,
                                              fontWeight: FontWeight.w700),
                                        ),
                                        Text(" "),
                                        Text(
                                            "${AppConstant.currency}${mrpPrice}",
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: grayColorTitle,
                                                fontWeight: FontWeight.w400)),
                                      ],
                                    ),
                              //addQuantityView(),
                            ],
                          ),

                          //0 => subscription is on
                          //1 => subscription is off
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                    visible: false,
                                    child: InkWell(
                                      onTap: () async {},
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: appThemeSecondary,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          width: 100,
                                          height: 30,
                                          child: Center(
                                              child: Text(
                                            "SUBSCRIBE",
                                            style: TextStyle(
                                                color: appThemeSecondary),
                                          ))),
                                    )),
                                addQuantityView(),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ],
                  )),
                ]),
          ),
        ),
        Container(
            height: 0.1,
            width: MediaQuery.of(context).size.width,
            color: Color(0xFFBDBDBD))
      ]),
    );
  }

  Widget addQuantityView() {
    return Visibility(
      visible: !_isProductOutOfStock,
      child: Container(
        //color: orangeColor,
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          color: showAddButton == false ? whiteColor : appThemeSecondary,
          //border: Border.all(color: showAddButton == false ? whiteColor : orangeColor, width: 0,),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
        child: showAddButton == true
            ? InkWell(
                onTap: () async {
                  bool proceed = await widget.addQuantityFunction(
                      widget.product, counter.toString());
                  //print("add onTap");
                  if (proceed && _checkStockQuantity(counter)) {
                    setState(() {});
                    counter++;
                    showAddButton = false;
                    eventBus.fire(
                        onSubscribeProduct(widget.product, counter.toString()));
                    widget.callback();
                  }
                },
                child: Container(
                  child: Center(
                    child: Text(
                      "Add",
                      style: TextStyle(color: whiteColor),
                    ),
                  ),
                ),
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
                          onTap: () async {
                            bool proceed = await widget.addQuantityFunction(
                                widget.product, counter.toString());
                            if (proceed && counter != 0) {
                              setState(() => counter--);
                              if (counter == 0) {
                                eventBus.fire(onSubscribeProduct(
                                    widget.product, counter.toString()));
                              } else {
                                eventBus.fire(onSubscribeProduct(
                                    widget.product, counter.toString()));
                              }
                              widget.callback();
                            }
                          },
                          child: Container(
                            width: 35,
                            height: 25,
                            decoration: BoxDecoration(
                              color: grayColor,
                              border: Border.all(
                                color: grayColor,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: Icon(Icons.remove,
                                color: Colors.white, size: 20),
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      width: 30.0,
                      height: 30.0,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(15.0)),
                        border: new Border.all(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                          child: Text(
                        "$counter",
                        style: TextStyle(fontSize: 18),
                      )),
                    ),
                    Container(
                      padding: const EdgeInsets.all(0.0),
                      width: 30.0, // you can adjust the width as you need
                      child: GestureDetector(
                        onTap: () async {
                          bool proceed = await widget.addQuantityFunction(
                              widget.product, counter.toString());
                          if (proceed && _checkStockQuantity(counter)) {
                            setState(() => counter++);
                            if (counter == 0) {
                              eventBus.fire(onSubscribeProduct(
                                  widget.product, counter.toString()));
                              // delete from cart table
//                              removeFromCartTable(widget.product.variantId);
                            } else {
                              eventBus.fire(onSubscribeProduct(
                                  widget.product, counter.toString()));
                              // insert/update to cart table
//                              insertInCartTable(widget.product, counter);
                            }
                          }
                        },
                        child: Container(
                            width: 35,
                            height: 25,
                            decoration: BoxDecoration(
                              color: appThemeSecondary,
                              border: Border.all(
                                color: appThemeSecondary,
                                width: 1,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child:
                                Icon(Icons.add, color: Colors.white, size: 20)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget addVegNonVegOption() {
    Color foodOption =
        widget.product.nutrient == "Non Veg" ? Colors.red : Colors.green;
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 7),
      child: widget.product.nutrient == "None"
          ? Container()
          : Container(
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

//  void removeFromCartTable(String variant_Id) {
//    try {
//      //print("------removeFromCartTable-------");
//      String variantId;
//      variantId = variant == null ? variant_Id : variant.id;
//      databaseHelper.delete(DatabaseHelper.SUBSCRIPTION_CART_Table, variantId).then((count) {
//        widget.callback();
//        eventBus.fire(updateCartCount());
//      });
//    } catch (e) {
//      print(e);
//    }
//  }

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

  _checkOutOfStock({bool findNext = false}) async {
    _isProductOutOfStock = false;
//1)min_alert
//if product min_stock_alert  number is less than or equal to the product stock -> make the product oos
//2)threshold_quantity -
//if product stock number is less than or equal to zero -> make the product oos
//3)continue_selling -> no out of stock

    Variant selectedVariant =
        variant != null ? variant : findVariant(widget.product.variantId);
    if (selectedVariant != null &&
        selectedVariant.stockType != null &&
        selectedVariant.stockType.isNotEmpty) {
      switch (selectedVariant.stockType) {
        case 'min_alert':
          if (selectedVariant.minStockAlert != null &&
              selectedVariant.stock != null) {
            int stock = int.parse(selectedVariant.stock);
            int minStockAlert = int.parse(selectedVariant.minStockAlert);
            if (minStockAlert >= stock) {
              _isProductOutOfStock = true;
            }
          }
          break;
        case 'threshold_quantity':
          if (selectedVariant.stock != null) {
            int stock = int.parse(selectedVariant.stock);
            if (stock <= 0) {
              _isProductOutOfStock = true;
            }
          }
          break;
        case 'continue_selling':
          _isProductOutOfStock = false;
          break;
        default:
          _isProductOutOfStock = false;
      }
    }

    if (findNext &&
        variant == null &&
        selectedVariant != null &&
        _isProductOutOfStock &&
        widget.product.variants != null &&
        widget.product.variants.isNotEmpty) {
      //find next variant which is in the stocks
      for (int i = 0; i < widget.product.variants.length; i++) {
        variant = widget.product.variants[i];
        await _checkOutOfStock(findNext: false);
      }
    }
    if (mounted) setState(() {});
    return _isProductOutOfStock;
  }

  bool _checkStockQuantity(int counter) {
    bool isProductAvailable = true;
//1)min_alert
//if product min_stock_alert  number is less than or equal to the product stock -> make the product oos
//2)threshold_quantity -
//if product stock number is less than or equal to zero -> make the product oos
//3)continue_selling -> no out of stock

    Variant selectedVariant =
        variant != null ? variant : findVariant(widget.product.variantId);
    if (selectedVariant != null &&
        selectedVariant.stockType != null &&
        selectedVariant.stockType.isNotEmpty) {
      switch (selectedVariant.stockType) {
        case 'threshold_quantity':
          if (selectedVariant.stock != null) {
            int stock = int.parse(selectedVariant.stock);
            if (stock <= 0) {
              isProductAvailable = false;
              Utils.showToast("Out of Stock", true);
            } else if (stock <= counter) {
              isProductAvailable = false;
              Utils.showToast(
                  "Only ${counter} Items Available in Stocks", true);
            } else {
              isProductAvailable = true;
            }
          }
          break;
        case 'min_alert':
          if (selectedVariant.stock != null &&
              selectedVariant.minStockAlert != null) {
            int stock = int.parse(selectedVariant.stock);
            int minStockAlert = int.parse(selectedVariant.minStockAlert);
            if (stock <= 0) {
              isProductAvailable = false;
              Utils.showToast("Out of Stock", true);
            } else if (counter >= (stock - minStockAlert)) {
              isProductAvailable = false;
              Utils.showToast(
                  "Only ${counter} Items Available in Stocks", true);
            } else if (stock <= counter) {
              isProductAvailable = false;
              Utils.showToast(
                  "Only ${counter} Items Available in Stocks", true);
            } else {
              isProductAvailable = true;
            }
          }
          break;
        default:
          isProductAvailable = true;
      }
    }
    return isProductAvailable;
  }

  Variant findVariant(String variantId) {
    Variant foundVariant;
    if (widget.product.variants != null)
      for (int i = 0; i < widget.product.variants.length; i++) {
        if (widget.product.variants[i].id.compareTo(variantId) == 0) {
          foundVariant = widget.product.variants[i];
          break;
        }
      }
    return foundVariant;
  }

//  void insertInCartTable(Product product, int quantity) {
//    String variantId, weight, mrpPrice, price, discount, isUnitType;
//    variantId = variant == null ? widget.product.variantId : variant.id;
//    weight = variant == null ? widget.product.weight : variant.weight;
//    mrpPrice = variant == null ? widget.product.mrpPrice : variant.mrpPrice;
//    price = variant == null ? widget.product.price : variant.price;
//    discount = variant == null ? widget.product.discount : variant.discount;
//    isUnitType = variant == null ? widget.product.isUnitType : variant.unitType;
//
//    var mId = int.parse(product.id);
//    //String variantId = product.variantId;
//
//    Map<String, dynamic> row = {
//      DatabaseHelper.ID: mId,
//      DatabaseHelper.VARIENT_ID: variantId,
//      DatabaseHelper.WEIGHT: weight,
//      DatabaseHelper.MRP_PRICE: mrpPrice,
//      DatabaseHelper.PRICE: price,
//      DatabaseHelper.DISCOUNT: discount,
//      DatabaseHelper.UNIT_TYPE: isUnitType,
//      DatabaseHelper.PRODUCT_ID: product.id,
//      DatabaseHelper.isFavorite: product.isFav,
//      DatabaseHelper.QUANTITY: quantity.toString(),
//      DatabaseHelper.IS_TAX_ENABLE: product.isTaxEnable,
//      DatabaseHelper.Product_Name: product.title,
//      DatabaseHelper.nutrient: product.nutrient,
//      DatabaseHelper.description: product.description,
//      DatabaseHelper.imageType: product.imageType,
//      DatabaseHelper.imageUrl: product.imageUrl,
//      DatabaseHelper.image_100_80: product.image10080,
//      DatabaseHelper.image_300_200: product.image300200,
//    };
//
//    databaseHelper
//        .checkIfProductsExistInDb(DatabaseHelper.SUBSCRIPTION_CART_Table, variantId)
//        .then((count) {
//      //print("-count-- ${count}");
//      if (count == 0) {
//        databaseHelper.addProductToCart(row,isSubscriptionTable: true).then((count) {
//          widget.callback();
//          eventBus.fire(updateCartCount());
//        });
//      } else {
//        databaseHelper.updateProductInCart(row, variantId,isSubscriptionTable: true).then((count) {
//          widget.callback();
//          eventBus.fire(updateCartCount());
//        });
//      }
//    });
//  }

}
