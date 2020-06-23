// To parse this JSON data, do
//
//     final stripeCheckOutModel = stripeCheckOutModelFromJson(jsonString);

import 'dart:convert';

StripeCheckOutModel stripeCheckOutModelFromJson(String str) => StripeCheckOutModel.fromJson(json.decode(str));

String stripeCheckOutModelToJson(StripeCheckOutModel data) => json.encode(data.toJson());

class StripeCheckOutModel {
  bool success;
  String checkoutUrl;
  String message;
  String paymentRequestId;

  StripeCheckOutModel({
    this.success,
    this.checkoutUrl,
    this.message,
    this.paymentRequestId,
  });

  factory StripeCheckOutModel.fromJson(Map<String, dynamic> json) => StripeCheckOutModel(
    success: json["success"],
    checkoutUrl: json["checkout_url"],
    message: json["message"] == null ? "" : json["message"],
    paymentRequestId: json["payment_request_id"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "checkout_url": checkoutUrl,
    "payment_request_id": paymentRequestId,
  };
}
