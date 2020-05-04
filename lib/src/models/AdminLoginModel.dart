// To parse this JSON data, do
//
//     final adminLoginModel = adminLoginModelFromJson(jsonString);

import 'dart:convert';

AdminLoginModel adminLoginModelFromJson(String str) => AdminLoginModel.fromJson(json.decode(str));

String adminLoginModelToJson(AdminLoginModel data) => json.encode(data.toJson());

class AdminLoginModel {
  bool success;
  String storeId;
  String message;

  AdminLoginModel({
    this.success,
    this.storeId,
    this.message,
  });

  factory AdminLoginModel.fromJson(Map<String, dynamic> json) => AdminLoginModel(
    success: json["success"],
    storeId: json["store_id"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "store_id": storeId,
    "message": message,
  };
}
