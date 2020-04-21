// To parse this JSON data, do
//
//     final pickUpModel = pickUpModelFromJson(jsonString);

import 'dart:convert';

PickUpModel pickUpModelFromJson(String str) => PickUpModel.fromJson(json.decode(str));

String pickUpModelToJson(PickUpModel data) => json.encode(data.toJson());

class PickUpModel {
  bool success;
  List<Datum> data;

  PickUpModel({
    this.success,
    this.data,
  });

  factory PickUpModel.fromJson(Map<String, dynamic> json) => PickUpModel(
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
  String ispickupAdd;
  String pickupPhone;
  String pickupEmail;
  String pickupLat;
  String pickupLng;
  String cityId;
  String storeId;
  String minOrder;
  String charges;
  String note;
  bool notAllow;

  Area({
    this.areaId,
    this.ispickupAdd,
    this.pickupPhone,
    this.pickupEmail,
    this.pickupLat,
    this.pickupLng,
    this.cityId,
    this.storeId,
    this.minOrder,
    this.charges,
    this.note,
    this.notAllow,
  });

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    areaId: json["area_id"],
    ispickupAdd: json["ispickup_add"],
    pickupPhone: json["pickup_phone"],
    pickupEmail: json["pickup_email"],
    pickupLat: json["pickup_lat"],
    pickupLng: json["pickup_lng"],
    cityId: json["city_id"],
    storeId: json["store_id"],
    minOrder: json["min_order"],
    charges: json["charges"],
    note: json["note"],
    notAllow: json["not_allow"],
  );

  Map<String, dynamic> toJson() => {
    "area_id": areaId,
    "ispickup_add": ispickupAdd,
    "pickup_phone": pickupPhone,
    "pickup_email": pickupEmail,
    "pickup_lat": pickupLat,
    "pickup_lng": pickupLng,
    "city_id": cityId,
    "store_id": storeId,
    "min_order": minOrder,
    "charges": charges,
    "note": note,
    "not_allow": notAllow,
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
