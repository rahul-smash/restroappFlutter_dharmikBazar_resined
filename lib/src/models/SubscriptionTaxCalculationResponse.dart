// To parse this JSON data, do
//
//     final subscriptionTaxCalculationResponse = subscriptionTaxCalculationResponseFromJson(jsonString);

import 'dart:convert';

import 'package:restroapp/src/models/TaxCalulationResponse.dart';

class SubscriptionTaxCalculationResponse {
  SubscriptionTaxCalculationResponse({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  SubscriptionTaxCalculation data;
  String message;

  SubscriptionTaxCalculationResponse copyWith(
          {bool success, SubscriptionTaxCalculation data, String message}) =>
      SubscriptionTaxCalculationResponse(
        success: success ?? this.success,
        data: data ?? this.data,
        message: message ?? this.message,
      );

  String toRawJson() => json.encode(toJson());

  factory SubscriptionTaxCalculationResponse.fromJson(
          String couponCode, Map<String, dynamic> json) =>
      SubscriptionTaxCalculationResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == '' ? null : json["message"],
        data: json["data"] == null
            ? null
            : SubscriptionTaxCalculation.fromJson(couponCode, json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
      };
}

class SubscriptionTaxCalculation {
  SubscriptionTaxCalculation({
    this.total,
    this.singleDayTotal,
    this.walletRefund,
    this.itemSubTotal,
    this.singleDayItemSubTotal,
    this.tax,
    this.singleDayTax,
    this.discount,
    this.singleDayDiscount,
    this.shipping,
    this.singleDayShipping,
    this.fixedTaxAmount,
    this.singleDayFixedTaxAmount,
    this.taxDetail,
    this.taxLabel,
    this.fixedTax,
    this.orderDetail,
    this.isChanged,
    this.couponCode,
    this.storeStatus,
    this.storeMsg,
    this.storeTimeSetting,
  });

  String total;
  String singleDayTotal;
  String walletRefund;
  String itemSubTotal;
  String singleDayItemSubTotal;
  String tax;
  String singleDayTax;
  String discount;
  String singleDayDiscount;
  String shipping;
  String singleDayShipping;
  String fixedTaxAmount;
  String singleDayFixedTaxAmount;
  List<TaxDetail> taxDetail;
  List<TaxLabel> taxLabel;
  List<dynamic> fixedTax;
  List<OrderDetail> orderDetail;
  bool isChanged;
  String couponCode;
  String storeStatus;
  String storeMsg;
  StoreTimeSetting storeTimeSetting;

  SubscriptionTaxCalculation copyWith({
    String total,
    String singleDayTotal,
    String walletRefund,
    String itemSubTotal,
    String singleDayItemSubTotal,
    String tax,
    String singleDayTax,
    String discount,
    String singleDayDiscount,
    String shipping,
    String singleDayShipping,
    String fixedTaxAmount,
    String singleDayFixedTaxAmount,
    List<TaxDetail> taxDetail,
    List<TaxLabel> taxLabel,
    List<dynamic> fixedTax,
    List<OrderDetail> orderDetail,
    bool isChanged,
    String couponCode,
    String storeStatus,
    String storeMsg,
    StoreTimeSetting storeTimeSetting,
  }) =>
      SubscriptionTaxCalculation(
        total: total ?? this.total,
        singleDayTotal: singleDayTotal ?? this.singleDayTotal,
        walletRefund: walletRefund ?? this.walletRefund,
        itemSubTotal: itemSubTotal ?? this.itemSubTotal,
        singleDayItemSubTotal:
            singleDayItemSubTotal ?? this.singleDayItemSubTotal,
        tax: tax ?? this.tax,
        singleDayTax: singleDayTax ?? this.singleDayTax,
        discount: discount ?? this.discount,
        singleDayDiscount: singleDayDiscount ?? this.singleDayDiscount,
        shipping: shipping ?? this.shipping,
        singleDayShipping: singleDayShipping ?? this.singleDayShipping,
        fixedTaxAmount: fixedTaxAmount ?? this.fixedTaxAmount,
        singleDayFixedTaxAmount:
            singleDayFixedTaxAmount ?? this.singleDayFixedTaxAmount,
        taxDetail: taxDetail ?? this.taxDetail,
        taxLabel: taxLabel ?? this.taxLabel,
        fixedTax: fixedTax ?? this.fixedTax,
        orderDetail: orderDetail ?? this.orderDetail,
        isChanged: isChanged ?? this.isChanged,
        couponCode: couponCode ?? this.couponCode,
        storeStatus: storeStatus ?? this.storeStatus,
        storeMsg: storeMsg ?? this.storeMsg,
        storeTimeSetting: storeTimeSetting ?? this.storeTimeSetting,
      );

  String toRawJson() => json.encode(toJson());

  factory SubscriptionTaxCalculation.fromJson(
          String couponCodePassed, Map<String, dynamic> json) =>
      SubscriptionTaxCalculation(
        total: json["total"] == null ? null : json["total"],
        singleDayTotal:
            json["single_day_total"] == null ? null : json["single_day_total"],
        walletRefund: json["wallet_refund"] == null
            ? null
            : json["wallet_refund"] is int || json["wallet_refund"] is double
                ? json["wallet_refund"].toString()
                : json["wallet_refund"],
        itemSubTotal:
            json["item_sub_total"] == null ? null : json["item_sub_total"],
        singleDayItemSubTotal: json["single_day_item_sub_total"] == null
            ? null
            : json["single_day_item_sub_total"],
        tax: json["tax"] == null ? null : json["tax"],
        singleDayTax:
            json["single_day_tax"] == null ? null : json["single_day_tax"],
        discount: json["discount"] == null ? null : json["discount"],
        singleDayDiscount: json["single_day_discount"] == null
            ? null
            : json["single_day_discount"],
        shipping: json["shipping"] == null ? null : json["shipping"],
        singleDayShipping: json["single_day_shipping"] == null
            ? null
            : json["single_day_shipping"],
        fixedTaxAmount:
            json["fixed_tax_amount"] == null ? null : json["fixed_tax_amount"],
        singleDayFixedTaxAmount: json["single_day_fixed_tax_amount"] == null
            ? null
            : json["single_day_fixed_tax_amount"],
        taxDetail: json["tax_detail"] == null
            ? null
            : List<TaxDetail>.from(
                json["tax_detail"].map((x) => TaxDetail.fromJson(x))),
        taxLabel: json["tax_label"] == null
            ? null
            : List<TaxLabel>.from(
                json["tax_label"].map((x) => TaxLabel.fromJson(x))),
        fixedTax: json["fixed_Tax"] == null
            ? null
            : List<FixedTax>.from(
                json["fixed_Tax"].map((x) => FixedTax.fromJson(x))),
        orderDetail: json["order_detail"] == null
            ? null
            : List<OrderDetail>.from(
                json["order_detail"].map((x) => OrderDetail.fromJson(x))),
        isChanged: json["is_changed"] == null ? null : json["is_changed"],
        couponCode: couponCodePassed,
        storeStatus: json["store_status"] == null ? null : json["store_status"],
        storeMsg: json["store_msg"] == null ? null : json["store_msg"],
        storeTimeSetting: json["StoreTimeSetting"] == null
            ? null
            : StoreTimeSetting.fromJson(json["StoreTimeSetting"]),
      );

  Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "single_day_total": singleDayTotal == null ? null : singleDayTotal,
        "wallet_refund": walletRefund == null ? null : walletRefund,
        "item_sub_total": itemSubTotal == null ? null : itemSubTotal,
        "single_day_item_sub_total":
            singleDayItemSubTotal == null ? null : singleDayItemSubTotal,
        "tax": tax == null ? null : tax,
        "single_day_tax": singleDayTax == null ? null : singleDayTax,
        "discount": discount == null ? null : discount,
        "single_day_discount":
            singleDayDiscount == null ? null : singleDayDiscount,
        "shipping": shipping == null ? null : shipping,
        "single_day_shipping":
            singleDayShipping == null ? null : singleDayShipping,
        "fixed_tax_amount": fixedTaxAmount == null ? null : fixedTaxAmount,
        "single_day_fixed_tax_amount":
            singleDayFixedTaxAmount == null ? null : singleDayFixedTaxAmount,
        "tax_detail": taxDetail == null
            ? null
            : List<dynamic>.from(taxDetail.map((x) => x.toJson())),
        "tax_label": taxLabel == null
            ? null
            : List<dynamic>.from(taxLabel.map((x) => x.toJson())),
        "fixed_Tax": fixedTax == null
            ? null
            : List<dynamic>.from(fixedTax.map((x) => x.toJson())),
        "order_detail": orderDetail == null
            ? null
            : List<dynamic>.from(orderDetail.map((x) => x.toJson())),
        "is_changed": isChanged == null ? null : isChanged,
        "store_status": storeStatus == null ? null : storeStatus,
        "store_msg": storeMsg == null ? null : storeMsg,
        "StoreTimeSetting":
            storeTimeSetting == null ? null : storeTimeSetting.toJson(),
      };
}

class TaxLabel {
  TaxLabel({
    this.label,
    this.rate,
  });

