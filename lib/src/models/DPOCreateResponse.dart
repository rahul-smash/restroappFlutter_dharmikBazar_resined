// To parse this JSON data, do
//
//     final dpoCreateResponse = dpoCreateResponseFromJson(jsonString);

import 'dart:convert';

class DpoCreateResponse {
  DpoCreateResponse({
    this.success,
    this.data,
  });

  bool success;
  String data;

  DpoCreateResponse copyWith({
    bool success,
    String data,
  }) =>
      DpoCreateResponse(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory DpoCreateResponse.fromRawJson(String str) => DpoCreateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DpoCreateResponse.fromJson(Map<String, dynamic> json) => DpoCreateResponse(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : data,
  };
}
