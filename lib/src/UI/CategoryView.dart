import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/SubCategoryProducstScreen.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';

class CategoriesView extends StatelessWidget {

  @required
  CategoryModel categoryModel;

  CategoriesView(this.categoryModel);

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if(categoryModel != null && categoryModel.subCategory.isNotEmpty){
              Navigator.push(context, MaterialPageRoute(builder: (context) => SubCategoryProducstScreen(categoryModel)),);
            }
          },
          child: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(categoryModel.image300200),
          ),
        ),

        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
          child: Text(
            categoryModel.title,
            maxLines: 1,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}



