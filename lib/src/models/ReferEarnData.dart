// To parse this JSON data, do
//
//     final referEarnData = referEarnDataFromJson(jsonString);

import 'dart:convert';

ReferEarnData referEarnDataFromJson(String str) => ReferEarnData.fromJson(json.decode(str));

String referEarnDataToJson(ReferEarnData data) => json.encode(data.toJson());

class ReferEarnData {
  bool isRefererFnEnable;
  ReferEarn referEarn;
  bool status;
  String userReferCode;

  ReferEarnData({
    this.isRefererFnEnable,
    this.referEarn,
    this.status,
    this.userReferCode,
  });

  factory ReferEarnData.fromJson(Map<String, dynamic> json) => ReferEarnData(
    isRefererFnEnable: json["is_referer_fn_enable"],
    referEarn: ReferEarn.fromJson(json["ReferEarn"]),
    status: json["status"],
    userReferCode: json["user_refer_code"],
  );

  Map<String, dynamic> toJson() => {
    "is_referer_fn_enable": isRefererFnEnable,
    "ReferEarn": referEarn.toJson(),
    "status": status,
    "user_refer_code": userReferCode,
  };
}

class ReferEarn {
  String id;
  String sharedMessage;
  bool blDeviceIdUnique;

  ReferEarn({
    this.id,
    this.sharedMessage,
    this.blDeviceIdUnique,
  });

  factory ReferEarn.fromJson(Map<String, dynamic> json) => ReferEarn(
    id: json["id"],
    sharedMessage: json["shared_message"],
    blDeviceIdUnique: json["bl_device_id_unique"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "shared_message": sharedMessage,
    "bl_device_id_unique": blDeviceIdUnique,
  };
}
