import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restroapp/src/ui/CardView.dart';
import 'dart:convert';
import 'models/store_data.dart';
import 'models/store_list.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    TextEditingController editingController = TextEditingController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restro App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(
            title: Text('Search'),
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() => Navigator.pop(context, false),
            )
        ),
        body: StoreListUI(),
      ),
    );
  }
}

class StoreListUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    print("createStatee createState");
    return _StoreListWithSearch();
  }
}

class _StoreListWithSearch extends State<StoreListUI> {

  TextEditingController editingController = TextEditingController();
  String url = 'https://app.restroapp.com/1/api_v5/storeList';
  Map<String, String> headers = {"device_id": "abaf785580c22722","user_id": "","device_token": "","platform": "android"};


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
                                StoreListModel storelist = projectSnap.data[index];
                                //print('index: ${index}');
                                return Cardview(storelist);
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
                      future: postRequest(url,headers),
                    ),
                  ),


                ],
            ),
        ),

    );
  }

}

Future<List<StoreListModel>> postRequest(String url, Map jsonMap) async {
  //print('$url , $jsonMap');

  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(jsonMap)));
  HttpClientResponse response = await request.close();
  String reply = await response.transform(utf8.decoder).join();
  print(reply);
  //print("API response $reply");
  httpClient.close();
  final parsed = json.decode(reply);
  List<StoreListModel> storelist = (parsed["data"] as List).map<StoreListModel>((json) => new StoreListModel.fromJson(json)).toList();
  //print(" storelist ${storelist.length}");

  return storelist;
}
