import 'package:flutter/material.dart';
import 'package:restroapp/src/UI/CartBottomView.dart';
import 'package:restroapp/src/UI/ProductTileView.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';

class SubCategoryProductScreen extends StatelessWidget {
  final CategoryModel categoryModel;
  SubCategoryProductScreen(this.categoryModel);

  final CartTotalPriceBottomBar bottomBar =
      CartTotalPriceBottomBar(ParentInfo.productList);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categoryModel.subCategory.length,
      child: Scaffold(
        appBar: AppBar(
            title: Text(categoryModel.title),
            centerTitle: true,
        ),
        body: Column(children: <Widget>[
          TabBar(
            labelColor: appTheme,
            unselectedLabelColor: Colors.black,
            indicatorColor: appTheme,
            indicatorWeight: 3,
            tabs: List.generate(categoryModel.subCategory.length, (int index) {
              return Tab(text: categoryModel.subCategory[index].title);
            }),
          ),
          Expanded(
              child: TabBarView(
            children:
                List.generate(categoryModel.subCategory.length, (int index) {
              return getProductsWidget(categoryModel.subCategory[index].id);
            }),
          ))
        ]),
        bottomNavigationBar: bottomBar,
      ),
    );
  }

  Widget getProductsWidget(String subCategoryId) {
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
                  return ProductTileItem(product, () {
                    bottomBar.state.updateTotalPrice();
                  });
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
