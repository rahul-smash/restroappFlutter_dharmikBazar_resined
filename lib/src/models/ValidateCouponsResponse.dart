// To parse this JSON data, do
//
//     final validateCouponsResponse = validateCouponsResponseFromJson(jsonString);

import 'dart:convert';

ValidateCouponsResponse validateCouponsResponseFromJson(String str) => ValidateCouponsResponse.fromJson(json.decode(str));

String validateCouponsResponseToJson(ValidateCouponsResponse data) => json.encode(data.toJson());

class ValidateCouponsResponse {
  Data data;
  bool success;
  String message;
  String discountAmount;

  ValidateCouponsResponse({
    this.data,
    this.success,
    this.message,
    this.discountAmount,
  });

  factory ValidateCouponsResponse.fromJson(Map<String, dynamic> json) => ValidateCouponsResponse(
    data: Data.fromJson(json["data"]),
    success: json["success"],
    message: json["message"],
    discountAmount: json["DiscountAmount"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "success": success,
    "message": message,
    "DiscountAmount": discountAmount,
  };
}

class Data {
  String id;
  String storeId;
  String discountType;
  String orderFacilities;
  String paymentMethod;
  String name;
  String couponCode;
  String discount;
  String discountUpto;
  String minimumOrderAmount;
  String usageLimit;
  DateTime validFrom;
  DateTime validTo;
  String offerNotification;
  String offerTermCondition;
  String offerDescription;
  String status;
  String sort;
  DateTime created;
  DateTime modified;

  Data({
    this.id,
    this.storeId,
    this.discountType,
    this.orderFacilities,
    this.paymentMethod,
    this.name,
    this.couponCode,
    this.discount,
    this.discountUpto,
    this.minimumOrderAmount,
    this.usageLimit,
    this.validFrom,
    this.validTo,
    this.offerNotification,
    this.offerTermCondition,
    this.offerDescription,
    this.status,
    this.sort,
    this.created,
    this.modified,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    storeId: json["store_id"],
    discountType: json["discount_type"],
    orderFacilities: json["order_facilities"],
    paymentMethod: json["payment_method"],
    name: json["name"],
    couponCode: json["coupon_code"],
    discount: json["discount"],
    discountUpto: json["discount_upto"],
    minimumOrderAmount: json["minimum_order_amount"],
    usageLimit: json["usage_limit"],
    validFrom: DateTime.parse(json["valid_from"]),
    validTo: DateTime.parse(json["valid_to"]),
    offerNotification: json["offer_notification"],
    offerTermCondition: json["offer_term_condition"],
    offerDescription: json["offer_description"],
    status: json["status"],
    sort: json["sort"],
    created: DateTime.parse(json["created"]),
    modified: DateTime.parse(json["modified"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "store_id": storeId,
    "discount_type": discountType,
    "order_facilities": orderFacilities,
    "payment_method": paymentMethod,
    "name": name,
    "coupon_code": couponCode,
    "discount": discount,
    "discount_upto": discountUpto,
    "minimum_order_amount": minimumOrderAmount,
    "usage_limit": usageLimit,
    "valid_from": "${validFrom.year.toString().padLeft(4, '0')}-${validFrom.month.toString().padLeft(2, '0')}-${validFrom.day.toString().padLeft(2, '0')}",
    "valid_to": "${validTo.year.toString().padLeft(4, '0')}-${validTo.month.toString().padLeft(2, '0')}-${validTo.day.toString().padLeft(2, '0')}",
    "offer_notification": offerNotification,
    "offer_term_condition": offerTermCondition,
    "offer_description": offerDescription,
    "status": status,
    "sort": sort,
    "created": created.toIso8601String(),
    "modified": modified.toIso8601String(),
  };
}
