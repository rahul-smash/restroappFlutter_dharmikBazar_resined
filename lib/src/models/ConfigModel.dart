// To parse this JSON data, do
//
//     final configModel = configModelFromJson(jsonString);

import 'dart:convert';

ConfigModel configModelFromJson(String str) => ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  String storeId;
  String isAdminLogin;
  String appTheme;

  ConfigModel({
    this.storeId,
    this.isAdminLogin,
    this.appTheme,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
    storeId: json["store_id"],
    isAdminLogin: json["isAdminLogin"],
    appTheme: json["appTheme"],
  );

  Map<String, dynamic> toJson() => {
    "store_id": storeId,
    "isAdminLogin": isAdminLogin,
    "appTheme": appTheme,
  };
}
