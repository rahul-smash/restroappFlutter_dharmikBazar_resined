
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
  CartTotalPriceBottomBar(ParentInfo.productList);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selctedTag = -1;
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
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: appTheme)
                ),
                child: ListTile(
                  title: TextField(
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      if(value.trim().isEmpty){
                        Utils.showToast("Please enter some valid keyword", false);
                      }else{
                        selctedTag = -1;
                        callSearchAPI();
                      }
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
                  trailing: IconButton(icon: Icon(Icons.search,color: appTheme,),
                      onPressed: () {
                        if(controller.text.trim().isEmpty){
                          Utils.showToast("Please enter some valid keyword", false);
                        }else{
                          selctedTag = -1;
                          callSearchAPI();
                        }
                      }),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: showTagsList(),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFFBDBDBD)
              ),
              Expanded(
                child: subCategory == null ? Utils.getEmptyView2("No data found!")
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
        height: 50.0,
        child: ListView.builder(
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
        )
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