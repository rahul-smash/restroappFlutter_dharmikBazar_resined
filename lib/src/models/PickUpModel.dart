// To parse this JSON data, do
//
//     final pickUpModel = pickUpModelFromJson(jsonString);

import 'dart:convert';

PickUpModel pickUpModelFromJson(String str) =>
    PickUpModel.fromJson(json.decode(str));

String pickUpModelToJson(PickUpModel data) => json.encode(data.toJson());

class PickUpModel {
  bool success;
  List<Datum> data;
  String message;
  int errorCode;

  PickUpModel({
    this.success,
    this.data,
    this.message,
    this.errorCode,
  });

  factory PickUpModel.fromJson(Map<String, dynamic> json) => PickUpModel(
        success: json["success"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"] == null ? null : json["message"],
        errorCode: json["error_code"] == null ? null : json["error_code"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message == null ? null : message,
        "error_code": errorCode == null ? null : errorCode,
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
  String areaName;
  String pickupAdd;
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
    this.areaName,
    this.pickupAdd,
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
        areaName: json["area_name"],
        pickupAdd: json["pickup_add"],
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
        "area_name": areaName,
        "pickup_add": pickupAdd,
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
