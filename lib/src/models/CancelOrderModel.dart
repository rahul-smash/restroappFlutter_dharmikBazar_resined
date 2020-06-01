// To parse this JSON data, do
//
//     final cancelOrderModel = cancelOrderModelFromJson(jsonString);

import 'dart:convert';

CancelOrderModel cancelOrderModelFromJson(String str) => CancelOrderModel.fromJson(json.decode(str));

String cancelOrderModelToJson(CancelOrderModel data) => json.encode(data.toJson());

class CancelOrderModel {
  CancelOrderModel({
    this.success,
    this.data,
    this.paymentMethod,
  });

  bool success;
  String data;
  String paymentMethod;

  factory CancelOrderModel.fromJson(Map<String, dynamic> json) => CancelOrderModel(
    success: json["success"],
    data: json["data"],
    paymentMethod: json["payment_method"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data,
    "payment_method": paymentMethod,
  };
}
