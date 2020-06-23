// To parse this JSON data, do
//
//     final storeBranchesModel = storeBranchesModelFromJson(jsonString);

import 'dart:convert';

StoreBranchesModel storeBranchesModelFromJson(String str) => StoreBranchesModel.fromJson(json.decode(str));

String storeBranchesModelToJson(StoreBranchesModel data) => json.encode(data.toJson());

class StoreBranchesModel {
  StoreBranchesModel({
    this.success,
    this.data,
  });

  bool success;
  List<BranchData> data;

  factory StoreBranchesModel.fromJson(Map<String, dynamic> json) => StoreBranchesModel(
    success: json["success"],
    data: List<BranchData>.from(json["data"].map((x) => BranchData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BranchData {
  BranchData({
    this.id,
    this.storeName,
  });

  String id;
  String storeName;

  factory BranchData.fromJson(Map<String, dynamic> json) => BranchData(
    id: json["id"],
    storeName: json["store_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "store_name": storeName,
  };
}
