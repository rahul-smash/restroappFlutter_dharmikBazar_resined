import 'package:flutter/material.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/BaseState.dart';
import 'package:restroapp/src/utils/Utils.dart';

class AddSubscriptionScreen extends StatefulWidget {

  AddSubscriptionScreen();

  @override
  _AddSubscriptionScreenState createState() {
    return _AddSubscriptionScreenState();
  }
}

class _AddSubscriptionScreenState extends BaseState<AddSubscriptionScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Add Subscription"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        height: 60.0,
                        color: Colors.grey[200],
                        child: InkWell(
                          onTap: (){

                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon( Icons.add,color: Colors.black,size: 30.0,),
                                Text(
                                  "Add Delivery Address",
                                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Deliver To",style: TextStyle(fontSize: 16),),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                                      child: Row(
                                        children: [
                                          Text("Vicky Sharma",
                                            style: TextStyle(fontSize: 18,color: Colors.black),),

                                          Container(
                                            height: 30.0,
                                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                            color: appTheme,
                                            child: InkWell(
                                              onTap: () async {},
                                              child: ButtonTheme(
                                                minWidth: 60,
                                                child: RaisedButton(
                                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                  textColor: Colors.grey[600],
                                                  color: Colors.grey[300],
                                                  onPressed: () async {
                                                  },
                                                  child: Text("Home",
                                                    style: TextStyle(color: Colors.grey[700],),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )

                                        ],
                                      ),
                                    ),
                                    Text("Netsmartz House, Floor 3, Plot No. 10, Rajiv Gandhi IT Park, Chandigarh, 160101",style: TextStyle(fontSize: 16),),
                                  ],
                                ),
                              ),
                            ),

                            Container(
                              height: 35.0,
                              margin: EdgeInsets.fromLTRB(0, 20, 10, 0),
                              color: appTheme,
                              child: InkWell(
                                onTap: () async {},
                                child: ButtonTheme(
                                  minWidth: 80,
                                  child: RaisedButton(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    textColor: Colors.grey[600],
                                    color: Colors.grey[300],
                                    onPressed: () async {
                                    },
                                    child: Text("Change",
                                      style: TextStyle(color: Colors.grey[700],),
                                    ),
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        height: 1,
                        color: Colors.grey,
                      )

                    ],
                  ),
                )
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Wrap(
                children: [
                  addSubscriptionBtn()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addSubscriptionBtn() {


    return Container(
      height: 50.0,
      color: appTheme,
      child: InkWell(
        onTap: () async {},
        child: ButtonTheme(
          minWidth: Utils.getDeviceWidth(context),
          child: RaisedButton(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            textColor: Colors.white,
            color: appTheme,
            onPressed: () async {
            },
            child: Text("Subscribe",style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
        ),
      ),
    );

  }
}