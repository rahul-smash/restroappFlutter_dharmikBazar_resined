// To parse this JSON data, do
//
//     final stripeVerifyModel = stripeVerifyModelFromJson(jsonString);

import 'dart:convert';

StripeVerifyModel stripeVerifyModelFromJson(String str) => StripeVerifyModel.fromJson(json.decode(str));

String stripeVerifyModelToJson(StripeVerifyModel data) => json.encode(data.toJson());

class StripeVerifyModel {
  bool success;
  String paymentId;
  String paymentRequestId;

  StripeVerifyModel({
    this.success,
    this.paymentId,
    this.paymentRequestId,
  });

  factory StripeVerifyModel.fromJson(Map<String, dynamic> json) => StripeVerifyModel(
    success: json["success"],
    paymentId: json["payment_id"],
    paymentRequestId: json["payment_request_id"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "payment_id": paymentId,
    "payment_request_id": paymentRequestId,
  };
}
