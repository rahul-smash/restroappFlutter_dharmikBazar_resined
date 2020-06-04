
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
  SubCategoryModel subCategory;
  CartTotalPriceBottomBar bottomBar =
  CartTotalPriceBottomBar(ParentInfo.searchList);
  bool isSearchEmpty;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selctedTag = -1;
    isSearchEmpty = true;
    ApiController.searchTagsAPI().then((respons){
      SearchTagsModel response = respons;
      setState(() {
        tagsList = response.data;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        //return a `Future` with false value so this route cant be popped or closed.
        Navigator.pop(context,false);
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
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                //padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: searchGrayColor,
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0)),
                    border: Border.all(color: searchGrayColor,)
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: Icon(Icons.search,color: appTheme,),
                              onPressed: () {
                                if(controller.text.trim().isEmpty){
                                  Utils.showToast("Please enter some valid keyword", false);
                                }else{
                                  selctedTag = -1;
                                  callSearchAPI();
                                }
                              }),
                          Flexible(
                            child: TextField(
                              textInputAction: TextInputAction.search,
                              onSubmitted: (value) {
                                if(value.trim().isEmpty){
                                  Utils.showToast("Please enter some valid keyword", false);
                                }else{
                                  selctedTag = -1;
                                  callSearchAPI();
                                }
                              },
                              onChanged: (text){
                                print("onChanged ${text}");
                                if(text.trim().isEmpty){
                                  isSearchEmpty = true;
                                }else{
                                  isSearchEmpty = false;
                                }
                                setState(() {
                                });
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
                              icon: Icon(Icons.clear,color: appTheme,),
                              onPressed: () {
                                setState(() {
                                  controller.text = "";
                                  setState(() {
                                    subCategory = null;
                                  });
                                });
                              }),
                        ]
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: showTagsList(),
              ),
              Expanded(
                child: subCategory == null ? Utils.getEmptyView2("")
                    : ListView.builder(
                  itemCount: subCategory.products.length,
                  itemBuilder: (context, index) {
                    Product product = subCategory.products[index];
                    return ProductTileItem(product, () {
                      bottomBar.state.updateTotalPrice();
                    },ClassType.Search);
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomBar,
      ),
    );
  }

  Widget showTagsList(){
    Color chipSelectedColor, textColor;
    print("---selctedTag-${selctedTag}---");
    Widget horizontalList = new Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        //height: 150.0,
        child: Tags(
          itemCount: tagsList.length,
          alignment: WrapAlignment.start,
          //horizontalScroll: true,
          itemBuilder: (int index){
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
              onPressed: (item){
                setState(() {
                  selctedTag = index;
                  //print("selctedTag= ${tagsList[selctedTag]}");
                  controller.text = tagsList[selctedTag];
                  callSearchAPI();
                });
              },
            );
          },
        ) ,
        /*child: ListView.builder(
          itemCount: tagsList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            String tagName = tagsList[index];
            if(selctedTag == index){
              chipSelectedColor = appTheme;
              textColor = Color(0xFFFFFFFF);
            }else{
              chipSelectedColor = Color(0xFFBDBDBD);
              textColor = Color(0xFF000000);
            }
            return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: InkWell(
                onTap: (){
                  setState(() {
                    selctedTag = index;
                    //print("selctedTag= ${tagsList[selctedTag]}");
                    controller.text = tagsList[selctedTag];
                    callSearchAPI();
                  });
                },
                child: Chip(
                  autofocus: true,
                  label: Text('${tagName}',style: TextStyle(color: textColor),),
                  backgroundColor: chipSelectedColor,
                ),
              ),
            );
          },
        )*/
    );
    return horizontalList;
  }


  void callSearchAPI(){
    Utils.hideKeyboard(context);
    Utils.isNetworkAvailable().then((isNetworkAvailable) async {
      if(isNetworkAvailable){
        Utils.showProgressDialog(context);
        SubCategoryResponse subCategoryResponse =
        await ApiController.getSearchResults(controller.text);
        Utils.hideKeyboard(context);
        Utils.hideProgressDialog(context);
        print("==subCategories= ${subCategoryResponse.subCategories.length}");
        if(subCategoryResponse == null || subCategoryResponse.subCategories.isEmpty){
          Utils.showToast("No result found.", false);
          setState(() {
            subCategory = null;
          });
        }else{
          setState(() {
            subCategory = subCategoryResponse.subCategories.first;
          });
        }
      } else{
        Utils.showToast(AppConstant.noInternet, false);
      }
    });
  }

}