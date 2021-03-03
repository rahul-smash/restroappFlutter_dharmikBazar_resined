// To parse this JSON data, do
//
//     final razorpayOrderData = razorpayOrderDataFromJson(jsonString);

import 'dart:convert';

RazorpayOrderData razorpayOrderDataFromJson(String str) => RazorpayOrderData.fromJson(json.decode(str));

String razorpayOrderDataToJson(RazorpayOrderData data) => json.encode(data.toJson());

class RazorpayOrderData {
  bool success;
  String message;
  Data data;

  RazorpayOrderData({
    this.success,
    this.message,
    this.data,
  });

  factory RazorpayOrderData.fromJson(Map<String, dynamic> json) => RazorpayOrderData(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String id;
  String entity;
  int amount;
  String currency;
  String status;
  String orderId;
  String invoiceId;
  bool international;
  String method;
  int amountRefunded;
  String refundStatus;
  bool captured;
  String description;
  String cardId;
  String bank;
  String wallet;
  String vpa;
  String email;
  String contact;
  String customerId;
  String tokenId;
  List<dynamic> notes;
  int fee;
  int tax;
  String errorCode;
  String errorDescription;
  int createdAt;

  Data({
    this.id,
    this.entity,
    this.amount,
    this.currency,
    this.status,
    this.orderId,
    this.invoiceId,
    this.international,
    this.method,
    this.amountRefunded,
    this.refundStatus,
    this.captured,
    this.description,
    this.cardId,
    this.bank,
    this.wallet,
    this.vpa,
    this.email,
    this.contact,
    this.customerId,
    this.tokenId,
    this.notes,
    this.fee,
    this.tax,
    this.errorCode,
    this.errorDescription,
    this.createdAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    entity: json["entity"],
    amount: json["amount"],
    currency: json["currency"],
    status: json["status"],
    orderId: json["order_id"],
    invoiceId: json["invoice_id"],
    international: json["international"],
    method: json["method"],
    amountRefunded: json["amount_refunded"],
    refundStatus: json["refund_status"],
    captured: json["captured"],
    description: json["description"],
    cardId: json["card_id"],
    bank: json["bank"],
    wallet: json["wallet"],
    vpa: json["vpa"],
    email: json["email"],
    contact: json["contact"],
    customerId: json["customer_id"],
    tokenId: json["token_id"],
    notes: List<dynamic>.from(json["notes"].map((x) => x)),
    fee: json["fee"],
    tax: json["tax"],
    errorCode: json["error_code"],
    errorDescription: json["error_description"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "entity": entity,
    "amount": amount,
    "currency": currency,
    "status": status,
    "order_id": orderId,
    "invoice_id": invoiceId,
    "international": international,
    "method": method,
    "amount_refunded": amountRefunded,
    "refund_status": refundStatus,
    "captured": captured,
    "description": description,
    "card_id": cardId,
    "bank": bank,
    "wallet": wallet,
    "vpa": vpa,
    "email": email,
    "contact": contact,
    "customer_id": customerId,
    "token_id": tokenId,
    "notes": List<dynamic>.from(notes.map((x) => x)),
    "fee": fee,
    "tax": tax,
    "error_code": errorCode,
    "error_description": errorDescription,
    "created_at": createdAt,
  };
}
