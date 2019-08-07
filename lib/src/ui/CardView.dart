import 'package:flutter/material.dart';
import 'package:restroapp/src/models/store_list.dart';

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

  onCardTapped(String id) {
    print("----onCardTapped ${id}");

  }
}