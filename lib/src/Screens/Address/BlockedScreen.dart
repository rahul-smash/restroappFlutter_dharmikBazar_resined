import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/models/ConfigModel.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreBranchesModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/Utils.dart';

class UserBlocked extends StatefulWidget {
  DeliveryAddressResponse responseData;
  UserBlocked(this.responseData);

  @override
  _UserBlockedState createState() => _UserBlockedState();
}

class _UserBlockedState extends State<UserBlocked> {
  BranchData branchData;
  StoreModel store;
  CategoryResponse categoryResponse;
  ConfigModel configObject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Account Issue"),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: WillPopScope(
          onWillPop: () {
            logout(context, branchData);
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Container(
                child: Wrap(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Center(
                        child: Text(
                          "Account Issue",
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
                          "${widget.responseData.message}",
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
                              style: Utils.getButtonDecoration(
                                color: appThemeSecondary
                              ),

                              onPressed: () {
                                logout(context, branchData);
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ));
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
      print(storeData);
      CategoryResponse categoryResponse =
          await ApiController.getCategoriesApiRequest(storeData.store.id);
      print(categoryResponse);
      setState(() {
        this.store = storeData.store;
        this.branchData = selectedStore;
        this.categoryResponse = categoryResponse;
        Utils.hideProgressDialog(context);
      });
      print(store);
      print(configObject);
    } catch (e) {
      print(e);
    }
  }
}
