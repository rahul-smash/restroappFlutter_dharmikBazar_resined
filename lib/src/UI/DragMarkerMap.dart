import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';

// import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreRadiousResponse.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:restroapp/src/utils/validator.dart';

import '../utils/AutoSearch.dart';

class DragMarkerMap extends StatefulWidget {
  StoreRadiousResponse data;
  DeliveryAddressData addressData;

  DragMarkerMap(this.data, {this.addressData});

  @override
  _DragMarkerMapState createState() => _DragMarkerMapState();
}

class _DragMarkerMapState extends State<DragMarkerMap> {
  GoogleMapController _mapController;
  Set<Marker> markers = Set();
  LatLng center, selectedLocation;
  String address;
  String zipCode;
  String cityValue;
  String cityId;
  bool enableDialog;
  List<Area> areaList;
  List<String> addressList = List.empty(growable: true);
  String selectedTag;
  final fullNameController = new TextEditingController();
  final mobileController = new TextEditingController();
  final emailController = new TextEditingController();
  final addressController = new TextEditingController();
  TextEditingController zipCodeController = new TextEditingController();

  String localAddress = '';
  RadiousData areaObject;

  @override
  void initState() {
    addressList.add("Home");
    addressList.add("Work");
    addressList.add("Other");
    selectedTag = addressList.first;
    areaList = List.empty(growable: true);
    center = LatLng(0.0, 0.0);
    selectedLocation = LatLng(0.0, 0.0);
    address = "";
    zipCode = "";
    cityValue = "Click here...";
    if (widget.data != null && widget.data.data.length == 1) {
      cityValue = "${widget.data.data[0].city.city}";
      cityId = "${widget.data.data[0].city.id}";
      areaList.addAll(widget.data.data[0].area);
      enableDialog = false;
    } else {
      enableDialog = true;
    }
    getLocation();
    getUserData();
    getAddressData();
    print("${widget.data.data.length}");
    super.initState();
  }

