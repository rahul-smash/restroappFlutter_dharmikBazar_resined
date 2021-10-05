// To parse this JSON data, do
//
//     final promiseToPayUserResponse = promiseToPayUserResponseFromJson(jsonString);

import 'dart:convert';

class PromiseToPayUserResponse {
  PromiseToPayUserResponse({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  String message;

  PromiseToPayUserResponse copyWith({
    bool success,
    Data data,
    String message,
  }) =>
      PromiseToPayUserResponse(
        success: success ?? this.success,
        data: data ?? this.data,
        message: message ?? this.message,
      );

  factory PromiseToPayUserResponse.fromRawJson(String str) =>
      PromiseToPayUserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PromiseToPayUserResponse.fromJson(Map<String, dynamic> json) =>
      PromiseToPayUserResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null
            ? null
            : (json["data"] is List ? null : Data.fromJson(json["data"])),
        message: json["message"] == null ? null : json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
        "message": message == null ? null : message,
      };
}

class Data {
  Data({
    this.id,
    this.promiseToPay,
    this.fullName,
  });

  String id;
  String promiseToPay;
  String fullName;

  Data copyWith({
    String id,
    String promiseToPay,
    String fullName,
  }) =>
      Data(
        id: id ?? this.id,
        promiseToPay: promiseToPay ?? this.promiseToPay,
        fullName: fullName ?? this.fullName,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] == null ? null : json["id"],
        promiseToPay:
            json["promise_to_pay"] == null ? null : json["promise_to_pay"],
        fullName: json["full_name"] == null ? null : json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "promise_to_pay": promiseToPay == null ? null : promiseToPay,
        "full_name": fullName == null ? null : fullName,
      };
}
