import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreAreasData.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:restroapp/src/utils/Utils.dart';
//import 'package:location/location.dart';

class SaveDeliveryAddress extends StatefulWidget {

  bool isEditAddress;
  DeliveryAddressData area;
  SaveDeliveryAddress(this.isEditAddress,this.area);

  @override
  _SaveDeliveryAddressState createState() => _SaveDeliveryAddressState();
}

class _SaveDeliveryAddressState extends State<SaveDeliveryAddress> {

  String areaTitle = "select here";
  String areaId = "";
  String address_id="";
  TextEditingController addressController = new TextEditingController();
  TextEditingController zipCodeController = new TextEditingController();
  bool runForFirstOnly = false;
  String address ="";

  @override
  Widget build(BuildContext context) {

    if(runForFirstOnly == false){
      if(widget.isEditAddress){
        areaTitle = widget.area.areaName;
        areaId = widget.area.areaId;
        address_id = widget.area.id;
        addressController.text = widget.area.address;
        zipCodeController.text = widget.area.zipcode;
        runForFirstOnly = true;
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      //body: SingleChildScrollView(child: YourBody()),
      appBar: AppBar(
          title: Text('Delivery Addresses'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, AppConstant.NOT_Refresh),
          )),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Align(
              alignment: Alignment.center,
              // Align however you like (i.e .centerRight, centerLeft)
              child: new Text(
                "Add Address",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20.0),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 10, 10),
            child: InkWell(
              onTap: () {
                print("Select Area click");

                AreaCustomDialog dialog = new AreaCustomDialog();

                showDialog(context: context,
                  builder: (BuildContext context) => dialog,
                ).then((_) async {
                  setState((){
                    print("--------------showDialog setState------------------");
                    areaTitle = dialog.state.selectedArea.typeName;
                    areaId = dialog.state.selectedArea.id;
                    print(dialog.state.selectedArea.id);
                    print(dialog.state.selectedArea.typeName);

                });
                });
              },
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      "Select Area:",
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: new Text(
                        "${areaTitle}",//
                        style: TextStyle(color: Colors.black, fontSize: 22.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey, height: 2.0),

          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: InkWell(
              onTap: (){
                getLocation().then((value) {
                  setState(() {
                    address = value;
                    print("---ADDRESS--- = ${address}");
                    addressController.text = address;
                  });
                });

              },
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      "Current Location:",
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: InkWell(
              onTap: () {
                print("Enter Full Address");
              },
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      "Enter Full Address:",
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: new Container(
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
                              contentPadding: EdgeInsets.only( left: 5, bottom: 5, top: 5, right: 5),
                              hintText: 'enter here'),

                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey, height: 2.0),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
            child: InkWell(
              onTap: () {
                print("zip/postal code");
              },
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: new Text(
                      "Zip/Postal Code:",
                      style: TextStyle(color: Colors.black, fontSize: 17.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: new Container(
                        child: new TextField(
                          controller: zipCodeController,
                          keyboardType: TextInputType.number,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.only( left: 0, bottom: 0, top: 0, right: 0),
                              hintText: 'enter here'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(color: Colors.grey, height: 2.0),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: ButtonTheme(
              minWidth: 150.0,
              height: 45.0,
              child: RaisedButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(28.0),
                    side: BorderSide(color: Colors.red)
                ),
                onPressed: () {

                  print(areaTitle);
                  if(areaId.isEmpty){
                    Utils.showToast("Select Area", false);
                    return;
                  }
                  if(addressController.text.trim().isEmpty){
                    Utils.showToast("enter address", false);
                    return;
                  }
                  print(areaId);
                  print(addressController.text);
                  print(zipCodeController.text);

                  ProgressDialog pr;
                  //For normal dialog
                  pr = new ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
                  pr.show();

                  String method;
                  if(widget.isEditAddress){
                    method = AppConstant.EDIT;
                  }else{
                    method = AppConstant.ADD;
                  }
                  // edit and save api
                  ApiController.saveDeliveryAddressApiRequest(method,zipCodeController.text,
                      addressController.text, areaId, areaTitle,address_id).then((value){
                    pr.hide();
                    Navigator.pop(context, AppConstant.Refresh);
                  });

                },
                color: Colors.red,
                padding: EdgeInsets.all(5.0),
                textColor: Colors.white,
                child: Text("Done".toUpperCase(),style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //print(position);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates( coordinates);
    var first = addresses.first;
    //print("${first.featureName} : ${first.addressLine}");
    //print(' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
    return first.addressLine;
  }
}

class AreaCustomDialog extends StatefulWidget {

  AreaCustomDialogState state = new AreaCustomDialogState();
  @override
  AreaCustomDialogState createState() => state;

}

class AreaCustomDialogState extends State<AreaCustomDialog> {

  Area selectedArea = new Area();

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      //backgroundColor: Colors.transparent,
      //child: dialogContent(context),
      child: FutureBuilder(
        future: ApiController.deliveryAreasRequest(),
        builder: (context, projectSnap){
          if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container(color: const Color(0xFFFFE306));
          }else{
            if(projectSnap.hasData){
              //print('---projectSnap.Data-length-${projectSnap.data.length}---');
              //return Container(color: const Color(0xFFFFE306));
              List<Area> areaList  = projectSnap.data;
              return dialogContent(context,areaList);
            }else {
              //print('-------CircularProgressIndicator----------');
              return Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.black26,
                    valueColor:AlwaysStoppedAnimation<Color>(Colors.black26)),
              );
            }
          }
        },
      ),
    );
  }

  dialogContent(BuildContext context, List<Area> areaList) {
    TextEditingController editingController = TextEditingController();
    return Container(
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Consts.padding),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: areaList.length,
                itemBuilder: (context, index) {
                  Area area = areaList[index];
                  return ListTile(
                    onTap: (){
                      print(area.typeName);
                      selectedArea = area;
                      Navigator.pop(context,true);
                      /*setState(() {
                        print("dialog area list click");
                      });*/
                    },
                    title: Text(area.typeName),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterSearchResults(String value) {
    print("filterSearchResults ${value}");
  }

}

class Consts {
  Consts._();

  static const double padding = 10.0;
}
