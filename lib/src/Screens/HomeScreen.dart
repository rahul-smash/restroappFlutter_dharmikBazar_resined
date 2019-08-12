import 'package:flutter/material.dart';
import 'package:restroapp/src/models/StoreData.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restroapp/src/utils/Constants.dart';

class HomeScreen extends StatelessWidget {
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
    );
    ;
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

class _StoreListWithSearch extends State<HomeScreenUI> {

  final List<String> imgList = [];
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green)
  ];
  StoreData storeData;
  _StoreListWithSearch(this.storeData);

  @override
  void initState() {
    //print("------------ initState---------------");
    try {
      if (storeData.store.banners.isEmpty) {
        imgList.add(AppConstant.PLACEHOLDER);
        imgList.add(AppConstant.PLACEHOLDER);
        imgList.add(AppConstant.PLACEHOLDER);
      } else {
        for (var i = 0; i < storeData.store.banners.length; i++) {
          String imageUrl = storeData.store.banners[i].image;
          if (imageUrl.isEmpty) {
            imgList.add(AppConstant.PLACEHOLDER);
          } else {
            imgList.add(imageUrl);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //Auto playing carousel
    //print("------Widget build---------");
    final CarouselSlider storeBanners = CarouselSlider(
      viewportFraction: 0.9,
      aspectRatio: 2.0,
      autoPlay: true,
      enlargeCenterPage: true,
      items: imgList.map(
        (url) {
          return Container(
            margin: EdgeInsets.all(3.0),
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

    void onTabTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(storeData.store.storeName),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: Column(children: [
                storeBanners,
              ]))
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // new
        backgroundColor: Colors.red,
        onTap: onTabTapped, // new
        items: [
          new BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Cart'),
              backgroundColor: Colors.red),
          new BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            title: Text('Offers'),
            backgroundColor: Colors.red,
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('History'),
              backgroundColor: Colors.red),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Contact'),
              backgroundColor: Colors.red)
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[

            UserAccountsDrawerHeader(
              accountName: Text('Achin verma'),
              accountEmail: Text('achin@signity.com'),
              currentAccountPicture:
              Image.network('https://winaero.com/blog/wp-content/uploads/2015/05/windows-10-user-account-login-icon.png'),
              decoration: BoxDecoration(color: Colors.blueAccent),
            ),


            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Home'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('My Profile'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
