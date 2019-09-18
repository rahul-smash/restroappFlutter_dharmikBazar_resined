import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/Screens/SaveDeliveryAddress.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class AddDeliveryAddress extends StatefulWidget {

  @override
  _AddDeliveryAddressState createState() => _AddDeliveryAddressState();
}

class _AddDeliveryAddressState extends State<AddDeliveryAddress> {

  ProceedBottomBar proceedBottomBar = new ProceedBottomBar();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          title: Text("Delivery Addresses"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      body: Column(
        children: <Widget>[
          Divider(color: Colors.white, height: 2.0),
          Container(
            height: 50.0,
            color: Colors.deepOrange,
            child: InkWell(
              onTap: () {
                goToNextScreen(context);
                //print("on click message");
                /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SaveDeliveryAddress()),
                );*/
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: const Icon(
                        CupertinoIcons.add_circled,
                        color: Colors.white,
                        size: 35.0,
                      ),
                      padding: const EdgeInsets.all(0),
                      onPressed: () {

                      }),
                  Text(
                    "Add Delivery Addresses",
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ),
          DeliveryAddressList(),
        ],
      ),
      bottomNavigationBar: proceedBottomBar,
    );
  }
}

void goToNextScreen(BuildContext _context) async {
  var result = await Navigator.push(_context, new MaterialPageRoute(
    builder: (BuildContext context) => new SaveDeliveryAddress(),
    fullscreenDialog: true,)
  );
  if(result == AppConstant.Refresh){
    print("----Refresh-Cart--Refresh Refresh-");
    //updateTotalPrice();
  }
}

class DeliveryAddressList extends StatefulWidget{

  DeliveryAddressListState state = new DeliveryAddressListState();

  @override
  DeliveryAddressListState createState() => state;

}

class DeliveryAddressListState extends State<DeliveryAddressList>{

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: ApiController.deliveryAddressApiRequest(),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container(color: const Color(0xFFFFE306));
          }else{
            if(projectSnap.hasData){
              //print('---projectSnap.Data-length-${projectSnap.data.length}---');
              List<DeliveryAddressData> dataList =projectSnap.data;
              print('---DeliveryAddressData----: ${dataList.length}');
              //return Container(color: const Color(0xFFFFE306));
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    DeliveryAddressData area = dataList[index];

                    return new Card(
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: Text(area.firstName,
                                style: TextStyle(fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                            child: Row(
                              children: <Widget>[
                                new Icon(
                                  Icons.phone, color: Colors.grey,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Text(area.mobile),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                            child: Row(
                              children: <Widget>[
                                new Icon(
                                  Icons.location_on, color: Colors.grey,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Text(area.address),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                            child: Row(
                              children: <Widget>[
                                new Icon(
                                  Icons.email, color: Colors.grey,
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Text(area.email),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: Colors.grey, thickness: 1.0),

                        ],
                      ),
                    );

                  },
                ),
              );
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
    );
  }

}

class ProceedBottomBar extends StatefulWidget {
  final _ProceedBottomBarState state = new _ProceedBottomBarState();

  @override
  _ProceedBottomBarState createState() => state;
}

class _ProceedBottomBarState extends State<ProceedBottomBar> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 50.0,
      color: Colors.deepOrange,
      child: InkWell(
        onTap: () {
          print("on click message");
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
}
