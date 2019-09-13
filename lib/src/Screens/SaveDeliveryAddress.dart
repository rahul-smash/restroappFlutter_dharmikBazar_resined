import 'package:flutter/material.dart';

class SaveDeliveryAddress extends StatefulWidget {
  @override
  _SaveDeliveryAddressState createState() => _SaveDeliveryAddressState();
}

class _SaveDeliveryAddressState extends State<SaveDeliveryAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      //body: SingleChildScrollView(child: YourBody()),
      appBar: AppBar(
          title: Text('Delivery Addresses'),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
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
                        "Area",
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
                          keyboardType: TextInputType.multiline,
                          maxLength: null,
                          maxLines: null,
                          decoration: new InputDecoration(
                              border: InputBorder.none,
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
        ],
      ),
    );
  }
}
