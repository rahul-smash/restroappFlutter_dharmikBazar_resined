import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:restroapp/src/Screens/Offers/AvailableOffersList.dart';
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

  String imageUrl;
  Variant variant;
  String discount,price,variantId,weight;

  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {

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

    imageUrl = widget.product.imageType == "0" ? widget.product.image10080: widget.product.imageUrl;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
    );
  }

// add Product Details top view 
  Widget getProductDetailsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0,left: 40,right: 40),
          child: imageUrl == "" ? Container(): Padding(
              padding: EdgeInsets.all(0),
              child: Container(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child:Image.network(imageUrl, fit: BoxFit.cover),
                ),
              )),
        ),
        //addDivideView(),
        Padding(
          padding: const EdgeInsets.only(top: 15.0,left: 20),
          child: Text("${widget.product.title}",
            style: TextStyle(fontSize: 16.0,color: Colors.black,fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 20.0),
                  child: (discount == "0.00" || discount == "0" || discount == "0.0")
                      ? Text("${AppConstant.currency}${price}",
                    style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),):
                  Row(
                    children: <Widget>[
                      Text("${AppConstant.currency}${discount}",
                          style: TextStyle(decoration: TextDecoration.lineThrough,fontWeight: FontWeight.bold)),
                      Text(" "),
                      Text("${AppConstant.currency}${price}",style: TextStyle(fontWeight: FontWeight.bold),),
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

          ],
        ),
        addDividerView(),
        InkWell(
          onTap: () async {
            variant = await DialogUtils.displayVariantsDialog(context, "${widget.product.title}", widget.product.variants);
            if(variant != null){
              setState(() {});
            }
            },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 5.0, left: 20.0),
                child: Text("Available In - ",
                  style: TextStyle( fontSize: 16.0,fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                decoration: BoxDecoration(
                  border: Border.all(color: orangeColor, width: 1,),
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, left: 15.0),
                      child: Text(
                        "${weight}",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: orangeColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0, left: 10.0,right: 5),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: orangeColor,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        addDividerView(),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
          child:Text("Product Detail",style: TextStyle(fontSize: 16.0),
          ),
        ),
        Padding(padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
          child: Text("${widget.product.description}",
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
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