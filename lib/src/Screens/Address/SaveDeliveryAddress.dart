import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreDeliveryAreasResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';

class SaveDeliveryAddress extends StatefulWidget {
  final DeliveryAddressData selectedAddress;
  final VoidCallback callback;

  SaveDeliveryAddress(this.selectedAddress, this.callback);

  @override
  _SaveDeliveryAddressState createState() => _SaveDeliveryAddressState();
}

class _SaveDeliveryAddressState extends State<SaveDeliveryAddress> {
  StoreArea selectedArea;
  TextEditingController addressController = new TextEditingController();
  TextEditingController zipCodeController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.selectedAddress != null) {
      selectedArea = StoreArea();
      selectedArea.id = widget.selectedAddress.areaId;
      selectedArea.areaName = widget.selectedAddress.areaName;
      addressController.text = widget.selectedAddress.address;
      zipCodeController.text = widget.selectedAddress.zipCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text('Delivery Addresses'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )),
        body: SingleChildScrollView(
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: new Text(
                          "Add Address",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20.0),
                        ),
                      ),
                      SizedBox(height: 50),
                      Text(
                        "Area",
                        style: TextStyle(color: Colors.black, fontSize: 17.0),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    AreaOptionDialog((area) {
                                      setState(() {
                                        selectedArea = area;
                                      });
                                }),
                              );
                            },
                            child: Text(
                              selectedArea != null
                                  ? selectedArea.areaName
                                  : "Select",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                            ),
                          )),
                      Divider(color: Colors.grey, height: 2.0),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: InkWell(
                          onTap: () {
                            getLocation().then((value) {
                              setState(() {
                                addressController.text = value;
                              });
                            });
                          },
                          child: Text(
                            "Get Current Location",
                            style:
                                TextStyle(color: Colors.black, fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.grey[200],
                        height: 100.0,
                        child: new TextField(
                          controller: addressController,
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          maxLines: null,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 5, bottom: 5, top: 5, right: 5),
                              hintText: 'Enter Complete Address'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Zip/Postal Code:",
                          style: TextStyle(color: Colors.black, fontSize: 17.0),
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
                          minWidth: 150.0,
                          height: 50.0,
                          child: RaisedButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                side: BorderSide(color: appTheme)),
                            onPressed: () {
                              if (selectedArea == null) {
                                Utils.showToast("Please select area", false);
                              } else if (addressController.text
                                  .trim()
                                  .isEmpty) {
                                Utils.showToast(
                                    "Enter complete address", false);
                              } else if (zipCodeController.text
                                  .trim()
                                  .isEmpty) {
                                Utils.showToast("Enter zipcode", false);
                              } else {
                                // edit and save api
                                Utils.showProgressDialog(context);
                                ApiController.saveDeliveryAddressApiRequest(
                                        widget.selectedAddress == null
                                            ? "ADD"
                                            : "EDIT",
                                        zipCodeController.text,
                                        addressController.text,
                                        selectedArea.id,
                                        selectedArea.areaName,
                                        widget.selectedAddress == null
                                            ? null
                                            : widget.selectedAddress.id)
                                    .then((response) {
                                  Utils.hideProgressDialog(context);
                                  if (response != null && response.success) {
                                    widget.callback();
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            },
                            color: appTheme,
                            padding: EdgeInsets.all(5.0),
                            textColor: Colors.white,
                            child: Text("Done", style: TextStyle(fontSize: 20, fontFamily: 'DIN')),
                          ),
                        ),
                      ),
                    ],
                  ))),
        ));
  }

  Future<String> getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    return first.addressLine;
  }
}

class AreaOptionDialog extends StatefulWidget {
  final Function(StoreArea) callback;
  AreaOptionDialog(this.callback);

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
      child: FutureBuilder(
        future: ApiController.getDeliveryArea(),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container();
          } else {
            if (projectSnap.hasData) {
              StoreDeliveryAreasResponse response = projectSnap.data;
              if (response.success) {
                List<StoreArea> areas = response.areas;
                return dialogContent(context, areas);
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

  dialogContent(BuildContext context, List<StoreArea> areaList) {
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
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Select Area",
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: areaList.length,
                itemBuilder: (context, index) {
                  StoreArea area = areaList[index];
                  return ListTile(
                    onTap: () {
                      widget.callback(area);
                      Navigator.pop(context, true);
                    },
                    title: Text(area.areaName),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
