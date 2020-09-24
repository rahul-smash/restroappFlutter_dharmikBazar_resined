import 'dart:convert';
import 'dart:io';

import 'package:restroapp/src/utils/Utils.dart';

import 'DeliveryAddressResponse.dart';
import 'TaxCalulationResponse.dart';

class OrderDetailsModel {
  String shipping_charges;
  String note;
  String totalPrice;
  String paymentMethod;
  TaxCalculationModel taxModel;
  DeliveryAddressData address;
  bool isComingFromPickUpScreen;
  String areaId;
  OrderType deliveryType;
  String razorpay_order_id;
  String razorpay_payment_id;
  String deviceId;
  String online_method;
  String userId;
  String deviceToken;
  String storeAddress;
  String selectedDeliverSlotValue;
  String cart_saving = "0.00";
  String encodedtaxDetail = "[]";
  String encodedtaxLabel = "[]";
  String encodedFixedTax = "[]";


  OrderDetailsModel(this.shipping_charges, this.note, this.totalPrice,
      this.paymentMethod, this.taxModel, this.address,
      this.isComingFromPickUpScreen, this.areaId, this.deliveryType,
      this.razorpay_order_id, this.razorpay_payment_id, this.deviceId,
      this.online_method, this.userId, this.deviceToken, this.storeAddress,
      this.selectedDeliverSlotValue, this.cart_saving){
    try {
      List jsonfixedTaxList =
      taxModel.fixedTax.map((fixedTax) => fixedTax.toJson()).toList();
      encodedFixedTax = jsonEncode(jsonfixedTaxList);
      //print("encodedFixedTax= ${encodedFixedTax}");
    } catch (e) {
      print(e);
    }

    try {
      List jsontaxDetailList =
      taxModel.taxDetail.map((taxDetail) => taxDetail.toJson()).toList();
      encodedtaxDetail = jsonEncode(jsontaxDetailList);
      //print("encodedtaxDetail= ${encodedtaxDetail}");
    } catch (e) {
      print(e);
    }

    try {
      List jsontaxLabelList =
      taxModel.taxLabel.map((taxLabel) => taxLabel.toJson()).toList();
      encodedtaxLabel = jsonEncode(jsontaxLabelList);
      //print("encodedtaxLabel= ${encodedtaxLabel}");
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() => {
        "shipping_charges": this.shipping_charges,
        "note": this.note,
        "calculated_tax_detail": "",
        "coupon_code": taxModel == null ? "" : '${taxModel.couponCode}',
        "device_id": deviceId,
        "user_address": this.isComingFromPickUpScreen == true
            ? storeAddress
            : address.address,
        "store_fixed_tax_detail": "",
        "tax": taxModel == null ? "0" : '${taxModel.tax}',
        "store_tax_rate_detail": "",
        "platform": Platform.isIOS ? "IOS" : "Android",
        "tax_rate": "0",
        "total": '${taxModel.total}',
        "user_id": userId,
        "device_token": deviceToken,
        "delivery_type": this.deliveryType==OrderType.Delivery?'Delivery':'PickUp',
        "user_address_id":
            isComingFromPickUpScreen == true ? areaId : address.id,
        "checkout": /*totalPrice*/ "${taxModel.itemSubTotal}",
        "payment_method": paymentMethod == "2" ? "COD" : "online",
        "discount": taxModel == null ? "" : '${taxModel.discount}',
        "payment_request_id": razorpay_order_id,
        "payment_id": razorpay_payment_id,
        "online_method": online_method,
        "delivery_time_slot": selectedDeliverSlotValue,
        "store_fixed_tax_detail": encodedFixedTax,
        "store_tax_rate_detail": encodedtaxLabel,
        "calculated_tax_detail": encodedtaxDetail,
        "cart_saving": cart_saving,
      };

   get orderDetails => json.encode(toJson());
}
