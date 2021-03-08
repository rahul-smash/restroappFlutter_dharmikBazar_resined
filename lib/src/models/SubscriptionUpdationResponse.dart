// To parse this JSON data, do
//
//     final subscriptionUpdationResponse = subscriptionUpdationResponseFromJson(jsonString);

import 'dart:convert';

class SubscriptionUpdationResponse {
  SubscriptionUpdationResponse({
    this.success,
    this.data,
    this.message,
    this.paymentMethod,
  });

  bool success;
  String data;
  String message;
  String paymentMethod;

  SubscriptionUpdationResponse copyWith({
    bool success,
    String data,
    String paymentMethod,
  }) =>
      SubscriptionUpdationResponse(
        success: success ?? this.success,
        data: data ?? this.data,
        message: message ?? this.message,
        paymentMethod: paymentMethod ?? this.paymentMethod,
      );

  factory SubscriptionUpdationResponse.fromRawJson(String str) => SubscriptionUpdationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionUpdationResponse.fromJson(Map<String, dynamic> json) => SubscriptionUpdationResponse(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : json["data"],
    message: json["message"] == null ? null : json["message"],
    paymentMethod: json["payment_method"] == null ? null : json["payment_method"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : data,
    "message": message == null ? null : message,
    "payment_method": paymentMethod == null ? null : paymentMethod,
  };
}
