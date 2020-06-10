// To parse this JSON data, do
//
//     final configModel = configModelFromJson(jsonString);

import 'dart:convert';

ConfigModel configModelFromJson(String str) => ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  String storeId;
  String isGroceryApp;
  String isAdminLogin;
  String currency;
  String appTheme = "0xff75990B";
  String leftMenuIconColors = "0xffffffff";
  String leftMenuBackgroundColor = "0xff151515";
  String leftMenuTitleColors = "0xffffffff";
  String leftMenuUsernameColors = "0xffffffff";
  String bottomBarIconColor = "0xff42a700";
  String bottomBarTextColor = "0xff000000";
  String dotIncreasedColor = "0xff42a700";
  String left_menu_header_bkground = "0xff000000";
  String bottomBarBackgroundColor = "0xffffffff";
  String leftMenuLabelTextColors = "0xffffffff";

  ConfigModel({
    this.storeId,
    this.isGroceryApp,
    this.isAdminLogin,
    this.currency,
    this.appTheme,
    this.leftMenuIconColors,
    this.leftMenuBackgroundColor,
    this.leftMenuTitleColors,
    this.leftMenuUsernameColors,
    this.bottomBarIconColor,
    this.bottomBarTextColor,
    this.dotIncreasedColor,
    this.left_menu_header_bkground,
    this.bottomBarBackgroundColor,
    this.leftMenuLabelTextColors,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
    storeId: json["store_id"],
    isGroceryApp: json["isGroceryApp"],
    isAdminLogin: json["isAdminLogin"],
    currency: json["currency"],
    appTheme: json["app_theme_color"],
    leftMenuIconColors: json["left_menu_icon_color"],
    leftMenuBackgroundColor: json["left_menu_background_color"],
    leftMenuTitleColors: json["left_menu_title_color"],
    leftMenuUsernameColors: json["left_menu_username_color"],
    bottomBarIconColor: json["bottom_bar_icon_color"],
    bottomBarTextColor: json["bottom_bar_text_color"],
    dotIncreasedColor: json["dot_increased_color"],
    left_menu_header_bkground: json["left_menu_header_bkground"],
    bottomBarBackgroundColor: json["bottom_bar_background_color"],
    leftMenuLabelTextColors: json["left_menu_label_Color"],
  );

  Map<String, dynamic> toJson() => {
    "store_id": storeId,
    "isAdminLogin": isAdminLogin,
    "isGroceryApp":isGroceryApp,
    "currency":currency,
    "app_theme_color": appTheme,
    "left_menu_icon_color": leftMenuIconColors,
    "left_menu_background_color": leftMenuBackgroundColor,
    "left_menu_title_color": leftMenuTitleColors,
    "left_menu_username_color": leftMenuUsernameColors,
    "bottom_bar_icon_color": bottomBarIconColor,
    "bottom_bar_text_color": bottomBarTextColor,
    "dot_increased_color": dotIncreasedColor,
    "left_menu_header_bkground": left_menu_header_bkground,
    "bottom_bar_background_color": bottomBarBackgroundColor,
    "left_menu_label_Color": leftMenuLabelTextColors,

  };
}
