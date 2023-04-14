import 'package:flutter/material.dart';
import 'package:restroapp/src/UI/CartBottomView.dart';
import 'package:restroapp/src/UI/ProductTileView.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class SubCategoryProductScreen extends StatelessWidget {
  final CategoryModel categoryModel;
  bool isComingFromBaner;
  int index;
  final CartTotalPriceBottomBar bottomBar =
      CartTotalPriceBottomBar(ParentInfo.productList);

  SubCategoryProductScreen(
      this.categoryModel, this.isComingFromBaner, this.index);

  @override
  Widget build(BuildContext context) {
    //print("---subCategory.length--=${categoryModel.subCategory.length}");
    return DefaultTabController(
      length: categoryModel.subCategory.length,
      initialIndex: isComingFromBaner ? index : index,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(categoryModel.title),
            centerTitle: true,
          ),
          body: Column(children: <Widget>[
            TabBar(
              isScrollable: categoryModel.subCategory.length == 1 ? false : true,
              labelColor: Colors.black,
              unselectedLabelColor: grayColorTitle,
              indicatorColor:
                  categoryModel.subCategory.length == 1 ? appTheme : appThemeSecondary,
              indicatorWeight: 3,
              tabs: List.generate(categoryModel.subCategory.length, (int index) {
                bool isTabVisible;
                if (categoryModel.subCategory.length == 1) {
                  isTabVisible = false;
                } else {
                  isTabVisible = true;
                }
                return Visibility(
                  visible: isTabVisible,
                  child: Tab(
                    text: categoryModel.subCategory[index].title,
                  ),
                );
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
              //Check
              SubCategoryModel subCategory = SubCategoryModel();
//              SubCategoryModel subCategory =response.subCategories.first;
              for (int i = 0; i < response.subCategories.length; i++) {
                if (subCategoryId == response.subCategories[i].id) {
                  subCategory = response.subCategories[i];
                  break;
                }
              }
              if (subCategory.products == null) {
                return Container();
              }

              //print("products.length= ${subCategory.products.length}");
              if (subCategory.products.length == 0) {
                return Utils.getEmptyView2("No Products found!");
              } else {
                return ListView.builder(
                  itemCount: subCategory.products.length,
                  itemBuilder: (context, index) {
                    Product product = subCategory.products[index];
                    return ProductTileItem(product, () {
                      bottomBar.state.updateTotalPrice();
                    }, ClassType.SubCategory);
                  },
                );
              }
            } else {
              //print("no products.length=");
              return Utils.getEmptyView2(AppConstant.noInternet);
//                return Utils.getEmptyView2("No Products found!");
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
