import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/AddDeliveryAddressScreen.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/CartData.dart';

class MyCart extends StatelessWidget {

  ProceedBottomBar proceedBottomBar = new ProceedBottomBar();
  DatabaseHelper databaseHelper = new DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
            title: Text("My Cart"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context, false),
            )),
        body: Column(
          children: <Widget>[
            Divider(color: Colors.white, height: 2.0),
            FutureBuilder(
              future: databaseHelper.getCartItemList(),
              builder: (context, projectSnap) {
                if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
                  //print('project snapshot data is: ${projectSnap.data}');
                  return Container(color: const Color(0xFFFFE306));
                } else {
                  if(projectSnap.hasData){
                    print('---projectSnap.Data-length-${projectSnap.data.length}---');
                    //List<CartProductData> cartList = projectSnap.data;
                    //return Text("Done ${cartList.length}");
                    return ListView.builder(
                      shrinkWrap: true, //Your Column doesn't know how much height it will take. use this
                      itemCount: projectSnap.data.length,
                      itemBuilder: (context, index) {
                        CartProductData cartProductData = projectSnap.data[index];
                        //print('-------ListView.builder-----${index}');
                        return Column(
                          children: <Widget>[
                            new ListTileItem(cartProductData),
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
            ),
          ],
        ),
        bottomNavigationBar: proceedBottomBar,
      ),
    );
  }
}


//============================Cart List Item widget=====================================
class ListTileItem extends StatefulWidget {

  CartProductData cartProductData;
  ListTileItem(this.cartProductData);

  @override
  _ListTileItemState createState() => new _ListTileItemState();
}
//============================Cart List Item State=====================================
class _ListTileItemState extends State<ListTileItem> {

  int counter = 0;

  @override
  initState() {
    super.initState();
    //print("---initState initState----initState-");
  }

  @override
  Widget build(BuildContext context) {
    //print("---_Widget build--${widget.subCatProducts.title}-and discount-${widget.subCatProducts.variants[0].discount}");
    Row row;
    String discount = widget.cartProductData.discount;
    if(discount == "0.00" || discount == "0" || discount == "0.0"){
      row = new Row(
        children: <Widget>[
          Text("\$${widget.cartProductData.price}"),
        ],
      );
    }else{
      row = new Row(
        children: <Widget>[
          Text("\$${widget.cartProductData.discount}", style: TextStyle(decoration: TextDecoration.lineThrough)),
          Text(" "),
          Text("${widget.cartProductData.price}"),
        ],
      );
    }

    return new ListTile(
      title: new Text(widget.cartProductData.product_name,style: new TextStyle(fontWeight: FontWeight.w500,fontSize: 20.0, color:Colors.deepOrange)),
      //subtitle: new Text("\$${widget.subCatProducts.variants[0].price}"),
      subtitle: row,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          counter != 0?IconButton(icon: new Icon(Icons.remove),
            //onPressed: ()=> setState(()=> counter--),
            onPressed: (){
              setState(()=> counter--);
              //print("--remove-onPressed-${counter}--");
            },
          ):new Container(),

          Text("${counter}"),

          IconButton(icon: Icon(Icons.add),
            highlightColor: Colors.black,
            onPressed: (){
              setState(()=> counter++);
              //print("--add-onPressed-${counter}--");

            },
          ),
        ],
      ),
    );
  }

}

class ProceedBottomBar extends StatefulWidget {
  final _ProceedBottomBarState state = new _ProceedBottomBarState();

  @override
  _ProceedBottomBarState createState() => state;
}

class _ProceedBottomBarState extends State<ProceedBottomBar> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 50.0,
      color: Colors.deepOrange,
      child: InkWell(
        onTap: () {
          //print("on click message");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDeliveryAddress()),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Proceed",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ],
        ),
      ),

    );
  }
}