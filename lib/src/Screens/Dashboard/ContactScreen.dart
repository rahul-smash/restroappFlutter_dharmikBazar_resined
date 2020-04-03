import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreen createState() => _ContactScreen();
}

class _ContactScreen extends State<ContactScreen> {
  final Set<Marker> _markers = {};
  String lat, lng;
  LatLng _initialPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    StoreModel store = await SharedPrefs.getStore();
    lat = store.lat;
    lng = store.lng;
    setState(() {
      _initialPosition = LatLng(double.parse(lat), double.parse(lng));
    });
  }

  void _onAddMarkerButtonPressed() {
    print('in _onAddMarkerButtonPressed()');
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("111"),
        position: LatLng(double.parse(lat), double.parse(lng)),
        infoWindow: InfoWindow(
          title: "" + lat + "" + lng,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    print('setState() done');
  }

  GoogleMapController mapController;
  //Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);import 'package:permission_handler/permission_handler.dart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('Contact'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Container(
              /*height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,*/

              height: 250,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(lat), double.parse(lng)),
                    zoom: 15),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          print('in fab()');
          _onAddMarkerButtonPressed();

          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(double.parse(lat), double.parse(lng)),
                zoom: 15.0,
              ),
            ),
          );
        }));
  }
}
/*
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactScreen extends StatefulWidget {
  @override
  _contactScreen createState() => _contactScreen();
}

class _contactScreen extends State<ContactScreen> {
  Completer<GoogleMapController> controller1;
  String lat,lng;
  GoogleMapController mapController;
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};


  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }
  void _getUserLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lat = prefs.getString(AppConstant.LAT);
    lng = prefs.getString(AppConstant.LNG);
    print('@@lat--+$lat');
    print('@@lng--+$lng');
    setState(() {
      _initialPosition = LatLng(double.parse(lat),double.parse(lng));
      print("@@@@@@@@@@@@"+'$_initialPosition');
    });
  }

  _onMapCreated(GoogleMapController controller) {
    //setState(() {;
      mapController =controller;
   // });
  }

 // MapType _currentMapType = MapType.normal;

  @override
  Widget build(BuildContext context) {



    return Scaffold(

      appBar: AppBar(
        title: new Text('Contact'),
        centerTitle: true,
      ),
      body: _initialPosition == null ? Container(child: Center(child:Text('loading map..', style: TextStyle(fontFamily: 'Avenir-Medium', color: Colors.grey[400]),),),) : Container(
        child: Stack(children: <Widget>[
          GoogleMap(
            markers: _markers,

            //mapType: _currentMapType,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.4746,
            ),

            onMapCreated: _onMapCreated,
            zoomGesturesEnabled: true,
          //  onCameraMove: _onCameraMove,
            //myLocationEnabled: true,
          //  compassEnabled: true,
           // myLocationButtonEnabled: false,

          ),

        ]),
      ),
    );
  }
}

*/

/*
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
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
 */
/* void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }*/ /*

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
     */
/* _initialPosition = CameraPosition(target: LatLng(double.parse(lat),double.parse(lng)), tilt: 30.0,
        zoom: 17.0,);*/ /*

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
*/
