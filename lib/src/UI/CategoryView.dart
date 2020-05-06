import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/BookOrder/SubCategoryProductScreen.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';

class CategoryView extends StatelessWidget {
  final CategoryModel categoryModel;
  CategoryView(this.categoryModel);

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (categoryModel != null && categoryModel.subCategory.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SubCategoryProductScreen(categoryModel);
                }),
              );
            }
          },
          child: Container(
            width: 100.0,
            height: 100.0,
            decoration: new BoxDecoration(
              color: Colors.white,
              image: new DecorationImage(
                image: new NetworkImage(categoryModel.image300200),
                fit: BoxFit.cover,
              ),
              borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
              border: new Border.all(
                color: appTheme,
                width: 2.0,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          child: Text(
            categoryModel.title,
            maxLines: 1,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
