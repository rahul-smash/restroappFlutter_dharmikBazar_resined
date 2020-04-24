import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/Screens/BookOrder/ConfirmOrderScreen.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/PickUpModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/BaseState.dart';

class StoreLocationScreen extends StatefulWidget {

  Area areaObject;

  StoreLocationScreen(this.areaObject);

  @override
  _StoreLocationScreenState createState() {
    return _StoreLocationScreenState();
  }
}

class _StoreLocationScreenState extends BaseState<StoreLocationScreen> {

  String lat = "0", lng = "0";
  GoogleMapController mapController;
  Set<Marker> markers = Set();
  LatLng center;

  @override
  void initState() {
    super.initState();
    lat = widget.areaObject.pickupLat;
    lng = widget.areaObject.pickupLng;
    center = LatLng(double.parse(lat), double.parse(lng));
    markers.addAll([Marker(markerId: MarkerId('value'),position: center)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text('Place Order'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  markers: markers,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  tiltGesturesEnabled: true,
                  myLocationEnabled: false,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(lat), double.parse(lng)),
                      zoom: 15),
                ),
              ),
            ),
            Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: EdgeInsets.only(top: 10, left: 10,right: 10,bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Address",maxLines: 1,overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 18,fontWeight: FontWeight.w500)),
                              Text("${widget.areaObject.pickupAdd}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                  fontSize: 16,fontWeight: FontWeight.w400)),
                            ],
                          ),
                      ),
                    ]
                ),
            ),
          ],
        ),

      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: (){
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ConfirmOrderScreen(null, "2",true, widget.areaObject.areaId)),
            );
          },
          child: Container(
            height: 40,
            color: appTheme,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(left: 0.0),
                child: RichText(
                  text: TextSpan(
                    text: "Proceed",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}