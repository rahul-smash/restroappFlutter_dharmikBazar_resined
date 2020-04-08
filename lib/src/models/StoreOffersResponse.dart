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
  String couponCode;
  String discount;
  String usageLimit;
  String minimumOrderAmount;
  String validFrom;
  String validTo;
  String offerTermCondition;

  OfferModel({
    this.id,
    this.couponCode,
    this.discount,
    this.usageLimit,
    this.minimumOrderAmount,
    this.validFrom,
    this.validTo,
    this.offerTermCondition,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json["id"],
        couponCode: json["coupon_code"],
        discount: json["discount"],
        usageLimit: json["usage_limit"],
        minimumOrderAmount: json["minimum_order_amount"],
        validFrom: json["valid_from"],
        validTo: json["valid_to"],
        offerTermCondition: json["offer_term_condition"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coupon_code": couponCode,
        "discount": discount,
        "usage_limit": usageLimit,
        "minimum_order_amount": minimumOrderAmount,
        "valid_from": validFrom,
        "valid_to": validTo,
        "offer_term_condition": offerTermCondition,
      };
}
