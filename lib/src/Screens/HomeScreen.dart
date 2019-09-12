import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/Categories.dart';
import 'package:restroapp/src/models/StoreData.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restroapp/src/ui/CategoriesView.dart';
import 'package:restroapp/src/utils/Constants.dart';

class HomeScreen extends StatelessWidget {

  StoreData storeData;
  HomeScreen(this.storeData);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        body: HomeScreenUI(storeData),
      ),
    );
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
      enlargeCenterPage: false,
      items: imgList.map(
        (url) {
          return Container(
            margin: EdgeInsets.all(0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(0.0)),
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
        print("_currentIndex ${_currentIndex}");
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(storeData.store.storeName),
        centerTitle: true,
      ),
      body: Container(
          child : Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 0.0),
                  child: Column(children: [
                    storeBanners,
                  ])),
              Expanded(
                child: FutureBuilder<List<CategoriesData>>(
                  future: ApiController.getCategoriesApiRequest(storeData.store.id), // a previously-obtained Future<String> or null
                    builder: (context, projectSnap) {
                      if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
                        //print('project snapshot data is: ${projectSnap.data}');
                        return Container(color: const Color(0xFFFFE306));
                      } else {
                        if(projectSnap.hasData){

                          //print('------Master-Categories---------: ${projectSnap.data.length}');

                          return Container(
                            margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                            padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                              decoration: BoxDecoration(
                                border: new Border.all(color: Colors.deepOrange),
                                image: DecorationImage(
                                  image: AssetImage("images/categories_bg.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            child: GridView.count(
                                crossAxisCount: 2,
                                childAspectRatio: 1.3,
                                padding: const EdgeInsets.all(14.0),
                                mainAxisSpacing: 4.0,
                                crossAxisSpacing: 4.0,
                                shrinkWrap: true,
                                children: projectSnap.data.map((CategoriesData categoriesData) {

                                  return GridTile(child: CategoriesView(categoriesData));
                                }).toList()
                            ),
                          );
                          //return projectSnap.data.toString();

                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.black26,
                                valueColor:AlwaysStoppedAnimation<Color>(Colors.black26)),
                          );
                        }
                      }
                    }
                ),
              ),
            ],
          ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // new
        backgroundColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        items: [
          new BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              title: Text('Cart', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red),

          new BottomNavigationBarItem(
            icon: Icon(Icons.local_offer, color: Colors.white),
            title: Text('Offers', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),

          new BottomNavigationBarItem(
              icon: Icon(Icons.history, color: Colors.white),
              title: Text('History', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.red),

          new BottomNavigationBarItem(
              icon: Icon(Icons.contact_mail, color: Colors.white),
              title: Text('Contact', style: TextStyle(color: Colors.white)),
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
              decoration: BoxDecoration(color: Colors.deepOrange),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('My Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Delivery Address'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('My Orders'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Book Now'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('My Favorites'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('About Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Refer & Earn'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
    );
  }
}
