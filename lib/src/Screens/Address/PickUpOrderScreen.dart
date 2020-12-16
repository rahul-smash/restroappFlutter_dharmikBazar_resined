import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restroapp/src/models/PickUpModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/BaseState.dart';
import 'package:restroapp/src/utils/DialogUtils.dart';
import 'package:restroapp/src/utils/Utils.dart';

import 'StoreLocationScreen.dart';

class PickUpOrderScreen extends StatefulWidget {
  PickUpModel storeArea;
  OrderType pickUp;

  PickUpOrderScreen(this.storeArea, this.pickUp);

  @override
  _PickUpOrderScreen createState() => _PickUpOrderScreen();
}

class _PickUpOrderScreen extends BaseState<PickUpOrderScreen> {
  Datum cityObject;
  Area areaObject;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PickUp Order"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context, false),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min, // <-- notice 'min' here. Important
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                color: Color(0xff000000),
                width: 1,
              )),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Select City:",
                          style: TextStyle(color: infoLabel, fontSize: 18.0),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                          child: InkWell(
                            onTap: () async {
                              Datum result =
                                  await DialogUtils.displayCityDialog(
                                      context, "Select City", widget.storeArea);
                              if (result == null) return;
                              cityObject = result;
                              setState(() {});
                              print("--object->---${cityObject.city.city}-");
                            },
                            child: Container(
                              child: Text(
                                cityObject == null
                                    ? "City"
                                    : "${cityObject.city.city}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Select Area:",
                          style: TextStyle(color: infoLabel, fontSize: 18.0),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                          child: InkWell(
                            onTap: () async {
                              Area result = await DialogUtils.displayAreaDialog(
                                  context, "Select Area", cityObject);
                              if (result == null) return;
                              areaObject = result;
                              setState(() {});
                            },
                            child: Container(
                              child: Text(
                                areaObject == null
                                    ? "Area"
                                    : areaObject.areaName,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          child: InkWell(
            onTap: () {
              if (cityObject != null && areaObject != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          StoreLocationScreen(areaObject, widget.pickUp)),
                );
              } else {
                Utils.showToast("Please select City and Area", true);
              }
            },
            child: Container(
              height: 40,
              color: appTheme,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Proceed",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
