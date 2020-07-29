// To parse this JSON data, do
//
//     final deliveryTimeSlotModel = deliveryTimeSlotModelFromJson(jsonString);

import 'dart:convert';

DeliveryTimeSlotModel deliveryTimeSlotModelFromJson(String str) =>
    DeliveryTimeSlotModel.fromJson(json.decode(str));

String deliveryTimeSlotModelToJson(DeliveryTimeSlotModel data) =>
    json.encode(data.toJson());

class DeliveryTimeSlotModel {
  bool success;
  String message;
  Data data;

  DeliveryTimeSlotModel({
    this.success,
    this.message,
    this.data,
  });

  factory DeliveryTimeSlotModel.fromJson(Map<String, dynamic> json) =>
      DeliveryTimeSlotModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  String is24X7Open;
  List<DateTimeCollection> dateTimeCollection;

  Data({
    this.is24X7Open,
    this.dateTimeCollection,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        is24X7Open: json["is24x7_open"],
        dateTimeCollection: json["date_time_collection"] == null
            ? List()
            : List<DateTimeCollection>.from(json["date_time_collection"]
                .map((x) => DateTimeCollection.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "is24x7_open": is24X7Open,
        "date_time_collection":
            List<dynamic>.from(dateTimeCollection.map((x) => x.toJson())),
      };
}

class DateTimeCollection {
  String label;
  List<Timeslot> timeslot;

  DateTimeCollection({
    this.label,
    this.timeslot,
  });

  factory DateTimeCollection.fromJson(Map<String, dynamic> json) =>
      DateTimeCollection(
        label: json["label"],
        timeslot: List<Timeslot>.from(
            json["timeslot"].map((x) => Timeslot.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "timeslot": List<dynamic>.from(timeslot.map((x) => x.toJson())),
      };
}

class Timeslot {
  String label;
  String value;
  bool isEnable;
  String innerText;

  Timeslot({
    this.label,
    this.value,
    this.isEnable,
    this.innerText,
  });

  factory Timeslot.fromJson(Map<String, dynamic> json) => Timeslot(
        label: json["label"],
        value: json["value"],
        isEnable: json["is_enable"],
        innerText: json["inner_text"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "is_enable": isEnable,
        "inner_text": innerText,
      };
}
