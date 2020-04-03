import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:restroapp/src/Screens/SideMenu/AboutScreen.dart';
import 'package:restroapp/src/Screens/SideMenu/AddDeliveryAddressScreen.dart';
import 'package:restroapp/src/Screens/BookNowScreen.dart';
import 'package:restroapp/src/Screens/LoginSignUp/LoginScreen.dart';
import 'package:restroapp/src/Screens/SideMenu/MyOrderScreen.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';

import '../SideMenu/ProfileScreen.dart';

class SideMenuScreen extends StatelessWidget {
  final StoreModel store;
  final String userName;
  SideMenuScreen(this.store, this.userName);

  final _drawerItems = [
    DrawerChildItem('Home', Icon(Icons.home)),
    DrawerChildItem('My Profile', Icon(Icons.account_circle)),
    DrawerChildItem('Delivery Address', Icon(Icons.location_on)),
    DrawerChildItem('My Orders', Icon(Icons.shopping_cart)),
    DrawerChildItem('Book Now', Icon(Icons.assignment)),
    DrawerChildItem('My Favorites', Icon(Icons.favorite)),
    DrawerChildItem('About Us', Icon(Icons.account_box)),
    DrawerChildItem('Refer & Earn', Icon(Icons.share)),
    DrawerChildItem('Login', Icon(Icons.exit_to_app)),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: _drawerItems.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return (index == 0
                ? UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.black,
                    ),
                    accountName: Text('Welcome'),
                    accountEmail: Text(userName ?? ''),
                    currentAccountPicture:
                        Image.asset("images/ic_launcher.png"),
                  )
                : createDrawerItem(index - 1, context));
          }),
    );
  }

  Widget createDrawerItem(int index, BuildContext context) {
    var item = _drawerItems[index];
    return ListTile(
      leading: item.icon,
      title: index == _drawerItems.length - 1
          ? Text(userName == null ? 'Login' : 'Logout')
          : Text(item.title),
      onTap: () {
        _openPageForIndex(index, context);
      },
    );
  }

  _openPageForIndex(int pos, BuildContext context) {
    switch (pos) {
      case 0:
        Navigator.pop(context);
        break;
      case 1:
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
      case 2:
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddDeliveryAddress()),
        );
        break;
      case 3:
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyOrderScreen(context)),
        );
        break;
      case 4:
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookNowScreen(context)),
        );
        break;
      case 5:
        Navigator.pop(context);
        break;
      case 6:
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen(context)),
        );
        break;
      case 7:
        share();
        break;
      case 8:
        if (userName != null) {
          _showDialog(context);
        } else {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
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

  Future logout(BuildContext context) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.clear().then((status) {
        if (status == true) {
          DatabaseHelper databaseHelper = new DatabaseHelper();
          databaseHelper.deleteTable(DatabaseHelper.Categories_Table);
          databaseHelper.deleteTable(DatabaseHelper.Sub_Categories_Table);
          databaseHelper.deleteTable(DatabaseHelper.Products_Table);
          databaseHelper.deleteTable(DatabaseHelper.CART_Table);

          Utils.showToast(AppConstant.logoutSuccess, true);
        }
      });
      //Pop Drawer
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Kindly download',
        text: 'Kindly download' + store.storeName + 'app from',
        linkUrl: store.androidShareLink,
        chooserTitle: 'Refer & Earn');
  }
}

class DrawerChildItem {
  String title;
  Icon icon;
  DrawerChildItem(this.title, this.icon);
}
