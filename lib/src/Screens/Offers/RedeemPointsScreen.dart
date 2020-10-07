import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/LoyalityPointsModel.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class RedeemPointsScreen extends StatefulWidget {

  final DeliveryAddressData address;
  final String paymentMode; // 2 = COD, 3 = Online Payment
  final Function(TaxCalculationModel) callback;
  bool isComingFromPickUpScreen;
  String areaId;
  List<String> reddemPointsCodeList;
  bool isOrderVariations=false;
  List<OrderDetail> responseOrderDetail;

  RedeemPointsScreen(this.address,this.paymentMode, this.isComingFromPickUpScreen,
      this.areaId,this.callback,this.reddemPointsCodeList,this.isOrderVariations,this.responseOrderDetail);

  @override
  RedeemPointsScreenState createState() => RedeemPointsScreenState();
}

class RedeemPointsScreenState extends State<RedeemPointsScreen> {

  DatabaseHelper databaseHelper = new DatabaseHelper();
  String area_id_value;
  List<LoyalityData> loyalityList = List();
  bool isLoading = true;
  LoyalityPointsModel loyalityPointsModel;

  @override
  void initState() {
    super.initState();
    callLoyalityPointsApi();
    area_id_value = widget.isComingFromPickUpScreen ? widget.areaId : widget.address.areaId;
  }

  void callLoyalityPointsApi() {
    isLoading = true;
    ApiController.getLoyalityPointsApiRequest().then((response){
      this.loyalityPointsModel = response;
      setState(() {
        isLoading = false;
        if(loyalityPointsModel.success){
          loyalityList = loyalityPointsModel.data;
        }else{
          Utils.showToast("No data found!", false);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffdbdbdb),
        appBar: AppBar(
            title: Text("Redeem Points"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context, false),
            )),
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
        //elevation: 0.0,
        body: Container(
          child: Column(
            children: <Widget>[
              Image.asset('images/process_img.png',fit:BoxFit.fitWidth,),
              Divider(color:Color(0xffdbdbdb),height: 1,),
                  isLoading
                  ? Center(child: CircularProgressIndicator())
                  : loyalityList == null
                  ? SingleChildScrollView(child:Center(child: Text('No Data found!')))
                  : loyalityList.isEmpty ? Utils.getEmptyView2("No Data found!") :showListView(),
            ],
          ),
        ),
    );
  }

  Widget showListView() {
    return Expanded(
      child: ListView.builder(
          itemCount: loyalityList.length,
          itemBuilder: (context, index) {
            LoyalityData loyalityData = loyalityList[index];
            Color redeemButtonColor;
            try {
              print("${loyalityPointsModel.loyalityPoints}");
              double userLoyalityPoints = double.parse(loyalityPointsModel.loyalityPoints);
              int userLoyalityPointsValue = userLoyalityPoints.round();
              int pointsValue = int.parse(loyalityData.points);
              if(userLoyalityPointsValue >= pointsValue){
                redeemButtonColor = appTheme;
              }else{
                redeemButtonColor = Color(0xffdbdbdb);
              }
            } catch (e) {
              print(e);
            }

            String redeemText;
            if(widget.reddemPointsCodeList.contains(loyalityData.couponCode)){
              redeemText = "Redeemed";
            }else{
              redeemText = "Redeem";
            }

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
                          child: ListTile(
                            title: Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("${AppConstant.currency}${loyalityData.amount} OFF for ${loyalityData.points} Points",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontWeight: FontWeight.w500),),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text("Redeem for ${loyalityData.points} Points",
                                          textAlign: TextAlign.end,style: TextStyle(color: appTheme),),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Text("${loyalityData.couponCode}",style: TextStyle(color: appTheme),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Container(
                              child: Padding(
                                padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: RaisedButton(
                                  padding:EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  textColor: Colors.white,
                                  color: redeemButtonColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    //side: BorderSide(color: Colors.red)
                                  ),
                                  onPressed: () async {
                                    bool isNetworkAvailable = await Utils.isNetworkAvailable();
                                    if(!isNetworkAvailable){
                                      Utils.showToast(AppConstant.noInternet, false);
                                      return;
                                    }
                                    if(redeemButtonColor == appTheme){
                                      print("-1--redeemButtonColor=${redeemButtonColor}");

                                      if(widget.reddemPointsCodeList.contains(loyalityData.couponCode)){
                                        //Utils.showToast("Already Applied this Coupon", false);
                                      }else{

                                        if(widget.reddemPointsCodeList.isEmpty){
                                          databaseHelper.getCartItemsListToJson(isOrderVariations:widget.isOrderVariations,responseOrderDetail: widget.responseOrderDetail).then((json) {
                                            if (json.length == 2) {
                                              Utils.showToast(
                                                  "All Items are out of stock.",
                                                  true);
                                              Utils.hideProgressDialog(context);
                                              return;
                                            }
                                            validateCouponApi(loyalityData, json,);
                                          });
                                        }else{
                                          Utils.showToast("Please remove the applied coupon first!", false);
                                        }

                                      }
                                    }else{
                                      print("-2--redeemButtonColor=${redeemButtonColor}");
                                    }
                                  },
                                  child: new Text("${redeemText}"),
                                ),
                              ),
                            ),
                          ),
                        )
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

  void validateCouponApi(LoyalityData loyalityData, String json) {
    print("----couponCode-----=>${loyalityData.amount}");
    Utils.showProgressDialog(context);
    ApiController.multipleTaxCalculationRequest(loyalityData.couponCode,
        loyalityData.amount, "0", json).then((response) async {

      Utils.hideProgressDialog(context);
      if (response.success) {
        widget.callback(response.taxCalculation);
      }else{
        Utils.showToast(response.message, true);
      }
      Navigator.pop(context, true);

    });

  }
}
