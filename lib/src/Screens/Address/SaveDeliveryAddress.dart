import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/UI/SelectLocation.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreAreaResponse.dart';
import 'package:restroapp/src/models/StoreDeliveryAreasResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/BaseState.dart';
import 'package:restroapp/src/utils/Utils.dart';

class SaveDeliveryAddress extends StatefulWidget {
  final DeliveryAddressData selectedAddress;
  final VoidCallback callback;
  String addressValue;
  Coordinates coordinates;

  SaveDeliveryAddress(
      this.selectedAddress, this.callback, this.addressValue, this.coordinates);

  @override
  _SaveDeliveryAddressState createState() => _SaveDeliveryAddressState();
}

class _SaveDeliveryAddressState extends State<SaveDeliveryAddress> {
  Area selectedArea;
  City selectedCity;
  TextEditingController addressController = new TextEditingController();
  TextEditingController zipCodeController = new TextEditingController();
  TextEditingController fullnameController = new TextEditingController();
  LocationData locationData;
  Datum dataObject;

  @override
  void initState() {
    super.initState();
    if (widget.selectedAddress != null) {
      //print("-11111111111-------");
      selectedCity = City();
      selectedCity.city = widget.selectedAddress.city;
      selectedCity.id = widget.selectedAddress.cityId;

      selectedArea = Area();
      selectedArea.areaId = widget.selectedAddress.areaId;
      selectedArea.area = widget.selectedAddress.areaName;
      addressController.text = widget.selectedAddress.address;
      zipCodeController.text = widget.selectedAddress.zipCode;
      fullnameController.text =
          "${widget.selectedAddress.firstName} ${widget.selectedAddress.lastName}";

      locationData = new LocationData();
      locationData.address = widget.selectedAddress.address;
      locationData.lat = widget.selectedAddress.lat.toString();
      locationData.lng = widget.selectedAddress.lng.toString();
    } else {
      //print("-2222222222222222-------");
      locationData = new LocationData();

      if (widget.addressValue != null && widget.addressValue.isNotEmpty) {
        //print("-3333333333333333-------");
        locationData.address = widget.addressValue;
        addressController.text = widget.addressValue;
        locationData.lat = widget.coordinates.latitude.toString();
        locationData.lng = widget.coordinates.longitude.toString();
      }
    }
    //getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            widget.selectedAddress != null ? "Edit Address" : "Add Address",
            style: new TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        "City*",
                        style: TextStyle(color: infoLabel, fontSize: 17.0),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                          child: InkWell(
                            onTap: () async {
                              Utils.showProgressDialog(context);
                              StoreAreaResponse storeArea =
                                  await ApiController.getStoreAreaApiRequest();
                              Utils.hideProgressDialog(context);
                              List<Datum> data = storeArea.data;
                              if (data.length == 1) {
                                setState(() {
                                  dataObject = data[0];
                                  selectedCity = dataObject.city;
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CityDialog((area) {
                                    setState(() {
                                      dataObject = area;
                                      selectedCity = dataObject.city;
                                    });
                                  }),
                                );
                              }
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  selectedCity != null
                                      ? selectedCity.city
                                      : "Select",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                  ),
                                )),
                          )),
                      Divider(color: Colors.grey, height: 2.0),
                      SizedBox(height: 20),
                      Text(
                        "Area*",
                        style: TextStyle(color: infoLabel, fontSize: 17.0),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                          child: InkWell(
                            onTap: () async {
                              if(selectedCity == null){
                                Utils.showToast("Please select city first!", false);
                                return ;
                              }
                              if (dataObject == null) {
                                Utils.showProgressDialog(context);
                                StoreAreaResponse storeArea =
                                    await ApiController
                                        .getStoreAreaApiRequest();
                                Utils.hideProgressDialog(context);
                                List<Datum> data = storeArea.data;
                                //find city
                                for (int i = 0; i < data.length; i++) {
                                  if (data[i].city.id == selectedCity.id) {
                                    dataObject = data[i];
                                    break;
                                  }
                                }
                              }
                              if (selectedCity == null) {}
                              print("-area.length-${dataObject.area.length}--");
                              if (dataObject.area.length == 1) {
                                setState(() {
                                  selectedArea = dataObject.area[0];
                                });
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AreaOptionDialog((area) {
                                    setState(() {
                                      selectedArea = area;
                                    });
                                  }, dataObject),
                                );
                              }
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  selectedArea != null
                                      ? selectedArea.area
                                      : "Select",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                  ),
                                )),
                          )),
                      Divider(color: Colors.grey, height: 2.0),
                      SizedBox(height: 20),
                      InkWell(
                          onTap: () {
                            Geolocator()
                                .isLocationServiceEnabled()
                                .then((value) async {
                              if (value == true) {
                                var geoLocator = Geolocator();
                                var status = await geoLocator
                                    .checkGeolocationPermissionStatus();
                                print("--status--=${status}");
                                /*if (status == GeolocationStatus.denied || status == GeolocationStatus.restricted){
                                  Utils.showToast("Please accept location permissions to get your location from settings!", false);
                                }*/

                                var result = await Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SelectLocationOnMap(),
                                      fullscreenDialog: true,
                                    ));
                                if (result != null) {
                                  locationData = result;
                                  if (locationData.address.isNotEmpty) {
                                    addressController.text =
                                        locationData.address;
                                  }
                                }
                              } else {
                                Utils.showToast("Please turn on gps!", false);
                              }
                            });
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'Enter or Select Location - ',
                              style: TextStyle(color: infoLabel, fontSize: 17),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Click here',
                                    style: TextStyle(
                                      color: Colors.lightBlue,
                                      decoration: TextDecoration.underline,
                                    )),
                                TextSpan(
                                    text: '*',
                                ),
                                // can add more TextSpans here...
                              ],
                            ),
                          )),
                      SizedBox(height: 10),
                      Container(
                        color: Colors.grey[200],
                        height: 100.0,
                        child: new TextField(
                          controller: addressController,
                          keyboardType: TextInputType.multiline,
                          maxLength: 100,
                          maxLines: null,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 10, bottom: 10, top: 10, right: 10),
                              hintText: AppConstant.enterAddress),
                        ),
                      ),
                      Divider(color: Colors.grey, height: 2.0),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Full Name:*",
                          style: TextStyle(color: infoLabel, fontSize: 17.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: Container(
                          child: new TextField(
                            controller: fullnameController,
                            keyboardType: TextInputType.multiline,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 0, bottom: 0, top: 0, right: 0)),
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey, height: 2.0),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Zip/Postal Code:",
                          style: TextStyle(color: infoLabel, fontSize: 17.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Container(
                          child: new TextField(
                            controller: zipCodeController,
                            keyboardType: TextInputType.number,
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 0, bottom: 0, top: 0, right: 0)),
                          ),
                        ),
                      ),
                      Divider(color: Colors.grey, height: 2.0),
                      SizedBox(height: 30),
                      Align(
                        alignment: Alignment.center,
                        child: ButtonTheme(
                          minWidth: 180.0,
                          height: 40.0,
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                side: BorderSide(color: appTheme)),
                            onPressed: () async {
                              bool isNetworkAvailable =
                                  await Utils.isNetworkAvailable();
                              if (!isNetworkAvailable) {
                                Utils.showToast(AppConstant.noInternet, false);
                                return;
                              }

                              if (selectedCity == null) {
                                Utils.showToast(AppConstant.selectCity, false);
                                return;
                              }
                              if (selectedArea == null) {
                                Utils.showToast(AppConstant.selectArea, false);
                                return;
                              }
                              if (addressController.text.trim().isEmpty) {
                                Utils.showToast(
                                    AppConstant.pleaseEnterAddress, false);
                                return;
                              }
                              if (fullnameController.text.trim().isEmpty) {
                                Utils.showToast(
                                    AppConstant.pleaseFullname, false);
                                return;
                              }
                              /*if(zipCodeController.text.trim().isEmpty) {
                                Utils.showToast(AppConstant.enterZipCode, false);
                                return;
                              }*/

                              print(
                                  "--addressController---${addressController.text}---");

                              Utils.showProgressDialog(context);
                              ApiController.saveDeliveryAddressApiRequest(
                                      widget.selectedAddress == null
                                          ? "ADD"
                                          : "EDIT",
                                      zipCodeController.text,
                                      addressController.text,
                                      selectedArea.areaId,
                                      selectedArea.area,
                                      widget.selectedAddress == null
                                          ? null
                                          : widget.selectedAddress.id,
                                      fullnameController.text,
                                      selectedCity.city,
                                      selectedCity.id,
                                      "${locationData.lat}",
                                      "${locationData.lng}")
                                  .then((response) {
                                Utils.hideProgressDialog(context);
                                //print('@@REsonsesss'+response.toString());
                                if (response != null && response.success) {
                                  print('@@response.success');
                                  //widget.callback();
                                  Utils.showToast(response.message, true);
                                  Navigator.pop(context, true);
                                  //Navigator.of(context, rootNavigator: true)..pop()..pop();
                                } else {
                                  print('Not @@response.success');
                                  Utils.showToast(
                                      "Error while saving address!", true);
                                }
                              });
                            },
                            color: appTheme,
                            padding: EdgeInsets.all(5.0),
                            textColor: Colors.white,
                            child: Text("Done"),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ))),
        ));
  }
}

