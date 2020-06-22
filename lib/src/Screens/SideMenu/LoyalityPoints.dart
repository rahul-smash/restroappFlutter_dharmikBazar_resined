import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/LoyalityPointsModel.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/BaseState.dart';
import 'package:restroapp/src/utils/Utils.dart';

class LoyalityPointsScreen extends StatefulWidget {

  StoreModel store;
  LoyalityPointsScreen(this.store);

  @override
  _LoyalityPointsScreenState createState() {
    return _LoyalityPointsScreenState();
  }
}

class _LoyalityPointsScreenState extends BaseState<LoyalityPointsScreen> {

  List<LoyalityData> loyalityList = List();
  bool isLoading = true;
  LoyalityPointsModel loyalityPointsModel;

  @override
  void initState() {
    super.initState();
    callLoyalityPointsApi();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffdbdbdb),
      appBar: AppBar(
          title: Text("Loyality Points"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Image.asset('images/process_img.png',fit:BoxFit.fitWidth,),
            Divider(color:Color(0xffdbdbdb),height: 1,),
            isLoading
                ? Center(child: CircularProgressIndicator())
                : loyalityList == null
                ? SingleChildScrollView(
                child: Center(child: Padding(padding: EdgeInsets.only(top: 50),
                  child: Text('No Data found!'),
                ),
                ))
                : showListView(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
            height: 100,
            width: Utils.getDeviceWidth(context),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bottom_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
                    textColor: Colors.black,
                    color: Color(0xffdbdbdb),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      //side: BorderSide(color: Colors.red)
                    ),
                    onPressed: () => null,
                    child: new Text(loyalityPointsModel == null ? "0" : "${loyalityPointsModel.loyalityPoints}"),
                  ),
                  Text("AVAILABLE POINTS")
                ],
              ),
            )
        ),
      ),
    );
  }

  void callLoyalityPointsApi() {
    isLoading = true;
    ApiController.getLoyalityPointsApiRequest().then((response){
      this.loyalityPointsModel = response;
      setState(() {
        isLoading = false;
        loyalityList = loyalityPointsModel.data;
      });
    });
  }

  Widget showListView() {

    return Expanded(
      child: loyalityList.isEmpty ? Padding(padding: EdgeInsets.only(top: 50),
        child: Utils.getEmptyView2("No data found!"),)
          :ListView.builder(
          itemCount: loyalityList.length,
          itemBuilder: (context, index) {
            LoyalityData loyalityData = loyalityList[index];
            return Container(
              color: Color(0xffdbdbdb),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    color: Color(0xffffffff),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: new Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Redeem",textAlign: TextAlign.left,
                                    style: TextStyle(fontWeight: FontWeight.w600),),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    //mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
                                    //crossAxisAlignment: CrossAxisAlignment.center, //Center Row contents vertically,
                                    children: <Widget>[
                                      Text("${loyalityData.points}",
                                        textAlign: TextAlign.end,style: TextStyle(fontSize: 18),),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(5, 3, 0, 0),
                                        child: Text("Points"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          child: new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Container(
                              padding:  EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffdbdbdb)),
                              child: Center(
                                child: Text("Get",style: TextStyle(fontWeight: FontWeight.w600),),
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          child: new Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Column(
                              children: <Widget>[
                                Text("Discount",style: TextStyle(fontWeight: FontWeight.w600),),
                                Text("${AppConstant.currency}${loyalityData.amount}",
                                  style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color:Color(0xffdbdbdb),height: 1,),
                ],
              ),
            );
          }
      ),
    );
  }
}