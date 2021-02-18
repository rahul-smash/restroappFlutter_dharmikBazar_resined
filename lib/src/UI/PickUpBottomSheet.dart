import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';

class PickUpBottomSheet {
  static void showBottomSheet(
      context, LatLng center, LatLng selectedLocation, String address) {
    LatLng localCenter, localSelectedLocation;
    GoogleMapController _mapController;
    localCenter = center;
    localSelectedLocation = selectedLocation;
    Set<Marker> markers = Set();
    String localAddress = address;
    getAddressFromLocationFromMap(double latitude, double longitude,
        {StateSetter setState}) async {
      try {
        localCenter = LatLng(latitude, longitude);
        localSelectedLocation = LatLng(latitude, longitude);
        Coordinates coordinates = new Coordinates(latitude, longitude);
        var addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var first = addresses.first;
        localAddress = first.addressLine;
        if (setState != null)
          setState(() {
            localAddress = first.addressLine;
          });
      } catch (e) {
        print(e);
        address = "No address found!";
      }
    }

    markers.addAll([
      Marker(
          draggable: true,
          icon: BitmapDescriptor.defaultMarker,
          markerId: MarkerId('value'),
          position: localCenter,
          onDragEnd: (value) {
            getAddressFromLocationFromMap(value.latitude, value.longitude);
          })
    ]);
    getAddressFromLocationFromMap(localCenter.latitude, localCenter.longitude);
    showModalBottomSheet(
        enableDrag: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return Wrap(children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 15, 5, 5),
                          child: Icon(
                            Icons.cancel,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      child: Text(
                        'Set Location',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.all(20),
                        //padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: searchGrayColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(
                              color: searchGrayColor,
                            )),
                        child: InkWell(
                            onTap: () async {},
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Center(
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(3, 3, 10, 3),
                                          child: Image.asset(
                                              'images/searchicon.png',
                                              width: 20,
                                              fit: BoxFit.scaleDown,
                                              color: appTheme)),
                                      Expanded(
                                        child: RichText(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          text: TextSpan(
                                            text: "${localAddress}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                            ))),
                    Container(
                        height: Utils.getDeviceHeight(context) >
                                Utils.getDeviceWidth(context)
                            ? Utils.getDeviceWidth(context) - 50
                            : Utils.getDeviceHeight(context) / 2 - 50,
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: localCenter,
                            zoom: 15.0,
                          ),
                          mapType: MapType.normal,
                          markers: markers,
                          onTap: (latLng) {
                            if (markers.length >= 1) {
                              markers.clear();
                            }
                            setState(() {
                              markers.add(Marker(
                                  draggable: true,
                                  icon: BitmapDescriptor.defaultMarker,
                                  markerId: MarkerId('value'),
                                  position: latLng,
                                  onDragEnd: (value) {
                                    print(value.latitude);
                                    print(value.longitude);
                                    getAddressFromLocationFromMap(
                                        value.latitude, value.longitude,
                                        setState: setState);
                                  }));
                              getAddressFromLocationFromMap(
                                  latLng.latitude, latLng.longitude,
                                  setState: setState);
                            });
                          },
                          onCameraMove: (CameraPosition position) {
                            CameraPosition newPos =
                                CameraPosition(target: position.target);
                            Marker marker = markers.first;

                            setState(() {
                              markers.first
                                  .copyWith(positionParam: newPos.target);
                            });
                          },
                          //onCameraMove: _onCameraMove,
                        )),
                    Align(
                      alignment: Alignment.center,
                      child: ButtonTheme(
                        minWidth: 180.0,
                        height: 40.0,
                        child: RaisedButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              side: BorderSide(color: appTheme)),
                          onPressed: () async {},
                          color: appTheme,
                          padding: EdgeInsets.all(5.0),
                          textColor: Colors.white,
                          child: Text("Submit"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              )
            ]);
          });
        });
  }
}
