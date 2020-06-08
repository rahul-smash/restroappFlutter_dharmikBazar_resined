import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restroapp/src/Screens/BookOrder/SubCategoryProductScreen.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

class CategoryView extends StatelessWidget {

  final CategoryModel categoryModel;
  StoreModel store;
  CategoryView(this.categoryModel, this.store);

  Widget build(BuildContext context) {
    return Container(
      width: Utils.getDeviceWidth(context),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              if(checkIfStoreClosed()){
                DialogUtils.displayCommonDialog(context, store.storeName, store.storeMsg);
              }else{
                if (categoryModel != null && categoryModel.subCategory.isNotEmpty) {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return SubCategoryProductScreen(categoryModel);
                    }),
                  );
                  Map<String,dynamic> attributeMap = new Map<String,dynamic>();
                  attributeMap["ScreenName"] = "${categoryModel.title}";
                  Utils.sendAnalyticsEvent("Clicked category",attributeMap);
                }
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              width: Utils.getDeviceWidth(context),
              height: 100.0,
              child: CachedNetworkImage(
                  imageUrl: "${categoryModel.image300200}",
                  width: Utils.getDeviceWidth(context),height: 100.0,
                  fit: BoxFit.cover
                //placeholder: (context, url) => CircularProgressIndicator(),
                //errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Center(
                child: Text(categoryModel.title,textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(color: Colors.black)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool checkIfStoreClosed(){
    if(store.storeStatus == "0"){
      //0 mean Store close
      return true;
    }else{
      return false;
    }
  }
}
