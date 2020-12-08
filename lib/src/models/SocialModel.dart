// To parse this JSON data, do
//
//     final socialModel = socialModelFromJson(jsonString);

import 'dart:convert';

SocialModel socialModelFromJson(String str) => SocialModel.fromJson(json.decode(str));

String socialModelToJson(SocialModel data) => json.encode(data.toJson());

class SocialModel {
  SocialModel({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  factory SocialModel.fromJson(Map<String, dynamic> json) => SocialModel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.facebook,
    this.twitter,
    this.instagram,
    this.linkedin,
    this.youtube,
    this.whatsapp
  });

  String id;
  String facebook;
  String twitter;
  String instagram;
  String linkedin;
  String youtube;
  String whatsapp;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    facebook: json["facebook"],
    twitter: json["twitter"],
    instagram: json["instagram"],
    linkedin: json["linkedin"],
    youtube: json["youtube"],
    whatsapp: json["whatsapp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "facebook": facebook,
    "twitter": twitter,
    "instagram": instagram,
    "linkedin": linkedin,
    "youtube": youtube,
    "whatsapp": whatsapp,
  };
}
