import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';

class ProductDetailsScreen extends StatefulWidget {

  Product product;
  ProductDetailsScreen(this. product);

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailsState();
  }
}

class _ProductDetailsState extends State<ProductDetailsScreen> {

  String imageUrl,price;

  @override
  initState() {
    super.initState();
    price = widget.product.price.toString();
    imageUrl = widget.product.imageType == "0" ? widget.product.image10080: widget.product.imageUrl;
  }

  Widget build(BuildContext context) {
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Card(
            elevation: 5,
            child: imageUrl == "" ? Container(): Padding(
                padding: EdgeInsets.all(0),
                child: Container(
                  width: 150.0,
                  height: 130.0,
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
          ),
        ),
        addDivideView(),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text("${widget.product.title}",
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
        addDividerView(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Text(
                    "${AppConstant.currency}${price}",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                ),

                InkWell(
                  onTap: () async {
                    Variant variant = await DialogUtils.displayVariantsDialog(context, "${widget.product.title}", widget.product.variants);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                        child: Text(
                          "1 Kg",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 20.0),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),

          ],
        ),
        addDividerView(),
        Padding(padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
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

  // add divider view 
  addDivideView() {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey,
      margin: EdgeInsets.only(top: 5.0),
    );
  }

  // Add divider View 
  Widget addDividerView() {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width,
      color: Color(0xFF424242),
      margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
    );
  }
}