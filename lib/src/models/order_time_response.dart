// To parse this JSON data, do
//
//     final orderTimeResponse = orderTimeResponseFromJson(jsonString);

import 'dart:convert';

OrderTimeResponse orderTimeResponseFromJson(String str) => OrderTimeResponse.fromJson(json.decode(str));

String orderTimeResponseToJson(OrderTimeResponse data) => json.encode(data.toJson());

class OrderTimeResponse {
  OrderTimeResponse({
    this.success,
    this.data,
  });

  bool success;
  OrderTimeData data;

  factory OrderTimeResponse.fromJson(Map<String, dynamic> json) => OrderTimeResponse(
    success: json["success"],
    data: json["data"] == null ? null : OrderTimeData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };
}

class OrderTimeData {
  OrderTimeData({
    this.orderId,
    this.deliverySlot,
    this.orderProcessTime,
  });

  String orderId;
  String deliverySlot;
  String orderProcessTime;

  factory OrderTimeData.fromJson(Map<String, dynamic> json) => OrderTimeData(
    orderId: json["order_id"],
    deliverySlot: json["delivery_slot"],
    orderProcessTime: json["order_process_time"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "delivery_slot": deliverySlot,
    "order_process_time": orderProcessTime,
  };
}