  String label;
  String rate;

  TaxLabel copyWith({
    String label,
    String rate,
  }) =>
      TaxLabel(
        label: label ?? this.label,
        rate: rate ?? this.rate,
      );

  factory TaxLabel.fromRawJson(String str) =>
      TaxLabel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaxLabel.fromJson(Map<String, dynamic> json) => TaxLabel(
        label: json["label"] == null ? null : json["label"],
        rate: json["rate"] == null ? null : json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "label": label == null ? null : label,
        "rate": rate == null ? null : rate,
      };
}

class StoreTimeSetting {
  StoreTimeSetting({
    this.is24X7Open,
    this.openhoursFrom,
    this.openhoursTo,
    this.closehoursMessage,
    this.storeOpenDays,
  });

  String is24X7Open;
  String openhoursFrom;
  String openhoursTo;
  String closehoursMessage;
  String storeOpenDays;

  StoreTimeSetting copyWith({
    String is24X7Open,
    String openhoursFrom,
    String openhoursTo,
    String closehoursMessage,
    String storeOpenDays,
  }) =>
      StoreTimeSetting(
        is24X7Open: is24X7Open ?? this.is24X7Open,
        openhoursFrom: openhoursFrom ?? this.openhoursFrom,
        openhoursTo: openhoursTo ?? this.openhoursTo,
        closehoursMessage: closehoursMessage ?? this.closehoursMessage,
        storeOpenDays: storeOpenDays ?? this.storeOpenDays,
      );

