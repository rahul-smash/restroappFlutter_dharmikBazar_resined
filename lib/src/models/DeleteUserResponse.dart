// To parse this JSON data, do
//
//     final deleteUserResponse = deleteUserResponseFromJson(jsonString);

import 'dart:convert';

class DeleteUserResponse {
  DeleteUserResponse({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  String data;

  DeleteUserResponse copyWith({
    bool success,
    String message,
    String data,
  }) =>
      DeleteUserResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory DeleteUserResponse.fromRawJson(String str) => DeleteUserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeleteUserResponse.fromJson(Map<String, dynamic> json) => DeleteUserResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data,
  };
}
