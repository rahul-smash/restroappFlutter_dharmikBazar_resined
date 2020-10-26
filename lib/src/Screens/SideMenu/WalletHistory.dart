
import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/models/WalleModel.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class WalletHistoryScreen extends StatefulWidget {

  WalletHistoryScreen();

  @override
  _WalletHistoryScreenState createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {

  WalleModel walleModel;

  @override
  void initState() {
    super.initState();
    ApiController.getUserWallet().then((response){
      setState(() {
        this.walleModel = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: walleModel == null
          ? Utils.showIndicator()
          : SafeArea(
        child: Container(
          child: Stack(
            children: [

              Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: blue1,
                    height: 180.0,
                  ),

                ],
              ),

              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)
                    ),
                    height: Utils.getDeviceHeight(context)-180,
                    margin: EdgeInsets.only(top: 150,left: 15,right: 15),
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                          child: Text("Transcations",style: TextStyle(color: blue2,fontSize: 16)),
                        ),
                        ListView.builder(
                          itemBuilder: (context, index) {

                            return Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Column(
                                children: [
                                  showWalletView(walleModel.data.walletHistory[index]),
                                  SizedBox(height: 15,),
                                  Utils.showDivider(context),
                                ],
                              ),
                            );
                          },
                          itemCount: walleModel.data.walletHistory.length,
                          shrinkWrap: true,
                        ),
                      ],
                    )
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.fromLTRB(20, 80, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Wallet Balance",style: TextStyle(color: blue2,fontSize: 16),),
                    Row(
                      children: [
                        Text("${AppConstant.currency}",
                            style: TextStyle(color: Colors.white)),
                        Text("${walleModel.data.userWallet}",
                            style: TextStyle(color: Colors.white,fontSize: 24)),
                      ],
                    )
                  ],
                )
              ),

              Row(
                children: [
                  Padding(
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back,color: Colors.white,size: 30,),
                      //child: Image.asset("images/back.png",width: 25,height: 25,),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 15, 0, 10),
                  ),
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget showWalletView(WalletHistory walletHistory) {

    return Row(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Icon(Icons.add_circle_outline),
        ),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${walletHistory.label}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal)),
                SizedBox(height: 5),
                Text("#${walletHistory.displayOrderId}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 15)),
              ]
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('${AppConstant.currency}${walletHistory.refund}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal)),
                SizedBox(height: 5),
                Text("${Utils.convertWalletDate(walletHistory.dateTime.toString())}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey[500], fontSize: 15)),
              ]
          ),
        ),
      ],
    );
  }
}