  factory StoreTimeSetting.fromRawJson(String str) =>
      StoreTimeSetting.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoreTimeSetting.fromJson(Map<String, dynamic> json) =>
      StoreTimeSetting(
        is24X7Open: json["is24x7_open"] == null ? null : json["is24x7_open"],
        openhoursFrom:
            json["openhours_from"] == null ? null : json["openhours_from"],
        openhoursTo: json["openhours_to"] == null ? null : json["openhours_to"],
        closehoursMessage: json["closehours_message"] == null
            ? null
            : json["closehours_message"],
        storeOpenDays:
            json["store_open_days"] == null ? null : json["store_open_days"],
      );

  Map<String, dynamic> toJson() => {
        "is24x7_open": is24X7Open == null ? null : is24X7Open,
        "openhours_from": openhoursFrom == null ? null : openhoursFrom,
        "openhours_to": openhoursTo == null ? null : openhoursTo,
        "closehours_message":
            closehoursMessage == null ? null : closehoursMessage,
        "store_open_days": storeOpenDays == null ? null : storeOpenDays,
      };
}

class FixedTax {
  FixedTax({
    this.sort,
    this.fixedTaxLabel,
    this.fixedTaxAmount,
    this.isTaxEnable,
    this.isDiscountApplicable,
  });

  String sort;
  String fixedTaxLabel;
  String fixedTaxAmount;
  String isTaxEnable;
  String isDiscountApplicable;

  FixedTax copyWith({
    String sort,
    String fixedTaxLabel,
    String fixedTaxAmount,
    String isTaxEnable,
    String isDiscountApplicable,
  }) =>
      FixedTax(
        sort: sort ?? this.sort,
        fixedTaxLabel: fixedTaxLabel ?? this.fixedTaxLabel,
        fixedTaxAmount: fixedTaxAmount ?? this.fixedTaxAmount,
        isTaxEnable: isTaxEnable ?? this.isTaxEnable,
        isDiscountApplicable: isDiscountApplicable ?? this.isDiscountApplicable,
      );

  factory FixedTax.fromRawJson(String str) =>
      FixedTax.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FixedTax.fromJson(Map<String, dynamic> json) => FixedTax(
        sort: json["sort"] == null ? null : json["sort"],
        fixedTaxLabel:
            json["fixed_tax_label"] == null ? null : json["fixed_tax_label"],
        fixedTaxAmount:
            json["fixed_tax_amount"] == null ? null : json["fixed_tax_amount"],
        isTaxEnable:
            json["is_tax_enable"] == null ? null : json["is_tax_enable"],
        isDiscountApplicable: json["is_discount_applicable"] == null
            ? null
            : json["is_discount_applicable"],
      );

  Map<String, dynamic> toJson() => {
        "sort": sort == null ? null : sort,
        "fixed_tax_label": fixedTaxLabel == null ? null : fixedTaxLabel,
        "fixed_tax_amount": fixedTaxAmount == null ? null : fixedTaxAmount,
        "is_tax_enable": isTaxEnable == null ? null : isTaxEnable,
        "is_discount_applicable":
            isDiscountApplicable == null ? null : isDiscountApplicable,
      };
}
