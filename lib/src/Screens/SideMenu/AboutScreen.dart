import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/SharedPrefs.dart';
import 'package:restroapp/src/models/ReferEarnData.dart';
import 'package:restroapp/src/models/StoreResponseModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/MySeparator.dart';
import 'package:restroapp/src/utils/Utils.dart';

class AboutScreen extends StatefulWidget {
  AboutScreen(BuildContext context);

  @override
  State<StatefulWidget> createState() {
    return _AboutScreenState();
  }
}

class _AboutScreenState extends State<AboutScreen> {
  String aboutUs;
  ReferEanCode referEanCode = new ReferEanCode();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final txtCode = new TextEditingController();
  String code ;

  @override
  void initState() {
    super.initState();
    _onShare();
   // _aboutUsData();
  }

  _aboutUsData() async {
    StoreModel store = await SharedPrefs.getStore();
    setState(() {
      aboutUs = store.aboutUs;
      print("----aboutUs-----${aboutUs}-----");
    });
  }

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
        child: SingleChildScrollView(
            child: new Column(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
              Container(
                margin: new EdgeInsets.only(top: 15.0),
                child: Align(
                    alignment: Alignment.center,
                    child: new Text(
                      AppConstant.txt_Refer,
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    )),
              ),
              new Align(
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
                margin: new EdgeInsets.only(top: 20.0),
                height: 180.0,
                width: 150.0,
                decoration: new BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/gift.png"),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                margin: new EdgeInsets.only(top: 10.0),
                child: const MySeparator(color: Colors.grey),
              ),
              Container(
                margin: new EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Align(
                    alignment: Alignment.center,
                    child: new Text(
                      AppConstant.txt_Refer_code,
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.grey,
                      ),
                    )),
              ),
              Container(
                margin: new EdgeInsets.only(top: 10.0),
                child: const MySeparator(color: Colors.grey),
              ),
              Container(
                margin: new EdgeInsets.only(top: 15.0),
                child: Align(
                    alignment: Alignment.center,

                /*  child: new  Text(""code"",style: TextStyle(
                    color: Colors.blue,
                  ),
                  ),*/

                    child: new Text(

                        AppConstant.txt_code,
                        // onChanged: (v) => phoneController.text = v,
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          color: Colors.blue,
                        )),
                   ),
              ),
              Container(
                  margin: new EdgeInsets.fromLTRB(30.0, 20.0, 5.0, 20.0),
                  child: Align(
                      alignment: Alignment.center,
                      child: new Text(
                        AppConstant.txt_sharing_content,
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Colors.black,
                        ),
                      ))),
              new Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.only(left: 40.0, top: 20.0, right: 40.0),
                  child: RaisedButton(
                    color: appTheme,
                    disabledColor: appTheme,
                    child:  Text(
                    AppConstant.txt_share,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: share,
                  )),
            ])),
      ),
    );
  }
  Future<void> share() async {
    ReferEarn getReferEan = await SharedPrefs.getReferEarn();
    await FlutterShare.share(
        title: 'Kindly download',
        text: 'Kindly download' + getReferEan.sharedMessage + 'app from',
        chooserTitle: 'Refer & Earn');
  }
  void _onShare() {

    print('@@Functionality is pending');

      Utils.showProgressDialog(context);
      ApiController.referEarn()
          .then((response) {
        Utils.hideProgressDialog(context);
        if(response.status){
          code=response.userReferCode;
          print('@@refernceCode--'+code);

        }

          //  Navigator.pop(context);
      });
  }
  }
class ReferEanCode {

  String getCode;
}
