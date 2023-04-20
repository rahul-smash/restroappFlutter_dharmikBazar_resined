import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/Screens/Favourites/Favourite.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginEmailScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginMobileScreen.dart';
import 'package:restroapp/src/Screens/Offers/MyOrderScreenVersion2.dart';
import 'package:restroapp/src/Screens/SideMenu/AboutScreen.dart';
import 'package:restroapp/src/Screens/SideMenu/FAQScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/ReferEarnData.dart';
import 'package:restroapp/src/models/SocialModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/models/WalleModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:share_plus/share_plus.dart';

import 'AdditionalInformations.dart';
import 'LoyalityPoints.dart';
import 'ProfileScreen.dart';
import 'SubscriptionHistory.dart';
import 'WalletHistory.dart';

class NavDrawerMenu extends StatefulWidget {
  final StoreModel store;
  final String userName;
  SocialModel socialModel;
  WalleModel walleModel;

  NavDrawerMenu(this.store, this.userName, {this.socialModel, this.walleModel});

  @override
  _NavDrawerMenuState createState() {
    return _NavDrawerMenuState(walleModel: walleModel);
  }
}

class _NavDrawerMenuState extends State<NavDrawerMenu> {
  List<dynamic> _drawerItems = [];

  WalleModel walleModel;
  double iconHeight = 25;
  GoogleSignIn _googleSignIn;
  String walletBalance="0.0";
  _NavDrawerMenuState({this.walleModel});

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        // 'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    //print("isRefererFnEnable=${widget.store.isRefererFnEnable}");
    _drawerItems
        .add(DrawerChildItem(DrawerChildConstants.HOME, "images/home.png"));
    _drawerItems.add(DrawerChildItem(
        DrawerChildConstants.MY_PROFILE, "images/myprofile.png"));
    _drawerItems.add(DrawerChildItem(
        DrawerChildConstants.DELIVERY_ADDRESS, "images/deliveryaddress.png"));
    _drawerItems.add(
        DrawerChildItem(DrawerChildConstants.MY_ORDERS, "images/my_order.png"));
    if (widget.store.subscription.status == '1') {
      _drawerItems.add(DrawerChildItem(
          DrawerChildConstants.Subscription, "images/my_order.png"));
    }
    if (widget.store.loyality == "1")
      _drawerItems.add(DrawerChildItem(
          DrawerChildConstants.LOYALITY_POINTS, "images/loyality.png"));
    _drawerItems.add(
        DrawerChildItem(DrawerChildConstants.MY_FAVORITES, "images/myfav.png"));
//    _drawerItems.add(DrawerChildItem(
//        DrawerChildConstants.ABOUT_US, "images/about_image.png"));
    _drawerItems.add(DrawerChildItem(
        widget.store.isRefererFnEnable && AppConstant.isLoggedIn
            ? DrawerChildConstants.ReferEarn
            : DrawerChildConstants.SHARE,
        "images/refer.png"));
    _drawerItems.add(DrawerChildItem(
        DrawerChildConstants.ADDITION_INFORMATION, "images/about.png"));
    _drawerItems
        .add(DrawerChildItem(DrawerChildConstants.LOGIN, "images/sign_in.png"));
//    _drawerItems.add(DrawerChildItem(DrawerChildConstants.SUPPORT,
//        "images/sign_in.png"));
    try {
      _setSetUserId();
    } catch (e) {
      print(e);
    }
    if (AppConstant.isLoggedIn) {
      ApiController.getUserWallet().then((response) {
        setState(() {
          this.walleModel = response;
          if(walleModel!=null && walleModel?.data?.userWallet?.isNotEmpty)
            {
              if(double.parse(walleModel?.data?.userWallet)<=0.0)
                {
                  walletBalance="0.0";
                }
              else
                {
                  walletBalance=walleModel?.data?.userWallet??"0.0";
                }
            }
          else{
            walletBalance="0.0";
          }
        });
      });
    }
    if (widget.socialModel == null)
      ApiController.getStoreSocialOptions().then((value) {
        widget.socialModel = value;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          canvasColor: left_menu_background_color,
        ),
        child: Drawer(
            child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _drawerItems.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return (index == 0
                        ? Container(
                            child: Column(
                              children: [
                                createHeaderInfoItem(),
                                showUserWalletView(),
                              ],
                            ),
                          )
                        : createDrawerItem(index - 1, context));
                  }),
            ),
            Visibility(
//                    visible: socialModel != null &&
//                        socialModel.data != null &&
//                        socialModel.data.facebook.isNotEmpty ||
//                        socialModel != null &&
//                            socialModel.data != null &&
//                            socialModel.data.twitter.isNotEmpty ||
//                        socialModel != null &&
//                            socialModel.data != null &&
//                            socialModel.data.youtube.isNotEmpty ||
//                        socialModel != null &&
//                            socialModel.data != null &&
//                            socialModel.data.instagram.isNotEmpty ||
//                        socialModel != null &&
//                            socialModel.data != null &&
//                            socialModel.data.linkedin.isNotEmpty ,
                visible: true,
                child: Container(
                  color: appTheme,
                  height: 40,
                  child: Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            "Follow Us On",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Visibility(
                            visible: widget.socialModel != null &&
                                widget.socialModel.data != null &&
                                widget.socialModel.data.facebook.isNotEmpty,
                            child: InkWell(
                              onTap: () {
                                if (widget.socialModel != null) {
                                  if (widget
                                      .socialModel.data.facebook.isNotEmpty)
                                    Utils.launchURL(
                                        widget.socialModel.data.facebook);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Image.asset(
                                  "images/fbicon.png",
                                  width: iconHeight,
                                  height: iconHeight,
                                ),
                              ),
                            )),
                        Visibility(
                          visible: widget.socialModel != null &&
                              widget.socialModel.data != null &&
                              widget.socialModel.data.twitter.isNotEmpty,
                          child: InkWell(
                            onTap: () {
                              if (widget.socialModel != null) {
                                if (widget.socialModel.data.twitter.isNotEmpty)
                                  Utils.launchURL(
                                      widget.socialModel.data.twitter);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Image.asset(
                                "images/twittericon.png",
                                width: iconHeight,
                                height: iconHeight,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.socialModel != null &&
                              widget.socialModel.data != null &&
                              widget.socialModel.data.linkedin.isNotEmpty,
                          child: InkWell(
                            onTap: () {
                              if (widget.socialModel != null) {
                                if (widget.socialModel.data.linkedin.isNotEmpty)
                                  Utils.launchURL(
                                      widget.socialModel.data.linkedin);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Image.asset(
                                "images/linkedinicon.png",
                                width: iconHeight,
                                height: iconHeight,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.socialModel != null &&
                              widget.socialModel.data != null &&
                              widget.socialModel.data.youtube.isNotEmpty,
                          child: InkWell(
                            onTap: () {
                              if (widget.socialModel != null) {
                                if (widget.socialModel.data.youtube.isNotEmpty)
                                  Utils.launchURL(
                                      widget.socialModel.data.youtube);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Image.asset(
                                "images/youtubeicon.png",
                                width: iconHeight,
                                height: iconHeight,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.socialModel != null &&
                              widget.socialModel.data != null &&
                              widget.socialModel.data.instagram.isNotEmpty,
                          child: InkWell(
                            onTap: () {
                              if (widget.socialModel != null) {
                                if (widget
                                    .socialModel.data.instagram.isNotEmpty)
                                  Utils.launchURL(
                                      widget.socialModel.data.instagram);
                              }
                            },
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: Image.asset(
                                "images/instagram.png",
                                width: iconHeight,
                                height: iconHeight,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        )));
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
                  child: Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
              Flexible(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Welcome',
                          style: TextStyle(
                              color: leftMenuWelcomeTextColors,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text(
                          AppConstant.isLoggedIn == false
                              ? ''
                              : widget.userName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: leftMenuWelcomeTextColors, fontSize: 15)),
                    ]),
              ),
            ])));
  }

  Widget showUserWalletView() {
    return Visibility(
      visible: widget.store.wallet_setting == "1" ? true : false,
      child: InkWell(
        onTap: () async {
          print("showUserWalletView");
          bool isNetworkAvailable = await Utils.isNetworkAvailable();
          if (!isNetworkAvailable) {
            Utils.showToast(AppConstant.noInternet, false);
            return;
          }
          if (AppConstant.isLoggedIn) {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WalletHistoryScreen(widget.store)),
            );
            Map<String, dynamic> attributeMap = new Map<String, dynamic>();
            attributeMap["WalletHistory"] = "WalletHistoryScreen";
            Utils.sendAnalyticsEvent("Clicked ProfileScreen", attributeMap);
          } else {
            Navigator.pop(context);
            Utils.showLoginDialog(context);
          }
        },
        child: Container(
          child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: ListTile(
                //leading: Icon(Icons.account_balance_wallet,color: left_menu_icon_colors, size: 30),
                leading: Image.asset(
                  "images/walleticon.png",
                  color: left_menu_icon_colors,
                  height: 30,
                  width: 30,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Wallet Balance",
                        style: TextStyle(
                            color: leftMenuLabelTextColors, fontSize: 16)),
                    Text(
                        AppConstant.isLoggedIn
                            ? walleModel == null
                                ? "${AppConstant.currency}"
                                : "${AppConstant.currency} ${walletBalance??"0.0"}"
                            : "",
                        style: TextStyle(
                            color: leftMenuLabelTextColors, fontSize: 15)),
                  ],
                ),
              )),
        ),
      ),
    );
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

  _openPageForIndex(DrawerChildItem item, int pos, BuildContext context) async {
    switch (item.title) {
//      case DrawerChildConstants.SUPPORT:
//        if (AppConstant.isLoggedIn) {
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => ChatSupport(),
//            ));
//        } else {
//          Navigator.pop(context);
//          Utils.showLoginDialog(context);
//        }
//        break;
      case DrawerChildConstants.HOME:
        Navigator.pop(context);
        break;
      case DrawerChildConstants.MY_PROFILE:
        if (AppConstant.isLoggedIn) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen(false, "", "", null, null)),
          );
          Map<String, dynamic> attributeMap = new Map<String, dynamic>();
          attributeMap["ScreenName"] = "ProfileScreen";
          Utils.sendAnalyticsEvent("Clicked ProfileScreen", attributeMap);
        } else {
          Navigator.pop(context);
          Utils.showLoginDialog(context);
        }
        break;
      case DrawerChildConstants.DELIVERY_ADDRESS:
        if (AppConstant.isLoggedIn) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DeliveryAddressList(false, OrderType.Menu)),
          );
          Map<String, dynamic> attributeMap = new Map<String, dynamic>();
          attributeMap["ScreenName"] = "DeliveryAddressList";
          Utils.sendAnalyticsEvent("Clicked DeliveryAddressList", attributeMap);
        } else {
          Navigator.pop(context);
          Utils.showLoginDialog(context);
        }
        break;
      case DrawerChildConstants.MY_ORDERS:
        if (AppConstant.isLoggedIn) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyOrderScreenVersion2(widget.store)),
          );
          Map<String, dynamic> attributeMap = new Map<String, dynamic>();
          attributeMap["ScreenName"] = "MyOrderScreen";
          Utils.sendAnalyticsEvent("Clicked MyOrderScreen", attributeMap);
        } else {
          Navigator.pop(context);
          Utils.showLoginDialog(context);
        }
        break;
      case DrawerChildConstants.Subscription:
        if (AppConstant.isLoggedIn) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubscriptionHistory(widget.store)),
          );
          Map<String, dynamic> attributeMap = new Map<String, dynamic>();
          attributeMap["ScreenName"] = "Subscription";
          Utils.sendAnalyticsEvent("Clicked Subscription", attributeMap);
        } else {
          Navigator.pop(context);
          Utils.showLoginDialog(context);
        }
        break;
      case DrawerChildConstants.LOYALITY_POINTS:
        if (AppConstant.isLoggedIn) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoyalityPointsScreen(widget.store)),
          );
        } else {
          Navigator.pop(context);
          Utils.showLoginDialog(context);
        }

        break;
      case DrawerChildConstants.MY_FAVORITES:
        if (AppConstant.isLoggedIn) {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Favourites(() {})),
          );
          Map<String, dynamic> attributeMap = new Map<String, dynamic>();
          attributeMap["ScreenName"] = "Favourites";
          Utils.sendAnalyticsEvent("Clicked Favourites", attributeMap);
        } else {
          Navigator.pop(context);
          Utils.showLoginDialog(context);
        }
        break;
      case DrawerChildConstants.ABOUT_US:
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen(widget.store)),
        );
        Map<String, dynamic> attributeMap = new Map<String, dynamic>();
        attributeMap["ScreenName"] = "AboutScreen";
        Utils.sendAnalyticsEvent("Clicked AboutScreen", attributeMap);
        break;

      case DrawerChildConstants.ADDITION_INFORMATION:
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdditionalInformation(widget.store)),
        );
        Map<String, dynamic> attributeMap = new Map<String, dynamic>();
        attributeMap["ScreenName"] = "AdditionalInformation";
        Utils.sendAnalyticsEvent("Clicked AdditionalInformation", attributeMap);
        break;
      case DrawerChildConstants.ReferEarn:
      case DrawerChildConstants.SHARE:
        if (AppConstant.isLoggedIn) {
          if (widget.store.isRefererFnEnable) {
            Navigator.pop(context);

            Utils.showProgressDialog(context);
            ReferEarnData referEarn = await ApiController.referEarn();
            Utils.hideProgressDialog(context);
            share2(referEarn.referEarn.sharedMessage, widget.store);
          } else {
            Utils.showToast("Refer Earn is inactive!", true);
            share2(null, widget.store);
          }
        } else {
          Navigator.pop(context);
          if (widget.store.isRefererFnEnable) {
            var result = await DialogUtils.showInviteEarnAlert(context);
          } else {
            share2(null, widget.store);
          }
        }
        //share();

        Map<String, dynamic> attributeMap = new Map<String, dynamic>();
        attributeMap["ScreenName"] = "share apk url";
        Utils.sendAnalyticsEvent("Clicked share", attributeMap);

        //DialogUtils.showInviteEarnAlert2(context);

        break;
      case DrawerChildConstants.LOGIN:
      case DrawerChildConstants.LOGOUT:
        if (AppConstant.isLoggedIn) {
          _showDialog(context);
        } else {
          Navigator.pop(context);
          SharedPrefs.getStore().then((storeData) {
            StoreModel model = storeData;
            print("---internationalOtp--${model.internationalOtp}");
            //User Login with Mobile and OTP = 0
            // 1 = email and 0 = ph-no
            if (model.internationalOtp == "0") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginMobileScreen("menu")),
              );
              Map<String, dynamic> attributeMap = new Map<String, dynamic>();
              attributeMap["ScreenName"] = "LoginMobileScreen";
              Utils.sendAnalyticsEvent(
                  "Clicked LoginMobileScreen", attributeMap);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginEmailScreen("menu")),
              );
              Map<String, dynamic> attributeMap = new Map<String, dynamic>();
              attributeMap["ScreenName"] = "LoginEmailScreen";
              Utils.sendAnalyticsEvent(
                  "Clicked LoginEmailScreen", attributeMap);
            }
          });
        }
        break;
      case DrawerChildConstants.FAQ:
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FAQScreen(widget.store)),
        );
        Map<String, dynamic> attributeMap = new Map<String, dynamic>();
        attributeMap["ScreenName"] = "FAQ";
        Utils.sendAnalyticsEvent("Clicked AboutScreen", attributeMap);
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
            new TextButton(
              child: new Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('YES'),
              onPressed: () async {
                Navigator.of(context).pop();
                logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> share() async {
    Share.share(
        'Kindly download ${widget.store.storeName} app from ${Platform.isIOS ? widget.store.iphoneShareLink : widget.store.androidShareLink}',
        subject: 'Share');
  }

  Future<void> share2(String referEarn, StoreModel store) async {
    if (referEarn != null && store.isRefererFnEnable) {
      Share.share('${store.storeName} $referEarn', subject: 'Refer & Earn');
    } else {
      Share.share(
          'Kindly download ${store.storeName} app from ${Platform.isIOS ? store.iphoneShareLink : store.androidShareLink}',
          subject: 'Share');
    }
  }

  Future logout(BuildContext context) async {
    try {
      // FacebookLogin facebookSignIn = new FacebookLogin();
      // var facebookSignIn = FacebookAuth.instance;
      // bool isFbLoggedIn = await facebookSignIn.isLoggedIn;
      // print("isFbLoggedIn=${isFbLoggedIn}");
      // if (isFbLoggedIn) {
      // await facebookSignIn.logOut();
      // }

      bool isGoogleSignedIn = await _googleSignIn.isSignedIn();
      if (isGoogleSignedIn) {
        await _googleSignIn.signOut();
      }

      SharedPrefs.setUserLoggedIn(false);
      SharedPrefs.storeSharedValue(AppConstant.isAdminLogin, "false");
      SharedPrefs.removeKey(AppConstant.showReferEarnAlert);
      SharedPrefs.removeKey(AppConstant.referEarnMsg);
      SharedPrefs.removeKey("user_wallet");
      SharedPrefs.removeKey("user");

      AppConstant.isLoggedIn = false;
      DatabaseHelper databaseHelper = new DatabaseHelper();
      // databaseHelper.deleteTable(DatabaseHelper.Categories_Table);
      // databaseHelper.deleteTable(DatabaseHelper.Sub_Categories_Table);
      databaseHelper.deleteTable(DatabaseHelper.Favorite_Table);
      databaseHelper.deleteTable(DatabaseHelper.CART_Table);
      // databaseHelper.deleteTable(DatabaseHelper.Products_Table);
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
      if (AppConstant.isLoggedIn) {
        UserModel user = await SharedPrefs.getUser();
        await Utils.analytics.setUserId(id: '${user.id}');
        await Utils.analytics.setUserProperty(name: "userid", value: user.id);
        await Utils.analytics
            .setUserProperty(name: "useremail", value: user.email);
        await Utils.analytics
            .setUserProperty(name: "userfullName", value: user.fullName);
        await Utils.analytics
            .setUserProperty(name: "userphone", value: user.phone);
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
  static const Subscription = "Subscription";
  static const MY_PROFILE = "My Profile";
  static const DELIVERY_ADDRESS = "Delivery Address";
  static const MY_ORDERS = "My Orders";
  static const LOYALITY_POINTS = "Loyalty Points";
  static const MY_FAVORITES = "My Favorites";
  static const ABOUT_US = "About Us";
  static const ADDITION_INFORMATION = "Additional \nInformation";
  static const SHARE = "Share";
  static const FAQ = "FAQ";
  static const TERMS_CONDITIONS = "Terms and Conditions";
  static const PRIVACY_POLICY = "Privacy Policy";
  static const REFUND_POLICY = "Refund Policy";
  static const ReferEarn = "Refer & Earn";
  static const LOGIN = "Login";
  static const LOGOUT = "Logout";
  static const SUPPORT = "Support";
}
