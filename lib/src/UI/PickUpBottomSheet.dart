import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/models/PickUpModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Callbacks.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

class PickUpBottomSheet {
  static void showBottomSheet(
    context,
    PickUpModel storeArea,
    OrderType pickUp,
  ) {
    Area areaObject = storeArea.data.first.area.first;
    Datum cityObject = storeArea.data.first;
    String lat = "0", lng = "0";
    Set<Marker> markers = Set();

    LatLng localCenter;
    GoogleMapController _mapController;

    if (areaObject != null) {
      lat = areaObject.pickupLat;
      lng = areaObject.pickupLng;
      localCenter = LatLng(double.parse(lat), double.parse(lng));
      markers.addAll([
        Marker(
          markerId: MarkerId('value'),
          position: localCenter,
        )
      ]);
    } else {
      localCenter = LatLng(double.parse(lat), double.parse(lng));
    }

//    localSelectedLocation = selectedLocation;
//    Set<Marker> markers = Set();
//    String localAddress = address;

//    getAddressFromLocationFromMap(double latitude, double longitude,
//        {StateSetter setState}) async {
//      try {
//        localCenter = LatLng(latitude, longitude);
//        localSelectedLocation = LatLng(latitude, longitude);
//        Coordinates coordinates = new Coordinates(latitude, longitude);
//        var addresses =
//            await Geocoder.local.findAddressesFromCoordinates(coordinates);
//        var first = addresses.first;
//        localAddress = first.addressLine;
//        if (setState != null)
//          setState(() {
//            localAddress = first.addressLine;
//          });
//      } catch (e) {
//        print(e);
//        address = "No address found!";
//      }
//    }

//    markers.addAll([
//      Marker(
//          draggable: true,
//          icon: BitmapDescriptor.defaultMarker,
//          markerId: MarkerId('value'),
//          position: localCenter,
//          onDragEnd: (value) {
//            getAddressFromLocationFromMap(value.latitude, value.longitude);
//          })
//    ]);
//    getAddressFromLocationFromMap(localCenter.latitude, localCenter.longitude);
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
                        'Pick Address',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        Datum result = await DialogUtils.displayCityDialog(
                            context, "Select City", storeArea);
                        if (result == null) {
                          return;
                        }
                        cityObject = result;
                        setState(() {
                          areaObject = null;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.0, right: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 15, 0, 10),
                                color: Colors.white,
                                child: Text(
                                  cityObject == null
                                      ? "Select City"
                                      : "City: ${cityObject.city.city}",
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    Divider(color: Colors.grey, height: 2.0),
                    InkWell(
                      onTap: () async {
                        Area result = await DialogUtils.displayAreaDialog(
                            context, "Select Area", cityObject);
                        if (result == null) return;
                        areaObject = result;

                        if (result != null) {
                          lat = areaObject.pickupLat;
                          lng = areaObject.pickupLng;
                          localCenter =
                              LatLng(double.parse(lat), double.parse(lng));
                          markers.clear();
                          markers.addAll([
                            Marker(
                              markerId: MarkerId('value'),
                              position: localCenter,
                            )
                          ]);
                          setState(() {
                            _mapController.moveCamera(
                                CameraUpdate.newLatLng(localCenter));
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 00, 0, 0),
                        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                        height: 50,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 10.0, right: 10, top: 5, bottom: 5),
                                child: RichText(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  text: TextSpan(
                                    text: areaObject == null
                                        ? "Select Pickup Area"
                                        : "Area: ${areaObject.pickupAdd}",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
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
                          onCameraMove: (CameraPosition position) {
//                            CameraPosition newPos =
//                                CameraPosition(target: position.target);
//                            Marker marker = markers.first;
//
//                            setState(() {
//                              markers.first
//                                  .copyWith(positionParam: newPos.target);
//                            });
                          },
                          //onCameraMove: _onCameraMove,
                        )),
                    Visibility(
                      visible: areaObject == null ? false : true,
                      child: Container(
                        padding: EdgeInsets.only(left: 12, right: 12),
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
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                    SizedBox(
                                      width:
                                          (Utils.getDeviceWidth(context) - 50),
                                      child: Text(
                                          areaObject != null
                                              ? "${areaObject.pickupAdd}"
                                              : "Select area",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ButtonTheme(
                        minWidth: 180.0,
                        height: 40.0,
                        child: ElevatedButton(
                          style: Utils.getButtonDecoration(
                              edgeInsets: EdgeInsets.all(5.0),
                              color:  appTheme,
                              border:RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  side: BorderSide(color: appTheme))
                          ),
                          onPressed: () async {
                            if (areaObject.note.isEmpty) {
                              Navigator.pop(context);
                            } else {
                              var result = await DialogUtils
                                  .displayOrderConfirmationDialog(
                                context,
                                "Confirmation",
                                areaObject.note,
                              );
                              if (result == true) {
                                Navigator.pop(context);
                              }
                            }

                            eventBus.fire(onAddressSelected(null,
                                areaObject: areaObject));
                          },

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
