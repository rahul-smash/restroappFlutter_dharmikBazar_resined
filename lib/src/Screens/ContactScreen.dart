import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactScreen extends StatefulWidget {
  ContactScreen(BuildContext context);

  @override
  _contactScreen createState() => new _contactScreen();
}

class _contactScreen extends State<ContactScreen> {
  final Set<Marker> _markers = Set();
  final double _zoom = 10;
   CameraPosition _initialPosition ;
  MapType _defaultMapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center;
  String lat,lng;
  GoogleMapController mapController;

  LatLng _lastMapPosition;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
 /* void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }*/
  @override
  initState() {
    super.initState();
    print("---initState _contactScreen---");
    _initProfileData();
  }

  _initProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      ///DO MY Logic CALLS

      lat = prefs.getString(AppConstant.LAT);
      lng = prefs.getString(AppConstant.LNG);
      print('@@lat--+$lat');
      print('@@lng--+$lng');
     //_center =  LatLng(double.parse(lat),double.parse(lng));
      _initialPosition = CameraPosition(target: LatLng(double.parse(lat),double.parse(lng)), tilt: 30.0,
        zoom: 17.0,);
      print("---_initialPosition _contactScreen---$_initialPosition");

    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        title: new Text('Contact'),
        centerTitle: true,
      ),
        body: GoogleMap(
          //enable zoom gestures
          zoomGesturesEnabled: true,
          markers: _markers,
          mapType: _defaultMapType,
          onMapCreated: _onMapCreated,

          initialCameraPosition: CameraPosition(target: LatLng(double.parse(lat),double.parse(lng),),zoom: 11.0,),
        ),
    );

  }
}
