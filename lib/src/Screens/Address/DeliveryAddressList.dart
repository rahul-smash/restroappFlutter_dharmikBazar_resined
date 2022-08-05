import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

// import 'package:package_info/package_info.dart';
import 'package:restroapp/src/Screens/Address/SaveDeliveryAddress.dart';
import 'package:restroapp/src/UI/DragMarkerMap.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/CategoryResponseModel.dart';
import 'package:restroapp/src/models/ConfigModel.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreBranchesModel.dart';
import 'package:restroapp/src/models/StoreRadiousResponse.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

import '../../models/SubCategoryResponse.dart';
import '../../models/weight_wise_charges_response.dart';
import '../BookOrder/ConfirmOrderScreen.dart';

//DeliveryAddressList
class DeliveryAddressList extends StatefulWidget {
  final bool showProceedBar;
  OrderType delivery;

  DeliveryAddressList(this.showProceedBar, this.delivery);

  @override
  _AddDeliveryAddressState createState() => _AddDeliveryAddressState();
}

class _AddDeliveryAddressState extends State<DeliveryAddressList> {
  int selectedIndex = 0;
  List<DeliveryAddressData> addressList = [];
  Area radiusArea;

  // Coordinates coordinates;
  bool isLoading = false;
  DeliveryAddressResponse responsesData;
  BranchData branchData;
  StoreModel store;
  CategoryResponse categoryResponse;
  Location location = new Location();

  ConfigModel configObject;
  PermissionStatus _permissionGranted;

  bool _serviceEnabled;

  @override
  void initState() {
    super.initState();
    // coordinates = new Coordinates(0.0, 0.0);
    callDeliverListApi();
  }

