// To parse this JSON data, do
//
//     final phonePeResponse = phonePeResponseFromJson(jsonString);

import 'dart:convert';

class PhonePeResponse {
  PhonePeResponse({
    this.success,
    this.paymentRequestId,
    this.data,
    this.message,
  });

  bool success;
  String paymentRequestId;
  PhonePeResponseData data;
  String message;

  PhonePeResponse copyWith({
    bool success,
    String paymentRequestId,
    PhonePeResponseData data,
    String message,
  }) =>
      PhonePeResponse(
        success: success ?? this.success,
        paymentRequestId: paymentRequestId ?? this.paymentRequestId,
        data: data ?? this.data,
        message: message ?? this.message,
      );

  factory PhonePeResponse.fromRawJson(String str) => PhonePeResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PhonePeResponse.fromJson(Map<String, dynamic> json) => PhonePeResponse(
    success: json["success"] == null ? null : json["success"],
    paymentRequestId: json["payment_request_id"] == null ? null : json["payment_request_id"],
    data: json["data"] == null ? null : PhonePeResponseData.fromJson(json["data"]),
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "payment_request_id": paymentRequestId == null ? null : paymentRequestId,
    "data": data == null ? null : data.toJson(),
    "message": message == null ? null : message,
  };
}

class PhonePeResponseData {
  PhonePeResponseData({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  bool success;
  String code;
  String message;
  DataData data;

  PhonePeResponseData copyWith({
    bool success,
    String code,
    String message,
    DataData data,
  }) =>
      PhonePeResponseData(
        success: success ?? this.success,
        code: code ?? this.code,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory PhonePeResponseData.fromRawJson(String str) => PhonePeResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PhonePeResponseData.fromJson(Map<String, dynamic> json) => PhonePeResponseData(
    success: json["success"] == null ? null : json["success"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : json["data"] is List?null:  DataData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "code": code == null ? null : code,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toJson(),
  };
}

class DataData {
  DataData({
    this.redirectType,
    this.redirectUrl,
  });

  String redirectType;
  String redirectUrl;

  DataData copyWith({
    String redirectType,
    String redirectUrl,
  }) =>
      DataData(
        redirectType: redirectType ?? this.redirectType,
        redirectUrl: redirectUrl ?? this.redirectUrl,
      );

  factory DataData.fromRawJson(String str) => DataData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    redirectType: json["redirectType"] == null ? null : json["redirectType"],
    redirectUrl: json["redirectURL"] == null ? null : json["redirectURL"],
  );

  Map<String, dynamic> toJson() => {
    "redirectType": redirectType == null ? null : redirectType,
    "redirectURL": redirectUrl == null ? null : redirectUrl,
  };
}
