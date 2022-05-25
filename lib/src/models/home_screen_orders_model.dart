// To parse this JSON data, do
//
//     final homeScreenOrdersModel = homeScreenOrdersModelFromJson(jsonString);

import 'dart:convert';

HomeScreenOrdersModel homeScreenOrdersModelFromJson(String str) => HomeScreenOrdersModel.fromJson(json.decode(str));

String homeScreenOrdersModelToJson(HomeScreenOrdersModel data) => json.encode(data.toJson());

class HomeScreenOrdersModel {
  HomeScreenOrdersModel({
    this.success,
    this.data,
  });

  bool success;
  List<HomeOrderData> data;

  factory HomeScreenOrdersModel.fromJson(Map<String, dynamic> json) => HomeScreenOrdersModel(
    success: json["success"],
    data: json["data"] == null ? null : List<HomeOrderData>.from(json["data"].map((x) => HomeOrderData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class HomeOrderData {
  HomeOrderData({
    this.id,
    this.status,
    this.displayOrderId,
    this.total,
  });

  String id;
  String status;
  String displayOrderId;
  String total;

  factory HomeOrderData.fromJson(Map<String, dynamic> json) => HomeOrderData(
    id: json["id"],
    status: json["status"],
    displayOrderId: json["display_order_id"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "display_order_id": displayOrderId,
    "total": total,
  };
}
