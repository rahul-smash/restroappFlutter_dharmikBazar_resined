import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/ReferEarnData.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/MySeparator.dart';
import 'package:restroapp/src/utils/Utils.dart';

class ReferEarn extends StatefulWidget {

  ReferEarn();

  @override
  State<StatefulWidget> createState() {
    return _ReferEarnState();
  }
}

class _ReferEarnState extends State<ReferEarn> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text(
          AppConstant.aboutUs,
          style: new TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: new Container(
        child: FutureBuilder(
          future: ApiController.referEarn(),
          builder: (context,projectSnap){
            if (projectSnap.connectionState == ConnectionState.none &&
                projectSnap.hasData == null) {
              return Container(color: const Color(0xFFFFE306));
            }else{
              if(projectSnap.hasData){

                ReferEarnData referEarn = projectSnap.data;

                return SingleChildScrollView(
                    child:Column(crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: new EdgeInsets.only(top: 15.0),
                            child: Align(
                                alignment: Alignment.center,
                                child: new Text(
                                  "Refer N Earn",
                                  style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                    color: Colors.black,
                                  ),
                                )),
                          ),
                          Align(
                              alignment: Alignment.center,
                              child: new Text(
                                AppConstant.txt_coupon_firebies,
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              )),
                          Container(
                            margin: new EdgeInsets.only(top: 20.0,bottom: 10),
                            width: 150.0,
                            height: 150.0,
                            decoration: new BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/gift.png"),
                                  fit: BoxFit.scaleDown),
                            ),
                          ),
                          Container(
                            //margin: new EdgeInsets.only(top: 10.0),
                            child: const MySeparator(color: Colors.grey),
                          ),
                          Container(
                            margin: new EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Align(
                                alignment: Alignment.center,
                                child: new Text(
                                  AppConstant.txt_Refer_code,
                                  style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.grey,
                                  ),
                                )),
                          ),
                          Container(
                            //margin: EdgeInsets.only(top: 10.0),
                            child: MySeparator(color: Colors.grey),
                          ),
                          Container(
                            margin: new EdgeInsets.only(top: 15.0),
                            child: Align(alignment: Alignment.center,
                              child: new Text(
                                  "${referEarn.userReferCode}",
                                  style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.0,
                                    color: Colors.blue,
                                  )),
                            ),
                          ),
                          Container(
                              margin: new EdgeInsets.fromLTRB(20.0, 20.0, 5.0, 20.0),
                              child: Align(
                                  alignment: Alignment.center,
                                  child: new Text(
                                   "${referEarn.referEarn.sharedMessage}" ,textAlign: TextAlign.center,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                      color: Colors.black,
                                    ),
                                  ))),
                          Container(
                              width: double.infinity,
                              padding:
                              const EdgeInsets.only(left: 30.0, top: 20.0, right: 40.0),
                              child: RaisedButton(
                                color: appTheme,
                                disabledColor: appTheme,
                                child:  Text(
                                  AppConstant.txt_share,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: (){
                                  share();
                                },
                              )),
                        ]));
              }else{
                return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.black26,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.black26)),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> share() async {
    StoreModel store = await SharedPrefs.getStore();
    await FlutterShare.share(
        title: 'Kindly download',
        text: 'Kindly download' + store.storeName + 'app from',
        linkUrl: store.androidShareLink,
        chooserTitle: 'Refer & Earn');
  }

}
