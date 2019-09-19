import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:restroapp/src/Screens/SaveDeliveryAddress.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class AddDeliveryAddress extends StatefulWidget {

  _AddDeliveryAddressState addressState = new _AddDeliveryAddressState();
  int selectedIndex = 0;
  @override
  _AddDeliveryAddressState createState() => addressState;
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
                //print("on click message");
                goToNextScreen(context,false,null).then((value){
                   print("-------on activity results--------");
                   if(value == AppConstant.Refresh){
                     print("-------Refresh View--------");
                     setState(() {

                     });
                   }
                });
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
          FutureBuilder(
            future: ApiController.deliveryAddressApiRequest(),
            builder: (context, projectSnap) {
              if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
                //print('project snapshot data is: ${projectSnap.data}');
                return Container(color: const Color(0xFFFFE306));
              }else{
                if(projectSnap.hasData){
                  //print('---projectSnap.Data-length-${projectSnap.data.length}---');
                  List<DeliveryAddressData> dataList =projectSnap.data;
                  //print('---DeliveryAddressData----: ${dataList.length}');
                  //this goes in our State class as a global variable
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        DeliveryAddressData area = dataList[index];
                        bool isChecked;
                        if(widget.selectedIndex == index){
                          isChecked = true;
                        }else{
                          isChecked = false;
                        }
                        //print("-----selectedIndex of postion---- = ${widget.selectedIndex}----------");
                        //print("-----index of postion = ${index} for value is ${isChecked}----");
                        return new Card(
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(area.firstName,
                                        style: TextStyle(fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 20.0),
                                      ),
                                      Checkbox(
                                        value: isChecked,
                                        onChanged: (value) {
                                          //print("---onChanged ${value} of postion = ${index}---");
                                          //isChecked = value;
                                          setState(() {
                                            widget.selectedIndex = index;
                                            //print("----selectedIndex is ${widget.selectedIndex}");
                                          });

                                          },
                                      ),
                                    ],
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
                                    Flexible(
                                        child:Padding(
                                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          child: Text(area.address),
                                        ),
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
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: InkWell(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: new Text("Edit Address"),
                                        ),
                                        onTap: (){
                                          //print("onTap Edit Address");
                                          goToNextScreen(context,true,area).then((value){
                                            print("-------on activity results--------");
                                            if(value == AppConstant.Refresh){
                                              //print("-------Refresh View--------");
                                              setState(() {

                                              });
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                    Container(color: Colors.grey, height: 30, width: 1,),
                                    Flexible(
                                        child: InkWell(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: new Text("Remove Address"),
                                          ),
                                          onTap: (){
                                            print("onTap Remove Address");
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                // return object of type Dialog
                                                return AlertDialog(
                                                  title: new Text("Delete"),
                                                  content: new Text("Are you sure you want to delete this address?"),
                                                  actions: <Widget>[
                                                    // usually buttons at the bottom of the dialog
                                                    new FlatButton(
                                                      child: new Text("Yes"),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();

                                                        Utils.showProgressDialog(context);
                                                        ApiController.deleteDeliveryAddressApiRequest(area.id).then((value){

                                                          Utils.hideProgressDialog(context);

                                                          setState(() {

                                                          });

                                                        });
                                                      },
                                                    ),
                                                    new FlatButton(
                                                      child: new Text("No"),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        )
                                    ),
                                  ],
                                ),
                              ),

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
          ),
        ],
      ),
      bottomNavigationBar: proceedBottomBar,
    );
  }
}


Future<String> goToNextScreen(BuildContext _context, bool isEditAddress, DeliveryAddressData area) async {
  var result = await Navigator.push(_context, new MaterialPageRoute(
    builder: (BuildContext context) => new SaveDeliveryAddress(isEditAddress,area),
    fullscreenDialog: true,)
  );
  if(result == AppConstant.Refresh){
    print("----Refresh-Cart--Refresh Refresh-");
    return AppConstant.Refresh;
  }else{
    return AppConstant.NOT_Refresh;
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
