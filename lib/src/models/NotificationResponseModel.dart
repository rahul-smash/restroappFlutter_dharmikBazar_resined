// To parse this JSON data, do
//
//     final notificationResponseModel = notificationResponseModelFromJson(jsonString);

import 'dart:convert';

class NotificationResponseModel {
  NotificationResponseModel({
    this.success,
    this.data,
  });

  bool success;
  List<Datum> data;

  NotificationResponseModel copyWith({
    bool success,
    List<Datum> data,
  }) =>
      NotificationResponseModel(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory NotificationResponseModel.fromRawJson(String str) => NotificationResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => NotificationResponseModel(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.storeId,
    this.title,
    this.description,
    this.offerId,
    this.bigPic,
    this.schedule,
    this.scheduledDatetime,
    this.status,
    this.created,
    this.modified,
    this.unique,
    this.type,
  });

  String id;
  String storeId;
  String title;
  String description;
  String offerId;
  String bigPic;
  String schedule;
  String scheduledDatetime;
  String status;
  String created;
  String modified;
  int unique;
  String type;

  Datum copyWith({
    String id,
    String storeId,
    String title,
    String description,
    String offerId,
    String bigPic,
    String schedule,
    String scheduledDatetime,
    String status,
    String created,
    String modified,
    int unique,
    String type,
  }) =>
      Datum(
        id: id ?? this.id,
        storeId: storeId ?? this.storeId,
        title: title ?? this.title,
        description: description ?? this.description,
        offerId: offerId ?? this.offerId,
        bigPic: bigPic ?? this.bigPic,
        schedule: schedule ?? this.schedule,
        scheduledDatetime: scheduledDatetime ?? this.scheduledDatetime,
        status: status ?? this.status,
        created: created ?? this.created,
        modified: modified ?? this.modified,
        unique: unique ?? this.unique,
        type: type ?? this.type,
      );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    storeId: json["store_id"] == null ? null : json["store_id"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    offerId: json["offer_id"] == null ? null : json["offer_id"],
    bigPic: json["big_pic"] == null ? null : json["big_pic"],
    schedule: json["schedule"] == null ? null : json["schedule"],
    scheduledDatetime: json["scheduled_datetime"] == null ? null : json["scheduled_datetime"],
    status: json["status"] == null ? null : json["status"],
    created: json["created"] == null ? null : json["created"],
    modified: json["modified"] == null ? null : json["modified"],
    unique: json["unique"] == null ? null : json["unique"],
    type: json["type"] == null ? null : json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "store_id": storeId == null ? null : storeId,
    "title": title == null ? null : title,
    "description": description == null ? null : description,
    "offer_id": offerId == null ? null : offerId,
    "big_pic": bigPic == null ? null : bigPic,
    "schedule": schedule == null ? null : schedule,
    "scheduled_datetime": scheduledDatetime == null ? null : scheduledDatetime,
    "status": status == null ? null : status,
    "created": created == null ? null : created,
    "modified": modified == null ? null : modified,
    "unique": unique == null ? null : unique,
    "type": type == null ? null : type,
  };
}
