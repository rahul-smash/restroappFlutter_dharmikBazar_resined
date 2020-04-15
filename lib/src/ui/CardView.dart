import 'package:flutter/material.dart';
import 'package:restroapp/src/Screens/HomeScreen.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/StoreData.dart';
import 'package:restroapp/src/models/store_list.dart';
import 'package:restroapp/src/utils/Constants.dart';
import 'package:restroapp/src/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cardview extends StatefulWidget {

  StoreListModel store;

  Cardview(this.store);

  @override
  State<StatefulWidget> createState() {
    return CardviewState(store);
  }
}

class CardviewState extends State<Cardview> {

  StoreListModel store;
  String renderUrl;

  CardviewState(this.store);

  Widget get storeCard {
    String imgUrl = "https://s3.amazonaws.com/store-asset/1562067647-unnamed_(1).png";
    if(store.store_logo.isEmpty){

    }else{
      imgUrl = store.store_logo;
    }

    return
      new Card(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(backgroundImage:NetworkImage(imgUrl)),
                  title: Text('${store.store_name}:'),
                  subtitle: Text('${store.country}'),
                  onTap: () {
                    //print("----onCardTapped-${store.id}");
                    onCardTapped(store.id);
                    //Go to the next screen with Navigator.push
                  },
                ),
              ]
          )
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child:  storeCard,
    );
  }

  onCardTapped(String storeId) async{
    try {
      //print("----storeId ${storeId}");
      callVersionApi(AppConstant.DEVICE_ID,storeId);
    } catch (e) {
      print(e);
    }

  }

  callVersionApi(String key,String storeId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String deviceId = prefs.getString(key);
      print("----deviceId ${deviceId}");

      SharedPrefs.storeSharedValue(AppConstant.STORE_ID, storeId);

      Utils.showProgressDialog(context);

      ApiController.versionApiRequest(storeId,deviceId).then((storeData) {

        print(storeData.store.id);
        Utils.hideProgressDialog(context);
        if(storeData.success){
          Route route = MaterialPageRoute(builder: (context) => HomeScreen(storeData));
          Navigator.pushReplacement(context, route);
          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(storeData)),);
        }else{
          Utils.showToast("Please try again", false);
        }
      });

    } catch (e) {
      print(e);
    }
  }

}

