// To parse this JSON data, do
//
//     final storeAreaResponse = storeAreaResponseFromJson(jsonString);

import 'dart:convert';

StoreAreaResponse storeAreaResponseFromJson(String str) => StoreAreaResponse.fromJson(json.decode(str));

String storeAreaResponseToJson(StoreAreaResponse data) => json.encode(data.toJson());

class StoreAreaResponse {
  bool success;
  List<Datum> data;

  StoreAreaResponse({
    this.success,
    this.data,
  });

  factory StoreAreaResponse.fromJson(Map<String, dynamic> json) => StoreAreaResponse(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  City city;
  List<Area> area;

  Datum({
    this.city,
    this.area,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
