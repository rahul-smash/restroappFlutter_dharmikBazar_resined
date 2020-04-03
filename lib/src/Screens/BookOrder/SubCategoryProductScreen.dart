import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/Screens/MyCartScreen.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class SubCategoryProductScreen extends StatelessWidget {
  final CategoryModel categoryModel;
  SubCategoryProductScreen(this.categoryModel);

  final TotalPriceBottomBar bottomBar = TotalPriceBottomBar();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categoryModel.subCategory.length,
      child: Scaffold(
        appBar: AppBar(
            title: Text(categoryModel.title),
            centerTitle: true,
            bottom: TabBar(
              tabs:
                  List.generate(categoryModel.subCategory.length, (int index) {
                return Tab(text: categoryModel.subCategory[index].title);
              }),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: TabBarView(
          children:
              List.generate(categoryModel.subCategory.length, (int index) {
            return getProductsWidget(
                categoryModel.subCategory[index].id, bottomBar);
          }),
        ),
        bottomNavigationBar: bottomBar,
      ),
    );
  }

  Widget getProductsWidget(
      String subCategoryId, TotalPriceBottomBar bottomBar) {
    return FutureBuilder(
      future: ApiController.getSubCategoryProducts(subCategoryId),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container();
        } else {
          if (projectSnap.hasData) {
            SubCategoryResponse response = projectSnap.data;
            if (response.success) {
              SubCategoryModel subCategory = response.subCategories.first;
              return ListView.builder(
                itemCount: subCategory.products.length,
                itemBuilder: (context, index) {
                  Product product = subCategory.products[index];
                  return Column(
                    children: <Widget>[
                      new ListTileItem(product, () {
                        bottomBar.state.updateTotalPrice();
                      }),
                    ],
                  );
                },
              );
            } else {
              return Container();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.black26,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)),
            );
          }
        }
      },
    );
  }
}

class ListTileItem extends StatefulWidget {
  final Product product;
  final VoidCallback callback;

  ListTileItem(this.product, this.callback);

  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  int counter = 0;

  @override
  initState() {
    super.initState();
    databaseHelper
        .getProductQuantitiy(int.parse(widget.product.id))
        .then((count) {
      counter = int.parse(count);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Row row;
    String discount = widget.product.variants[0].discount.toString();
    if (discount == "0.00" || discount == "0" || discount == "0.0") {
      row = new Row(
        children: <Widget>[
          Text("\$${widget.product.variants[0].price}"),
        ],
      );
    } else {
      row = new Row(
        children: <Widget>[
          Text("\$${widget.product.variants[0].discount}",
              style: TextStyle(decoration: TextDecoration.lineThrough)),
          Text(" "),
          Text("${widget.product.variants[0].price}"),
        ],
      );
    }

    return new ListTile(
      title: new Text(widget.product.title,
          style: new TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              color: Colors.deepOrange)),
      subtitle: row,
      leading: new Icon(
        Icons.favorite,
        color: Colors.grey,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          counter != 0
              ? IconButton(
                  icon: new Icon(Icons.remove),
                  onPressed: () {
                    setState(() => counter--);
                    if (counter == 0) {
                      // delete from cart table
                      removeFromCartTable(widget.product.id);
                    } else {
                      // insert/update to cart table
                      insertInCartTable(widget.product, counter);
                    }
                    widget.callback();
                  },
                )
              : new Container(),
          Text("$counter"),
          IconButton(
            icon: Icon(Icons.add),
            highlightColor: Colors.black,
            onPressed: () {
              setState(() => counter++);
              if (counter == 0) {
                // delete from cart table
                removeFromCartTable(widget.product.id);
              } else {
                // insert/update to cart table
                insertInCartTable(widget.product, counter);
              }
            },
          ),
        ],
      ),
    );
  }

  void insertInCartTable(Product subCatProducts, int quantity) {
    String id = subCatProducts.id;
    String variantsId = subCatProducts.variants[0].id;
    String productId = subCatProducts.id;
    String weight = subCatProducts.variants[0].weight;
    String mrpPrice = subCatProducts.variants[0].mrpPrice;
    String price = subCatProducts.variants[0].price;
    String discount = subCatProducts.variants[0].discount;
    String productQuantity = quantity.toString();
    String isTaxEnable = subCatProducts.isTaxEnable;
    String title = subCatProducts.title;
    var mId = int.parse(id);

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.ID: mId,
      DatabaseHelper.VARIENT_ID: variantsId,
      DatabaseHelper.PRODUCT_ID: productId,
      DatabaseHelper.WEIGHT: weight,
      DatabaseHelper.MRP_PRICE: mrpPrice,
      DatabaseHelper.PRICE: price,
      DatabaseHelper.DISCOUNT: discount,
      DatabaseHelper.QUANTITY: productQuantity,
      DatabaseHelper.IS_TAX_ENABLE: isTaxEnable,
      DatabaseHelper.Product_Name: title,
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

class TotalPriceBottomBar extends StatefulWidget {
  final _PriceBottomBarState state = new _PriceBottomBarState();

  @override
  _PriceBottomBarState createState() => state;
}

class _PriceBottomBarState extends State<TotalPriceBottomBar> {
  double totalPrice = 0.00;
  DatabaseHelper databaseHelper = new DatabaseHelper();
  bool firstTime = false;

  updateTotalPrice() {
    databaseHelper.getTotalPrice().then((mTotalPrice) {
      setState(() {
        totalPrice = mTotalPrice;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (firstTime == false) {
      databaseHelper.getTotalPrice().then((mTotalPrice) {
        firstTime = true;
        setState(() {
          totalPrice = mTotalPrice;
        });
      });
    }
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
                    if (totalPrice == 0.0) {
                      Utils.showToast(AppConstant.addItems, false);
                    } else {
                      goToMyCartScreen(context);
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Total",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 21)),
                      ),
                      Text(
                        "\$${databaseHelper.roundOffPrice(totalPrice, 2)}",
                        style: TextStyle(fontSize: 20),
                      ),
                      Expanded(child: SizedBox()),
                      new Expanded(
                        child: Text("Proceed To Order",
                            style: TextStyle(
                                fontSize: 15, backgroundColor: Colors.white)),
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

  void goToMyCartScreen(BuildContext _context) async {
    var result = await Navigator.push(
        _context,
        new MaterialPageRoute(
          builder: (BuildContext context) => new MyCart(context),
          fullscreenDialog: true,
        ));
    if (result == AppConstant.Refresh) {
      updateTotalPrice();
    }
  }
}
