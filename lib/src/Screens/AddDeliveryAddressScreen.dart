import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/Screens/SaveDeliveryAddress.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
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
                print("on click message");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SaveDeliveryAddress()),
                );
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
          DeliverAddressList(),
        ],
      ),
      bottomNavigationBar: proceedBottomBar,
    );
  }
}

class DeliverAddressList extends StatefulWidget{

  DeliverAddressListState state = new DeliverAddressListState();

  @override
  DeliverAddressListState createState() => state;

}

class DeliverAddressListState extends State<DeliverAddressList>{

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
              print('---projectSnap.Data-length-${projectSnap.data.length}---');
              return Container(color: const Color(0xFFFFE306));

            }else {
              print('-------CircularProgressIndicator----------');
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
