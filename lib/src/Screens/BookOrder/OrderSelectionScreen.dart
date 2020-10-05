import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/Screens/Address/PickUpOrderScreen.dart';
import 'package:restroapp/src/Screens/Address/StoreLocationScreen.dart';
import 'package:restroapp/src/Screens/Address/StoreLocationScreenWithMultiplePick.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/PickUpModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

class OrderSelectionScreen extends StatefulWidget {

  String pickupfacility,  delieveryAdress;
  OrderSelectionScreen(this.pickupfacility, this.delieveryAdress);

  @override
  _OrderSelectionScreen createState() => _OrderSelectionScreen();
}

class _OrderSelectionScreen extends State<OrderSelectionScreen> {

  DatabaseHelper databaseHelper = new DatabaseHelper();
  //StoreModel store;
  bool pickUpFacility,delieveryAddress;
  double mheight;

  @override
  void initState() {
    super.initState();
    //mheight = 310;
    print("OrderSelectionScreen ${widget.pickupfacility} and ${widget.delieveryAdress}");
    if(widget.pickupfacility == "1" && widget.delieveryAdress == "1"){
      pickUpFacility = true;
      delieveryAddress = true;
    }else{

      if(widget.pickupfacility == "1"){
        pickUpFacility = true;
      }
      if(widget.pickupfacility == "0"){
        pickUpFacility = false;
      }
      if(widget.delieveryAdress == "1"){
        delieveryAddress = true;
      }
      if(widget.delieveryAdress == "0"){
        delieveryAddress = false;
      }

      if(widget.pickupfacility == "0" && widget.delieveryAdress == "0"){
        pickUpFacility = false;
        delieveryAddress = true;
      }

    }

    if(pickUpFacility == true && delieveryAddress == true){
      mheight = 310;
    }else{
      mheight = 160;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: Text("Select Delivery Option"),
        content: Container(
          width: double.maxFinite,
          height: mheight,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Visibility(
                        visible: delieveryAddress,
                        child:  GestureDetector(
                          onTap: () async {
                            print('@@CartBottomView----'+"DeliveryScreen");

                            StoreModel storeObject = await SharedPrefs.getStore();
                            bool status = Utils.checkStoreOpenTime(storeObject,OrderType.Delivery);
                            if(!status){
                              Utils.showToast("${storeObject.closehoursMessage}", false);
                              Navigator.pop(context);
                              return;
                            }
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DeliveryAddressList(true,OrderType.Delivery)),
                            );

                          },
                          child: new Container(
                            margin: EdgeInsets.fromLTRB(10.0, 00.0, 10.0, 10.0),
                            padding: EdgeInsets.all(10.0),
                            child: new Row(
                              children: [
                                new Expanded(
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
                                        height: 100.0,
                                        width: 150.0,
                                        decoration: new BoxDecoration(
                                          image: DecorationImage(
                                            image: new AssetImage(
                                              'images/deliver.png',
                                            ),
                                            fit: BoxFit.scaleDown,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                      Text("Deliver"),
                                      // Code to create the view for address.
                                    ],
                                  ),
                                ),
                                // Icon to indicate the phone number.
                              ],
                            ),
                          ),
                        ),),
                      Visibility(
                        visible: pickUpFacility,
                        child:  GestureDetector(
                          onTap: ()  async {
                            print('@@CartBottomView----'+"PickUPActivy");

                            StoreModel storeObject = await SharedPrefs.getStore();
                            bool status = Utils.checkStoreOpenTime(storeObject,OrderType.Delivery);
                            if(!status){
                              Utils.showToast("${storeObject.closehoursMessage}", false);
                              Navigator.pop(context);
                              return;
                            }

                            Utils.showProgressDialog(context);
                            ApiController.getStorePickupAddress().then((response){

                              Utils.hideProgressDialog(context);
                              PickUpModel storeArea = response;

                              print('---PickUpModel---${storeArea.data.length}--');
                              if(storeArea != null && storeArea.data.isNotEmpty){
                                if(storeArea.data.length == 1 && storeArea.data[0].area.length == 1){
                                  Area areaObject = storeArea.data[0].area[0];
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StoreLocationScreen(areaObject,OrderType.PickUp)),
                                  );
                                }else{
                                  Navigator.pop(context);
                                  Navigator.push(context,
                                    MaterialPageRoute(
//                                        builder: (context) => PickUpOrderScreen(storeArea,OrderType.PickUp)),
                                        builder: (context) => StoreLocationScreenWithMultiplePick(storeArea,OrderType.PickUp)),
                                  );
                                }
                              }else{
                                Utils.showToast("No pickup data found!", true);
                              }
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                // First child in the Row for the name and the
                                Expanded(
                                  // Name and Address are in the same column
                                  child: new Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Code to create the view for name.
                                      Container(
                                        margin: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                                        height: 100.0,
                                        width: 150.0,
                                        decoration: new BoxDecoration(
                                          image: DecorationImage(
                                            image: new AssetImage(
                                              'images/pickup.png',
                                            ),
                                            fit: BoxFit.scaleDown,
                                          ),
                                          shape: BoxShape.rectangle,
                                        ),
                                      ),
                                      // Code to create the view for address.
                                      Text("Pickup"),
                                    ],
                                  ),
                                ),
                                // Icon to indicate the phone number.
                              ],
                            ),
                          ),
                        ),),
                    ]),
              )
            ],
          )
        )
    );

  }

}