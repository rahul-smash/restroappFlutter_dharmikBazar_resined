// To parse this JSON data, do
//
//     final verifyEmailModel = verifyEmailModelFromJson(jsonString);

import 'dart:convert';

VerifyEmailModel verifyEmailModelFromJson(String str) => VerifyEmailModel.fromJson(json.decode(str));

String verifyEmailModelToJson(VerifyEmailModel data) => json.encode(data.toJson());

class VerifyEmailModel {
  VerifyEmailModel({
    this.success,
    this.userExists,
    this.message,
  });

  bool success;
  int userExists;
  String message;

  factory VerifyEmailModel.fromJson(Map<String, dynamic> json) => VerifyEmailModel(
    success: json["success"],
    userExists: json["user_exists"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "user_exists": userExists,
    "message": message,
  };
}
