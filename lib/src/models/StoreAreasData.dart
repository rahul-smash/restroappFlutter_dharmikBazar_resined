// To parse this JSON data, do
//
//     final storeAreaData = storeAreaDataFromJson(jsonString);

import 'dart:convert';

StoreAreaData storeAreaDataFromJson(String str) => StoreAreaData.fromJson(json.decode(str));

String storeAreaDataToJson(StoreAreaData data) => json.encode(data.toJson());

class StoreAreaData {
  bool success;
  List<Area> data;

  StoreAreaData({
    this.success,
    this.data,
  });

  factory StoreAreaData.fromJson(Map<String, dynamic> json) => StoreAreaData(
    success: json["success"],
    data: List<Area>.from(json["data"].map((x) => Area.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Area {
  String id;
  String cityId;
  String storeId;
  String minOrder;
  String charges;
  String note;
  bool notAllow;
  String radius;
  String area;
  String typeName;

  Area({
    this.id,
    this.cityId,
    this.storeId,
    this.minOrder,
    this.charges,
    this.note,
    this.notAllow,
    this.radius,
    this.area,
    this.typeName,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    id: json["id"],
    cityId: json["city_id"],
    storeId: json["store_id"],
    minOrder: json["min_order"],
    charges: json["charges"],
    note: json["note"],
    notAllow: json["not_allow"],
    radius: json["radius"],
    area: json["area"],
    typeName: json["typeName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "city_id": cityId,
    "store_id": storeId,
    "min_order": minOrder,
    "charges": charges,
    "note": note,
    "not_allow": notAllow,
    "radius": radius,
    "area": area,
    "typeName": typeName,
  };
}
