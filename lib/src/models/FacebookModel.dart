// To parse this JSON data, do
//
//     final facebookModel = facebookModelFromJson(jsonString);

import 'dart:convert';

FacebookModel facebookModelFromJson(String str) => FacebookModel.fromJson(json.decode(str));

String facebookModelToJson(FacebookModel data) => json.encode(data.toJson());

class FacebookModel {
  FacebookModel({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.id,
  });

  String name= "";
  String firstName= "";
  String lastName= "";
  String email = "";
  String id= "";

  factory FacebookModel.fromJson(Map<String, dynamic> json) => FacebookModel(
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"] == null ? "" : json["email"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "id": id,
  };
}
