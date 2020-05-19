import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiConstants.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';


class StoreListScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restro App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('RestroApp'),
          /*leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false),
            )*/
        ),
        body: StoreListUI(),
      ),
    );
  }
}

class StoreListUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StoreListWithSearch();
  }
}


class _StoreListWithSearch extends State<StoreListUI> {

  TextEditingController editingController = TextEditingController();
  Map<String, String> headers = {"device_id": "abaf785580c22722",
    "user_id": "","device_token": "","platform": "android"};

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return new Scaffold(

      body:Container(
        child:Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  print("onChanged value ${value}");
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
              child: FutureBuilder(
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.none && projectSnap.hasData == null) {
                    //print('project snapshot data is: ${projectSnap.data}');
                    return Container(color: const Color(0xFFFFE306));
                  } else {
                    if(projectSnap.hasData){
                      return ListView.builder(
                        itemCount: projectSnap.data.length,
                        itemBuilder: (context, index) {
                          //print(projectSnap.data);
                          //StoreListModel storelist = projectSnap.data[index];
                          //print('index: ${index}');
                          //return Cardview(storelist);
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                            backgroundColor: Colors.black26,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.black26)),
                      );
                    }
                  }
                },
                //future: ApiController.storeListRequest(ApiConstants.storeList,headers),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

