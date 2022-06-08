import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoding/geocoding.dart';
// import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';

class SelectLocationOnMap extends StatefulWidget {
  SelectLocationOnMap();

  @override
  SelectLocationOnMapState createState() => SelectLocationOnMapState();
}

class SelectLocationOnMapState extends State<SelectLocationOnMap> {
  GoogleMapController _mapController;
  Set<Marker> markers = Set();
  LatLng center, selectedLocation;
  String address;
  LocationData locationData = LocationData();

  @override
  void initState() {
    super.initState();
    print("--SelectLocationOnMapState-");
    address = "";
    center = LatLng(0.0, 0.0);
    selectedLocation = LatLng(0.0, 0.0);
    locationData.address = address;
    locationData.lat = "0.0";
    locationData.lng = "0.0";
    getLocation();
  }

  void _getLastKnownPosition() async {
    Position position = await Geolocator.getLastKnownPosition();

    if (position != null) {
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
      if (mounted)
        setState(() {
          _mapController.moveCamera(CameraUpdate.newLatLng(center));
        });
    } else {
      //Utils.showToast("No last known position available...", true);
    }
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
          Container(
            margin: EdgeInsets.fromLTRB(0, 00, 0, 0),
            height: 50,
            color: Colors.white,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    EdgeInsets.only(left: 10.0, right: 10, top: 5, bottom: 5),
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
                target: center,
                zoom: 15.0,
              ),
              mapType: MapType.normal,
              markers: markers,
              onCameraMove: _onCameraMove,
              //onCameraMove: _onCameraMove,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () async {
            Navigator.pop(context, locationData);
          },
          child: Container(
            height: 40,
            color: appTheme,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: RichText(
                  text: TextSpan(
                    text: "Select Location",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
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
    await Utils.determinePosition();
    _getLastKnownPosition();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
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
      locationData.lat = "${latitude}";
      locationData.lng = "${longitude}";
      // Coordinates coordinates = new Coordinates(latitude, longitude);
      // var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var addresses = await placemarkFromCoordinates(latitude, longitude);
      var first = addresses.first;
      // print("--addresses-${addresses} and ${first}");
      print(
          "----------${first.name} and ${first.street}-postalCode-${first.postalCode}------");
      setState(() {
        address = first.street;
        locationData.address = address;
      });
    } catch (e) {
      print(e);
    }
  }

  void _onCameraMove(CameraPosition position) {
    CameraPosition newPos = CameraPosition(target: position.target);
    Marker marker = markers.first;

    setState(() {
      markers.first.copyWith(positionParam: newPos.target);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }
}

class LocationData {
  String _address = "";
  String _lat = "";
  String _lng = "";

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get lat => _lat;

  set lat(String value) {
    _lat = value;
  }

  String get lng => _lng;

  set lng(String value) {
    _lng = value;
  }
}
