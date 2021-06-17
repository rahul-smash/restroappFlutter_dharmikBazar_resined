// class CreatePaytmTxnTokenResponse {
//   bool success;
//   String message;
//   String url;
//
//   CreatePaytmTxnTokenResponse({this.success, this.message, this.url});
//
//   CreatePaytmTxnTokenResponse.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     url = json['url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     data['url'] = this.url;
//     return data;
//   }
// }
import 'dart:convert';

class CreatePaytmTxnTokenResponse {
  CreatePaytmTxnTokenResponse({
    this.success,
    this.message,
    this.txnToken,
    this.orderid,
    this.mid,
    this.url,
  });

  bool success;
  String message;
  String txnToken;
  String orderid;
  String mid;
  String url;

  CreatePaytmTxnTokenResponse copyWith({
    bool success,
    String message,
    String txnToken,
    String orderid,
    String mid,
    String url,
  }) =>
      CreatePaytmTxnTokenResponse(
        success: success ?? this.success,
        message: message ?? this.message,
        txnToken: txnToken ?? this.txnToken,
        orderid: orderid ?? this.orderid,
        mid: mid ?? this.mid,
        url: url ?? this.url,
      );

  factory CreatePaytmTxnTokenResponse.fromRawJson(String str) => CreatePaytmTxnTokenResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreatePaytmTxnTokenResponse.fromJson(Map<String, dynamic> json) => CreatePaytmTxnTokenResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    txnToken: json["txnToken"] == null ? null : json["txnToken"],
    orderid: json["orderid"] == null ? null : json["orderid"],
    mid: json["mid"] == null ? null : json["mid"],
    url: json["url"] == null ? null : json["url"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "txnToken": txnToken == null ? null : txnToken,
    "orderid": orderid == null ? null : orderid,
    "mid": mid == null ? null : mid,
    "url": url == null ? null : url,
  };
}
