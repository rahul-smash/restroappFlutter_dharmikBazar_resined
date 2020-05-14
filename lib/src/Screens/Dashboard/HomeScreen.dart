import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restroapp/src/Screens/Dashboard/ContactScreen.dart';
import 'package:restroapp/src/Screens/BookOrder/MyCartScreen.dart';
import 'package:restroapp/src/Screens/Offers/MyOrderScreen.dart';
import 'package:restroapp/src/Screens/Offers/OfferScreen.dart';
import 'package:restroapp/src/Screens/SideMenu/SideMenu.dart';
import 'package:restroapp/src/UI/CategoryView.dart';
import 'package:restroapp/src/UI/DragMarkerMap.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:restroapp/src/utils/version_check.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class HomeScreen extends StatefulWidget {
  final StoreModel store;
  HomeScreen(this.store);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState(this.store);
  }
}

class _HomeScreenState extends State<HomeScreen> {

  StoreModel store;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  List<NetworkImage> imgList = [];
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  UserModel user;

  _HomeScreenState(this.store);

  @override
  void initState() {
    super.initState();
    initFirebase();
    try {
      print("-----store.banners-----${store.banners.length}------");
      if (store.banners.isEmpty) {
        imgList = [
          NetworkImage(AppConstant.placeholderImageUrl),
          NetworkImage(AppConstant.placeholderImageUrl),
          NetworkImage(AppConstant.placeholderImageUrl),
        ];
      } else {
        for (var i = 0; i < store.banners.length; i++) {
          String imageUrl = store.banners[i].image;
          imgList.add(NetworkImage(imageUrl.isEmpty ? AppConstant.placeholderImageUrl : imageUrl),);
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
          icon: Image.asset('images/hamburger.png', width: 25),
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
                          padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                          color: Colors.white,
                          child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 1.3,
                              padding: const EdgeInsets.all(14.0),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                              shrinkWrap: true,
                              children: response.categories
                                  .map((CategoryModel model) {
                                return GridTile(
                                    child: CategoryView(model)
                                );
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
      drawer: NavDrawerMenu(store, user == null ? null : user.fullName),
      bottomNavigationBar: addBottomBar(),
    );
  }
  Widget addBanners() {

    return Stack(
      children: <Widget>[
        Center(
          child: SizedBox(
            height: 220.0,
            width: Utils.getDeviceWidth(context),
            child: Carousel(
              boxFit: BoxFit.cover,
              autoplay: true,
              animationCurve: Curves.fastOutSlowIn,
              animationDuration: Duration(milliseconds: 3000),
              dotSize: 6.0,
              dotIncreasedColor: dotIncreasedColor,
              dotBgColor: Colors.transparent,
              dotPosition: DotPosition.bottomCenter,
              dotVerticalPadding: 10.0,
              showIndicator: imgList.length == 1 ? false : true,
              indicatorBgPadding: 7.0,
              images: imgList,
            ),
          ),
        ),
      ],
    );
  }

  Widget addBottomBar() {
    return Stack(
      overflow: Overflow.visible,
      alignment: new FractionalOffset(.5, 1.0),
      children: <Widget>[
        BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: appTheme,
          type: BottomNavigationBarType.fixed,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart, color: bottomBarIconColor),
                title: Text('Cart', style: TextStyle(color: bottomBarTextColor)),
                backgroundColor: appTheme),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_offer, color: bottomBarIconColor),
              title: Text('Offers', style: TextStyle(color: bottomBarTextColor)),
              backgroundColor: appTheme,
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart, color: Colors.white,size: 0,),
                title: Text(''),
                backgroundColor: appTheme),
            BottomNavigationBarItem(
                icon: Icon(Icons.history, color: bottomBarIconColor),
                title: Text('History', style: TextStyle(color: bottomBarTextColor)),
                backgroundColor: appTheme),
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_mail, color: bottomBarIconColor),
                title: Text('Contact', style: TextStyle(color: bottomBarTextColor)),
                backgroundColor: appTheme)
          ],
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Image.asset("images/icon_home_categories.png",
            height: 60, width: 60,
          ),
        ),
      ],
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyCartScreen(() {})),
        );
      }
      if (_currentIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyOfferScreen(context)),
        );
      }
      if (_currentIndex == 3) {
        if (AppConstant.isLoggedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyOrderScreen(context)),
          );
        } else {
          Utils.showLoginDialog(context);
        }
      }
      if (_currentIndex == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ContactScreen()),
        );
      }
    });
  }

  _handleDrawer() async {
    try {
      _key.currentState.openDrawer();
      //print("------_handleDrawer-------");
      if (AppConstant.isLoggedIn) {
            user = await SharedPrefs.getUser();
            //if(user != null)
            setState(() {});
          }
    } catch (e) {
      print(e);
    }
  }

  void initFirebase() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        try {
          print("------onMessage: $message");
          if(AppConstant.isLoggedIn){
            String title = message['notification']['title'];
            String body = message['notification']['body'];
            showNotification(title,body,message);
          }
        } catch (e) {
          print(e);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch: $message");

      },
      onResume: (Map<String, dynamic> message) async {
        //print("onResume: $message");

      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.getToken().then((token){
      print("----token---- ${token}");
      try {
        SharedPrefs.storeSharedValue(AppConstant.deviceToken, token.toString());
      } catch (e) {
        print(e);
      }
    });
  }

  Future showNotification(String title,String body, Map<String, dynamic> message) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid =
    AndroidInitializationSettings('ic_notification');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'restroapp', 'restroapp', 'restroapp app',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'item x');

  }
  Future<void> onSelectNotification(String payload) async {
    debugPrint('onSelectNotification : ');
  }
  Future<void> onDidReceiveLocalNotification(int id, String title,
      String body, String payload) async {
    debugPrint('onDidReceiveLocalNotification : ');
  }
}
