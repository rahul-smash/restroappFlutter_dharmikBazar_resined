import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/Utils.dart';

class AvailableOffersDialog extends StatefulWidget {

  final DeliveryAddressData address;
  final String paymentMode; // 2 = COD, 3 = Online Payment
  final Function(TaxCalculationModel) callback;
  bool isComingFromPickUpScreen;
  String areaId;

  AvailableOffersDialog(this.address, this.paymentMode,
      this.isComingFromPickUpScreen , this. areaId,this.callback);

  @override
  AvailableOffersState createState() => AvailableOffersState();
}

class AvailableOffersState extends State<AvailableOffersDialog> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  String area_id_value;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    area_id_value = widget.isComingFromPickUpScreen ? widget.areaId : widget.address.areaId;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0.0,
        child: Container(
          height: 350,
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(0.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              Container(
                  height: 50,
                  color: appTheme,
                  child: Center(
                    child: Text("Select Coupon",
                        style: TextStyle(color: Colors.white, fontSize: 18.0)),
                  )),
              FutureBuilder(
                future:ApiController.storeOffersApiRequest(area_id_value),
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.none &&
                      projectSnap.hasData == null) {
                    return Container();
                  } else {
                    if (projectSnap.hasData) {
                      StoreOffersResponse response = projectSnap.data;
                      if (response.success) {
                        List<OfferModel> offerList = response.offers;
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: offerList.length,
                            itemBuilder: (context, index) {
                              OfferModel offer = offerList[index];
                              return ListTile(
                                title: Text(
                                  offer.couponCode,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("Min Order ${offer.minimumOrderAmount}"),
                                  ],
                                ),
                                trailing: Container(
                                  child: Padding(
                                    padding:EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: new RaisedButton(
                                      padding:EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      textColor: Colors.white,color: appTheme,
                                      onPressed: () {
                                        Utils.showProgressDialog(context);
                                        databaseHelper.getCartItemsListToJson().then((json) {
                                          validateCouponApi(offer.couponCode, json);
                                        });
                                      },
                                      child: new Text("Apply"),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container(
                            child: Center(
                          child: Text(response.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black45,
                                fontSize: 18.0,
                              )),
                        ));
                      }
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
              ),
            ],
          ),
        ));
  }

  void validateCouponApi(String couponCode, String json) {
    //print("----couponCode-----=>${couponCode}");
    ApiController.validateOfferApiRequest(couponCode, widget.paymentMode, json).then((validCouponModel) {
      if (validCouponModel != null &&validCouponModel.success) {

        Utils.showToast(validCouponModel.message, true);

        ApiController.multipleTaxCalculationRequest(couponCode,validCouponModel.discountAmount, "0", json)
            .then((response) async {
          Utils.hideProgressDialog(context);
          if (response.success) {
            widget.callback(response.taxCalculation);
          }
          Navigator.pop(context, true);
        });
      } else {
        Utils.hideProgressDialog(context);
        Utils.showToast(validCouponModel.message, true);
      }
    });
  }
}
