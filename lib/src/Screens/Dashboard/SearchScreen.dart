import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:restroapp/src/UI/CartBottomView.dart';
import 'package:restroapp/src/UI/ProductTileView.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/SearchTagsModel.dart';
import 'package:restroapp/src/models/SubCategoryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/BaseState.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:flutter_tags/flutter_tags.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() {
    return _SearchScreenState();
  }
}

class _SearchScreenState extends BaseState<SearchScreen> {
  TextEditingController controller = TextEditingController();
  int selctedTag;
  List<String> tagsList = List();
  List<SubCategoryModel> subCategoryList = List();
  SubCategoryModel subCategory;
  List<Product> productsList = List();
  CartTotalPriceBottomBar bottomBar =
      CartTotalPriceBottomBar(ParentInfo.searchList);
  bool isSearchEmpty;

  ScrollController _scrollController;
  GlobalKey tagskey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selctedTag = -1;
    isSearchEmpty = true;
    ApiController.searchTagsAPI().then((respons) {
      SearchTagsModel response = respons;
      setState(() {
        tagsList = response.data;
      });
    });
    _scrollController = ScrollController();
    tagskey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //return a `Future` with false value so this route cant be popped or closed.
        Navigator.pop(context, false);
        return new Future(() {
          return false;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Search"),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: 40,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              //padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: searchGrayColor,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(
                    color: searchGrayColor,
                  )),
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                child: Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.search,
                              color: appTheme,
                            ),
                            onPressed: () {
                              if (controller.text.trim().isEmpty) {
                                Utils.showToast(
                                    "Please enter some valid keyword",
                                    false);
                              } else {
                                selctedTag = -1;
                                callSearchAPI();
                              }
                            }),
                        Flexible(
                          child: TextField(
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              if (value.trim().isEmpty) {
                                Utils.showToast(
                                    "Please enter some valid keyword",
                                    false);
                              } else {
                                selctedTag = -1;
                                callSearchAPI();
                              }
                            },
                            onChanged: (text) {
                              print("onChanged ${text}");
                              if (text.trim().isEmpty) {
                                isSearchEmpty = true;
                              } else {
                                isSearchEmpty = false;
                              }
                              setState(() {});
                            },
                            controller: controller,
                            cursorColor: Colors.black,
                            keyboardType: TextInputType.text,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Search"),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: appTheme,
                            ),
                            onPressed: () {
                              setState(() {
                                controller.text = "";
                                setState(() {
                                  subCategory = null;
                                  productsList.clear();
                                });
                              });
                            }),
                      ]),
                ),
              ),
            ),
            Expanded(child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: _scrollController,
              child: Container(
                child: Column(
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: showTagsList(),
                    ),
                    Container(
                      key: tagskey,
                    ),
                    productsList.length == 0
                        ? Utils.getEmptyView2("")
                        : ListView.builder(
//                  controller: _scrollController,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: productsList.length,
                      itemBuilder: (context, index) {
                        Product product = productsList[index];
                        return ProductTileItem(product, () {
                          bottomBar.state.updateTotalPrice();
                        }, ClassType.Search);
                      },
                    ),
                  ],
                ),
              ),
            ),)

          ],
        ),
        bottomNavigationBar: bottomBar,
      ),
    );
  }

  Widget showTagsList() {
    Color chipSelectedColor, textColor;
    print("---selctedTag-${selctedTag}---");
    Widget horizontalList = new Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
      //height: 150.0,
      child: Tags(
        itemCount: tagsList.length,
        alignment: WrapAlignment.start,
        //horizontalScroll: true,
        itemBuilder: (int index) {
          String tagName = tagsList[index];
          return ItemTags(
            key: Key(index.toString()),
            index: index,
            elevation: 0.0,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
              width: 1,
              color: favGrayColor,
            ),
            color: favGrayColor,
            activeColor: searchTagsColor,
            textActiveColor: Colors.white,
            singleItem: true,
            splashColor: Colors.green,
            combine: ItemTagsCombine.withTextBefore,
            title: tagName,
            onPressed: (item) {
              setState(() {
                selctedTag = index;
                //print("selctedTag= ${tagsList[selctedTag]}");
                controller.text = tagsList[selctedTag];
                callSearchAPI();
              });
            },
          );
        },
      ),
    );
    return horizontalList;
  }

  void callSearchAPI() {
    Utils.hideKeyboard(context);
    Utils.isNetworkAvailable().then((isNetworkAvailable) async {
      if (isNetworkAvailable) {
        Utils.sendSearchAnalyticsEvent(controller.text);
        Utils.showProgressDialog(context);
        SubCategoryResponse subCategoryResponse =
            await ApiController.getSearchResults(controller.text);
        Utils.hideKeyboard(context);
        Utils.hideProgressDialog(context);
        if (subCategoryResponse == null ||
            subCategoryResponse.subCategories.isEmpty) {
          Utils.showToast("No result found.", false);
          setState(() {
            subCategory = null;
          });
        } else {
          //print("==subCategories= ${subCategoryResponse.subCategories.length}");
          setState(() {
            subCategoryList = subCategoryResponse.subCategories;
            productsList.clear();
            for (int i = 0; i < subCategoryList.length; i++) {
              productsList.addAll(subCategoryList[i].products);
            }
//            RenderBox box = tagskey.currentContext.findRenderObject();
//            Offset position =
//                box.localToGlobal(Offset.zero); //this is global position
//            double y = position.dy;
////            if(productsList.length>1)
//            y = y - 200;
//            _scrollController.animateTo(y,
//                duration: Duration(milliseconds: 120), curve: Curves.ease);
          });
        }
      } else {
        Utils.showToast(AppConstant.noInternet, false);
      }
    });
  }
}
