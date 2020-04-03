import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/SideMenu/SaveDeliveryAddress.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import '../BookOrder/ConfirmOrderScreen.dart';

class DeliveryAddressList extends StatefulWidget {
  @override
  _AddDeliveryAddressState createState() => _AddDeliveryAddressState();
}

class _AddDeliveryAddressState extends State<DeliveryAddressList> {
  int selectedIndex = 0;
  List<DeliveryAddressData> addressList = [];

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
          addCreateAddressButton(),
          addAddressList()
        ],
      ),
      bottomNavigationBar: addProceedBar(),
    );
  }

  Widget addCreateAddressButton() {
    return Container(
      height: 50.0,
      color: appTheme,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) =>
                    new SaveDeliveryAddress(null, () {
                  setState(() {});
                }),
                fullscreenDialog: true,
              ));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                  size: 35.0,
                ),
                padding: const EdgeInsets.all(0),
                onPressed: () {}),
            Text(
              "Add Delivery Address",
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget addAddressList() {
    return FutureBuilder(
      future: ApiController.getAddressApiRequest(),
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return Container();
        } else {
          if (projectSnap.hasData) {
            DeliveryAddressResponse response = projectSnap.data;
            if (response.success) {
              addressList = response.data;
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
    );
  }

  Widget addAddressCard(DeliveryAddressData area, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    area.firstName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0),
                  ),
                  Checkbox(
                    value: selectedIndex == index,
                    onChanged: (value) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          addAddressInfoRow(Icons.phone, area.mobile),
          addAddressInfoRow(Icons.location_on, area.address),
          addAddressInfoRow(Icons.email, area.email),
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
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SaveDeliveryAddress(area, () {
                              setState(() {});
                            }),
                            fullscreenDialog: true,
                          ));
                    },
                  ),
                ),
                Container(
                  color: Colors.grey,
                  height: 30,
                  width: 1,
                ),
                Flexible(
                    child: InkWell(
                  child: Align(
                    alignment: Alignment.center,
                    child: new Text("Remove Address"),
                  ),
                  onTap: () {
                    showDialogForDelete(area);
                  },
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addAddressInfoRow(IconData icon, String info) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Row(
        children: <Widget>[
          new Icon(
            icon,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text(info),
          ),
        ],
      ),
    );
  }

  Widget addProceedBar() {
    return Container(
      height: 50.0,
      color: appTheme,
      child: InkWell(
        onTap: () {
          if (addressList.length == 0) {
            Utils.showToast(AppConstant.selectAddress, false);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ConfirmOrderScreen(addressList[selectedIndex], "2")),
            );
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

  void showDialogForDelete(DeliveryAddressData area) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete"),
          content: new Text(AppConstant.deleteAddress),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                Utils.showProgressDialog(context);
                ApiController.deleteDeliveryAddressApiRequest(area.id)
                    .then((response) {
                  Utils.hideProgressDialog(context);
                  if (response != null && response.success) {
                    setState(() {});
                  }
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
  }
}
