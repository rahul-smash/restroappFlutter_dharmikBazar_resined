import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:restroapp/src/Screens/Dashboard/eligible_product_screen.dart';
import 'package:restroapp/src/Screens/Dashboard/my_coupons_screen.dart';
import 'package:restroapp/src/UI/ProductTileView.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CartTableData.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../singleton/app_version_singleton.dart';

class MoreDetailScreen extends StatefulWidget {
  Product product;
  bool isApiLoading = true;
  String productID = '';

  MoreDetailScreen(this.product, {this.productID});

  @override
  State<StatefulWidget> createState() {
    return _MoreDetailsState();
  }
}

class _MoreDetailsState extends State<MoreDetailScreen> {
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

  bool isLoading = true;

  int _current = 0;

  CarouselController _carouselController;

  var _pageController;
  OfferDetails offerDetails;

  @override
  initState() {
    super.initState();
    selctedTag = 0;
    showAddButton = false;
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
    imageUrl = widget.product.imageType == "0"
        ? widget.product.image
        : widget.product.imageUrl;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: SingleChildScrollView(
            child: getProductDetailsView(),
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: () async {
            try {
              UserModel user = await SharedPrefs.getUser();
            } catch (e) {
              Utils.showToast('You need to login first', true);
              return;
            }

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MyCouponScreen(),
                ));
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 30),
            color: Colors.grey[200],
            child: Row(
              children: [
                //Icon(Icons.ac_unit,color: appThemeSecondary),
                Image.asset(
                  "images/available_coupon_icon.png",
                  height: 22,
                  width: 22,
                  fit: BoxFit.fill,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text("Available more coupons",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.arrow_forward_ios_sharp,
                      color: Colors.grey, size: 16),
                ),
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
            Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "images/my_coupon.png",
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 15.0, left: 30.0, right: 30.0),
//              EdgeInsets.all(0),
                ),
              ],
            ),
            isLoading
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    child: Utils.showSpinner())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Text(
                          "My Coupons",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          height: 30,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: _getImageView(),
                      ),
                      SizedBox(height: 10,),
                      //addDividerView(),
                      buildProductOfferView(),
                      addDividerView(),
                      Center(
                        child: Container(
                            child: Padding(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            "VALID TILL : ${(widget.product.offerDetails != null) ? Utils.convertValidTillDate(widget.product.offerDetails.validTo) : ''}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                        )),
                      ),
                      addDividerView(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        child: Text(
                          "Terms and Conditions",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                        child: Html(
                          data:
                              "${(widget.product.offerDetails != null) ? widget.product.offerDetails.offerTermCondition : ''}",
                          padding: EdgeInsets.all(10.0),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
          ],
          clipBehavior: Clip.none,
        ),
      ],
    );
  }

  Widget buildProductOfferView() {
    return Visibility(
      visible:
          AppVersionSingleton.instance.appVersion.store.product_coupon == "1" &&
                  widget.product.product_offer == 1
              ? true
              : false,
      child: this.offerDetails == null
          ? Container()
          : Container(
              margin: EdgeInsets.only(
                  top: 10.0, left: 20.0, bottom: 10.0, right: 10),
              width: Utils.getDeviceWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      //Icon(Icons.ac_unit,color: appThemeSecondary),
                      Image.asset(
                        "images/offericon_dis.png",
                        height: 22,
                        width: 22,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Text("${this.offerDetails.name}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text("COUPON",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      SizedBox(
                        width: 10,
                      ),
                      Text("(use at checkout)",
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54)),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text("Copy",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                      ],
                    ),
                    onTap: () {
                      print(this.offerDetails.couponCode);
                      Utils.copyToClipboard(context,this.offerDetails.couponCode);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  /*Text(
                      "Orders above : Rs ${(widget.product.offerDetails != null) ? widget.product.offerDetails.minimumOrderAmount : ''}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 10,
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // bottom sheet open here
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: EligibleProductScreen(
                                    offerId: widget.product.offerDetails.id,
                                  ),
                                );
                              });
                        },
                        child: Text("ELIGIBLE PRODUCTS",
                            style: TextStyle(
                                color: appThemeSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16)),
                      ),
                      Icon(Icons.arrow_forward_ios_sharp,
                          color: appThemeSecondary, size: 16),
                    ],
                  ),
                ],
              ),
            ),
    );
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
    _storeModel = await SharedPrefs.getStore();
    ApiController.getSubCategoryProductDetail(productID).then((value) {
      Product product = value.subCategories.first.products.first;
      this.offerDetails = product.offerDetails;
      if (widget.product == null) {
        widget.product = product;
      }
      getDataFromDB();
      print("widget.product.productImages=${widget.product.productImages.length}");
      print("-----placeholderUrl---${AppConstant.placeholderUrl}");
      print("-----imageUrl---${imageUrl}");
      setState(() {
        widget.product.productImages = product.productImages;
        widget.product.description = product.description;
        widget.product.offerDetails = product.offerDetails;
        widget.isApiLoading = false;
        isLoading = false;
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

  Future<void> share(Product product, String link) async {
    Share.share('You may like this ${product.title} $link', subject: 'Share');
  }

  Widget _getImageView() {
    return widget.product.productImages != null &&
            widget.product.productImages.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: _makeBanner(context, 0),
              ),
            ],
          )
        : imageUrl == ""
            ? Container(
                padding: EdgeInsets.all(10),
                child: Card(
                  elevation: 5,
                  child: Utils.getImgPlaceHolder(),
                ),
              )
            : Padding(
                padding: EdgeInsets.all(0),
                child: Card(
                  elevation: 5,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    /*child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: "${imageUrl}", fit: BoxFit.cover
                    ),
                  ),*/
                    child: CachedNetworkImage(
                      imageUrl: "${imageUrl}",
                      height: 100,
                      width: 100,
                      fit: BoxFit.scaleDown,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ));
  }

  Widget _makeBanner(BuildContext context, int _index) {
    return Card(
      elevation: 5,
      child: Container(
          height: 100,
          width: 100,
          child: CachedNetworkImage(
            imageUrl: "${widget.product.productImages[_index].url}",
            height: 100,
            width: 100,
            fit: BoxFit.scaleDown,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )),
    );
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
}
