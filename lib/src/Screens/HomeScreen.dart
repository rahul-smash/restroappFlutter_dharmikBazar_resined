import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/AboutScreen.dart';
import 'package:restroapp/src/Screens/AddDeliveryAddressScreen.dart';
import 'package:restroapp/src/Screens/BookNowScreen.dart';
import 'package:restroapp/src/Screens/ContactScreen.dart';
import 'package:restroapp/src/Screens/LoginScreen.dart';
import 'package:restroapp/src/Screens/MyCartScreen.dart';
import 'package:restroapp/src/Screens/OfferScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/Categories.dart';
import 'package:restroapp/src/models/StoreData.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restroapp/src/ui/CategoriesView.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ProfileScreen.dart';
import 'RegisterScreen.dart';

class HomeScreen extends StatelessWidget {

  StoreData storeData;
  HomeScreen(this.storeData);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: HomeScreenUI(storeData),
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
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _counter =0;
  int _currentIndex = 0;
  StoreData storeData;
  _StoreListWithSearch(this.storeData);
  String userName = "";
  String loginText = "";

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
        if(_currentIndex == 0){

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCart(context)),
          );
        }
        if(_currentIndex == 1){

          print('_offers------');
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => OfferScreen(context)),
          );
          /*Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OfferScreen()),
          );*/
        }
        if(_currentIndex == 2){

          print('_offers------');
        }
        if(_currentIndex == 3) {
          print('_contact------');

          Navigator.push(context,
            MaterialPageRoute(builder: (context) => ContactScreen(context)),
          );
        }
      });
    }

    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(storeData.store.storeName),
        centerTitle: true,
        leading: new IconButton(icon: new Icon(
            Icons.menu
        ),onPressed:_handleDrawer,),
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
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              accountName: Text('Welcome'),
              accountEmail: Text(userName),
              currentAccountPicture:
                  Image.asset("images/ic_launcher.png"),
              //Image.network('https://winaero.com/blog/wp-content/uploads/2015/05/windows-10-user-account-login-icon.png'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('My Profile'),
              onTap: () {
                print('My Profile----');
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              //  Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Delivery Address'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddDeliveryAddress()),
                );

              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('My Orders'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Book Now'),
              onTap: () {
                print('--Book_Now--');

                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookNowScreen(context)),
                );

               // Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('My Favorites'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_box),
              title: Text('About Us'),
              onTap: () {
               // Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen(context)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Refer & Earn'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text(loginText),
              onTap: () {
                if(loginText == "Logout"){
                  print("Logout");
                  _showDialog();
                }else{
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }

              },
            ),

          ],
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logout"),
          content: new Text("Are you sure you want to Logout?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: const Text('YES'),
              onPressed: () {
                Navigator.of(context).pop();
                logout();
              },
            ),
          ],
        );
      },
    );
  }

  _handleDrawer() async{
    _key.currentState.openDrawer();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(()  {
      ///DO MY Logic CALLS
      _counter++;

      userName = prefs.getString(AppConstant.USER_NAME);
      if(userName == null){
        userName = "";
      }
      String userId = prefs.getString(AppConstant.USER_ID);
      if(userId == null || userId.isEmpty){
        loginText = "Login";
      }else{
        loginText = "Logout";
      }

    });
  }

  Future logout() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear().then((status){
        if(status == true){

          DatabaseHelper databaseHelper = new DatabaseHelper();
          databaseHelper.deleteTable(DatabaseHelper.Categories_Table);
          databaseHelper.deleteTable(DatabaseHelper.Sub_Categories_Table);
          databaseHelper.deleteTable(DatabaseHelper.Products_Table);
          databaseHelper.deleteTable(DatabaseHelper.CART_Table);

          Utils.showToast("You have logged out successfully", true);

          SharedPrefs.storeSharedValue(AppConstant.STORE_ID, storeData.store.id);

          Utils.getDeviceId();
        }
      });

      Navigator.pop(context);
    } catch (e) {
      print(e);
    }

  }

}
