// To parse this JSON data, do
//
//     final storeRadiousResponse = storeRadiousResponseFromJson(jsonString);

import 'dart:convert';

StoreRadiousResponse storeRadiousResponseFromJson(String str) => StoreRadiousResponse.fromJson(json.decode(str));

String storeRadiousResponseToJson(StoreRadiousResponse data) => json.encode(data.toJson());

class StoreRadiousResponse {
  bool success;
  List<RadiousData> data;

  StoreRadiousResponse({
    this.success,
    this.data,
  });

  factory StoreRadiousResponse.fromJson(Map<String, dynamic> json) => StoreRadiousResponse(
    success: json["success"],
    data: List<RadiousData>.from(json["data"].map((x) => RadiousData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class RadiousData {
  City city;
  List<Area> area;

  RadiousData({
    this.city,
    this.area,
  });

  factory RadiousData.fromJson(Map<String, dynamic> json) => RadiousData(
    city: City.fromJson(json["City"]),
    area: List<Area>.from(json["Area"].map((x) => Area.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "City": city.toJson(),
    "Area": List<dynamic>.from(area.map((x) => x.toJson())),
  };
}

class Area {
  String areaId;
  String area;
  String cityId;
  String storeId;
  String minOrder;
  String charges;
  String note;
  bool notAllow;
  String radius;
  String radiusCircle;

  Area({
    this.areaId,
    this.area,
    this.cityId,
    this.storeId,
    this.minOrder,
    this.charges,
    this.note,
    this.notAllow,
    this.radius,
    this.radiusCircle,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    areaId: json["area_id"],
    area: json["area"],
    cityId: json["city_id"],
    storeId: json["store_id"],
    minOrder: json["min_order"],
    charges: json["charges"],
    note: json["note"],
    notAllow: json["not_allow"],
    radius: json["radius"],
    radiusCircle: json["radius_circle"],
  );

  Map<String, dynamic> toJson() => {
    "area_id": areaId,
    "area": area,
    "city_id": cityId,
    "store_id": storeId,
    "min_order": minOrder,
    "charges": charges,
    "note": note,
    "not_allow": notAllow,
    "radius": radius,
    "radius_circle": radiusCircle,
  };
}

class City {
  String city;
  String id;

  City({
    this.city,
    this.id,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
    city: json["city"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "city": city,
    "id": id,
  };
}