  callDeliverListApi() {
    isLoading = true;
    ApiController.getAddressApiRequest().then((responses) async {
      responsesData = responses;
      addressList = responsesData.data;
//      addressList = await Utils.checkDeletedAreaFromStore(context, addressList,
//          showDialogBool: true, hitApi: false);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: addressList != null
          ? AppBar(
              title: Text("Delivery Addresses"),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.pop(context, false),
              ),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 0.0, bottom: 0.0, left: 0, right: 10),
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            )
          : AppBar(
              title: Text("Account Issue"),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : addressList == null
              ? WillPopScope(
                  onWillPop: () {
                    logout(context, branchData);
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      //title: Text(title,textAlign: TextAlign.center,),
                      child: Container(
                        child: Wrap(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                              child: Center(
                                child: Text(
                                  "Account Issue",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: grayColorTitle, fontSize: 18),
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
                                  "${responsesData.message}",
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
                                    child: FlatButton(
                                      child: Text('OK'),
                                      color: appThemeSecondary,
                                      textColor: Colors.white,
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
                )
              : Column(
                  children: <Widget>[
                    Divider(color: Colors.white, height: 2.0),
                    addCreateAddressButton(),
                    addAddressList()
                  ],
                ),
      bottomNavigationBar: addressList == null
          ? Container(height: 5)
          : SafeArea(
              child: widget.showProceedBar
                  ? addProceedBar()
                  : Container(height: 5),
            ),
    );
  }

  Widget addCreateAddressButton() {
    return Container(
      height: 50.0,
      color: appTheme,
      child: InkWell(
        onTap: () async {
          print("----addCreateAddressButton-------");

          StoreModel store = await SharedPrefs.getStore();
          print("--deliveryArea->--${store.deliveryArea}-------");
          if (store.deliveryArea == "1") {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      SaveDeliveryAddress(null, () {
                    print("--Route-SaveDeliveryAddress-------");
                  }, "", 0.0, 0.0),
                  fullscreenDialog: true,
                ));
            print("--result--${result}-------");
            if (result == true) {
              //Utils.showProgressDialog(context);
              setState(() {
                isLoading = true;
              });
              DeliveryAddressResponse response =
                  await ApiController.getAddressApiRequest();
              //Utils.hideProgressDialog(context);
              setState(() {
                //addressList = null;
                isLoading = false;
                addressList = response.data;
              });
            } else {
              print("--result--else------");
            }
          } else if (store.deliveryArea == "0") {
            Utils.isNetworkAvailable().then((isConnected) {
              if (isConnected) {
                Utils.showProgressDialog(context);
                ApiController.storeRadiusApi().then((response) async {
                  Utils.hideProgressDialog(context);
                  if (response != null && response.success) {
                    StoreRadiousResponse data = response;
                    Geolocator.isLocationServiceEnabled()
                        .then((isLocationServiceEnabled) async {
                      print(
                          "----isLocationServiceEnabled----${isLocationServiceEnabled}--");
                      if (isLocationServiceEnabled) {
                        //------permission checking------
                        _serviceEnabled = await location.serviceEnabled();
                        if (!_serviceEnabled) {
                          _serviceEnabled = await location.requestService();
                          if (!_serviceEnabled) {
                            print("----!_serviceEnabled----$_serviceEnabled");
                            return;
                          }
                        }
                        _permissionGranted = await location.hasPermission();
                        print("permission sttsu $_permissionGranted");
                        if (_permissionGranted == PermissionStatus.denied) {
                          print("permission deniedddd");
                          _permissionGranted =
                              await location.requestPermission();
                          if (_permissionGranted != PermissionStatus.granted) {
                            print("permission not grantedd");

                            return;
                          }
                        }
                        //------permission checking over------

                        var result = await Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  DragMarkerMap(data),
                              fullscreenDialog: true,
                            ));
                        if (result != null) {
                          radiusArea = result;
                          print("----radiusArea = result-------");
                          //Utils.showProgressDialog(context);
                          setState(() {
                            isLoading = true;
                          });
                          DeliveryAddressResponse response =
                              await ApiController.getAddressApiRequest();
                          //Utils.hideProgressDialog(context);
                          setState(() {
                            print("----setState-------");
                            isLoading = false;
                            //addressList = null;
                            addressList = response.data;
                          });
                        }
                      } else {
                        Utils.showToast("Please turn on gps!", false);
                      }
                    });
                  } else {
                    Utils.showToast("No data found!", false);
                  }
                });
              } else {
                Utils.showToast(AppConstant.noInternet, false);
              }
            });
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_circle_outline,
              color: Colors.white,
              size: 35.0,
            ),
            Text(
              "Add Delivery Address",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
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

  Widget addAddressList() {
    //Utils.hideProgressDialog(context);
    if (addressList.isEmpty) {
      return Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Text("No Delivery Address found!"),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: addressList.length,
          itemBuilder: (context, index) {
            DeliveryAddressData area = addressList[index];
            return addAddressCard(area, index);
          },
        ),
      );
    }
  }

  Widget addAddressCard(DeliveryAddressData area, int index) {
    return Card(
      child: Padding(
          padding: EdgeInsets.only(top: 10, left: 6),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: (Utils.getDeviceWidth(context) - 100),
                    child: Text(
                      "${area.firstName}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16.0),
                    ),
                  ),
                  addAddressInfoRow(Icons.phone, area.mobile),
                  addAddressInfoRow(
                    Icons.location_on,
                    area.address2 != null && area.address2.trim().isNotEmpty
                        ? '${area.address != null && area.address.trim().isNotEmpty ? '${area.address}, ${area.address2}' : "${area.address2}"}'
                        : area.address,
                  ),
                  addAddressInfoRow(Icons.email, area.email),
                ],
              ),
              Container(
                child: Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      activeColor: Color(0xFFE0E0E0),
                      checkColor: Colors.green,
                      value: selectedIndex == index,
                      onChanged: (value) {
                        setState(() {
                          print("index = ${index}");
                          selectedIndex = index;
                        });
                      },
                    )),
              )
            ]),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              child: Divider(color: Color(0xFFBDBDBD), thickness: 1.0),
            ),
            addOperationBar(area, index)
          ])),
    );
  }

  Widget addAddressInfoRow(IconData icon, String info) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 5, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //Icon(icon, color: Colors.grey,),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: SizedBox(
              width: (Utils.getDeviceWidth(context) - 130),
              child: Text(info,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: infoLabel)),
            ),
          ),
        ],
      ),
    );
  }

  Widget addOperationBar(DeliveryAddressData area, int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 5, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: InkWell(
              child: Align(
                alignment: Alignment.center,
                child: Text("Edit Address",
                    style: TextStyle(
                        color: infoLabel, fontWeight: FontWeight.w500)),
              ),
              onTap: () async {
                var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SaveDeliveryAddress(area, () {
                        print('@@---Edit---SaveDeliveryAddress----------');
                      }, "", 0.0, 0.0),
                      fullscreenDialog: true,
                    ));
                print("-Edit-result--${result}-------");
                if (result == true) {
                  setState(() {
                    isLoading = true;
                  });
                  DeliveryAddressResponse response =
                      await ApiController.getAddressApiRequest();
                  //Utils.hideProgressDialog(context);
                  setState(() {
                    //addressList = null;
                    isLoading = false;
                    addressList = response.data;
                  });
                }
              },
            ),
          ),
          Container(
            color: Colors.grey,
            height: 30,
            width: 1,
          ),
          Flexible(
              child: InkWell(
            child: Align(
              alignment: Alignment.center,
              child: new Text("Remove Address",
                  style:
                      TextStyle(color: infoLabel, fontWeight: FontWeight.w500)),
            ),
            onTap: () async {
              print("--selectedIndex ${selectedIndex} and ${index}");
              var results = await DialogUtils.displayDialog(
                  context, "Delete", AppConstant.deleteAddress, "Cancel", "OK");
              if (results == true) {
                Utils.showProgressDialog(context);
                ApiController.deleteDeliveryAddressApiRequest(area.id)
                    .then((response) async {
                  Utils.hideProgressDialog(context);
                  if (response != null && response.success) {
                    print("---showDialogForDelete-----");
                    setState(() {
                      addressList.removeAt(index);
                      print("--selectedIndex ${selectedIndex} and ${index}");
                      if (selectedIndex == index && addressList.isNotEmpty) {
                        selectedIndex = 0;
                      }
                    });
                    /*Utils.showProgressDialog(context);
                    DeliveryAddressResponse response = await ApiController.getAddressApiRequest();
                    setState(() {
                      Utils.hideProgressDialog(context);
                      addressList = response.data;
                    });*/
                  }
                });
              }
              //showDialogForDelete(area);
            },
          )),
        ],
      ),
    );
  }

  Widget addProceedBar() {
    return Container(
      height: 50.0,
      color: appTheme,
      child: InkWell(
        onTap: () async {
          StoreModel storeModel = await SharedPrefs.getStore();
          DeliveryAddressData addressData =
              DeliveryAddressData.copyWith(item: addressList[selectedIndex]);
          if (storeModel.enableWeightWiseCharges == '1') {
            String shippingCharges =
                await calculateShipping(addressList[selectedIndex]);
            Utils.showProgressDialog(context);
            DatabaseHelper databaseHelper = new DatabaseHelper();
            List<Product> cartList = await databaseHelper.getCartItemList();
            String orderJson = await Utils.getCartListToJson(cartList);

            WeightWiseChargesResponse chargesResponse =
                await ApiController.getWeightWiseShippingCharges(
                    orderDetail: orderJson,
                    areaShippingCharge: shippingCharges);
            if (chargesResponse != null &&
                chargesResponse.success &&
                chargesResponse.data != null) {
              //update changes according to weight
              addressData.areaCharges =
                  chargesResponse.data.totalDeliveryCharge;
            }
            Utils.hideProgressDialog(context);
          }

          if (addressList.length == 0) {
            Utils.showToast(AppConstant.selectAddress, false);
          } else {
            print("minAmount=${addressList[selectedIndex].minAmount}");
            print("notAllow=${addressList[selectedIndex].notAllow}");
            if (addressList[selectedIndex].note.isEmpty) {
              if (widget.delivery == OrderType.SubScription) {
                eventBus.fire(onAddressSelected(addressList[selectedIndex]));
                Navigator.pop(context);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmOrderScreen(
                            addressData,
                            false,
                            "",
                            widget.delivery,
                            storeModel: storeModel,
                          )),
                );
              }
            } else {
              var result = await DialogUtils.displayOrderConfirmationDialog(
                context,
                "Confirmation",
                addressList[selectedIndex].note,
              );
              if (result == true) {
                if (widget.delivery == OrderType.SubScription) {
                  eventBus.fire(onAddressSelected(addressList[selectedIndex]));
                  Navigator.pop(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmOrderScreen(
                              addressData,
                              false,
                              "",
                              widget.delivery,
                              storeModel: storeModel,
                            )),
                  );
                }
              }
            }
            //Code Commented Due to not approved by client
            /* StoreModel storeModel = await SharedPrefs.getStore();
            bool isPaymentModeOnline = false;

            if (storeModel.onlinePayment == "1") {
              isPaymentModeOnline = true;
            } else {
              widget.paymentMode = "2"; //cod
            }
            //case 1: payment mode off and no note
            //case 2: payment mode ON and no note
            //case 3: payment mode On and Having Note

            if (!isPaymentModeOnline &&
                addressList[selectedIndex].note.isEmpty) {
              widget.paymentMode = "2";
            } else {
              var result =
                  await DialogUtils.displayOrderPaymentConfirmationDialog(
                      context,
//                      "Confirmation",
                      "Select Payment",
                      addressList[selectedIndex].note,
                      isPaymentModeOnline);

              if (result == PaymentType.CANCEL) {
                return;
              }
              if (result == PaymentType.ONLINE) {
                widget.paymentMode = "3";
              } else {
                widget.paymentMode = "2"; //cod
              }
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConfirmOrderScreen(
                        addressList[selectedIndex],
                        false,
                        "",
                        widget.delivery,
                        paymentMode: widget.paymentMode,
                      )),
            );*/
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.delivery == OrderType.SubScription
                ? Text(
                    "Select",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )
                : Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
          ],
        ),
      ),
    );
  }

  Future<String> calculateShipping(DeliveryAddressData addressList) async {
    int minAmount = 0;
    String shippingCharges = addressList.areaCharges;
    try {
      minAmount = double.parse(addressList.minAmount).toInt();
    } catch (e) {
      print(e);
    }
    DatabaseHelper databaseHelper = DatabaseHelper();
    double totalPrice = await databaseHelper.getTotalPrice();
    int mtotalPrice = totalPrice.round();

    print("----minAmount=${minAmount}");
    print("--Cart--mtotalPrice=${mtotalPrice}");
    print("----shippingCharges=${shippingCharges}");

    if (addressList.notAllow) {
      if (mtotalPrice <= minAmount) {
        print("---Cart-totalPrice is less than min amount----}");
        // then Store will charge shipping charges.

        totalPrice = mtotalPrice.toDouble();
      } else {
        totalPrice = mtotalPrice.toDouble();
      }
    } else {
      if (mtotalPrice <= minAmount) {
        print("---Cart-totalPrice is less than min amount----}");
        // then Store will charge shipping charges.
        totalPrice = totalPrice + int.parse(shippingCharges);
      } else {
        print("-Cart-totalPrice is greater than min amount---}");
        //then Store will not charge shipping.
        totalPrice = totalPrice;
        print(
            "---------- shipping mandatory ----------- ${addressList.isShippingMandatory}");
        if (addressList.isShippingMandatory == '0') {
          shippingCharges = "0";
          addressList.areaCharges = "0";
        }
      }
    }
    return shippingCharges;
  }
}
