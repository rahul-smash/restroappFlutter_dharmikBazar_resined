import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/Address/DeliveryAddressList.dart';
import 'package:restroapp/src/Screens/Address/PickUpOrderScreen.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';

class OrderSelectionScreen extends StatefulWidget {

  @override
  _OrderSelectionScreen createState() => _OrderSelectionScreen();
}

class _OrderSelectionScreen extends State<OrderSelectionScreen> {
  DatabaseHelper databaseHelper = new DatabaseHelper();

  StoreModel store;
  String pickupfacility,delieveryAdress;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddresKey();
  }
  void getAddresKey() async {
    store = await SharedPrefs.getStore();
    setState(() {
      pickupfacility = store.pickupFacility;
      delieveryAdress = store.deliveryFacility;
      //String dine=store.
      print('@@OrderSelectionScreen   '+pickupfacility+'  Delievery'+delieveryAdress);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: ListView(children: <Widget>[
          Visibility(
            visible: true,
            child:  GestureDetector(
              onTap: () {
                print('@@CartBottomView----'+"DeliveryScreen");
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryAddressList(true)),
                );
              },
              child: new Container(
                margin: const EdgeInsets.fromLTRB(10.0, 90.0, 10.0, 10.0),
                padding: const EdgeInsets.all(10.0),
                child: new Row(
                  children: [
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 90.0, 10.0, 10.0),
                            height: 100.0,
                            width: 100.0,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: new AssetImage(
                                  'images/deliver.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
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
            visible: true,
            child:  GestureDetector(
              onTap: () {
                print('@@CartBottomView----'+"PickUPActivy");
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PickUpOrderScreen()),
                );
              },
              child: new Container(
                margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                padding: const EdgeInsets.all(10.0),
                child: new Row(
                  children: [
                    // First child in the Row for the name and the
                    new Expanded(
                      // Name and Address are in the same column
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Code to create the view for name.
                          new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 10.0),
                            height: 100.0,
                            width: 100.0,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: new AssetImage(
                                  'images/pickup.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
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
            visible: false,
            child: GestureDetector(
              onTap: () {
                print('@@CartBottomView----'+"DineIn");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryAddressList(true)),
                );
              },
              child: new Container(
                padding: const EdgeInsets.all(10.0),
                child: new Row(
                  children: [
                    // First child in the Row for the name and the
                    new Expanded(
                      // Name and Address are in the same column
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Code to create the view for name.
                          new Container(
                            margin: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),

                            height: 100.0,
                            width: 100.0,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: new AssetImage(
                                  'images/dining.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),

                          /* new Container(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: new Text(
                            AppConstant.dine,
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                        ),*/
                          // Code to create the view for address.

                        ],
                      ),
                    ),
                    // Icon to indicate the phone number.
                  ],
                ),
              ),
            ),)

        ]));

    /* child: addBottomBar());*/
  }


  Widget addBottomBar() {
    return Column(
      children: [
        new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                print('@@CartBottomView----'+"PickUPActivy");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryAddressList(true)),
                );
              },
              child: new Container(
                padding: const EdgeInsets.all(15.0),
                child: new Column(
                  children: [
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: new AssetImage(
                                  'images/logo.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon to indicate the phone number.
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                print('@@CartBottomView----'+"DelieveryAddressList");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryAddressList(true)),
                );
              },
              child: new Container(
                padding: const EdgeInsets.all(15.0),
                child: new Column(
                  children: [
                    new Expanded(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          new Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                image: new AssetImage(
                                  'images/theme35.png',
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),


          ],
        ),
      ],
    );
  }


}