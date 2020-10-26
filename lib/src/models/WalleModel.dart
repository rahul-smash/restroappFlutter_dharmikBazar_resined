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
    this.walletHistory,
  });

  String userWallet;
  List<WalletHistory> walletHistory;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userWallet: json["user_wallet"],
    walletHistory: List<WalletHistory>.from(json["wallet_history"].map((x) => WalletHistory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "user_wallet": userWallet,
    "wallet_history": List<dynamic>.from(walletHistory.map((x) => x.toJson())),
  };
}

class WalletHistory {
  WalletHistory({
    this.id,
    this.displayOrderId,
    this.refund,
    this.label,
    this.dateTime,
  });

  String id;
  String displayOrderId;
  String refund;
  String label;
  DateTime dateTime;

  factory WalletHistory.fromJson(Map<String, dynamic> json) => WalletHistory(
    id: json["id"],
    displayOrderId: json["display_order_id"],
    refund: json["refund"],
    label: json["label"],
    dateTime: DateTime.parse(json["date_time"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "display_order_id": displayOrderId,
    "refund": refund,
    "label": label,
    "date_time": dateTime.toIso8601String(),
  };
}
