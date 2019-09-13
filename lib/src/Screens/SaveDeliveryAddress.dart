import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';

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
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AreaCustomDialog(
                  ),
                );
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
                onPressed: () {},
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
}

class AreaCustomDialog extends StatelessWidget {

  AreaCustomDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
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
              return Container(color: const Color(0xFFFFE306));
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

  dialogContent(BuildContext context) {
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
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('item is ${index}'),
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
