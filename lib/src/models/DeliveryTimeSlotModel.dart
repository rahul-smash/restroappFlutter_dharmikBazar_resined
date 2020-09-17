// To parse this JSON data, do
//
//     final deliveryTimeSlotModel = deliveryTimeSlotModelFromJson(jsonString);

import 'dart:convert';

class DeliveryTimeSlotModel {
  DeliveryTimeSlotModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  DeliveryTimeSlotModel copyWith({
    bool success,
    String message,
    Data data,
  }) =>
      DeliveryTimeSlotModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory DeliveryTimeSlotModel.fromRawJson(String str) => DeliveryTimeSlotModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeliveryTimeSlotModel.fromJson(Map<String, dynamic> json) => DeliveryTimeSlotModel(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.is24X7Open,
    this.dateTimeCollection,
  });

  String is24X7Open;
  List<DateTimeCollection> dateTimeCollection;

  Data copyWith({
    String is24X7Open,
    List<DateTimeCollection> dateTimeCollection,
  }) =>
      Data(
        is24X7Open: is24X7Open ?? this.is24X7Open,
        dateTimeCollection: dateTimeCollection ?? this.dateTimeCollection,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    is24X7Open: json["is24x7_open"] == null ? null : json["is24x7_open"],
    dateTimeCollection: json["date_time_collection"] == null ? null : List<DateTimeCollection>.from(json["date_time_collection"].map((x) => DateTimeCollection.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "is24x7_open": is24X7Open == null ? null : is24X7Open,
    "date_time_collection": dateTimeCollection == null ? null : List<dynamic>.from(dateTimeCollection.map((x) => x.toJson())),
  };
}

class DateTimeCollection {
  DateTimeCollection({
    this.label,
    this.timeslot,
  });

  String label;
  List<Timeslot> timeslot;

  DateTimeCollection copyWith({
    String label,
    List<Timeslot> timeslot,
  }) =>
      DateTimeCollection(
        label: label ?? this.label,
        timeslot: timeslot ?? this.timeslot,
      );

  factory DateTimeCollection.fromRawJson(String str) => DateTimeCollection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DateTimeCollection.fromJson(Map<String, dynamic> json) => DateTimeCollection(
    label: json["label"] == null ? null : json["label"],
    timeslot: json["timeslot"] == null ? null : List<Timeslot>.from(json["timeslot"].map((x) => Timeslot.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "label": label == null ? null : label,
    "timeslot": timeslot == null ? null : List<dynamic>.from(timeslot.map((x) => x.toJson())),
  };
}

class Timeslot {
  Timeslot({
    this.label,
    this.value,
    this.isEnable,
    this.innerText,
  });

  String label;
  String value;
  bool isEnable;
  String innerText;

  Timeslot copyWith({
    String label,
    String value,
    bool isEnable,
    String innerText,
  }) =>
      Timeslot(
        label: label ?? this.label,
        value: value ?? this.value,
        isEnable: isEnable ?? this.isEnable,
        innerText: innerText ?? this.innerText,
      );

  factory Timeslot.fromRawJson(String str) => Timeslot.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Timeslot.fromJson(Map<String, dynamic> json) => Timeslot(
    label: json["label"] == null ? null : json["label"],
    value: json["value"] == null ? null : json["value"],
    isEnable: json["is_enable"] == null ? null : json["is_enable"],
    innerText: json["inner_text"] == null ? null : json["inner_text"],
  );

  Map<String, dynamic> toJson() => {
    "label": label == null ? null : label,
    "value": value == null ? null : value,
    "is_enable": isEnable == null ? null : isEnable,
    "inner_text": innerText == null ? null : innerText,
  };
}
