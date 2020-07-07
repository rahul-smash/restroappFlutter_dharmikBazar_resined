class StoreOffersResponse {
  bool success;
  String message;
  List<OfferModel> offers;

  StoreOffersResponse({
    this.success,
    this.message,
    this.offers,
  });

  factory StoreOffersResponse.fromJson(Map<String, dynamic> json) =>
      StoreOffersResponse(
        success: json["success"],
        message: json["message"],
        offers: List<OfferModel>.from(
            json["data"].map((x) => OfferModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(offers.map((x) => x.toJson())),
      };
}

class OfferModel {
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
  String discount_type;
  String discount_upto;
  String image10080;
  String image300200;

  OfferModel(
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
        this.image,
        this.discount_type,
        this.discount_upto,
        this.image10080,
        this.image300200});

  OfferModel.fromJson(Map<String, dynamic> json) {
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
    image = json['image'];
    discount_type = json['discount_type'];
    discount_upto = json['discount_upto'];
    image10080 = json['image_100_80'];
    image300200 = json['image_300_200'];
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
    data['image'] = this.image;
    data['discount_type'] = this.discount_type;
    data['discount_upto'] = this.discount_upto;
    data['image_100_80'] = this.image10080;
    data['image_300_200'] = this.image300200;
    return data;
  }
}