  void getUserData() {
    try {
      if (widget.addressData == null) {
        SharedPrefs.getUser().then((user) {
          setState(() {
            fullNameController.text = user.fullName;
            mobileController.text = user.phone;
          });
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getAddressData() {
    if (widget.addressData != null) {
      fullNameController.text = widget.addressData.firstName;
      mobileController.text = widget.addressData.mobile;
      addressController.text = widget.addressData.address;
      zipCodeController.text = widget.addressData.zipCode;
      selectedTag = widget.addressData.addressType;

      if (widget.data != null &&
          widget.data.data.length != 0 &&
          widget.addressData != null) {
        areaObject = widget.data.data.singleWhere(
            (element) => element.city.id == widget?.addressData.cityId);
        cityValue = "${areaObject.city.city}";
        cityId = "${areaObject.city.id}";
        areaList.addAll(areaObject.area);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
            statusBarColor: whiteColor,
            statusBarIconBrightness: Brightness.dark),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _appBar(),
            body: _body(),
          ),
        ));
  }

  _appBar() {
    return AppBar(
      title: Text('Choose Your Location'),
      backgroundColor: appTheme,
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _fullName(),
          _mobile(),
          SizedBox(height: 10),
          _city(),
          _selectedAddress(),
          Container(
            height: 300.0,
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: _mapView(),
          ),
          _addressView(),
          _zipcode(),
          _addressList(),
          /* InkWell(
            onTap: () async {
              print("-------onTap---------");
              if (enableDialog == true) {
                RadiousData areaObject = await displayRadiusCityDialog(
                    context, "Select City", widget.data.data);
                //print("-------onTap----${areaObject.city.city}-----");
                setState(() {
                  cityValue = "${areaObject.city.city}";
                  cityId = "${areaObject.city.id}";
                  if (areaList != null && areaList.isNotEmpty) {
                    areaList.clear();
                  }
                  areaList.addAll(areaObject.area);
                });
                print("areaList ${areaList}");
              }
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 15, 0, 10),
                color: Colors.white,
                child: cityValue.compareTo("Click here...") == 0
                    ? RichText(
                  text: TextSpan(
                      text: "Select City:",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: " ${cityValue}",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        )
                      ]),
                  textAlign: TextAlign.left,
                )
                    : Text(
                  "Select City: ${cityValue}",
                ),
              ),
            ),
          ),Divider(color: Colors.grey, height: 2.0),*/
          SizedBox(height: 10.0),
          _saveAddressView(),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  _saveAddressView() {
    return TextButton(
        child: Text("Save Address", style: TextStyle(fontSize: 15.0)),
        onPressed: () async {
          if (!Validator.validField(fullNameController.text)) {
            Utils.showToast("Please enter Full Name.", false);
            return;
          }
          if (!Validator.validField(mobileController.text)) {
            Utils.showToast("Please enter Mobile Number.", false);
            return;
          }
          if (areaList.isEmpty) {
            Utils.showToast("Please select city.", false);
            return;
          }
          if (!Validator.validField(addressController.text)) {
            Utils.showToast("Please enter address.", false);
            return;
          }
          if (!Validator.validField(zipCodeController.text)) {
            Utils.showToast("Please enter zipcode.", false);
            return;
          }
          StoreModel store = await SharedPrefs.getStore();
          print(
              "====${selectedLocation.latitude},${selectedLocation.longitude}===");
          double distanceInKm = Utils.calculateDistance(
              selectedLocation.latitude,
              selectedLocation.longitude,
              double.parse(store.lat),
              double.parse(store.lng));
          int distanceInKms = distanceInKm.toInt();

          print("==distanceInKm==${distanceInKm}=AND=${distanceInKms}=");
          checkIfOrderDeliveryWithInRadious(distanceInKms);
        },
        style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: appTheme,
            padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 20.0),
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(5.0),
                side: BorderSide(color: appTheme))));
  }

  _fullName() {
    return addLabelWithField("Full Name", "Full Name", fullNameController);
  }

  _mobile() {
    return addLabelWithField("Mobile", "Mobile", mobileController,
        isNumericType: true,
        inputformatter: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          FilteringTextInputFormatter.digitsOnly
        ]);
  }

  _city() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<RadiousData>(
          dropdownColor: Colors.white,
          items: widget.data.data.map((RadiousData area) {
            return DropdownMenuItem<RadiousData>(
                value: area,
                child: Row(
                  children: <Widget>[
                    Text(area?.city?.city ?? ""),
                  ],
                ));
          }).toList(),
          onTap: () {},
          onChanged: (newValue) {
            if (enableDialog == true) {
              setState(() {
                areaObject = newValue;
                cityValue = "${areaObject.city.city}";
                cityId = "${areaObject.city.id}";
                if (areaList != null && areaList.isNotEmpty) {
                  areaList.clear();
                }
                areaList.addAll(areaObject.area);
              });
            }
          },
          value: areaObject,
          decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            filled: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            fillColor: Colors.white,
            label: Text.rich(
              TextSpan(
                text: "Select City",
                style: TextStyle(color: infoLabel, fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                      )),
                  // can add more TextSpans here...
                ],
              ),
            ),
          ),
        ),
        addDivider()
      ],
    );
  }

  _selectedAddress() {
    return Container(
        padding: EdgeInsets.only(left: 10.0, right: 10, top: 13, bottom: 13),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        color: Colors.grey[200],
        child: InkWell(
          onTap: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return CustomSearchScaffold();
                  },
                  fullscreenDialog: true,
                ));
            if (result != null) {
              LatLng detail = result;
              double lat = detail.latitude;
              double lng = detail.longitude;
              print("location = ${lat},${lng}");
              selectedLocation = LatLng(lat, lng);
              getAddressFromLocation(lat, lng);
              _mapController
                  .moveCamera(CameraUpdate.newLatLng(selectedLocation));
              // localCenter = LatLng(lat, lng);
              // localSelectedLocation = LatLng(lat, lng);
              // getAddressFromLocationFromMap(lat, lng,
              //     setState: setState);
              // markers.clear();
              // markers.addAll([
              //   Marker(
              //       draggable: true,
              //       icon: BitmapDescriptor.defaultMarker,
              //       markerId: MarkerId('value'),
              //       position: localCenter,
              //       onDragEnd: (value) {
              //         getAddressFromLocationFromMap(
              //             value.latitude, value.longitude,
              //             setState: setState);
              //       })
              // ]);
              // setState(() {
              //   _mapController.moveCamera(
              //       CameraUpdate.newLatLng(localCenter));
              // });
            }
          },
          child: Row(
            children: [
              _searchIcon(),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                          text: "${address}",
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
        ));
  }

  _searchIcon() {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
        child: Image.asset('images/searchicon.png',
            width: 20, fit: BoxFit.scaleDown, color: Colors.grey));
  }

  _addressView() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      color: Colors.grey[200],
      height: 100.0,
      child: new TextField(
        controller: addressController,
        keyboardType: TextInputType.text,
        maxLength: 100,
        maxLines: null,
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: InputBorder.none,
            contentPadding:
                EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
            hintText: "Door / Flat No."),
      ),
    );
  }

  _zipcode() {
    return addLabelWithField("ZipCode", "ZipCode", zipCodeController,
        isNumericType: true);
  }

  _addressList() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 15,
        children: addressList.map((tag) {
          return InkWell(
              onTap: () {
                selectedTag = tag;
                setState(() {});
              },
              child: Container(
                width: 80,
                padding: EdgeInsets.only(left: 5, right: 5),
                height: 30,
                decoration: BoxDecoration(
                  color: selectedTag == tag ?? ""
                      ? webThemeCategoryOpenColor
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    tag ?? "",
                    style: TextStyle(
                        fontSize: 16,
                        color: selectedTag == tag ?? ""
                            ? whiteColor
                            : Colors.black),
                  ),
                ),
              ));
        }).toList(),
      ),
    );
  }

  _mapView() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: center,
        zoom: 15.0,
      ),
      mapType: MapType.normal,
      markers: markers,
      onCameraMove: _onCameraMove,
      //onCameraMove: _onCameraMove,
    );
  }

  addLabelWithField(String label, String hint, TextEditingController controller,
      {bool isOptionaField = false,
      bool isNumericType = false,
      List<TextInputFormatter> inputformatter}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: !isOptionaField
              ? Text.rich(
                  TextSpan(
                    text: label,
                    style: TextStyle(color: infoLabel, fontSize: 12),
                    children: <TextSpan>[
                      TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: Colors.red,
                          )),
                      // can add more TextSpans here...
                    ],
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(color: infoLabel, fontSize: 12.0),
                ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: TextField(
              controller: controller,
              cursorColor: Colors.black,
              inputFormatters: inputformatter,
              keyboardType:
                  isNumericType ? TextInputType.phone : TextInputType.text,
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding:
                    EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
                hintText: hint,
              ),
            ),
          ),
        ),
        addDivider(),
      ],
    );
  }

  Widget addDivider() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Divider(color: Colors.grey, height: 2.0),
    );
  }

  Future<void> getLocation() async {
    Utils.showToast("Getting your location...", true);
    if (widget.addressData != null &&
        widget.addressData.lat != null &&
        widget.addressData.lat.isNotEmpty &&
        widget.addressData.lng != null &&
        widget.addressData.lng.isNotEmpty) {
      selectedLocation = LatLng(double.parse(widget.addressData.lat),
          double.parse(widget.addressData.lng));
      center = LatLng(double.parse(widget.addressData.lat),
          double.parse(widget.addressData.lng));
      getAddressFromLocation(
          selectedLocation.latitude, selectedLocation.longitude);
      markers.addAll([
        Marker(
            draggable: true,
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId('value'),
            position: selectedLocation,
            onDragEnd: (value) {
              selectedLocation=value;
              getAddressFromLocation(value.latitude, value.longitude);
              if(mounted) setState(() { });
            })
      ]);

      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _mapController.moveCamera(CameraUpdate.newLatLng(center));
        });
      });
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      center = LatLng(position.latitude, position.longitude);
      selectedLocation = LatLng(position.latitude, position.longitude);
      debugPrint("current location ${center}");
      markers.addAll([
        Marker(
            draggable: true,
            icon: BitmapDescriptor.defaultMarker,
            markerId: MarkerId('value'),
            position: selectedLocation,
            onDragEnd: (value) {
              debugPrint("==${value.longitude}}");
              selectedLocation=value;
              getAddressFromLocation(value.latitude, value.longitude);
              if(mounted) setState(() {

              });
            })
      ]);
      getAddressFromLocation(position.latitude, position.longitude);
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          _mapController.moveCamera(CameraUpdate.newLatLng(center));
        });
      });
    }
  }

  getAddressFromLocation(double latitude, double longitude) async {
    try {
      print("--widget.initialPosition != null----");
      var addresses = await placemarkFromCoordinates(latitude, longitude);
      var first = addresses.first;
      print(
          "---getAddressFromLocation-------${first.name} and ${first.street}-postalCode-${first.postalCode}------");
      setState(() {
        address =
            '${first.subLocality != null ? first.subLocality : ''}${first.locality != null ? ', ' + first.locality : ''}${first.subAdministrativeArea != null ? ', ' + first.subAdministrativeArea : ''}${first.administrativeArea != null ? ', ' + first.administrativeArea : ''}';
        if (address.length > 0)
          address = address[0] == ',' ? address.replaceFirst(',', '') : address;
        zipCode = first.postalCode;
        addressController.text = address ?? "";
        zipCodeController.text = zipCode ?? "";
      });
    } catch (e) {
      print(e);
      address = "No address found!";
    }
  }

  void _onCameraMove(CameraPosition position) {
    CameraPosition newPos = CameraPosition(target: position.target);
    setState(() {
      markers.first.copyWith(positionParam: newPos.target);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  Future<RadiousData> displayRadiusCityDialog(
    BuildContext context,
    String title,
    List<RadiousData> data,
  ) async {
    return await showDialog<RadiousData>(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: data.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
                itemBuilder: (context, index) {
                  RadiousData areaObject = data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(context, areaObject);
                    },
                    child: ListTile(
                      title: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(areaObject.city.city,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16)),
                            ),
                          ]),
                    ),
                  );
                },
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context, null);
                  // true here means you clicked ok
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkIfOrderDeliveryWithInRadious(int distanceInKms) async {
    try {
      Area area;
      print("---${areaList.length}---and-- ${distanceInKms}---");
      for (int i = 0; i < areaList.length; i++) {
        Area areaObject = areaList[i];
        int radius = int.parse(areaObject.radius);
        if (distanceInKms < radius && areaObject.radiusCircle == "Within") {
          //print("--if-${radius}---and-- ${distanceInKms}---");
          area = areaObject;
          setState(() {});
          break;
        } else {
          //print("--else-${radius}---and-- ${distanceInKms}---");
        }
      }
      print("==${area}");
      print("==${zipCode}");
      if (area != null) {
        Utils.showProgressDialog(context);
        UserModel user = await SharedPrefs.getUser();
        ApiController.saveDeliveryAddressApiRequest(
                widget.addressData == null ? "ADD" : "EDIT",
                zipCodeController.text.trim(),
                addressController.text.trim(),
                area.areaId,
                area.area,
                widget.addressData == null ? null : widget.addressData.id,
                fullNameController.text.trim(),
                cityValue,
                cityId,
                "${selectedLocation.latitude}",
                "${selectedLocation.longitude}",
                mobileController.text.trim(),
                selectedTag)
            .then((response) {
          Utils.hideProgressDialog(context);
          if (response != null && response.success) {
            Utils.showToast(response.message, false);
            //Navigator.pop(context);
            Navigator.pop(context, area);
          } else {
            if (response != null) Utils.showToast(response.message, false);
          }
        });
      } else {
        Utils.showToast("We can not deliver at your location!", false);
      }
    } catch (e) {
      print(e);
    }
  }
}
