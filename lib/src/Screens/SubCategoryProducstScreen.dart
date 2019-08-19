import 'package:flutter/material.dart';
import 'package:restroapp/src/models/Categories.dart';
import 'package:restroapp/src/models/SubCategories.dart';
import 'package:restroapp/src/networkhandler/ApiController.dart';

class SubCategoryProducstScreen extends StatelessWidget {

  CategoriesData categoriesData;

  SubCategoryProducstScreen(this.categoriesData);
  List<String> titles = [];
  List<Tab> tabs = new List();

  @override
  Widget build(BuildContext context) {
    //print("----- Tabs length----- ${categoriesData.subCategory.length}");
    if(categoriesData.subCategory.length == 1){
      //print("-ID's--${categoriesData.id}--Id=- ${categoriesData.subCategory[0].id}----");
      return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        debugShowCheckedModeBanner: false,
        home: ProductsListView(categoriesData),
      );
    }else{
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
                  //print(categoriesData.subCategory[index].title);
                  return getProductsWidget(categoriesData,categoriesData.subCategory[index].id);
                }),
              ),
            ),
          ),
        ),
      );
    }
  }
}

class ProductsListView extends StatelessWidget {

  CategoriesData categoriesData;

  ProductsListView(this.categoriesData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoriesData.title),
          centerTitle: true,
          leading: IconButton(icon:Icon(Icons.arrow_back),
            onPressed:() => Navigator.pop(context, false),
          )
      ),
      body: getProductsWidget(categoriesData, categoriesData.subCategory[0].id),
    );
  }
}

Widget getProductsWidget(CategoriesData categoriesData,String catId) {

  return FutureBuilder(
    future: ApiController.getSubCategoryProducts(categoriesData.id,catId),
    builder: (context, projectSnap) {
      if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
        //print('project snapshot data is: ${projectSnap.data}');
        return Container(color: const Color(0xFFFFE306));
      } else {
        if(projectSnap.hasData){
          //print('-------projectSnap.hasData---------------');
          return ListView.builder(
            itemCount: projectSnap.data.length,
            itemBuilder: (context, index) {
              Product subCatProducts = projectSnap.data[index];
              //print('-------ListView.builder---------');
              return Column(
                children: <Widget>[
                  new ListTileItem(subCatProducts),
                ],
              );
            },
          );
        }else {
          //print('-------CircularProgressIndicator----------');
          return Center(
            child: CircularProgressIndicator(
                backgroundColor: Colors.black26,
                valueColor:AlwaysStoppedAnimation<Color>(Colors.black26)),
          );
        }
      }
    },
  );
}


class ListTileItem extends StatefulWidget {

  Product subCatProducts;
  ListTileItem(this.subCatProducts);

  @override
  _ListTileItemState createState() => new _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    print("---_ListTileItemState-${counter}--");
    return new ListTile(
      title: new Text(widget.subCatProducts.title,style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 20.0, color:Colors.deepOrange)),
      subtitle: new Text("\$${widget.subCatProducts.variants[0].price}"),
      leading: new Icon(
        Icons.favorite, color: Colors.grey,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          counter != 0?
          IconButton(
            icon: new Icon(Icons.remove),
            onPressed: ()=> setState(()=> counter--),
          ):
          new Container(),
          Text("${counter}"),
          IconButton(
            icon: Icon(Icons.add),
            highlightColor: Colors.black,
            onPressed: () => setState(()=> counter++),
          ),
        ],
      ),
    );
  }

  void remove(){
    setState(() {
      counter--;
    });
  }

}

