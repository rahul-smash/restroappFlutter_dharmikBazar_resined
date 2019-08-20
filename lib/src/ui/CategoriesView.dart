import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/SubCategoryProducstScreen.dart';
import 'package:restroapp/src/models/Categories.dart';

class CategoriesView extends StatelessWidget {

  @required
  CategoriesData categoriesData;

  CategoriesView(this.categoriesData);

  Widget build(BuildContext context) {


    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              //do what you want here
              //print("cat click ${categoriesData.id}");
              //print("subCategory.length ${categoriesData.subCategory.length}");
              if(categoriesData != null && categoriesData.subCategory.isNotEmpty){
                Navigator.push(context, MaterialPageRoute(builder: (context) => SubCategoryProducstScreen(categoriesData)),);
              }
            },
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(categoriesData.image300200),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            child: Text(
              categoriesData.title,
              maxLines: 1,
              softWrap: true,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}



