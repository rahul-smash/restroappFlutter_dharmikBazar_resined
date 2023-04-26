import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart' as b;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/Screens/BookOrder/MyCartScreen.dart';
import 'package:restroapp/src/Screens/BookOrder/SubCategoryProductScreen.dart';
import 'package:restroapp/src/Screens/Dashboard/ContactScreen.dart';
import 'package:restroapp/src/Screens/Dashboard/ProductDetailScreen.dart';
import 'package:restroapp/src/Screens/Dashboard/widgets/order_time_popup.dart';
import 'package:restroapp/src/Screens/Notification/NotificationScreen.dart';
import 'package:restroapp/src/Screens/Offers/MyOrderScreenVersion2.dart';
import 'package:restroapp/src/Screens/Offers/OrderDetailScreenVersion2.dart';
import 'package:restroapp/src/Screens/SideMenu/SideMenu.dart';
import 'package:restroapp/src/UI/CategoryView.dart';
import 'package:restroapp/src/UI/SubscriptionHistoryDetails.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/models/ConfigModel.dart';
import 'package:restroapp/src/models/SocialModel.dart';
import 'package:restroapp/src/models/StoreBranchesModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/models/WalleModel.dart';
import 'package:restroapp/src/notifications/notification_service_helper.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'SearchScreen.dart';

class HomeScreen extends StatefulWidget {
  final StoreModel store;
  ConfigModel configObject;
  bool showForceUploadAlert;

  HomeScreen(this.store, this.configObject, this.showForceUploadAlert);

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState(this.store);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  StoreModel store;

  // FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  List<NetworkImage> imgList = [];
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  UserModel user;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  bool isStoreClosed;
  final DatabaseHelper databaseHelper = new DatabaseHelper();
  int cartBadgeCount;
  StoreBranchesModel storeBranchesModel;
  BranchData branchData;
  bool isLoading;
  CategoryResponse categoryResponse;
  WalleModel welleModel;
  SocialModel socialModel;
  Offset _offset;


  _HomeScreenState(this.store);

  @override
  void initState() {
    super.initState();
    _offset = Offset(Utils.width / 1.7, Utils.height / 1.7);
    isStoreClosed = false;
    // initFirebase();
    NotificationServiceHelper.instance.initialize();
    _setSetCurrentScreen();
    cartBadgeCount = 0;
    getCartCount();
    listenCartChanges();
    checkForMultiStore();
    getCategoryApi();
    _getWellet();
    ApiController.getStoreSocialOptions().then((value) {
      this.socialModel = value;
    });
    try {
      AppConstant.placeholderUrl = store.banner10080;
      //print("-----store.banners-----${store.banners.length}------");
      if (store.banners.isEmpty) {
        imgList = [NetworkImage(AppConstant.placeholderImageUrl)];
      } else {
        for (var i = 0; i < store.banners.length; i++) {
          String imageUrl = store.banners[i].image;
          imgList.add(
            NetworkImage(
                imageUrl.isEmpty ? AppConstant.placeholderImageUrl : imageUrl),
          );
        }
      }
      if (widget.showForceUploadAlert) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          DialogUtils.showForceUpdateDialog(context, store.storeName,
              store.forceDownload[0].forceDownloadMessage,
              storeModel: store);
        });
      } else {
        if (!checkIfStoreClosed()) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!AppConstant.isLoggedIn && store.isRefererFnEnable) {
              String showReferEarnAlert = await SharedPrefs.getStoreSharedValue(
                  AppConstant.showReferEarnAlert);
              if (showReferEarnAlert == null) {
                SharedPrefs.storeSharedValue(
                    AppConstant.showReferEarnAlert, "true");
                DialogUtils.showInviteEarnAlert2(context);
              }
            }
            if (store.storeOffer != null)
              DialogUtils.displayofferDialog(context, store.storeOffer,
                  onButtonPressed: _offerPressed);
          });
        }
      }
    } catch (e) {
      print(e);
    }

    // Remove app from battery optimization for custom rom devices
