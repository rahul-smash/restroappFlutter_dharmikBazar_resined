import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restroapp/src/Screens/Dashboard/ContactScreen.dart';
import 'package:restroapp/src/Screens/BookOrder/MyCartScreen.dart';
import 'package:restroapp/src/Screens/Offers/MyOrderScreen.dart';
import 'package:restroapp/src/Screens/Offers/OfferScreen.dart';
import 'package:restroapp/src/Screens/SideMenu/SideMenu.dart';
import 'package:restroapp/src/UI/CategoryView.dart';
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
  List<String> imgList = [];
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  UserModel user;
  String androidAPPversion,ios_app_version,force_download,force_downloads,force_download_message;

  _HomeScreenState(this.store);

  @override
  void initState() {
    super.initState();
    initFirebase();
    try {
      if (store.banners.isEmpty) {
        imgList = [
          AppConstant.placeholderImageUrl,
          AppConstant.placeholderImageUrl,
          AppConstant.placeholderImageUrl
        ];
      } else {
        for (var i = 0; i < store.banners.length; i++) {
          String imageUrl = store.banners[i].image;
          imgList.add(
              imageUrl.isEmpty ? AppConstant.placeholderImageUrl : imageUrl);
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
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
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
      drawer: NavDrawerMenu(store, user == null ? null : user.fullName),
      bottomNavigationBar: addBottomBar(),
    );
  }

  Widget addBanners() {
    return CarouselSlider(
      viewportFraction: 0.9,
      aspectRatio: 1.7,
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
      backgroundColor: appTheme,
      type: BottomNavigationBarType.fixed,
      onTap: onTabTapped,
      // new
      items: [
        new BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            title: Text('Cart', style: TextStyle(color: Colors.white)),
            backgroundColor: appTheme),
        new BottomNavigationBarItem(
          icon: Icon(Icons.local_offer, color: Colors.white),
          title: Text('Offers', style: TextStyle(color: Colors.white)),
          backgroundColor: appTheme,
        ),
        new BottomNavigationBarItem(
            icon: Icon(Icons.history, color: Colors.white),
            title: Text('History', style: TextStyle(color: Colors.white)),
            backgroundColor: appTheme),
        new BottomNavigationBarItem(
            icon: Icon(Icons.contact_mail, color: Colors.white),
            title: Text('Contact', style: TextStyle(color: Colors.white)),
            backgroundColor: appTheme)
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
          MaterialPageRoute(builder: (context) => OfferScreen(context)),
        );
      }
      if (_currentIndex == 2) {
        if (AppConstant.isLoggedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyOrderScreen(context)),
          );
        } else {
          Utils.showLoginDialog(context);
        }
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
          String title = message['notification']['title'];
          String body = message['notification']['body'];
          showNotification(title,body,message);
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
