import 'package:flutter/material.dart';
import 'package:restroapp/src/models/StoreData.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restroapp/src/utils/Constants.dart';

class HomeScreen extends StatelessWidget{

  StoreData storeData;

  HomeScreen(this.storeData);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: storeData.store.storeName,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        body: HomeScreenUI(storeData),
      ),
    );;
  }
}

class HomeScreenUI extends StatefulWidget {

  StoreData storeData;
  HomeScreenUI(this.storeData);

  @override
  State<StatefulWidget> createState() {
    print("---------HomeScreenUI HomeScreenUI---------");

    return _StoreListWithSearch(storeData);
  }
}

class _StoreListWithSearch extends State<HomeScreenUI>{

  final List<String> imgList = [];

  StoreData storeData;
  _StoreListWithSearch(this.storeData);

  @override
  void initState() {
    //print("------------ initState---------------");
    for (var i = 0; i < storeData.store.banners.length; i++){
      String imageUrl = storeData.store.banners[i].image;
      if(imageUrl.isEmpty){
        imgList.add(AppConstant.PLACEHOLDER);
      }else{
        imgList.add(imageUrl);
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    //Auto playing carousel
    //print("------Widget build---------");
    final CarouselSlider autoPlayDemo = CarouselSlider(
      viewportFraction: 0.9,
      aspectRatio: 2.0,
      autoPlay: true,
      enlargeCenterPage: true,
      items: imgList.map(
            (url) {
          return Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Image.network(
                url,
                fit: BoxFit.cover,
                width: 1000.0,
              ),
            ),
          );
        },
      ).toList(),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(storeData.store.storeName),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: Column(children: [
                autoPlayDemo,
              ]))
        ],
      ),
    );
  }


}
