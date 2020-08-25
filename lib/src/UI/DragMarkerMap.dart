import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreRadiousResponse.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/models/UserResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';

class DragMarkerMap extends StatefulWidget {

  StoreRadiousResponse data;

  DragMarkerMap(this.data);

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

  @override
  void initState() {
    super.initState();
    areaList = List();
    center = LatLng(0.0, 0.0);
    selectedLocation = LatLng(0.0, 0.0);
    address = "";
    zipCode = "";
    getLocation();
    cityValue = "Click here...";
    if (widget.data != null && widget.data.data.length == 1) {
      cityValue = "${widget.data.data[0].city.city}";
      cityId = "${widget.data.data[0].city.id}";
      areaList.addAll(widget.data.data[0].area);
      enableDialog = false;
    } else {
      enableDialog = true;
    }
    print("${widget.data.data.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Choose Your Location'),
        backgroundColor: appTheme,
      ),
      body: Column(
        children: <Widget>[
          InkWell(
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
                }
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 0, 10),
                  color: Colors.white,
                  child: cityValue.compareTo("Click here...")==0?
                  RichText(
                    text:
                    TextSpan(text: "Select City:",
                        style: TextStyle(
                        color: Colors.black,),children: <TextSpan>[
                      TextSpan(
                        text: " ${cityValue}",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      )
                    ]), textAlign: TextAlign.left,):Text("Select City: ${cityValue}",),
                ),
              ),
          ),
          Divider(color: Colors.grey, height: 2.0),
          Container(
            margin: EdgeInsets.fromLTRB(0, 00, 0, 0),
            height: 50,
            color: Colors.white,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10, top: 5, bottom: 5),
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  text: TextSpan(
                    text: "Address: ${address}",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: center, zoom: 15.0,),
              mapType: MapType.normal,
              markers: markers,
              onCameraMove: _onCameraMove,
              //onCameraMove: _onCameraMove,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          child: InkWell(
            onTap: () async {
              StoreModel store = await SharedPrefs.getStore();

              print("====${selectedLocation.latitude},${selectedLocation
                  .longitude}===");
              double distanceInKm = Utils.calculateDistance(
                  selectedLocation.latitude, selectedLocation.longitude,
                  double.parse(store.lat), double.parse(store.lng));
              int distanceInKms = distanceInKm.toInt();

              print("==distanceInKm==${distanceInKm}=AND=${distanceInKms}=");

              checkIfOrderDeliveryWithInRadious(distanceInKms);
            },
            child: Container(
              height: 40,
              color: appTheme,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Save Address",
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getLocation() async {
    Utils.showToast("Getting your location...", true);
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // final coordinates = new Coordinates(position.latitude, position.longitude);
    center = LatLng(position.latitude, position.longitude);
    getAddressFromLocation(position.latitude, position.longitude);
    markers.addAll([
      Marker(
          draggable: true,
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId('value'),
          position: center,
          onDragEnd: (value) {
            print(value.latitude);
            print(value.longitude);
            getAddressFromLocation(value.latitude, value.longitude);
          })
    ]);
    setState(() {
      _mapController.moveCamera(CameraUpdate.newLatLng(center));
    });
  }

  getAddressFromLocation(double latitude, double longitude) async {
    try {
      selectedLocation = LatLng(latitude, longitude);
      Coordinates coordinates = new Coordinates(latitude, longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(
          coordinates);
      var first = addresses.first;
      //print("--addresses-${addresses} and ${first}");
      print("----------${first.featureName} and ${first
          .addressLine}-postalCode-${first.postalCode}------");

      setState(() {
        address = first.addressLine;
        zipCode = first.postalCode;
      });
    } catch (e) {
      print(e);
      address = "No address found!";
    }
  }

  void _onCameraMove(CameraPosition position) {
    CameraPosition newPos = CameraPosition(
        target: position.target
    );
    Marker marker = markers.first;

    setState(() {
      markers.first.copyWith(
          positionParam: newPos.target
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }


  Future<RadiousData> displayRadiusCityDialog(BuildContext context,
      String title, List<RadiousData> data,) async {
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
              new FlatButton(
                child: new Text("Cancel"),
                textColor: Colors.blue,
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
      //print("---${areaList.length}---and-- ${distanceInKms}---");
      for (int i = 0; i < areaList.length; i++) {
        Area areaObject = areaList[i];
        int radius = int.parse(areaObject.radius);
        if (distanceInKms < radius && areaObject.radiusCircle == "Within") {
          //print("--if-${radius}---and-- ${distanceInKms}---");
          area = areaObject;
          break;
        } else {
          //print("--else-${radius}---and-- ${distanceInKms}---");
        }
      }
      if (area != null) {
        Utils.showProgressDialog(context);
        UserModel user = await SharedPrefs.getUser();
        ApiController.saveDeliveryAddressApiRequest(
            "ADD",
            zipCode,
            address,
            area.areaId,
            area.area,
            null,
            user.fullName,
            cityValue,
            cityId,
            "${selectedLocation.latitude}",
            "${selectedLocation.longitude}").then((response) {
          Utils.hideProgressDialog(context);
          if (response != null && response.success) {
            Utils.showToast(response.message, false);
            //Navigator.pop(context);
            Navigator.pop(context, area);
          } else {
            if (response != null)
              Utils.showToast(response.message, false);
          }
        });
      } else {
        Utils.showToast("We can not deliver at your location!", false);
      }
      print("---radius-- ${area.radius}-charges.and ${area.charges}--");
    } catch (e) {
      print(e);
    }
  }


}