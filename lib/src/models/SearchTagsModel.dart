// To parse this JSON data, do
//
//     final searchTagsModel = searchTagsModelFromJson(jsonString);

import 'dart:convert';

SearchTagsModel searchTagsModelFromJson(String str) => SearchTagsModel.fromJson(json.decode(str));

String searchTagsModelToJson(SearchTagsModel data) => json.encode(data.toJson());

class SearchTagsModel {
  bool success;
  List<String> data;

  SearchTagsModel({
    this.success,
    this.data,
  });

  factory SearchTagsModel.fromJson(Map<String, dynamic> json) => SearchTagsModel(
    success: json["success"],
    data: List<String>.from(json["data"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x)),
  };
}
