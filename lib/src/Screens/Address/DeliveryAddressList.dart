import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restroapp/src/Screens/Address/SaveDeliveryAddress.dart';
import 'package:restroapp/src/UI/DragMarkerMap.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreRadiousResponse.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';
import '../BookOrder/ConfirmOrderScreen.dart';

class DeliveryAddressList extends StatefulWidget {

  final bool showProceedBar;
  DeliveryAddressResponse responsesData;
  DeliveryAddressList(this.showProceedBar,this.responsesData);

  @override
  _AddDeliveryAddressState createState() => _AddDeliveryAddressState();
}

class _AddDeliveryAddressState extends State<DeliveryAddressList> {

  int selectedIndex = 0;
  List<DeliveryAddressData> addressList = [];
  Area radiusArea;
  Coordinates coordinates;

  @override
  void initState() {
    super.initState();
    addressList = widget.responsesData.data;
    coordinates = new Coordinates(0.0, 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Delivery Addresses"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Column(
        children: <Widget>[
          Divider(color: Colors.white, height: 2.0),
          addCreateAddressButton(),
          addAddressList()
        ],
      ),
      bottomNavigationBar: widget.showProceedBar ? addProceedBar() : Container(height: 5),
    );
  }

  Widget addCreateAddressButton() {
    return Container(
      height: 50.0,
      color: appTheme,
      child: InkWell(
        onTap: () async {
          print("----addCreateAddressButton-------");

          StoreModel store = await SharedPrefs.getStore();
          print("--deliveryArea->--${store.deliveryArea}-------");
          if(store.deliveryArea == "0"){
            var result = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) =>
                SaveDeliveryAddress(null, () {
                  print("--Route-SaveDeliveryAddress-------");
                },"",coordinates),
              fullscreenDialog: true,
            ));
            print("--result--${result}-------");
            if(result != null){
              Utils.showProgressDialog(context);
              DeliveryAddressResponse response = await ApiController.getAddressApiRequest();
              setState(() {
                Utils.hideProgressDialog(context);
                addressList = response.data;
              });
            }

          }else if(store.deliveryArea == "1"){
            Utils.isNetworkAvailable().then((isConnected){
              if(isConnected){
                Utils.showProgressDialog(context);
                ApiController.storeRadiusApi().then((response) async {

                  Utils.hideProgressDialog(context);
                  if(response != null && response.success){
                    StoreRadiousResponse data =response;
                    Geolocator().isLocationServiceEnabled().then((isLocationServiceEnabled) async {
                      print("----isLocationServiceEnabled----${isLocationServiceEnabled}--");
                      if(isLocationServiceEnabled){

                        var geoLocator = Geolocator();
                        var status = await geoLocator.checkGeolocationPermissionStatus();
                        print("--status--=${status}");
                        if (status == GeolocationStatus.granted){
                          var result = await Navigator.push(context, new MaterialPageRoute(
                            builder: (BuildContext context) => DragMarkerMap(data),
                            fullscreenDialog: true,)
                          );
                          if(result != null){
                            radiusArea = result;
                            print("----radiusArea = result-------");
                            Utils.showProgressDialog(context);
                            DeliveryAddressResponse response = await ApiController.getAddressApiRequest();
                            Utils.hideProgressDialog(context);
                            setState(() {
                              print("----setState-------");
                              addressList = response.data;
                            });
                          }
                        }else{
                          Utils.showToast("Please accept location permissions to get your location from settings!", false);
                        }

                      }else{
                        Utils.showToast("Please turn on gps!", false);
                      }
                    });
                  }else{
                    Utils.showToast("No data found!", false);
                  }
                });


              }else{
                Utils.showToast(AppConstant.noInternet, false);
              }
            });

          }

        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.add_circle_outline,color: Colors.white,size: 35.0,),
                padding: const EdgeInsets.all(0),
                onPressed: () {}),
            Text("Add Delivery Address",style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget addAddressList() {
    //Utils.hideProgressDialog(context);
    if(addressList.isEmpty){
      return Center(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Text("No Delivery Address found!"),
        ),
      );
    }else{
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: addressList.length,
          itemBuilder: (context, index) {
            DeliveryAddressData area = addressList[index];
            return addAddressCard(area, index);
          },
        ),
      );
    }
  }

  Widget addAddressCard(DeliveryAddressData area, int index) {
    return Card(
      child: Padding(
          padding: EdgeInsets.only(top: 10, left: 6),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( area.firstName,
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 16.0),
                  ),
                  addAddressInfoRow(Icons.phone, area.mobile),
                  addAddressInfoRow(Icons.location_on, area.address),
                  addAddressInfoRow(Icons.email, area.email),
                ],
              ),
              Container(
                child: Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      activeColor: Color(0xFFE0E0E0),
                      checkColor: Colors.green,
                      value: selectedIndex == index,
                      onChanged: (value) {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    )),
              )
            ]),
            Divider(color: Color(0xFFBDBDBD), thickness: 1.0),
            addOperationBar(area)
          ])),
    );
  }

  Widget addAddressInfoRow(IconData icon, String info) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 5, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Colors.grey,),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: SizedBox(
              width: (Utils.getDeviceWidth(context)-150),
              child: Text(
                  info,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: infoLabel)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addOperationBar(DeliveryAddressData area) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: InkWell(
              child: Align(alignment: Alignment.center,
                child:Text("Edit Address",style: TextStyle(color: infoLabel, fontWeight: FontWeight.w500)),),
              onTap:() async {
                var result = await Navigator.push(context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>SaveDeliveryAddress(area, () {
                        print('@@---Edit---SaveDeliveryAddress----------');
                      },"",coordinates),
                      fullscreenDialog: true,
                    ));
                print("-Edit-result--${result}-------");
                if(result){
                  Utils.showProgressDialog(context);
                  DeliveryAddressResponse response = await ApiController.getAddressApiRequest();
                  setState(() {
                    Utils.hideProgressDialog(context);
                    addressList = response.data;
                  });
                }
              },
            ),
          ),
          Container(
            color: Colors.grey,
            height: 30,
            width: 1,
          ),
          Flexible(child: InkWell(
            child: Align(
              alignment: Alignment.center,
              child: new Text("Remove Address",style: TextStyle(color: infoLabel, fontWeight: FontWeight.w500)),
            ),
            onTap: () async {
              var results = await DialogUtils.displayDialog(context,"Delete",AppConstant.deleteAddress,
                  "Cancel","OK");
              if(results == true){
                Utils.showProgressDialog(context);
                ApiController.deleteDeliveryAddressApiRequest(area.id).then((response) async {
                  Utils.hideProgressDialog(context);
                  if (response != null && response.success) {
                    print("---showDialogForDelete-----");
                    Utils.showProgressDialog(context);
                    DeliveryAddressResponse response = await ApiController.getAddressApiRequest();
                    setState(() {
                      Utils.hideProgressDialog(context);
                      addressList = response.data;
                    });
                  }
                });
              }
              //showDialogForDelete(area);
            },
          )),
        ],
      ),
    );
  }

  Widget addProceedBar() {
    return Container(
      height: 50.0,
      color: appTheme,
      child: InkWell(
        onTap: () async {
          if (addressList.length == 0) {
            Utils.showToast(AppConstant.selectAddress, false);
          } else {

            StoreModel store = await SharedPrefs.getStore();
            print("--${store.onlinePayment}-}-");
            if(store.onlinePayment == "1"){
              //var result = await DialogUtils.displayPaymentDialog(context, "Select Payment",addressList[selectedIndex].note);
              var result = await DialogUtils.displayDialog(context, "Confirmation",addressList[selectedIndex].note,
              "Cancel","Proceed");
              if(result == true){
                Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ConfirmOrderScreen(addressList[selectedIndex],false,"")),
                );
              }

            }
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Proceed",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }

  /*getAddressList(){
    print("=====getAddressList==========");
    Utils.showProgressDialog(context);
    ApiController.getAddressApiRequest().then((responses){
      print("====called then future completes====");
      Utils.hideProgressDialog(context);
      DeliveryAddressResponse response = responses;
      setState(() {
        //Utils.hideProgressDialog(context);
        addressList = response.data;
      });
    }).whenComplete(() {
      Utils.hideProgressDialog(context);
      print("====called when future completes====");
    });
  }*/

}
