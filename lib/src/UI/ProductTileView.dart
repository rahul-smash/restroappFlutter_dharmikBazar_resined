import 'package:flutter/material.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class ProductTileItem extends StatefulWidget {
  final Product product;
  final VoidCallback callback;

  ProductTileItem(this.product, this.callback);

  @override
  _ProductTileItemState createState() => new _ProductTileItemState();
}

class _ProductTileItemState extends State<ProductTileItem> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  int counter = 0;

  @override
  initState() {
    super.initState();
    databaseHelper.getProductQuantitiy(int.parse(widget.product.id)).then((count) {
      counter = int.parse(count);
      setState(() {});
    });

    databaseHelper.checkProductFavValue(int.parse(widget.product.id)).then((favValue){
      //print("--ProductFavValue-- ${favValue} and ${widget.product.isFav}");
      setState(() {
        widget.product.isFav = favValue;
        //print("-isFav-${widget.product.isFav}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String discount = widget.product.discount.toString();
    String imageUrl = widget.product.imageType == "0" ? widget.product.image10080: widget.product.imageUrl;

    return Column(children: [
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
                            String count = await databaseHelper.checkProductFavValue(int.parse(widget.product.id));
                            print("--ProductFavValue-- ${count}");
                            Product product = widget.product;
                            if(count == null || count =="null"){
                              print("-if- ${count}");
                              product.isFav = "1";
                            }else if(count == "1"){
                              product.isFav = "0";
                            }else if(count == "0"){
                              product.isFav = "1";
                            }
                            if(product.isFav == "1"){
                              Utils.showToast(AppConstant.favsAdded, true);
                            }else{
                              Utils.showToast(AppConstant.favsRemoved, true);
                            }
                            Map<String, dynamic> row = {
                              DatabaseHelper.isFavorite: product.isFav,
                            };
                            int updatedRow = await databaseHelper.updateProductInCart(row, int.parse(widget.product.id));
                            print("--updatedRow-- ${updatedRow}");
                            widget.callback();
                            setState(() {

                            });
                          },
                          child: Utils.showFavIcon(widget.product.isFav),
                          //child: Image.asset("images/myfav.png", width: 25),
                        ),
                        addVegNonVegOption(),
                        imageUrl == ""
                            ? Container()
                            : Padding(
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
                                    style: new TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18.0,
                                      color: appTheme,
                                    )),
                                (discount == "0.00" ||
                                    discount == "0" ||
                                    discount == "0.0")
                                    ? Text("\$${widget.product.price}")
                                    : Row(
                                  children: <Widget>[
                                    Text("\$${widget.product.discount}",
                                        style: TextStyle(
                                            decoration:
                                            TextDecoration.lineThrough)),
                                    Text(" "),
                                    Text("\$${widget.product.price}"),
                                  ],
                                )
                              ],
                            )),
                      ],
                    )),
                addPlusMinusView()
              ])),
      Container(
          height: 1,
          width: MediaQuery
              .of(context)
              .size
              .width,
          color: Color(0xFFBDBDBD))
    ]);
  }

  Widget addVegNonVegOption() {
    Color foodOption =
    widget.product.nutrient == "Non Veg" ? Colors.red : Colors.green;
    return Padding(
      padding: EdgeInsets.only(left: 7, right: 7),
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

  Widget addPlusMinusView() {
    return Container(
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
                    removeFromCartTable(widget.product.id);
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
                  removeFromCartTable(widget.product.id);
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
    var mId = int.parse(product.id);

    Map<String, dynamic> row = {
      DatabaseHelper.ID: mId,
      DatabaseHelper.VARIENT_ID: product.variantId,
      DatabaseHelper.PRODUCT_ID: product.id,
      DatabaseHelper.WEIGHT: product.weight,
      DatabaseHelper.isFavorite: product.isFav,
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

    databaseHelper
        .checkIfProductsExistInCart(DatabaseHelper.CART_Table, mId)
        .then((count) {
      if (count == 0) {
        databaseHelper.addProductToCart(row).then((count) {
          widget.callback();
        });
      } else {
        databaseHelper.updateProductInCart(row, mId).then((count) {
          widget.callback();
        });
      }
    });
  }

  void removeFromCartTable(String productId) {
    try {
      databaseHelper
          .delete(DatabaseHelper.CART_Table, int.parse(productId))
          .then((count) {
        widget.callback();
      });
    } catch (e) {
      print(e);
    }
  }
}
