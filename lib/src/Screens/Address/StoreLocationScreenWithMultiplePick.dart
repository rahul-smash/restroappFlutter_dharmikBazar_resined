import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/Screens/BookOrder/ConfirmOrderScreen.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/PickUpModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/BaseState.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

class StoreLocationScreenWithMultiplePick extends StatefulWidget {
  Area areaObject;
  PickUpModel storeArea;
  OrderType pickUp;
  Datum cityObject;

  StoreLocationScreenWithMultiplePick(this.storeArea, this.pickUp) {
    this.areaObject = storeArea.data.first.area.first;
    cityObject = storeArea.data.first;
  }

  @override
  _StoreLocationScreenWithMultiplePickState createState() {
    return _StoreLocationScreenWithMultiplePickState();
  }
}

class _StoreLocationScreenWithMultiplePickState
    extends BaseState<StoreLocationScreenWithMultiplePick> {
  String lat = "0", lng = "0";
  GoogleMapController mapController;
  Set<Marker> markers = Set();
  LatLng center;

  @override
  void initState() {
    super.initState();
    if (widget.areaObject != null) {
      lat = widget.areaObject.pickupLat;
      lng = widget.areaObject.pickupLng;
      center = LatLng(double.parse(lat), double.parse(lng));
      markers.addAll([
        Marker(
          markerId: MarkerId('value'),
          position: center,
        )
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Place Order'),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Padding(
              padding:
                  EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0, right: 10),
              child: Icon(
                Icons.home,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            onTap: () async {
              Datum result = await DialogUtils.displayCityDialog(
                  context, "Select City", widget.storeArea);
              if (result == null) {
                return;
              }
              widget.cityObject = result;
              setState(() {
                widget.areaObject = null;
              });
            },
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 0, 10),
                  color: Colors.white,
                  child: Text(
                    widget.cityObject == null
                        ? "Select City"
                        : "City: ${widget.cityObject.city.city}",
                    textAlign: TextAlign.left,
                  ),
                )),
          ),
          Divider(color: Colors.grey, height: 2.0),
          InkWell(
            onTap: () async {
              Area result = await DialogUtils.displayAreaDialog(
                  context, "Select Area", widget.cityObject);
              if (result == null) return;
              widget.areaObject = result;
              setState(() {
                lat = widget.areaObject.pickupLat;
                lng = widget.areaObject.pickupLng;
                center = LatLng(double.parse(lat), double.parse(lng));
                markers.remove(0);
                markers.addAll([
                  Marker(
                    markerId: MarkerId('value'),
                    position: center,
                  )
                ]);
              });
            },
            child: Container(
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
                      text: widget.areaObject == null
                          ? "Select Pickup Area"
                          : "Area: ${widget.areaObject.pickupAdd}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                  Future.delayed(Duration(milliseconds: 1200)).then((onValue) =>
                      controller.animateCamera(CameraUpdate.newLatLngZoom(
                          LatLng(double.parse(lat), double.parse(lng)), 15)));
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
          Visibility(
            visible: widget.areaObject == null ? false : true,
            child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Address",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          SizedBox(
                            width: (Utils.getDeviceWidth(context) - 50),
                            child: Text(
                                widget.areaObject != null
                                    ? "${widget.areaObject.pickupAdd}"
                                    : "Select area",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400)),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          child: InkWell(
            onTap: () async {
             StoreModel storeModel=await SharedPrefs.getStore();
              if (widget.areaObject.note.isEmpty) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ConfirmOrderScreen(
                            null,
                            true,
                            widget.areaObject.areaId,
                            widget.pickUp,
                            areaObject: widget.areaObject,
                        storeModel: storeModel,
                          )),
                );
              } else {
                var result = await DialogUtils.displayOrderConfirmationDialog(
                  context,
                  "Confirmation",
                  widget.areaObject.note,
                );
                if (result == true) {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmOrderScreen(
                            null, true, widget.areaObject.areaId, widget.pickUp,
                            areaObject: widget.areaObject,storeModel: storeModel,)),
                  );
                }
              }
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
      ),
    );
  }
}
