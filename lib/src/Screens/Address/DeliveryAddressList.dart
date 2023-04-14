import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

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
import 'package:restroapp/src/models/ThirdPartyDeliveryResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';
import '../../models/SubCategoryResponse.dart';
import '../../models/weight_wise_charges_response.dart';
import '../BookOrder/ConfirmOrderScreen.dart';

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
  Coordinates coordinates;
  bool isLoading = false;
  DeliveryAddressResponse responsesData;
  BranchData branchData;
  StoreModel store;
  CategoryResponse categoryResponse;
  ConfigModel configObject;
  bool isTPDSError = false;

  @override
  void initState() {
    super.initState();
    coordinates = new Coordinates(0.0, 0.0);
    getStoreData();
    callDeliverListApi();
  }

  getStoreData() async {
    store = await SharedPrefs.getStore();
  }

  callDeliverListApi() {
    isLoading = true;
    ApiController.getAddressApiRequest().then((responses) async {
      responsesData = responses;
      addressList = responsesData.data;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: whiteColor,
            statusBarIconBrightness: Brightness.dark),
        child: SafeArea(
          child: Scaffold(
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
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0))),
                            //title: Text(title,textAlign: TextAlign.center,),
                            child: Container(
                              child: Wrap(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    child: Center(
                                      child: Text(
                                        "Account Issue",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: grayColorTitle,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height: 1,
                                      color: Colors.black45,
                                      width: MediaQuery.of(context).size.width),
                                  Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(10, 15, 10, 10),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin:
                                              EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: TextButton(
                                            child: Text('OK'),
                                            style: Utils.getButtonDecoration(
                                                color: appThemeSecondary),
                                            onPressed: () {
                                              logout(context, branchData);
                                              Navigator.popUntil(context,
                                                  (route) => route.isFirst);
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
          ),
        ));
  }

  Widget addCreateAddressButton() {
    return Container(
      height: 50.0,
      color: appTheme,
      child: InkWell(
        onTap: () async {
          store = await SharedPrefs.getStore();
          if (store.deliveryArea == "0") {
            _navigateToSaveDeliveryAddress();
          } else if (store.deliveryArea == "1") {
            _navigateToMapArea();
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
                  addAddressInfoRow(
                      Icons.location_on,
                      area.zipCode != null && area.zipCode.trim().isNotEmpty
                          ? '${area.zipCode != null && area.zipCode.trim().isNotEmpty ? '${area.zipCode}' : ""}'
                          : ""),
                  addAddressInfoRow(Icons.email, area.email),
                ],
              ),
              Column(
                children: [
                  Container(
                    child: Transform.scale(
                        scale: 1.5,
                        child: Checkbox(
                          activeColor: Color(0xFFE0E0E0),
                          checkColor: Colors.green,
                          value: selectedIndex == index,
                          onChanged: (value) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        )),
                  ),
                  Align(
                      alignment: Alignment.topRight,
                      child: Visibility(
                        child: Wrap(
                          children: [
                            Container(
//                        width: 70,
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                border:
                                    Border.all(color: grayLightColorSecondary),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                area.addressType != null &&
                                        area.addressType.isNotEmpty
                                    ? area.addressType
                                    : '',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        visible: area.addressType != null &&
                            area.addressType.isNotEmpty,
                      ))
                ],
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
                // var result = await Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (BuildContext context) =>
                //           SaveDeliveryAddress(area, () {
                //         print('@@---Edit---SaveDeliveryAddress----------');
                //       }, "", 0.0, 0.0),
                //       fullscreenDialog: true,
                //     ));
                // if (result == true) {
                //   setState(() {
                //     isLoading = true;
                //   });
                //   DeliveryAddressResponse response =
                //       await ApiController.getAddressApiRequest();
                //   //Utils.hideProgressDialog(context);
                //   setState(() {
                //     //addressList = null;
                //     isLoading = false;
                //     addressList = response.data;
                //   });
                // }
                if (store.deliveryArea == "0") {
                  _navigateToSaveDeliveryAddress(addressData: area);
                } else if (store.deliveryArea == "1") {
                  _navigateToMapArea(deliveryAddressData: area);
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
          if (addressList != null && addressList.length != 0) {
            DeliveryAddressData addressData =
                DeliveryAddressData.copyWith(item: addressList[selectedIndex]);
            if (storeModel.storeDeliveryModel ==
                AppConstant.DELIVERY_THIRD_PARTY) {
              if (addressData.zipCode == null ||
                  (addressData.zipCode != null &&
                      addressData.zipCode.isEmpty)) {
                Utils.showToast('ZipCode is mandatory ', false);
                return addressData;
              } else if (addressData.zipCode != null &&
                  addressData.zipCode.length != 6) {
                Utils.showToast('Please add valid ZipCode', false);
                return addressData;
              }
            }
            await checkingStoreDeliverymodel(storeModel, addressData);
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

    if (addressList.notAllow) {
      if (mtotalPrice <= minAmount) {
        print("---Cart-totalPrice is less than min amount----}");
        // then Store will charge shipping charges.

        totalPrice = mtotalPrice.toDouble();
      } else {
        totalPrice = mtotalPrice.toDouble();
        if (addressList.isShippingMandatory == '0') {
          shippingCharges = "0";
          addressList.areaCharges = "0";
        }
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

  checkingStoreDeliverymodel(
      StoreModel store, DeliveryAddressData addressData) async {
    isTPDSError = false;

    if (addressData.deliveryMode == "2" &&
        store.storeDeliveryModel == AppConstant.DELIVERY_THIRD_PARTY) {
      Utils.showProgressDialog(context);
      DatabaseHelper databaseHelper = new DatabaseHelper();
      List<Product> cartList = await databaseHelper.getCartItemList();
      String orderJson = await Utils.getCartListToJson(cartList);
      debugPrint("orderJson===${orderJson}");
      ThirdPartyDeliveryResponse chargesResponse =
          await ApiController.getDeliveryShippingChargesApi(
              orderDetail: orderJson, userZipcode: addressData.zipCode);
      Utils.hideProgressDialog(context);
      if (chargesResponse != null &&
          chargesResponse.success &&
          chargesResponse.data != null) {
        //update changes according to weight
        if (chargesResponse.data.errorMsg != null) {
          Utils.showToast(chargesResponse.data.errorMsg, false);
          isTPDSError = true;
        }
        addressData.thirdPartyDeliveryData = chargesResponse.data;
      } else {
        isTPDSError = true;
        if (chargesResponse.message != null) {
          Utils.showToast(chargesResponse.message, false);
          DialogUtils.displayLocationNotAvailbleDialog(
              context, chargesResponse.message, buttonText1: 'Change Zipcode',
              button1: () {
            Navigator.pop(context);
            _editAddress(addressData);
          });
        }
      }
    } else if (addressData.deliveryMode  == "1" &&
        store.storeDeliveryModel == AppConstant.DELIVERY_THIRD_PARTY) {
      addressData.areaCharges = addressData.areaCharges;
    } else if (addressData.deliveryMode  == "1" &&
        store.storeDeliveryModel == AppConstant.DELIVERY_WEIGHTWISE) {
      if (store.enableWeightWiseCharges == '1') {
        String shippingCharges =
            await calculateShipping(addressList[selectedIndex]);
        Utils.showProgressDialog(context);
        DatabaseHelper databaseHelper = new DatabaseHelper();
        List<Product> cartList = await databaseHelper.getCartItemList();
        String orderJson = await Utils.getCartListToJson(cartList);
        WeightWiseChargesResponse chargesResponse =
            await ApiController.getWeightWiseShippingCharges(
                orderDetail: orderJson, areaShippingCharge: shippingCharges);
        Utils.hideProgressDialog(context);
        if (chargesResponse != null &&
            chargesResponse.success &&
            chargesResponse.data != null) {
          //update changes according to weight
          addressData.areaCharges = chargesResponse.data.totalDeliveryCharge;

        }
      }
    } else if (addressData.deliveryMode == "1" &&
        store.storeDeliveryModel == AppConstant.DELIVERY_VALUEAPP) {
    } else {
      addressData.areaCharges = addressData.areaCharges;
    }

    if (addressData != null) {
      if (!isTPDSError) {
        if (addressList.length == 0) {
          Utils.showToast(AppConstant.selectAddress, false);
        } else {
          if (addressList[selectedIndex].note.isEmpty) {
            if (widget.delivery == OrderType.SubScription) {
              eventBus.fire(onAddressSelected(addressList[selectedIndex]));
              Navigator.pop(context);
            } else {
              debugPrint("=areacharges ${addressData?.areaCharges}");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ConfirmOrderScreen(
                          addressData,
                          false,
                          "",
                          widget.delivery,
                          storeModel: store,
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
              }
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
    } else {
      Utils.showToast("We can not deliver at your location!", false);
    }
  }

  Future<Area> checkIfOrderDeliveryWithInRadious(int distanceInKms,
      StoreRadiousResponse data, DeliveryAddressData addressData) async {
    if (data != null) {
      try {
        Area area;

        RadiousData radiousData = data.data
            .singleWhere((element) => element.city.id == addressData.cityId);
        Area areaObject = radiousData.area
            .singleWhere((element) => element.areaId == addressData.areaId);
        int radius = int.parse(areaObject.radius);

        if (distanceInKms < radius && areaObject.radiusCircle == "Within") {
          area = areaObject;
          setState(() {});
        }
        if (area != null) {
          return area;
        } else {
          Utils.showToast("We can not deliver at your location!", false);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void _editAddress(DeliveryAddressData area) async {
    if (store.deliveryArea == "0") {
      _navigateToSaveDeliveryAddress(addressData: area);
    } else if (store.deliveryArea == "1") {
      _navigateToMapArea(deliveryAddressData: area);
    }
  }

  _navigateToSaveDeliveryAddress({DeliveryAddressData addressData}) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              SaveDeliveryAddress(addressData, () {
            print("--Route-SaveDeliveryAddress-------");
          }, "", coordinates.latitude, coordinates.longitude),
          fullscreenDialog: true,
        ));
    if (result == true) {
      setState(() {
        isLoading = true;
      });
      DeliveryAddressResponse response =
          await ApiController.getAddressApiRequest();
      setState(() {
        isLoading = false;
        addressList = response.data;
      });
    }
  }

  _navigateToMapArea({DeliveryAddressData deliveryAddressData}) {
    return Utils.isNetworkAvailable().then((isConnected) {
      if (isConnected) {
        Utils.showProgressDialog(context);
        ApiController.storeRadiusApi().then((response) async {
          Utils.hideProgressDialog(context);
          if (response != null && response.success) {
            StoreRadiousResponse data = response;
            Geolocator.isLocationServiceEnabled()
                .then((isLocationServiceEnabled) async {
              if (isLocationServiceEnabled) {
                Geolocator geoLocator = Geolocator();
                LocationPermission status = await Geolocator.checkPermission();
                print("--status--=${status.name}==${PermissionStatus.denied}");
                if (status == LocationPermission.denied) {
                  Geolocator.requestPermission();
                } else if (status == LocationPermission.deniedForever) {
                  Geolocator.openAppSettings();
                } else if (status == LocationPermission.unableToDetermine) {
                  Geolocator.openAppSettings();
                } else {
                  var result = await Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (BuildContext context) => DragMarkerMap(data,
                            addressData: deliveryAddressData),
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
}
