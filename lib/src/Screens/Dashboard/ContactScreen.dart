import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  StoreModel store;
  ContactScreen(this.store);

  @override
  _ContactScreen createState() => _ContactScreen();
}

class _ContactScreen extends State<ContactScreen> {

  String lat = "0.0", lng = "0.0";
  GoogleMapController mapController;
  LatLng center ;
  Set<Marker> markers = Set();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    center = LatLng(double.parse(lat), double.parse(lng));
    lat = widget.store.lat;
    lng = widget.store.lng;
    center = LatLng(double.parse(lat), double.parse(lng));
    markers.addAll([Marker(
      markerId: MarkerId('value'),
      position: center,
      infoWindow: InfoWindow(title: "${widget.store.storeName}\n${widget.store.location}"),
    ),]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('Contact'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height - 250,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    markers: markers,
                    initialCameraPosition: CameraPosition(
                        target: center,
                        zoom: 13),
                  ),
                ),
              ),
              Container(
                //height: 120,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 10, left: 10,bottom: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.store == null ? "" : widget.store.storeName ?? "", style: TextStyle(color: infoLabel, fontSize: 18)),
                                SizedBox(height: 10),
                                Text("Address", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500)),
                                SizedBox(height: 7),
                                SizedBox(
                                  width: (Utils.getDeviceWidth(context)-100),
                                  child: Text(widget.store == null ? "" : widget.store.location ?? "",
                                      style: TextStyle(
                                          color: infoLabel, fontSize: 15)),
                                ),
                                Text(widget.store == null? "": (widget.store.city ??"" + ", " + widget.store.state ??""),
                                    style:TextStyle(color: infoLabel, fontSize: 15))
                              ],
                            )),
                        Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: IconButton(
                                  icon: Icon(Icons.phone, size: 30,),
                                  onPressed: () {
                                    //print("${store.contactNumber}");
                                    if(widget.store != null) {
                                      _launchCaller(widget.store.contactNumber);
                                    }
                                  },
                                )
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: IconButton(
                                  icon: Icon(Icons.markunread, size: 30,),
                                  onPressed: () {
                                    //print("${store.contactEmail}");
                                    if(widget.store != null) {
                                      _launchEmail(widget.store.contactEmail);
                                    }
                                  },
                                )
                            ),
                          ],
                        ),
                      ]))
            ],
          ),
        ),
    );
  }

  _launchCaller(String call) async {
    String url = "tel:$call";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchEmail(String email) async {
    String url = "mailto:$email?subject=&body=";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }


}
