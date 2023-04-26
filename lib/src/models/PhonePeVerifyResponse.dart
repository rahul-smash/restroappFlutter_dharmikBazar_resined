// To parse this JSON data, do
//
//     final phonePeVerifyResponse = phonePeVerifyResponseFromJson(jsonString);

import 'dart:convert';

class PhonePeVerifyResponse {
  PhonePeVerifyResponse({
    this.success,
    this.paymentRequestId,
    this.data,
  });

  bool success;
  String paymentRequestId;
  PhonePeVerifyResponseData data;

  PhonePeVerifyResponse copyWith({
    bool success,
    String paymentRequestId,
    PhonePeVerifyResponseData data,
  }) =>
      PhonePeVerifyResponse(
        success: success ?? this.success,
        paymentRequestId: paymentRequestId ?? this.paymentRequestId,
        data: data ?? this.data,
      );

  factory PhonePeVerifyResponse.fromRawJson(String str) => PhonePeVerifyResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PhonePeVerifyResponse.fromJson(Map<String, dynamic> json) => PhonePeVerifyResponse(
    success: json["success"] == null ? null : json["success"],
    paymentRequestId: json["payment_request_id"] == null ? null : json["payment_request_id"],
    data: json["data"] == null ? null : PhonePeVerifyResponseData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "payment_request_id": paymentRequestId == null ? null : paymentRequestId,
    "data": data == null ? null : data.toJson(),
  };
}

class PhonePeVerifyResponseData {
  PhonePeVerifyResponseData({
    this.success,
    this.code,
    this.message,
    this.data,
  });

  bool success;
  String code;
  String message;
  DataData data;

  PhonePeVerifyResponseData copyWith({
    bool success,
    String code,
    String message,
    DataData data,
  }) =>
      PhonePeVerifyResponseData(
        success: success ?? this.success,
        code: code ?? this.code,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory PhonePeVerifyResponseData.fromRawJson(String str) => PhonePeVerifyResponseData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PhonePeVerifyResponseData.fromJson(Map<String, dynamic> json) => PhonePeVerifyResponseData(
    success: json["success"] == null ? null : json["success"],
    code: json["code"] == null ? null : json["code"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : DataData.fromJson(json["data"]),
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
    this.merchantId,
    this.transactionId,
    this.providerReferenceId,
    this.amount,
    this.merchantOrderId,
    this.paymentState,
    this.payResponseCode,
  });

  String merchantId;
  String transactionId;
  String providerReferenceId;
  int amount;
  String merchantOrderId;
  String paymentState;
  String payResponseCode;

  DataData copyWith({
    String merchantId,
    String transactionId,
    String providerReferenceId,
    int amount,
    String merchantOrderId,
    String paymentState,
    String payResponseCode,
  }) =>
      DataData(
        merchantId: merchantId ?? this.merchantId,
        transactionId: transactionId ?? this.transactionId,
        providerReferenceId: providerReferenceId ?? this.providerReferenceId,
        amount: amount ?? this.amount,
        merchantOrderId: merchantOrderId ?? this.merchantOrderId,
        paymentState: paymentState ?? this.paymentState,
        payResponseCode: payResponseCode ?? this.payResponseCode,
      );

  factory DataData.fromRawJson(String str) => DataData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    merchantId: json["merchantId"] == null ? null : json["merchantId"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    providerReferenceId: json["providerReferenceId"] == null ? null : json["providerReferenceId"],
    amount: json["amount"] == null ? null : json["amount"],
    merchantOrderId: json["merchantOrderId"] == null ? null : json["merchantOrderId"],
    paymentState: json["paymentState"] == null ? null : json["paymentState"],
    payResponseCode: json["payResponseCode"] == null ? null : json["payResponseCode"],
  );

  Map<String, dynamic> toJson() => {
    "merchantId": merchantId == null ? null : merchantId,
    "transactionId": transactionId == null ? null : transactionId,
    "providerReferenceId": providerReferenceId == null ? null : providerReferenceId,
    "amount": amount == null ? null : amount,
    "merchantOrderId": merchantOrderId == null ? null : merchantOrderId,
    "paymentState": paymentState == null ? null : paymentState,
    "payResponseCode": payResponseCode == null ? null : payResponseCode,
  };
}
