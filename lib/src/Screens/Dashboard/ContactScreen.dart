import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreen createState() => _ContactScreen();
}

class _ContactScreen extends State<ContactScreen> {
  StoreModel store;
  String lat = "0", lng = "0";
  GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    store = await SharedPrefs.getStore();
    setState(() {
      lat = store.lat;
      lng = store.lng;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('Contact'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height - 250,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(lat), double.parse(lng)),
                    zoom: 15),
              ),
            ),
            Container(
                height: 150,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(store == null ? "" : store.storeName ?? "",
                                  style: TextStyle(
                                      color: infoLabel, fontSize: 18)),
                              SizedBox(height: 10),
                              Text("Address",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 7),
                              Text(store == null ? "" : store.location ?? "",
                                  style: TextStyle(
                                      color: infoLabel, fontSize: 15)),
                              Text(
                                  store == null
                                      ? ""
                                      : (store.city ??
                                          "" + ", " + store.state ??
                                          ""),
                                  style:
                                      TextStyle(color: infoLabel, fontSize: 15))
                            ],
                          )),
                      Padding(padding: EdgeInsets.only(right: 10), child: IconButton(
                        icon: Icon(Icons.phone, size: 40,),
                        onPressed: () {
                          if(store != null) {
                            launch(store.contactNumber);
                          }
                        },
                      )),
                    ]))
          ],
        ));
  }
}
