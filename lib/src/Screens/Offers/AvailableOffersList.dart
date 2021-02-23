import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restroapp/src/apihandler/ApiController.dart';
import 'package:restroapp/src/database/DatabaseHelper.dart';
import 'package:restroapp/src/models/DeliveryAddressResponse.dart';
import 'package:restroapp/src/models/StoreOffersResponse.dart';
import 'package:restroapp/src/models/SubscriptionTaxCalculationResponse.dart';
import 'package:restroapp/src/models/TaxCalulationResponse.dart';
import 'package:restroapp/src/utils/AppColor.dart';
import 'package:restroapp/src/utils/AppConstants.dart';
import 'package:restroapp/src/utils/Utils.dart';

class AvailableOffersDialog extends StatefulWidget {
  final DeliveryAddressData address;
  final String paymentMode;
  String shippingCharges = '0'; // 2 = COD, 3 = Online Payment
  final Function(TaxCalculationModel) callback;
  final Function(SubscriptionTaxCalculation) subcriptionCallback;
  bool isComingFromPickUpScreen;
  String areaId;
  List<String> appliedCouponCodeList;
  bool isOrderVariations = false;
  bool isSubcriptionScreen = false;
  List<OrderDetail> responseOrderDetail = List();
  Map<String, String> subcriptionMap = Map();

  AvailableOffersDialog(
      this.address,
      this.paymentMode,
      this.isComingFromPickUpScreen,
      this.areaId,
      this.callback,
      this.appliedCouponCodeList,
      this.isOrderVariations,
      this.responseOrderDetail,
      this.shippingCharges,
      {this.isSubcriptionScreen = false,
      this.subcriptionCallback,
      this.subcriptionMap});

  @override
  AvailableOffersState createState() => AvailableOffersState();
}

class AvailableOffersState extends State<AvailableOffersDialog> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  String area_id_value;

  @override
  void initState() {
    super.initState();
    area_id_value =
        widget.isComingFromPickUpScreen ? widget.areaId : widget.address.areaId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffdbdbdb),
        appBar: AppBar(
            title: Text("Available Offers"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context, false),
            )),
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
        //elevation: 0.0,
        body: Container(
          color: Color(0xffdbdbdb),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: ApiController.storeOffersApiRequest(area_id_value),
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

                              String applyText;
                              if (widget.appliedCouponCodeList
                                  .contains(offer.couponCode)) {
                                applyText = "Applied";
                              } else {
                                applyText = "Apply";
                              }
                              return Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
                                padding: EdgeInsets.fromLTRB(10, 10, 5, 10),
                                color: Color(0xffffffff),
                                child: Row(
                                  children: <Widget>[
                                    SizedBox(
                                      width: 60,
                                      child: Text(
                                        "${getOfferName(offer)}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                        height: 60,
                                        child: VerticalDivider(
                                            color: Colors.grey)),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 5, 0, 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  "Use code",
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 0, 3),
                                                  child: SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      "${offer.couponCode}",
                                                      style: TextStyle(
                                                        color:
                                                            appThemeSecondary,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "to avail this offer",
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 10, 0, 0),
                                              child: Text(
                                                  "Min order -  ${AppConstant.currency}${offer.minimumOrderAmount}"),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 5),
                                              child: Text(
                                                  "Valid Till- ${Utils.convertStringToDate2(offer.validTo)}"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: RaisedButton(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          textColor: Colors.black,
                                          color: Color(0xffdbdbdb),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            //side: BorderSide(color: Colors.red)
                                          ),
                                          onPressed: () async {
                                            bool isNetworkAvailable =
                                                await Utils
                                                    .isNetworkAvailable();
                                            if (!isNetworkAvailable) {
                                              Utils.showToast(
                                                  AppConstant.noInternet,
                                                  false);
                                              return;
                                            }
                                            if (widget.appliedCouponCodeList
                                                .contains(offer.couponCode)) {
                                              //Utils.showToast("Already Applied this Coupon", false);
                                            } else {
                                              if (widget.appliedCouponCodeList
                                                  .isEmpty) {
                                                if (!widget
                                                    .isSubcriptionScreen) {
                                                  databaseHelper
                                                      .getCartItemsListToJson(
                                                          isOrderVariations: widget
                                                              .isOrderVariations,
                                                          responseOrderDetail:
                                                              widget
                                                                  .responseOrderDetail)
                                                      .then((json) {
                                                    if (json.length == 2) {
                                                      Utils.showToast(
                                                          "All Items are out of stock.",
                                                          true);
                                                      return;
                                                    }
                                                    validateCouponApi(
                                                        offer.couponCode, json);
                                                  });
                                                } else {
                                                  validateCouponApi(
                                                      offer.couponCode,
                                                      widget.subcriptionMap[
                                                          'orderJson']);
                                                }
                                              } else {
                                                Utils.showToast(
                                                    "Please remove the applied coupon first!",
                                                    false);
                                              }
                                            }
                                          },
                                          child: new Text("${applyText}"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Container(
                            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
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
    print("----couponCode-----=>${couponCode}");
    Utils.showProgressDialog(context);
    ApiController.validateOfferApiRequest(couponCode, widget.paymentMode, json)
        .then((validCouponModel) {
      if (validCouponModel != null && validCouponModel.success) {
        Utils.showToast(validCouponModel.message, true);
        print("-discountAmount-=${validCouponModel.discountAmount}-");
        if (widget.isSubcriptionScreen) {
          ApiController.subscriptionMultipleTaxCalculationRequest(
                  couponCode: couponCode,
                  discount: validCouponModel.discountAmount,
                  shipping: widget.shippingCharges,
                  orderJson: widget.subcriptionMap['orderJson'],
                  userAddressId: widget.subcriptionMap['userAddressId'],
                  userAddress: widget.subcriptionMap['userAddress'],
                  deliveryTimeSlot:widget.isComingFromPickUpScreen?'': widget.subcriptionMap['deliveryTimeSlot'],
                  cartSaving: widget.subcriptionMap['cartSaving'],
                  totalDeliveries: widget.subcriptionMap['totalDeliveries'])
              .then((value) {
            Utils.hideProgressDialog(context);
            if (value.success) {
              widget.subcriptionCallback(value.data);
            }
            Navigator.pop(context, true);
          });
        } else {
          ApiController.multipleTaxCalculationRequest(couponCode,
                  validCouponModel.discountAmount, widget.shippingCharges, json)
              .then((response) async {
            Utils.hideProgressDialog(context);
            if (response.success) {
              widget.callback(response.taxCalculation);
            }
            Navigator.pop(context, true);
          });
        }
      } else {
        Utils.hideProgressDialog(context);
        Utils.showToast(validCouponModel.message, true);
      }
    });
  }

  getOfferName(OfferModel offer) {
    /*
    "discount_type": "3" == discount %oFF \n discount_upto black Uptp Rs100
    "discount_type": "2" == and discount_upto  OFF
    "discount_type": "1" == Uptp Rs100
    */

    String offerName = "";
    if (offer.discount_type == "3") {
      offerName =
          "${offer.discount}%\nOFF\nUpto ${AppConstant.currency}${offer.discount_upto}";
    }
    if (offer.discount_type == "2") {
      offerName = "Upto ${AppConstant.currency}${offer.discount_upto}\nOFF";
    }
    if (offer.discount_type == "1") {
      offerName = "Upto ${AppConstant.currency}${offer.discount_upto}\nOFF";
    }
    return offerName;
  }
}
