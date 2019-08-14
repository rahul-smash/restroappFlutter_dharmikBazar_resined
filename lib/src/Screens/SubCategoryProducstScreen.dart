import 'package:flutter/material.dart';
import 'package:restroapp/src/models/Categories.dart';
import 'package:restroapp/src/networkhandler/ApiController.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubCategoryProducstScreen extends StatelessWidget {

  CategoriesData categoriesData;

  SubCategoryProducstScreen(this.categoriesData);
  List<String> titles = [];
  List<Tab> tabs = new List();

  @override
  Widget build(BuildContext context) {

    for (int i = 0; i< categoriesData.subCategory.length; i++) {
      tabs.add(new Tab(text: categoriesData.subCategory[i].title));
    }

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: Container(
        child: DefaultTabController(length: categoriesData.subCategory.length,
            child: Scaffold(
                appBar: AppBar(
                  title: Text(categoriesData.title),
                  centerTitle: true,
                    bottom:TabBar(
                      tabs: tabs,
                    ),
                    leading: IconButton(icon:Icon(Icons.arrow_back),
                      onPressed:() => Navigator.pop(context, false),
                    )
                ),
              body: TabBarView(
                children: new List.generate(categoriesData.subCategory.length, (int index){

                  print(categoriesData.subCategory[index].title);
                  print(index);

                  openSubCategories(categoriesData,categoriesData.subCategory[index].id);

                  return new ListTile(
                    title: new Text(categoriesData.subCategory[index].title,
                    style: new TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
                    subtitle: new Text(categoriesData.subCategory[index].id),
                    leading: new Icon(
                      Icons.theaters,
                      color: Colors.blue[500],
                    ),
                  );
                }),
              ),
            ),
        ),
      ),
    );
  }
}

Future openSubCategories(CategoriesData categoriesData,String catId) async {
  print("subCategory.length ${categoriesData.subCategory.length}");
  if(categoriesData != null && categoriesData.subCategory.isNotEmpty) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String deviceId = prefs.getString(AppConstant.DEVICE_ID);

    ApiController.getSubCategoryProducts(categoriesData.id, catId, deviceId);
    if (categoriesData.subCategory.length == 1) {
      // call products api if only one category
    } else {
      // call sub category API

    }

  }

}
