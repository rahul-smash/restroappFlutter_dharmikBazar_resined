// To parse this JSON data, do
//
//     final thirdPartyDeliveryResponse = thirdPartyDeliveryResponseFromJson(jsonString);

import 'dart:convert';

import 'TaxCalulationResponse.dart';

class ThirdPartyDeliveryResponse {
  ThirdPartyDeliveryResponse({
    this.success,
    this.data,
  });

  bool success;
  ThirdPartyDeliveryData data;

  ThirdPartyDeliveryResponse copyWith({
    bool success,
    ThirdPartyDeliveryData data,
  }) =>
      ThirdPartyDeliveryResponse(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory ThirdPartyDeliveryResponse.fromRawJson(String str) =>
      ThirdPartyDeliveryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ThirdPartyDeliveryResponse.fromJson(Map<String, dynamic> json) =>
      ThirdPartyDeliveryResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : ThirdPartyDeliveryData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
      };
}

class ThirdPartyDeliveryData {
  ThirdPartyDeliveryData(
      {this.orderDetail,
      this.totalDimensions,
      this.shippingCharges,
      this.errorMsg});

  List<OrderDetail> orderDetail;
  TotalDimensions totalDimensions;
  List<ShippingCharge> shippingCharges;
  String errorMsg;

  ThirdPartyDeliveryData copyWith({
    List<OrderDetail> orderDetail,
    TotalDimensions totalDimensions,
    List<ShippingCharge> shippingCharges,
    String errorMsg,
  }) =>
      ThirdPartyDeliveryData(
        orderDetail: orderDetail ?? this.orderDetail,
        totalDimensions: totalDimensions ?? this.totalDimensions,
        shippingCharges: shippingCharges ?? this.shippingCharges,
        errorMsg: errorMsg ?? this.errorMsg,
      );

  String toRawJson() => json.encode(toJson());

  factory ThirdPartyDeliveryData.fromJson(Map<String, dynamic> json) =>
      ThirdPartyDeliveryData(
        orderDetail: json["order_detail"] == null
            ? null
            : List<OrderDetail>.from(
                json["order_detail"].map((x) => OrderDetail.fromJson(x))),
        totalDimensions: json["total_dimensions"] == null
            ? null
            : TotalDimensions.fromJson(json["total_dimensions"]),
        shippingCharges: json["shipping_charges"] == null
            ? null
            : json["shipping_charges"] is List
                ? List<ShippingCharge>.from(json["shipping_charges"]
                    .map((x) => ShippingCharge.fromJson(x)))
                : null,
        errorMsg: json["shipping_charges"] == null
            ? null
            : json["shipping_charges"] is String
                ? json["shipping_charges"]
                : null,
      );

  Map<String, dynamic> toJson() => {
        "order_detail": orderDetail == null
            ? null
            : List<dynamic>.from(orderDetail.map((x) => x.toJson())),
        "total_dimensions":
            totalDimensions == null ? null : totalDimensions.toJson(),
        "shipping_charges": shippingCharges == null
            ? null
            : List<dynamic>.from(shippingCharges.map((x) => x.toJson())),
      };
}

class ShippingCharge {
  ShippingCharge({
    this.courierCompanyId,
    this.courierName,
    this.estimatedDeliveryDays,
    this.etd,
    this.etdHours,
    this.freightCharge,
    this.rate,
    this.rtoCharges,
    this.postcode,
    this.city,
    this.state,
    this.orderPaymentMode,
  });

  String courierCompanyId;
  String courierName;
  String estimatedDeliveryDays;
  String etd;
  String etdHours;
  String freightCharge;
  String rate;
  String rtoCharges;
  String postcode;
  String city;
  String state;
  String orderPaymentMode;

