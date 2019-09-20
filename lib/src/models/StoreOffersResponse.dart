// To parse this JSON data, do
//
//     final storeOffersResponse = storeOffersResponseFromJson(jsonString);

import 'dart:convert';

StoreOffersResponse storeOffersResponseFromJson(String str) => StoreOffersResponse.fromJson(json.decode(str));

String storeOffersResponseToJson(StoreOffersResponse data) => json.encode(data.toJson());

class StoreOffersResponse {
  bool success;
  String message;
  List<OffersData> data;

  StoreOffersResponse({
    this.success,
    this.message,
    this.data,
  });

  factory StoreOffersResponse.fromJson(Map<String, dynamic> json) => StoreOffersResponse(
    success: json["success"],
    message: json["message"],
    data: List<OffersData>.from(json["data"].map((x) => OffersData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class OffersData {
  String id;
  String storeId;
  String name;
  String couponCode;
  String discount;
  String usageLimit;
  String minimumOrderAmount;
  String orderFacilities;
  String offerNotification;
  String validFrom;
  String validTo;
  String offerTermCondition;
  String image;
  String image10080;
  String image300200;

  OffersData({
    this.id,
    this.storeId,
    this.name,
    this.couponCode,
    this.discount,
    this.usageLimit,
    this.minimumOrderAmount,
    this.orderFacilities,
    this.offerNotification,
    this.validFrom,
    this.validTo,
    this.offerTermCondition,
    this.image,
    this.image10080,
    this.image300200,
  });

  factory OffersData.fromJson(Map<String, dynamic> json) => OffersData(
    id: json["id"],
    storeId: json["store_id"],
    name: json["name"],
    couponCode: json["coupon_code"],
    discount: json["discount"],
    usageLimit: json["usage_limit"],
    minimumOrderAmount: json["minimum_order_amount"],
    orderFacilities: json["order_facilities"],
    offerNotification: json["offer_notification"],
    validFrom: json["valid_from"],
    validTo: json["valid_to"],
    offerTermCondition: json["offer_term_condition"],
    image: json["image"],
    image10080: json["image_100_80"],
    image300200: json["image_300_200"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "store_id": storeId,
    "name": name,
    "coupon_code": couponCode,
    "discount": discount,
    "usage_limit": usageLimit,
    "minimum_order_amount": minimumOrderAmount,
    "order_facilities": orderFacilities,
    "offer_notification": offerNotification,
    "valid_from": validFrom,
    "valid_to": validTo,
    "offer_term_condition": offerTermCondition,
    "image": image,
    "image_100_80": image10080,
    "image_300_200": image300200,
  };
}
