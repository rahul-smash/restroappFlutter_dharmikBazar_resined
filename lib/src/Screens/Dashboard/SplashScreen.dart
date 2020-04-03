import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:restroapp/src/Screens/Dashboard/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
        future: ApiController.callVersionApi("1"),
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none &&
              projectSnap.hasData == null) {
            return Container(color: const Color(0xFFFFE306));
          } else {
            if (projectSnap.hasData) {
              StoreListResponse storeResponse = projectSnap.data;
              return MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: ListView.builder(
                    itemCount: storeResponse.stores.length,
                    itemBuilder: (context, index) {
                      StoreModel store = storeResponse.stores[index];
                      return Card(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: CircleAvatar(
                                    backgroundImage: NetworkImage(store
                                            .storeLogo.isEmpty
                                        ? "https://s3.amazonaws.com/store-asset/1562067647-unnamed_(1).png"
                                        : store.storeLogo)),
                                title: Text('${store.storeName}:'),
                                subtitle: Text('${store.country}'),
                                onTap: () {
                                  callVersionApi(store.id);
                                  //Go to the next screen with Navigator.push
                                },
                              ),
                            ]),
                      );
                    },
                  ));
            } else {
              return Center(
                child: CircularProgressIndicator(
                    backgroundColor: Colors.black26,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black26)),
              );
            }
          }
        },
      ),
    );
  }

  callVersionApi(String selectedStoreId) async {
    try {
      Utils.showProgressDialog(context);

      ApiController.versionApiRequest(selectedStoreId).then((storeData) {
        Utils.hideProgressDialog(context);
        if (storeData.success) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(storeData.store)));
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