class CityDialog extends StatefulWidget {
  final Function(Datum) callback;

  CityDialog(this.callback);

  @override
  CityDialogState createState() => CityDialogState();
}

class CityDialogState extends BaseState<CityDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      child: FutureBuilder(
        future: ApiController.getStoreAreaApiRequest(),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container();
          } else {
            if (projectSnap.hasData) {
              StoreAreaResponse response = projectSnap.data;
              if (response != null && !response.success) {
                Utils.showToast("No data found!", false);
              }
              if (response.success) {
                List<Datum> data = response.data;

                print("--cityDialog-${data.length}--");
                return cityDialogContent(context, data);
              } else {
                return Container();
              }
            } else {
              return Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.black26,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)),
              );
            }
          }
        },
      ),
    );
  }

  Widget cityDialogContent(BuildContext context, List<Datum> data) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
              height: 40,
              color: appTheme,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 35.0),
                  Text("City",
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              )),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              itemBuilder: (context, index) {
                Datum area = data[index];
                return InkWell(
                    onTap: () {
                      widget.callback(area);
                      Navigator.pop(context, true);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 1.0, color: Colors.black)),
                        color: Colors.white,
                      ),
                      child: Center(child: Text(area.city.city)),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AreaOptionDialog extends StatefulWidget {
  final Function(Area) callback;
  Datum dataObject;

  AreaOptionDialog(this.callback, this.dataObject);

  @override
  AreaOptionDialogState createState() => AreaOptionDialogState();
}

class AreaOptionDialogState extends State<AreaOptionDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0.0,
      child: dialogContent(context, widget.dataObject.area),
    );
  }

  dialogContent(BuildContext context, List<Area> areaList) {
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Container(
              height: 40,
              color: appTheme,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 35.0),
                  Text("Area",
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              )),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: areaList.length,
              itemBuilder: (context, index) {
                Area area = areaList[index];
                return InkWell(
                    onTap: () {
                      widget.callback(area);
                      Navigator.pop(context, true);
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 1.0, color: Colors.black)),
                        color: Colors.white,
                      ),
                      child: Center(child: Text(area.area)),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
