import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/ContactScreen.dart';
import 'package:restroapp/src/Screens/MyCartScreen.dart';
import 'package:restroapp/src/Screens/MyOrderScreen.dart';
import 'package:restroapp/src/Screens/OfferScreen.dart';
import 'package:restroapp/src/Screens/SideMenu.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restroapp/src/ui/CategoryView.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final StoreModel store;
  HomeScreen(this.store);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState(this.store);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final StoreModel store;

  List<String> imgList = [];
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  String userName;

  _HomeScreenState(this.store);

  @override
  void initState() {
    super.initState();
    try {
      if (store.banners.isEmpty) {
        imgList = [
          AppConstant.PLACEHOLDER,
          AppConstant.PLACEHOLDER,
          AppConstant.PLACEHOLDER
        ];
      } else {
        for (var i = 0; i < store.banners.length; i++) {
          String imageUrl = store.banners[i].image;
          imgList.add(imageUrl.isEmpty ? AppConstant.PLACEHOLDER : imageUrl);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(store.storeName),
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.menu),
          onPressed: _handleDrawer,
        ),
      ),
      body: Column(
        children: <Widget>[
          addBanners(),
          Expanded(
            child: FutureBuilder<CategoryResponse>(
                future: ApiController.getCategoriesApiRequest(store.id),
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.none &&
                      projectSnap.hasData == null) {
                    return Container();
                  } else {
                    if (projectSnap.hasData) {
                      CategoryResponse response = projectSnap.data;
                      if (response.success) {
                        return Container(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
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
                              children: response.categories
                                  .map((CategoryModel model) {
                                return GridTile(child: CategoryView(model));
                              }).toList()),
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.black26,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black26)),
                      );
                    }
                  }
                }),
          ),
        ],
      ),
      drawer: SideMenuScreen(store, userName),
      bottomNavigationBar: addBottomBar(),
    );
  }

  Widget addBanners() {
    return CarouselSlider(
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
  }

  Widget addBottomBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      // new
      backgroundColor: Colors.red,
      type: BottomNavigationBarType.fixed,
      onTap: onTabTapped,
      // new
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
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyCart(context)),
        );
      }
      if (_currentIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OfferScreen(context)),
        );
      }
      if (_currentIndex == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyOrderScreen(context)),
        );
      }
      if (_currentIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactScreen()),
        );
      }
    });
  }

  _handleDrawer() async {
    _key.currentState.openDrawer();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userName = prefs.getString(AppConstant.USER_NAME);
    });
  }
}