  ShippingCharge copyWith({
    String courierCompanyId,
    String courierName,
    String estimatedDeliveryDays,
    String etd,
    String etdHours,
    String freightCharge,
    String rate,
    String rtoCharges,
    String postcode,
    String city,
    String state,
    String orderPaymentMode,
  }) =>
      ShippingCharge(
        courierCompanyId: courierCompanyId ?? this.courierCompanyId,
        courierName: courierName ?? this.courierName,
        estimatedDeliveryDays:
            estimatedDeliveryDays ?? this.estimatedDeliveryDays,
        etd: etd ?? this.etd,
        etdHours: etdHours ?? this.etdHours,
        freightCharge: freightCharge ?? this.freightCharge,
        rate: rate ?? this.rate,
        rtoCharges: rtoCharges ?? this.rtoCharges,
        postcode: postcode ?? this.postcode,
        city: city ?? this.city,
        state: state ?? this.state,
        orderPaymentMode: orderPaymentMode ?? this.orderPaymentMode,
      );

  factory ShippingCharge.fromRawJson(String str) =>
      ShippingCharge.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShippingCharge.fromJson(Map<String, dynamic> json) => ShippingCharge(
        courierCompanyId: json["courier_company_id"] == null
            ? null
            : json["courier_company_id"].toString(),
        courierName: json["courier_name"] == null
            ? null
            : json["courier_name"].toString(),
        estimatedDeliveryDays: json["estimated_delivery_days"] == null
            ? null
            : json["estimated_delivery_days"].toString(),
        etd: json["etd"] == null ? null : json["etd"].toString(),
        etdHours:
            json["etd_hours"] == null ? null : json["etd_hours"].toString(),
        freightCharge: json["freight_charge"] == null
            ? null
            : json["freight_charge"].toString(),
        rate: json["rate"] == null ? null : json["rate"].toString(),
        rtoCharges:
            json["rto_charges"] == null ? null : json["rto_charges"].toString(),
        postcode: json["postcode"] == null ? null : json["postcode"].toString(),
        city: json["city"] == null ? null : json["city"].toString(),
        state: json["state"] == null ? null : json["state"].toString(),
        orderPaymentMode: json["order_payment_mode"] == null
            ? null
            : json["order_payment_mode"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "courier_company_id":
            courierCompanyId == null ? null : courierCompanyId,
        "courier_name": courierName == null ? null : courierName,
        "estimated_delivery_days":
            estimatedDeliveryDays == null ? null : estimatedDeliveryDays,
        "etd": etd == null ? null : etd,
        "etd_hours": etdHours == null ? null : etdHours,
        "freight_charge": freightCharge == null ? null : freightCharge,
        "rate": rate == null ? null : rate,
        "rto_charges": rtoCharges == null ? null : rtoCharges,
        "postcode": postcode == null ? null : postcode,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "order_payment_mode":
            orderPaymentMode == null ? null : orderPaymentMode,
      };
}

class TotalDimensions {
  TotalDimensions({
    this.totalLength,
    this.totalBreadth,
    this.totalHeight,
    this.totalWeight,
  });

  String totalLength;
  String totalBreadth;
  String totalHeight;
  String totalWeight;

  TotalDimensions copyWith({
    String totalLength,
    String totalBreadth,
    String totalHeight,
    String totalWeight,
  }) =>
      TotalDimensions(
        totalLength: totalLength ?? this.totalLength,
        totalBreadth: totalBreadth ?? this.totalBreadth,
        totalHeight: totalHeight ?? this.totalHeight,
        totalWeight: totalWeight ?? this.totalWeight,
      );

  factory TotalDimensions.fromRawJson(String str) =>
      TotalDimensions.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TotalDimensions.fromJson(Map<String, dynamic> json) =>
      TotalDimensions(
        totalLength: json["total_length"] == null
            ? null
            : json["total_length"].toString(),
        totalBreadth: json["total_breadth"] == null
            ? null
            : json["total_breadth"].toString(),
        totalHeight: json["total_height"] == null
            ? null
            : json["total_height"].toString(),
        totalWeight: json["total_weight"] == null
            ? null
            : json["total_weight"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "total_length": totalLength == null ? null : totalLength,
        "total_breadth": totalBreadth == null ? null : totalBreadth,
        "total_height": totalHeight == null ? null : totalHeight,
        "total_weight": totalWeight == null ? null : totalWeight,
      };
}
