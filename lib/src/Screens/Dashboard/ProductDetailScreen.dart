import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:restroapp/src/Screens/Offers/AvailableOffersList.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/CartTableData.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

class ProductDetailsScreen extends StatefulWidget {

  Product product;
  ProductDetailsScreen(this. product);

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailsState();
  }
}

class _ProductDetailsState extends State<ProductDetailsScreen> {

  DatabaseHelper databaseHelper = new DatabaseHelper();
  String imageUrl;
  Variant variant;
  String discount,price,variantId,weight,mrpPrice;
  int counter = 0;
  CartData cartData;
  bool showAddButton;
  int selctedTag;
  bool isVisible = true;

  @override
  initState() {
    super.initState();
    selctedTag = 0;
    showAddButton = false;
    getDataFromDB();
  }

  void getDataFromDB() {
    databaseHelper.getProductQuantitiy(widget.product.variantId).then((cartDataObj) {
      cartData = cartDataObj;
      counter = int.parse(cartData.QUANTITY);
      showAddButton = counter == 0 ? true : false;
      setState(() {});
    });
  }

  Widget build(BuildContext context) {

    variantId = variant == null ? widget.product.variantId : variant.id;
    if(variant == null){
      discount = widget.product.discount.toString();
      mrpPrice = widget.product.mrpPrice.toString();
      price = widget.product.price.toString();
      weight = widget.product.weight;
    }else{
      discount = variant.discount.toString();
      mrpPrice = variant.mrpPrice.toString();
      price = variant.price.toString();
      weight = variant.weight;
    }

    imageUrl = widget.product.imageType == "0" ? widget.product.image10080: widget.product.imageUrl;

    if(weight.isEmpty){
      isVisible = false;
    }


    return WillPopScope(
      onWillPop: (){
        print("onWillPop onWillPop");
        Navigator.pop(context, variant);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              return  Navigator.pop(context, variant);
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
        Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 10.0,left: 40,right: 40),
          child: imageUrl == "" ?
          Container(
            child: Center(
              child: Utils.getImgPlaceHolder(),
            ),
          )
              : Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: CachedNetworkImage(
                    imageUrl: "${imageUrl}", fit: BoxFit.cover
                    //placeholder: (context, url) => CircularProgressIndicator(),
                    //errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  //child:Image.network(imageUrl, fit: BoxFit.cover),
                ),
              )),
        ),
        //addDivideView(),
        Padding(
          padding: const EdgeInsets.only(top: 15.0,left: 20),
          child: Text("${widget.product.title}",
            style: TextStyle(fontSize: 16.0,color: grayColorTitle,),
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
                  padding: EdgeInsets.only(top: 10.0, left: 20.0),
                  child: (discount == "0.00" || discount == "0" || discount == "0.0")
                      ? Text("${AppConstant.currency}${price}",
                    style: TextStyle(color: grayColorTitle,fontWeight: FontWeight.w600),):
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
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                  child:Text("( Inclusive of all Taxes )",
                    style: TextStyle(fontSize: 11.0,color: Colors.grey),
                  ),
                ),
              ],
            ),
            addQuantityView(),
          ],
        ),
        Visibility(
          visible: isVisible,
          child: addDividerView(),
        ),
        Visibility(
          visible: isVisible,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 120,
                child: Padding(
                  padding: EdgeInsets.only(top: 0.0, left: 20.0),
                  child: Center(
                    child: Text("Available In ",
                        style: TextStyle( fontSize: 16.0,fontWeight: FontWeight.w400)),
                  ),
                ),
              ),
              Expanded(
                child: showTagsList(widget.product.variants),
              ),
            ],
          ),
        ),
        Visibility(
          visible: isVisible,
          child: addDividerView(),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
          child:Text("Product Detail",style: TextStyle(fontSize: 16.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
          /*child: Text("${widget.product.description}",
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),*/
          child: Html(data: "${widget.product.description}",
            padding: EdgeInsets.all(10.0),),
        ),
      ],
    );
  }


  Widget showTagsList(List<Variant> variants){
    Color chipSelectedColor, textColor;

    print("---variants---${variants.length}---");
    Widget horizontalList = new Container(
      height: 50.0,
      //margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: variants.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            Variant tagName = variants[index];
            if(selctedTag == index){
              chipSelectedColor = orangeColor;
              textColor = Color(0xFFFFFFFF);
            }else{
              chipSelectedColor = Color(0xFFBDBDBD);
              textColor = Color(0xFF000000);
            }
            return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: InkWell(
                onTap: (){
                  setState(() {
                    selctedTag = index;
                    //print("selctedTag= ${tagsList[selctedTag]}");
                    if(widget.product.variants.length != null && widget.product.variants.length == 1){
                      return;
                    }
                    variant = tagName;
                    if(variant != null){
                      setState(() {
                        databaseHelper.getProductQuantitiy(variant.id).then((cartDataObj) {
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  autofocus: true,
                  label: Text('${tagName.weight}',style: TextStyle(color: textColor),),
                  backgroundColor: chipSelectedColor,
                ),
              ),
            );
          },
        ),
    );
    return horizontalList;
  }

  Widget addQuantityView() {
    return Container(
        width: 100,
        height: 30,
        decoration: BoxDecoration(
          color: showAddButton == false ? whiteColor : orangeColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
        child: showAddButton == true
            ? InkWell(onTap: (){
          print("add onTap");
          setState(() {
            counter ++ ;
            showAddButton = false;
            // insert/update to cart table
            insertInCartTable(widget.product, counter);
          });
        },
          child: Container(child: Center(child: Text("Add",style: TextStyle(color: whiteColor),),),),
        )
            :
        Visibility(
          visible: showAddButton == true ? false : true,
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
                    //widget.callback();
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
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0,left: 20,right: 20),
    );
  }
}