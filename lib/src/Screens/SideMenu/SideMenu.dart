import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:restroapp/src/Screens/Favourites/Favourite.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginMobileScreen.dart';
import 'package:restroapp/src/Screens/SideMenu/AboutScreen.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/Screens/SideMenu/BookNowScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginEmailScreen.dart';
import 'package:restroapp/src/Screens/Offers/MyOrderScreen.dart';
import 'package:restroapp/src/Screens/SideMenu/ReferEarn.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/ReferEarnData.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';

import 'LoyalityPoints.dart';
import 'ProfileScreen.dart';

class NavDrawerMenu extends StatefulWidget {

  final StoreModel store;
  final String userName;
  NavDrawerMenu(this.store, this.userName);

  @override
  _NavDrawerMenuState createState() {
    return _NavDrawerMenuState();
  }
}

class _NavDrawerMenuState extends State<NavDrawerMenu> {
  List<dynamic> _drawerItems = List();
  _NavDrawerMenuState();

  @override
  void initState() {
    super.initState();
    _drawerItems
        .add(DrawerChildItem(DrawerChildConstants.HOME, "images/home.png"));
    _drawerItems.add(DrawerChildItem(
        DrawerChildConstants.MY_PROFILE, "images/myprofile.png"));
    _drawerItems.add(DrawerChildItem(
        DrawerChildConstants.DELIVERY_ADDRESS, "images/deliveryaddress.png"));
    _drawerItems.add(
        DrawerChildItem(DrawerChildConstants.MY_ORDERS, "images/my_order.png"));
    if (widget.store.loyality == "1")
      _drawerItems.add(DrawerChildItem(
          DrawerChildConstants.LOYALITY_POINTS, "images/loyality.png"));
    _drawerItems.add(
        DrawerChildItem(DrawerChildConstants.MY_FAVORITES, "images/myfav.png"));
    _drawerItems.add(
        DrawerChildItem(DrawerChildConstants.ABOUT_US, "images/about.png"));
    _drawerItems
        .add(DrawerChildItem(DrawerChildConstants.SHARE, "images/refer.png"));
    _drawerItems
        .add(DrawerChildItem(DrawerChildConstants.LOGIN, "images/sign_in.png"));
    try {
      _setSetUserId();
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: left_menu_background_color,
        ),
        child: Drawer(
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _drawerItems.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return (index == 0
                    ? createHeaderInfoItem()
                    : createDrawerItem(index - 1, context));
              }),
        )
    );
  }

  Widget createHeaderInfoItem() {
    return Container(
        color: left_menu_header_bkground,
        child: Padding(
            padding: EdgeInsets.only(left: 35, top: 40, bottom: 30),
            child: Row(children: [
              Padding(
                padding: EdgeInsets.only(left: 0, right: 20),
                child: Center(
                  child: Icon(Icons.account_circle,size: 60, color: Colors.white,),
                ),
              ),
              Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Welcome',
                          style: TextStyle(color: leftMenuWelcomeTextColors,
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(AppConstant.isLoggedIn == false ? '' : widget.userName,
                          maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: leftMenuWelcomeTextColors, fontSize: 15)
                      ),
                    ]
                ),
              ),
            ])));
  }

  Widget createDrawerItem(int index, BuildContext context) {
    var item = _drawerItems[index];
    return Padding(
        padding: EdgeInsets.only(left: 20),
        child: ListTile(
          leading: Image.asset(
              item.title == DrawerChildConstants.LOGIN ||
                  item.title == DrawerChildConstants.LOGOUT
                  ? AppConstant.isLoggedIn == false
                  ? 'images/sign_in.png'
                  : 'images/sign_out.png'
                  : item.icon,
              color: left_menu_icon_colors,
              width: 30),
          title: item.title == DrawerChildConstants.LOGIN ||
              item.title == DrawerChildConstants.LOGOUT
              ? Text(
              AppConstant.isLoggedIn == false
                  ? DrawerChildConstants.LOGIN
                  : DrawerChildConstants.LOGOUT,
              style:
              TextStyle(color: leftMenuLabelTextColors, fontSize: 15))
              : Text(item.title,
              style:
              TextStyle(color: leftMenuLabelTextColors, fontSize: 15)),
          onTap: () {
            _openPageForIndex(item, index, context);
          },
        ));
  }

  _openPageForIndex(DrawerChildItem item,int pos, BuildContext context) async {
    switch (item.title) {
      case DrawerChildConstants.HOME:
        Navigator.pop(context);
        break;
      case DrawerChildConstants.MY_PROFILE:
        if (AppConstant.isLoggedIn) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(false,"")),
          );
          Map<String,dynamic> attributeMap = new Map<String,dynamic>();
          attributeMap["ScreenName"] = "ProfileScreen";
          Utils.sendAnalyticsEvent("Clicked ProfileScreen",attributeMap);
        } else {
          Utils.showLoginDialog(context);
        }
        break;
      case DrawerChildConstants.DELIVERY_ADDRESS:
        if (AppConstant.isLoggedIn) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeliveryAddressList(false,OrderType.Menu)),
          );
          Map<String,dynamic> attributeMap = new Map<String,dynamic>();
          attributeMap["ScreenName"] = "DeliveryAddressList";
          Utils.sendAnalyticsEvent("Clicked DeliveryAddressList",attributeMap);
        } else {
          Utils.showLoginDialog(context);
        }
        break;
      case DrawerChildConstants.MY_ORDERS:
        if (AppConstant.isLoggedIn) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyOrderScreen(widget.store)),
          );
          Map<String,dynamic> attributeMap = new Map<String,dynamic>();
          attributeMap["ScreenName"] = "MyOrderScreen";
          Utils.sendAnalyticsEvent("Clicked MyOrderScreen",attributeMap);
        } else {
          Utils.showLoginDialog(context);
        }
        break;
      case DrawerChildConstants.LOYALITY_POINTS:
        if (AppConstant.isLoggedIn) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoyalityPointsScreen(widget.store)),
          );
        }else {
          Utils.showLoginDialog(context);
        }

        break;
      case DrawerChildConstants.MY_FAVORITES:
        if (AppConstant.isLoggedIn) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Favourites(() { })),
          );
          Map<String,dynamic> attributeMap = new Map<String,dynamic>();
          attributeMap["ScreenName"] = "Favourites";
          Utils.sendAnalyticsEvent("Clicked Favourites",attributeMap);
        }else {
          Utils.showLoginDialog(context);
        }
        break;
      case DrawerChildConstants.ABOUT_US:
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen(widget.store)),
        );
        Map<String,dynamic> attributeMap = new Map<String,dynamic>();
        attributeMap["ScreenName"] = "AboutScreen";
        Utils.sendAnalyticsEvent("Clicked AboutScreen",attributeMap);
        break;
      case DrawerChildConstants.SHARE:
        if (AppConstant.isLoggedIn) {
          if(widget.store.isRefererFnEnable){
            Navigator.pop(context);

            ReferEarnData referEarn = await ApiController.referEarn();
            share(referEarn,widget.store);

          }else{
            Utils.showToast("Refer Earn is inactive!", true);
          }
        }else {
          Navigator.pop(context);
          var result = await DialogUtils.showInviteEarnAlert(context);
          print("showInviteEarnAlert=${result}");
        }
        //share();

        Map<String,dynamic> attributeMap = new Map<String,dynamic>();
        attributeMap["ScreenName"] = "share apk url";
        Utils.sendAnalyticsEvent("Clicked share",attributeMap);

        //DialogUtils.showInviteEarnAlert2(context);
        
        break;
      case DrawerChildConstants.LOGIN:
      case DrawerChildConstants.LOGOUT:
        if (AppConstant.isLoggedIn) {
          _showDialog(context);
        } else {
          Navigator.pop(context);
          SharedPrefs.getStore().then((storeData){
            StoreModel model = storeData;
            print("---internationalOtp--${model.internationalOtp}");
            //User Login with Mobile and OTP = 0
            // 1 = email and 0 = ph-no
            if(model.internationalOtp == "0"){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginMobileScreen("menu")),
              );
              Map<String,dynamic> attributeMap = new Map<String,dynamic>();
              attributeMap["ScreenName"] = "LoginMobileScreen";
              Utils.sendAnalyticsEvent("Clicked LoginMobileScreen",attributeMap);
            }else{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginEmailScreen("menu")),
              );
              Map<String,dynamic> attributeMap = new Map<String,dynamic>();
              attributeMap["ScreenName"] = "LoginEmailScreen";
              Utils.sendAnalyticsEvent("Clicked LoginEmailScreen",attributeMap);
            }
          });
        }
        break;
    }
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Logout"),
          content: new Text(AppConstant.logoutConfirm),
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
                logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> share(ReferEarnData referEarn,StoreModel store) async {
    if(store.isRefererFnEnable){
      await FlutterShare.share(
          title: '${store.storeName}',
          linkUrl: referEarn.referEarn.sharedMessage,
          chooserTitle: 'Refer & Earn');
    }else{
      await FlutterShare.share(
          title: 'Kindly download',
          text: 'Kindly download' + widget.store.storeName + 'app from',
          linkUrl: widget.store.androidShareLink,
          chooserTitle: 'Share');
    }

  }

  Future logout(BuildContext context) async {
    try {
      SharedPrefs.setUserLoggedIn(false);
      SharedPrefs.storeSharedValue(AppConstant.isAdminLogin, "false");
      SharedPrefs.removeKey(AppConstant.showReferEarnAlert);
      AppConstant.isLoggedIn = false;
      DatabaseHelper databaseHelper = new DatabaseHelper();
      databaseHelper.deleteTable(DatabaseHelper.Categories_Table);
      databaseHelper.deleteTable(DatabaseHelper.Sub_Categories_Table);
      databaseHelper.deleteTable(DatabaseHelper.Favorite_Table);
      databaseHelper.deleteTable(DatabaseHelper.CART_Table);
      databaseHelper.deleteTable(DatabaseHelper.Products_Table);
      eventBus.fire(updateCartCount());
      Utils.showToast(AppConstant.logoutSuccess, true);

      setState(() {
        widget.userName == null;
      });
      //Pop Drawer
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _setSetUserId() async {
    try {
      if(AppConstant.isLoggedIn){
        UserModel user = await SharedPrefs.getUser();
        await Utils.analytics.setUserId('${user.id}');
        await Utils.analytics.setUserProperty(name: "userid", value: user.id);
        await Utils.analytics.setUserProperty(name: "useremail", value: user.email);
        await Utils.analytics.setUserProperty(name: "userfullName", value: user.fullName);
        await Utils.analytics.setUserProperty(name: "userphone", value: user.phone);
      }
    } catch (e) {
      print(e);
    }
  }

}



class DrawerChildItem {
  String title;
  String icon;
  DrawerChildItem(this.title, this.icon);
}

class DrawerChildConstants {
  static const HOME = "Home";
  static const MY_PROFILE = "My Profile";
  static const DELIVERY_ADDRESS = "Delivery Address";
  static const MY_ORDERS = "My Orders";
  static const LOYALITY_POINTS = "Loyality Points";
  static const MY_FAVORITES = "My Favorites";
  static const ABOUT_US = "About Us";
  static const SHARE = "Share";
  static const LOGIN = "Login";
  static const LOGOUT = "Logout";
}

