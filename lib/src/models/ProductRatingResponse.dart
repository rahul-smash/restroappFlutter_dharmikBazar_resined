// To parse this JSON data, do
//
//     final productRatingResponse = productRatingResponseFromJson(jsonString);

import 'dart:convert';

class ProductRatingResponse {
  ProductRatingResponse({
    this.success,
    this.message,
  });

  bool success;
  String message;

  ProductRatingResponse copyWith({
    bool success,
    String message,
  }) =>
      ProductRatingResponse(
        success: success ?? this.success,
        message: message ?? this.message,
      );

  factory ProductRatingResponse.fromRawJson(String str) => ProductRatingResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductRatingResponse.fromJson(Map<String, dynamic> json) => ProductRatingResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
