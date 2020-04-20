
class ValidateCouponResponse {
  bool success;
  String message;
  String discountAmount;

  ValidateCouponResponse({
    this.success,
    this.message,
    this.discountAmount,
  });

  factory ValidateCouponResponse.fromJson(Map<String, dynamic> json) => ValidateCouponResponse(
    success: json["success"],
    message: json["message"],
    discountAmount: json["DiscountAmount"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "DiscountAmount": discountAmount,
  };
}