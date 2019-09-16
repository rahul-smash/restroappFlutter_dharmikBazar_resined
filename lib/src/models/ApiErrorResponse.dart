// To parse this JSON data, do
//
//     final apiErrorResponse = apiErrorResponseFromJson(jsonString);

import 'dart:convert';

ApiErrorResponse apiErrorResponseFromJson(String str) => ApiErrorResponse.fromJson(json.decode(str));

String apiErrorResponseToJson(ApiErrorResponse data) => json.encode(data.toJson());

class ApiErrorResponse {
  bool success;
  String message;

  ApiErrorResponse({
    this.success,
    this.message,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) => ApiErrorResponse(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
