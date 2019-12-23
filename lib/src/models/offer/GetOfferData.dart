import 'dart:convert';

GetOfferData storeOffersResponseFromJson(String str) => GetOfferData.fromJson(json.decode(str));

String storeOffersResponseToJson(GetOfferData data) => json.encode(data.toJson());

class GetOfferData {
  bool success;
  String message;
  List<OfferData> data;

  GetOfferData({this.success, this.message, this.data});

  GetOfferData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<OfferData>();
      json['data'].forEach((v) {
        data.add(new OfferData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfferData {
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
  String image10080;
  String image300200;
  String image;

  OfferData(
      {this.id,
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
        this.image10080,
        this.image300200,
        this.image});

  OfferData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    name = json['name'];
    couponCode = json['coupon_code'];
    discount = json['discount'];
    usageLimit = json['usage_limit'];
    minimumOrderAmount = json['minimum_order_amount'];
    orderFacilities = json['order_facilities'];
    offerNotification = json['offer_notification'];
    validFrom = json['valid_from'];
    validTo = json['valid_to'];
    offerTermCondition = json['offer_term_condition'];
    image10080 = json['image_100_80'];
    image300200 = json['image_300_200'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['name'] = this.name;
    data['coupon_code'] = this.couponCode;
    data['discount'] = this.discount;
    data['usage_limit'] = this.usageLimit;
    data['minimum_order_amount'] = this.minimumOrderAmount;
    data['order_facilities'] = this.orderFacilities;
    data['offer_notification'] = this.offerNotification;
    data['valid_from'] = this.validFrom;
    data['valid_to'] = this.validTo;
    data['offer_term_condition'] = this.offerTermCondition;
    data['image_100_80'] = this.image10080;
    data['image_300_200'] = this.image300200;
    data['image'] = this.image;
    return data;
  }
}