/*    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bool isBatteryOptimization = await NotificationServiceHelper.instance
          .isManufacturerBatteryOptimizationDisabled();
      if (!isBatteryOptimization) {
        await showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text(
                          "Disable Battery Optimization",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: grayColorTitle, fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                        height: 1,
                        color: Colors.black45,
                        width: MediaQuery.of(context).size.width),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: Center(
                        child: Text(
                          "Disable the optimizations to allow smooth functioning of this app",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: TextButton(
                              child: Text('OK'),
                              color: appThemeSecondary,
                              textColor: Colors.white,
                              onPressed: () async {
                                Navigator.pop(context, true);
                                await NotificationServiceHelper.instance
                                    .showDisableManufacturerBatteryOptimizationSettings();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    });*/
  }

  _offerPressed() {
    Navigator.of(context).pop(true);
    if (store.storeOffer.linkTo.isNotEmpty) {
      if (store.storeOffer.linkTo == "category") {
        if (store.storeOffer.categoryId == "0" &&
            store.storeOffer.subCategoryId == "0" &&
            store.storeOffer.productId == "0") {
          print("return");
          return;
        }

        if (store.storeOffer.categoryId != "0" &&
            store.storeOffer.subCategoryId != "0" &&
            store.storeOffer.productId != "0") {
          // here we have to open the product detail
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(null,
                      productID: store.storeOffer.productId)));
        } else if (store.storeOffer.categoryId != "0" &&
            store.storeOffer.subCategoryId != "0" &&
            store.storeOffer.productId == "0") {
          //here open the banner sub category

          for (int i = 0; i < categoryResponse.categories.length; i++) {
            CategoryModel categories = categoryResponse.categories[i];
            if (store.storeOffer.categoryId == categories.id) {
              print(
                  "title ${categories.title} and ${categories.id} and ${store.storeOffer.categoryId}");
              if (categories.subCategory != null) {
                for (int j = 0; j < categories.subCategory.length; j++) {
                  SubCategory subCategory = categories.subCategory[j];
                  if (subCategory.id == store.storeOffer.subCategoryId) {
                    print(
                        "open the subCategory ${subCategory.title} and ${subCategory.id} = ${store.storeOffer.subCategoryId}");

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SubCategoryProductScreen(categories, true, j);
                      }),
                    );

                    break;
                  }
                }
              }
            }
            //print("Category ${categories.id} = ${categories.title} = ${categories.subCategory.length}");
          }
        } else if (store.storeOffer.categoryId != "0" &&
            store.storeOffer.subCategoryId == "0" &&
            store.storeOffer.productId == "0") {
          for (int i = 0; i < categoryResponse.categories.length; i++) {
            CategoryModel categories = categoryResponse.categories[i];
            if (store.storeOffer.categoryId == categories.id) {
              print(
                  "title ${categories.title} and ${categories.id} and ${store.storeOffer.categoryId}");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SubCategoryProductScreen(categories, true, 0);
                }),
              );
              break;
            }
          }
        }
        //-----------------------------------------------
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: whiteColor,
        statusBarIconBrightness: Brightness.dark
    ),child: SafeArea(
      child: Scaffold(
        key: _key,
        appBar: getAppBar(),
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                addBanners(),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : categoryResponse == null
                          ? SingleChildScrollView(child: Center(child: Text("")))
                          : showGridView(),
                ),
              ],
            ),
            Positioned(
              left: _offset.dx,
              top: _offset.dy,
              child: GestureDetector(
                onPanUpdate: (d) {
                  setState(() {
                    return _offset += Offset(d.delta.dx, d.delta.dy);
                  });
                },
                child: AppConstant.isLoggedIn
                    ? store.delivery_expected_times == '1'
                        ? OrderTimePopup()
                        : SizedBox()
                    : SizedBox(),
              ),
            ),
          ],
        ),
        drawer: NavDrawerMenu(
          store,
          user == null ? "" : user.fullName,
          socialModel: socialModel,
          walleModel: welleModel,
        ),
        bottomNavigationBar: SafeArea(
          child: addBottomBar(),
        ),
      ),
    ));
  }

  bool showBottomBar = false;
  callBack(bool showBottomBar) {
    this.showBottomBar = showBottomBar;
    //print("--------showBottomBar---------=${showBottomBar}");
  }

  Widget showGridView() {
    return Container(
      color: grayLightColor,
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.05,
          padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 8.0,
          shrinkWrap: true,
          children: categoryResponse.categories.map((CategoryModel model) {
            return GridTile(child: CategoryView(model, store, false, 0));
          }).toList()),
    );
  }

  Widget addBanners() {
    if (imgList.length == 0) {
      return Container();
    } else
      return Center(
        child: SizedBox(
          height: 220.0,
          width: Utils.getDeviceWidth(context),
          child: _CarouselView(),
        ),
      );
  }

  Widget _CarouselView() {
    return CarouselSlider.builder(
      itemCount: imgList.length,
      options: CarouselOptions(
        viewportFraction: 1.0,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        onPageChanged: (index, reason) {

        },
        enlargeCenterPage: false,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.ease,
        scrollDirection: Axis.horizontal,
      ),
      itemBuilder: (BuildContext context, int itemIndex, realIndex) =>
          Container(
        child: _makeBanner(context, itemIndex),
      ),
    );
  }

  Widget _makeBanner(BuildContext context, int _index) {
    return InkWell(
      onTap: () => _onBannerTap(_index),
      child: Container(
          padding:
              EdgeInsets.only(top: 0.0, bottom: 15.0, left: 15.0, right: 15.0),

          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: "${imgList[_index].url}",
              fit: BoxFit.fill,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          )),
    );
  }

  void _onBannerTap(position) {
    if (store.banners[position].linkTo.isNotEmpty) {
      if (store.banners[position].linkTo == "category") {
        if (store.banners[position].categoryId == "0" &&
            store.banners[position].subCategoryId == "0" &&
            store.banners[position].productId == "0") {
          print("return");
          return;
        }

        if (store.banners[position].categoryId != "0" &&
            store.banners[position].subCategoryId != "0" &&
            store.banners[position].productId != "0") {
          // here we have to open the product detail
        } else if (store.banners[position].categoryId != "0" &&
            store.banners[position].subCategoryId != "0" &&
            store.banners[position].productId == "0") {
          //here open the banner sub category

          for (int i = 0; i < categoryResponse.categories.length; i++) {
            CategoryModel categories = categoryResponse.categories[i];
            if (store.banners[position].categoryId == categories.id) {
              print(
                  "title ${categories.title} and ${categories.id} and ${store.banners[position].categoryId}");
              if (categories.subCategory != null) {
                for (int j = 0; j < categories.subCategory.length; j++) {
                  SubCategory subCategory = categories.subCategory[j];

                  if (subCategory.id == store.banners[position].subCategoryId) {
                    print(
                        "open the subCategory ${subCategory.title} and ${subCategory.id} = ${store.banners[position].subCategoryId}");

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return SubCategoryProductScreen(categories, true, j);
                      }),
                    );

                    break;
                  }
                }
              }
            }
            //print("Category ${categories.id} = ${categories.title} = ${categories.subCategory.length}");
          }
        } else if (store.banners[position].categoryId != "0" &&
            store.banners[position].subCategoryId == "0" &&
            store.banners[position].productId == "0") {

          for (int i = 0; i < categoryResponse.categories.length; i++) {
            CategoryModel categories = categoryResponse.categories[i];
            if (store.banners[position].categoryId == categories.id) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SubCategoryProductScreen(categories, true, 0);
                }),
              );
              break;
            }
          }
        }
      }
    }
  }

  Widget addBottomBar() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: new FractionalOffset(.5, 1.0),
      children: <Widget>[
        BottomNavigationBar(
          currentIndex: _currentIndex,
          backgroundColor: bottomBarBackgroundColor,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: bottomBarTextColor,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset('images/contacticon.png',
                  width: 24, fit: BoxFit.scaleDown, color: bottomBarIconColor),
              //title: Text('Contact', style: TextStyle(color: bottomBarTextColor)),
              label: 'Contact',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/searchcion.png',
                  width: 24, fit: BoxFit.scaleDown, color: bottomBarIconColor),
              //title: Text('Search', style: TextStyle(color: bottomBarTextColor)),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
                size: 0,
              ),
              //title: Text(''),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('images/historyicon.png',
                  width: 24, fit: BoxFit.scaleDown, color: bottomBarIconColor),
              //title: Text('My Orders', style: TextStyle(color: bottomBarTextColor)),
              label: 'My Orders',
            ),
            BottomNavigationBarItem(
              icon:  b.Badge(
                showBadge: cartBadgeCount == 0 ? false : true,
                badgeStyle: b.BadgeStyle
                  (
                  badgeColor: appThemeSecondary
                ),
                badgeContent: Text('$cartBadgeCount',
                    style: TextStyle(color: Colors.white)),
                child: Image.asset('images/carticon.png',
                    width: 24,
                    fit: BoxFit.scaleDown,
                    color: bottomBarIconColor),
              ),
              /*title: Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                child:
                    Text('Cart', style: TextStyle(color: bottomBarTextColor)),
              ),*/
              label: 'Cart',
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(shape: BoxShape.circle, color: appTheme),
          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
          //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: widget.configObject.isGroceryApp == "true"
              ? Image.asset(
                  "images/groceryicon2.png",
                  height: 40,
                  width: 40,
                  color: whiteColor,
                )
              : Image.asset("images/restauranticon.png",
                  height: 40, width: 40, color: whiteColor),
        ),
      ],
    );
  }

  onTabTapped(int index) {
    if (checkIfStoreClosed()) {
      DialogUtils.displayCommonDialog(context, store.storeName, store.storeMsg);
    } else {
      setState(() {
        _currentIndex = index;
        if (_currentIndex == 4) {
//          if (AppConstant.isLoggedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyCartScreen(() {
                      getCartCount();
                    })),
          );
//          }else{
//            Utils.showLoginDialog(context);
//          }

          Map<String, dynamic> attributeMap = new Map<String, dynamic>();
          attributeMap["ScreenName"] = "MyCartScreen";
          Utils.sendAnalyticsEvent("Clicked MyCartScreen", attributeMap);
        }
        if (_currentIndex == 1) {
          if (AppConstant.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            );
          } else {
            Utils.showLoginDialog(context);
          }
          Map<String, dynamic> attributeMap = new Map<String, dynamic>();
          attributeMap["ScreenName"] = "SearchScreen";
          Utils.sendAnalyticsEvent("Clicked SearchScreen", attributeMap);
        }
        if (_currentIndex == 3) {
          if (AppConstant.isLoggedIn) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyOrderScreenVersion2(this.store)),
            );
            Map<String, dynamic> attributeMap = new Map<String, dynamic>();
            attributeMap["ScreenName"] = "MyOrderScreen";
            Utils.sendAnalyticsEvent("Clicked MyOrderScreen", attributeMap);
          } else {
            Utils.showLoginDialog(context);
          }
        }
        if (_currentIndex == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactScreen(store)),
          );
          Map<String, dynamic> attributeMap = new Map<String, dynamic>();
          attributeMap["ScreenName"] = "ContactScreen";
          Utils.sendAnalyticsEvent("Clicked ContactScreen", attributeMap);
        }
      });
    }
  }

  _handleDrawer() async {
    try {
      if (checkIfStoreClosed()) {
        DialogUtils.displayCommonDialog(
            context, store.storeName, store.storeMsg);
      } else {
        _key.currentState.openDrawer();
        //print("------_handleDrawer-------");
        if (AppConstant.isLoggedIn) {
          user = await SharedPrefs.getUser();
          print("user.id=${user.id}");
          if (user != null) setState(() {});
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void initFirebase() {
    if (widget.configObject.isGroceryApp == "true") {
      AppConstant.isRestroApp = false;
    } else {
      AppConstant.isRestroApp = true;
    }
//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print(message.toString());
//         try {
//           print("------onMessage: $message");
//           if (AppConstant.isLoggedIn) {
//             if (Platform.isIOS) {
//               print("iosssssssssssssssss");
//               String title = message['aps']['alert']['title'];
//               String body = message['aps']['alert']['body'];
//               showNotification(title, body, message);
//             } else {
//               print("androiddddddddddd");
//               String title = message['notification']['title'];
//               String body = message['notification']['body'];
//               showNotification(title, body, message);
//             }
//           }
//         } catch (e) {
//           print(e);
//         }
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
// //        Utils.showToast('onLaunch', false);
//         onSelectNotification(jsonEncode(message));
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
// //        Utils.showToast('onResume', false);
//         onSelectNotification(jsonEncode(message));
//       },
//     );
//
//     _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(sound: true, badge: true, alert: true));
//     _firebaseMessaging.getToken().then((token) {
//       print("----token---- ${token}");
//       try {
//         SharedPrefs.storeSharedValue(AppConstant.deviceToken, token.toString());
//       } catch (e) {
//         print(e);
//       }
//     });
  }

  Future showNotification(
      String title, String body, Map<String, dynamic> message) async {
    // print('$body');
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //     new FlutterLocalNotificationsPlugin();
    //
    // String appName = await SharedPrefs.getStoreSharedValue(AppConstant.appName);
    //
    // var initializationSettingsAndroid =
    //     AndroidInitializationSettings('ic_notification');
    // var initializationSettingsIOS = IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    // var initializationSettings = InitializationSettings(
    //     initializationSettingsAndroid, initializationSettingsIOS);
    // flutterLocalNotificationsPlugin.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);
    //
    // var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    //   '${appName}',
    //   '${appName}',
    //   '${appName}',
    //   importance: Importance.Max,
    //   priority: Priority.High,
    //   ticker: 'ticker',
    //   style: AndroidNotificationStyle.BigText,
    // );
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    // var platformChannelSpecifics = NotificationDetails(
    //     androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    // await flutterLocalNotificationsPlugin.show(
    //     0, title, body, platformChannelSpecifics,
    //     payload: jsonEncode(message));
  }

  Future<void> onSelectNotification(String payload) async {
    debugPrint('onSelectNotification : ');
    if (payload != null) {
      try {
        Map<String, dynamic> map = json.decode(payload);
        String id = '';
        String type = '';
        StoreModel store = await SharedPrefs.getStore();
        bool isRatingEnable = store.reviewRatingDisplay != null &&
            store.reviewRatingDisplay.compareTo('1') == 0;
        Navigator.of(context).popUntil((route) => route.isFirst);
        if (Platform.isIOS) {
        } else {
          id = map['data']['id'];
          type = map['data']['type'];
          type = type.toLowerCase();
        }

        switch (type) {
          case 'order':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetailScreenVersion2(
                        isRatingEnable,
                        store,
                        orderId: id,
                      )),
            );
            break;
          case 'subscription':
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SubscriptionHistoryDetails(
                        orderHistoryDataId: id,
                        store: store,
                      )),
            );
            break;
        }
      } catch (e) {
        print(e);
      }
    }

    Map<String, dynamic> attributeMap = new Map<String, dynamic>();
    attributeMap["ScreenName"] = "MyOrderScreen";
    Utils.sendAnalyticsEvent("Clicked MyOrderScreen", attributeMap);
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    debugPrint('onDidReceiveLocalNotification : ');
  }

  void listenCartChanges() {
    eventBus.on<updateCartCount>().listen((event) {
      //print("<---Home----updateCartCount------->");
      getCartCount();
    });
  }

  void checkForMultiStore() {
    print("isMultiStore=${widget.configObject.isMultiStore}");
    if (widget.configObject.isMultiStore) {
      ApiController.multiStoreApiRequest(widget.configObject.primaryStoreId)
          .then((response) {
        //print("${storeBranchesModel.data.length}");
        setState(() {
          this.storeBranchesModel = response;
          if (storeBranchesModel != null) {
            if (storeBranchesModel.data.isNotEmpty) {
              for (int i = 0; i < storeBranchesModel.data.length; i++) {
                if (widget.store.id == storeBranchesModel.data[i].id) {
                  branchData = storeBranchesModel.data[i];
                  break;
                }
              }
            }
          }
        });
      });
    }
  }

  bool checkIfStoreClosed() {
    if (store.storeStatus == "0") {
      //0 mean Store close
      return true;
    } else {
      return false;
    }
  }

  Future<void> _setSetCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: 'HomeScreen',
      screenClassOverride: 'HomeScreenView',
    );
  }

  getCartCount() {
    databaseHelper.getCount(DatabaseHelper.CART_Table).then((value) {
      setState(() {
        cartBadgeCount = value;
      });
    });
  }

  void getCategoryApi() {
    isLoading = true;
    ApiController.getCategoriesApiRequest(store.id).then((response) {
      setState(() {
        isLoading = false;
        this.categoryResponse = response;
      });
    });
  }

  Future logout(BuildContext context, BranchData selectedStore) async {
    try {
      Utils.showProgressDialog(context);
      SharedPrefs.setUserLoggedIn(false);
      SharedPrefs.storeSharedValue(AppConstant.isAdminLogin, "false");
      SharedPrefs.removeKey(AppConstant.showReferEarnAlert);
      SharedPrefs.removeKey(AppConstant.referEarnMsg);
      AppConstant.isLoggedIn = false;
      DatabaseHelper databaseHelper = new DatabaseHelper();
      databaseHelper.deleteTable(DatabaseHelper.Categories_Table);
      databaseHelper.deleteTable(DatabaseHelper.Sub_Categories_Table);
      databaseHelper.deleteTable(DatabaseHelper.Favorite_Table);
      databaseHelper.deleteTable(DatabaseHelper.CART_Table);
      databaseHelper.deleteTable(DatabaseHelper.Products_Table);
      eventBus.fire(updateCartCount());

      StoreResponse storeData =
          await ApiController.versionApiRequest(selectedStore.id);
      CategoryResponse categoryResponse =
          await ApiController.getCategoriesApiRequest(storeData.store.id);
      setState(() {
        this.store = storeData.store;
        this.branchData = selectedStore;
        this.categoryResponse = categoryResponse;
        Utils.hideProgressDialog(context);
      });
    } catch (e) {
      print(e);
    }
  }

  Widget getAppBar() {
    bool rightActionsEnable = false,
        whatIconEnable = false,
        dialIconEnable = false;

    if (store.homePageDisplayNumberType != null &&
        store.homePageDisplayNumberType.isNotEmpty) {
      //0=>Contact Number,1=>App Icon,2=>None
      switch (store.homePageHeaderRight) {
        case "0":
          rightActionsEnable = true;
          break;
        case "1":
          rightActionsEnable = true;
          break;
        case "2":
          rightActionsEnable = false;
          break;
      }
      if (store.homePageDisplayNumber != null &&
          store.homePageDisplayNumber.isNotEmpty) {
        //0=>Whats app, 1=>Phone Call
        if (store.homePageDisplayNumberType.compareTo("0") == 0) {
          whatIconEnable = true;
        }
        //0=>Whats app, 1=>Phone Call
        if (store.homePageDisplayNumberType.compareTo("1") == 0) {
          dialIconEnable = true;
        }
      }
    }

    return AppBar(
      title: widget.configObject.isMultiStore == false
          ? Column(
              children: <Widget>[
                Visibility(
                  visible: store.homePageTitleStatus,
                  child: Text(
                    store.homePageTitle != null
                        ? store.homePageTitle
                        : store.storeName,
                  ),
                ),
                Visibility(
                  visible: store.homePageSubtitleStatus &&
                      store.homePageSubtitle != null,
                  child: Text(
                    store.homePageSubtitle != null
                        ? store.homePageSubtitle
                        : "",
                    style: TextStyle(fontSize: 13),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                )
              ],
            )
          : InkWell(
              onTap: () async {
                BranchData selectedStore =
                    await DialogUtils.displayBranchDialog(context,
                        "Select Branch", storeBranchesModel, branchData);
                if (selectedStore != null &&
                    store.id.compareTo(selectedStore.id) != 0)
                  logout(context, selectedStore);
              },
              child: Row(
                children: <Widget>[
                  Text(branchData == null ? "" : branchData.storeName),
                  Icon(Icons.keyboard_arrow_down)
                ],
              ),
            ),
      centerTitle: widget.configObject.isMultiStore == true ? false : true,
      leading: new IconButton(
        icon: Image.asset('images/hamburger.png', width: 25),
        onPressed: _handleDrawer,
      ),
      actions: <Widget>[
        Visibility(
            visible: AppConstant.isLoggedIn,
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                size: 25.0,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NotificationScreen(this.store);
                  }),
                );
              },
            )),
        Visibility(
          visible: rightActionsEnable && whatIconEnable,
          child: Padding(
              padding: EdgeInsets.only(right: 5.0),
              child: IconButton(
                icon: Image.asset(
                  'images/whatsapp.png',
                  width: 28,
                  height: 25,
                  color: Colors.white,
                ),
                onPressed: () {
                  Utils.launchWhatsApp(store.homePageDisplayNumber);
                },
              )),
        ),
        Visibility(
            visible: rightActionsEnable && dialIconEnable,
            child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    _launchCaller(store.homePageDisplayNumber);
                  },
                  child: Icon(
                    Icons.call,
                    size: 25.0,
                    color: Colors.white,
                  ),
                )))
      ],
    );
  }

  _launchCaller(String call) async {
    String url = "tel:$call";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  void _getWellet() async {
    welleModel = await ApiController.getUserWallet();
  }
}
