import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restroapp/src/Screens/BookOrder/SubCategoryProductScreen.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';

class CategoryView extends StatelessWidget {
  final CategoryModel categoryModel;
  CategoryView(this.categoryModel);

  Widget build(BuildContext context) {
    return Container(
      width: Utils.getDeviceWidth(context),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              if (categoryModel != null && categoryModel.subCategory.isNotEmpty) {
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                    return SubCategoryProductScreen(categoryModel);
                  }),
                );
              }
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(5, 5, 5, 0),
              width: Utils.getDeviceWidth(context),
              height: 100.0,
              child: Image.network('${categoryModel.image300200}',
                width: Utils.getDeviceWidth(context),height: 100.0,
                fit: BoxFit.cover,
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
}
