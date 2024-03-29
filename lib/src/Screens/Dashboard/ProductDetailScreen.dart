import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:restroapp/src/Screens/Dashboard/more_detail_screen.dart';
import 'package:restroapp/src/UI/ProductTileView.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CartTableData.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../singleton/app_version_singleton.dart';

class ProductDetailsScreen extends StatefulWidget {
  Product product;
  bool isApiLoading = true;
  String productID = '';

  ProductDetailsScreen(this.product, {this.productID});

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailsState();
  }
}

class _ProductDetailsState extends State<ProductDetailsScreen> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  String imageUrl;
  Variant variant;
  String discount, price, variantId, weight, mrpPrice;
  int counter = 0;
  CartData cartData;
  bool showAddButton;
  int selctedTag;
  StoreModel _storeModel;
  bool isVisible = true;
  List<Product> _recommendedProducts = List.empty(growable: true);
  double totalPrice = 0.00;

  bool _isProductOutOfStock = false;

  int _current = 0;

  CarouselController _carouselController;

  var _pageController;
  OfferDetails offerDetails;

  @override
  initState() {
    super.initState();
    selctedTag = 0;
    showAddButton = false;
    //print("-----product.product_offer---${widget.product.product_offer}");
    _carouselController = CarouselController();
    if (widget.product != null) getDataFromDB();
    getProductDetail(widget.product?.id ?? widget.productID);
  }

  void getDataFromDB() {
    databaseHelper
        .getProductQuantitiy(widget.product.variantId)
        .then((cartDataObj) {
      cartData = cartDataObj;
      counter = int.parse(cartData.QUANTITY);
      showAddButton = counter == 0 ? true : false;
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    if (widget.product == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              return Navigator.pop(context, variant);
            },
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(
              backgroundColor: Colors.black26,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)),
        ),
      );
    }
    variantId = variant == null ? widget.product.variantId : variant.id;
    if (variant == null) {
      discount = widget.product.discount.toString();
      mrpPrice = widget.product.mrpPrice.toString();
      price = widget.product.price.toString();
      weight = widget.product.weight;
    } else {
      discount = variant.discount.toString();
      mrpPrice = variant.mrpPrice.toString();
      price = variant.price.toString();
      weight = variant.weight;
    }
    imageUrl = widget.product.imageType == "0"
        ? widget.product.image
        : widget.product.imageUrl;
    //code changed due to blur images
    /*imageUrl = widget.product.imageType == "0"
        ? widget.product.image300200
        : widget.product.imageUrl;*/
    if (weight.isEmpty) {
      isVisible = false;
    }
    if(_storeModel.displayVariantWeight=='0'){
      isVisible = false;
    }
    return WillPopScope(
      onWillPop: () {
        print("onWillPop onWillPop");
        Navigator.pop(context, variant);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: <Widget>[
            Visibility(
                visible: _checkVisibility(),
                child: IconButton(
                  icon: Icon(
                    Icons.share,
                    size: 25.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    share(widget.product,
                        '${_storeModel.domain}/shop/product/${widget.product.id}');
                  },
                )),
            InkWell(
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: Padding(
                padding:
                    EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0, right: 10),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              return Navigator.pop(context, variant);
            },
          ),
          title: Text("${widget.product.title}"),
          centerTitle: true,
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getProductDetailsView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

// add Product Details top view 
  Widget getProductDetailsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: 10.0, bottom: 10.0, left: 0, right: 0),
//              EdgeInsets.all(0),
              child: _getImageView(),
            ),
            Visibility(
              visible:
                  (discount == "0.00" || discount == "0" || discount == "0.0")
                      ? false
                      : true,
              child: Container(
                child: Text(
                  "${discount.contains(".00") ? discount.replaceAll(".00", "") : discount}% OFF",
                  style: TextStyle(color: Colors.white),
                ),
                margin: EdgeInsets.only(left: 10, top: 10),
                padding: EdgeInsets.all(10),
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
              visible: _checkOutOfStock(),
              child: Container(
                height: 280.0,
                color: Colors.white54,
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 2),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Out of Stock",
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                      )),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.topRight,
                child: addVegNonVegOption(),
              ),
            ),
          ],
          clipBehavior: Clip.none,
        ),

        //addDivideView(),
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 20),
          child: Text(
            "${widget.product.title}",
            style: TextStyle(
              fontSize: 16.0,
              color: grayColorTitle,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0),
                  child: (discount == "0.00" ||
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
                            Text("${AppConstant.currency}${mrpPrice}",
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: grayColorTitle,
                                    fontWeight: FontWeight.w400)),
                          ],
                        ),
                ),
                // Padding(
                //   padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                //   child: Text(
                //     "( Inclusive of all Taxes )",
                //     style: TextStyle(fontSize: 11.0, color: Colors.grey),
                //   ),
                // ),
              ],
            ),
            addQuantityView(),
          ],
        ),
        Visibility(
          visible: true,
          child: /*_isProductOutOfStock ? SizedBox() : */addDividerView(),
        ),

        /*_isProductOutOfStock ? SizedBox() : */buildProductOfferView(),


        Visibility(
          visible: isVisible,
          child: /*_isProductOutOfStock ? SizedBox() : */addDividerView(),
        ),

        Visibility(
          visible: isVisible,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 120,
                child: Padding(
                  padding: EdgeInsets.only(top: 0.0, left: 15.0),
                  child: Center(
                    child: Text("Available In ",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
              Expanded(
                child: showTagsList(widget.product.variants),
              ),
            ],
          ),
        ),
        !widget.isApiLoading &&
                widget.product.description != null &&
                widget.product.description.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Visibility(
                    visible: isVisible,
                    child: addDividerView(),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    child: Text(
                      "Product Detail",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, left: 10.0, right: 10.0),
                    child: Html(
                      data: "${widget.product.description}",
                      padding: EdgeInsets.all(10.0),
                    ),
                  )
                ],
              )
            : !widget.isApiLoading
                ? Container()
                : Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.black26,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.black26)),
                  ),
        _recommendedProducts.length > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  addDividerView(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                    child: Text(
                      "Recommended Products",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    itemCount: _recommendedProducts.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      Product product = _recommendedProducts[index];
                      return ProductTileItem(product, () {
//              bottomBar.state.updateTotalPrice();
                      }, ClassType.SubCategory);
                    },
                  )
                ],
              )
            : Container(),
      ],
    );
  }

  Widget buildProductOfferView(){

    return Visibility(
      visible: AppVersionSingleton.instance.appVersion.store.product_coupon == "1" && widget.product.product_offer == 1
          ? true : false,
      child: this.offerDetails == null ? Container() : Container(
        margin: EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0,right: 10),
        width: Utils.getDeviceWidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                //Icon(Icons.ac_unit,color: appThemeSecondary),
                Image.asset("images/offericon_dis.png",
                  height: 22,
                  width: 22,
                  fit: BoxFit.fill,
                ),
                SizedBox(width: 5,),
                Expanded(
                  child: Text("${this.offerDetails.name}",
                    maxLines: 1,overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 16)),
                ),
                GestureDetector(
                  onTap: () async {
                    bool isNetworkAvailable = await Utils.isNetworkAvailable();
                    if (!isNetworkAvailable) {
                      Utils.showToast(AppConstant.noInternet, false);
                      return;
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MoreDetailScreen(widget.product),
                        ));
                  },
                  child: Text("MORE",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: appThemeSecondary,
                          fontWeight: FontWeight.w500,fontSize: 16)),
                ),
                Icon(Icons.arrow_forward_ios_sharp,color: appThemeSecondary,size: 16),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text("COUPON",
                    style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                SizedBox(width: 10,),
                Text("(use at checkout)",
                    style: TextStyle(fontSize: 16,color: Colors.black54)),
              ],
            ),
            SizedBox(height: 10,),

            InkWell(
              child: Row(
                children: [
                  Container(
                    width: 100,
                    height: 30,
                    color: appThemeSecondary.withOpacity(0.15),
                    child: DottedBorder(
                      color: appThemeSecondary,
                      strokeWidth: 1,
                      child: Center(
                        child: Text("${this.offerDetails.couponCode}",
                            maxLines: 1,overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  Text("Copy",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,fontSize: 16)),
                ],
              ),
              onTap: (){
                print(this.offerDetails.couponCode);
                Utils.copyToClipboard(context,this.offerDetails.couponCode);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget showTagsList(List<Variant> variants) {
    Color chipSelectedColor, textColor;

    //print("---variants---${variants.length}---");
    Widget horizontalList = new Container(
      height: 50.0,
      //margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: variants.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Variant tagName = variants[index];
          if (selctedTag == index) {
            chipSelectedColor = variants[index].weight.trim() == ""
                ? whiteColor
                : appThemeSecondary;
            textColor = Color(0xFFFFFFFF);
          } else {
            chipSelectedColor = Color(0xFFBDBDBD);
            textColor = Color(0xFF000000);
          }
          return Container(
            margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: InkWell(
              onTap: () {
                setState(() {
                  selctedTag = index;
                  //print("selctedTag= ${tagsList[selctedTag]}");
                  if (widget.product.variants.length != null &&
                      widget.product.variants.length == 1) {
                    return;
                  }
                  variant = tagName;
                  if (variant != null) {
                    setState(() {
                      databaseHelper
                          .getProductQuantitiy(variant.id)
                          .then((cartDataObj) {
                        //print("QUANTITY= ${cartDataObj.QUANTITY}");
                        cartData = cartDataObj;
                        counter = int.parse(cartData.QUANTITY);
                        showAddButton = counter == 0 ? true : false;
                        setState(() {});
                      });
                    });
                  }
                });
              },
              child: Chip(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                autofocus: true,
                label: Text(
                  '${tagName.weight}',
                  style: TextStyle(color: textColor),
                ),
                backgroundColor: chipSelectedColor,
              ),
            ),
          );
        },
      ),
    );
    return horizontalList;
  }

  Widget addVegNonVegOption() {
    Color foodOption =
        widget.product.nutrient == "Non Veg" ? Colors.red : Colors.green;
    return Visibility(
      visible:
          widget.product.nutrient != null && widget.product.nutrient.isNotEmpty,
      child: Padding(
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
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(5.0)),
                  )),
                )),
      ),
    );
  }

  Widget addQuantityView() {
    return Visibility(
      visible: !_isProductOutOfStock,
      child: Container(
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          color: showAddButton == false ? whiteColor : appThemeSecondary,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: showAddButton == true
            ? InkWell(
                onTap: () {
                  //print("add onTap");
                  if (_checkStockQuantity(counter)) {
                    setState(() {
                      counter++;
                      showAddButton = false;
                      // insert/update to cart table
                      insertInCartTable(widget.product, counter);
                      Utils.sendAnalyticsAddToCart(widget.product, counter);
                    });
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
                          onTap: () {
                            if (counter != 0) {
                              setState(() => counter--);
                              if (counter == 0) {
                                // delete from cart table
                                removeFromCartTable(widget.product.variantId);
                                Utils.sendAnalyticsRemovedToCart(
                                    widget.product, counter);
                              } else {
                                // insert/update to cart table
                                insertInCartTable(widget.product, counter);
                                Utils.sendAnalyticsAddToCart(
                                    widget.product, counter);
                              }
                              //widget.callback();
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
                        onTap: () {
                          if (_checkStockQuantity(counter)) {
                            setState(() => counter++);
                            if (counter == 0) {
                              // delete from cart table
                              removeFromCartTable(widget.product.variantId);
                              Utils.sendAnalyticsRemovedToCart(
                                  widget.product, counter);
                            } else {
                              // insert/update to cart table
                              insertInCartTable(widget.product, counter);
                              Utils.sendAnalyticsAddToCart(
                                  widget.product, counter);
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

    databaseHelper
        .checkIfProductsExistInDb(DatabaseHelper.CART_Table, variantId)
        .then((count) {
      //print("-count-- ${count}");
      if (count == 0) {
        databaseHelper.addProductToCart(row).then((count) {
          //widget.callback();
        });
      } else {
        databaseHelper.updateProductInCart(row, variantId).then((count) {
          //widget.callback();
        });
      }
    });
  }

  void removeFromCartTable(String variant_Id) {
    try {
      String variantId;
      variantId = variant == null ? variant_Id : variant.id;
      databaseHelper.delete(DatabaseHelper.CART_Table, variantId).then((count) {
        //widget.callback();
      });
    } catch (e) {
      print(e);
    }
  }

  // Add divider View 
  Widget addDividerView() {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width,
      color: grayColor,
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0, left: 20, right: 20),
    );
  }

  void getProductDetail(String productID) async {
    //_storeModel = await SharedPrefs.getStore();
    _storeModel = AppVersionSingleton.instance.appVersion.store;
    ApiController.getSubCategoryProductDetail(productID).then((value) {
      Product product = value.subCategories.first.products.first;
      try {
        if(widget.product.product_offer == 1 && product.product_offer == 0){
          widget.product.product_offer = 0;
        }
      } catch (e) {
        print(e);
      }
      //print("------getProductDetail----=${product.product_offer}");
      this.offerDetails = product.offerDetails;
      if (widget.product == null) {
        widget.product = product;
      }
      getDataFromDB();
      setState(() {
        widget.product.productImages = product.productImages;
        widget.product.description = product.description;
        widget.isApiLoading = false;
      });
    });

    if (_storeModel != null &&
        _storeModel.recommendedProducts.compareTo("1") == 0)
      ApiController.getRecommendedProducts(productID).then((value) {
        if (value != null && value.success) {
          for (var list in value.data) {
            _recommendedProducts.addAll(list.products);
          }
          setState(() {});
        }
      });
  }

  bool _checkVisibility() {
    bool isVisible = false;
    if (_storeModel != null &&
        _storeModel.domain != null &&
        _storeModel.domain.isNotEmpty) {
      isVisible = true;
    }
    return isVisible;
  }

  Future<void> share(Product product, String link) async {
    Share.share('You may like this ${product.title} $link', subject: 'Share');
  }

  Widget _getImageView() {
    return widget.product.productImages != null &&
            widget.product.productImages.isNotEmpty
        ? Column(
            children: <Widget>[
              Container(
                child: CarouselSlider.builder(
                  itemCount: widget.product.productImages.length,
                  carouselController: _carouselController,
                  options: CarouselOptions(
//                    aspectRatio: 16 / 9,
                    height: 280,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                    enlargeCenterPage: false,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.ease,
                    scrollDirection: Axis.horizontal,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return Container(
                      child: _makeBanner(context, index),
                    );
                  },
                ),
              ),
              Visibility(
                  visible: widget.product.productImages.length > 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.product.productImages.map((url) {
                        int index = widget.product.productImages.indexOf(url);
                        return _current == index
                            ? Container(
                                width: 7.0,
                                height: 7.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: dotIncreasedColor,
                                ),
                              )
                            : Container(
                                width: 6.0,
                                height: 6.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                              );
                      }).toList(),
                    ),
                  ))
            ],
          )
        : imageUrl == ""
            ? Container(
                child: Center(
                  child: Utils.getImgPlaceHolder(),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  /*child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: "${imageUrl}", fit: BoxFit.cover
                  ),
                ),*/
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: "${imageUrl}",
                      height: 280,
                      fit: BoxFit.scaleDown,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ));
  }

  Widget _makeBanner(BuildContext context, int _index) {
    return Container(
        height: 280,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: "${widget.product.productImages[_index].url}",
            height: 280,
            fit: BoxFit.scaleDown,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ));
  }

  bool _checkOutOfStock() {
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
    return _isProductOutOfStock;
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

  PageController getPageController() {
    //memory efficient
    if (_pageController != null) _pageController.dispose();

    return _pageController;
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
      {
        if (selectedVariant.maxQuantityPerOrder.isNotEmpty &&
            counter >= int.parse(selectedVariant.maxQuantityPerOrder)) {
          Utils.showToast(
              "Maximum quantity per order is " +
                  selectedVariant.maxQuantityPerOrder.toString(),
              true);
          return false;
        }
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
  }
}
