// To parse this JSON data, do
//
//     final walleModel = walleModelFromJson(jsonString);

import 'dart:convert';

WalleModel walleModelFromJson(String str) => WalleModel.fromJson(json.decode(str));

String walleModelToJson(WalleModel data) => json.encode(data.toJson());

class WalleModel {
  WalleModel({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory WalleModel.fromJson(Map<String, dynamic> json) => WalleModel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.userWallet,
  });

  String userWallet;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userWallet: json["user_wallet"],
  );

  Map<String, dynamic> toJson() => {
    "user_wallet": userWallet,
  };
}
