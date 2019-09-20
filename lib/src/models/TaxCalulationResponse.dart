// To parse this JSON data, do
//
//     final taxCalulationResponse = taxCalulationResponseFromJson(jsonString);

import 'dart:convert';

TaxCalulationResponse taxCalulationResponseFromJson(String str) => TaxCalulationResponse.fromJson(json.decode(str));

String taxCalulationResponseToJson(TaxCalulationResponse data) => json.encode(data.toJson());

class TaxCalulationResponse {
  bool success;
  Data data;

  TaxCalulationResponse({
    this.success,
    this.data,
  });

  factory TaxCalulationResponse.fromJson(Map<String, dynamic> json) => TaxCalulationResponse(
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
  };
}

class Data {
  String total;
  double itemSubTotal;
  int tax;
  String discount;
  String shipping;
  int fixedTaxAmount;
  List<dynamic> taxDetail;
  List<dynamic> taxLabel;
  List<dynamic> fixedTax;

  Data({
    this.total,
    this.itemSubTotal,
    this.tax,
    this.discount,
    this.shipping,
    this.fixedTaxAmount,
    this.taxDetail,
    this.taxLabel,
    this.fixedTax,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    total: json["total"],
    itemSubTotal: json["item_sub_total"].toDouble(),
    tax: json["tax"],
    discount: json["discount"],
    shipping: json["shipping"],
    fixedTaxAmount: json["fixed_tax_amount"],
    taxDetail: List<dynamic>.from(json["tax_detail"].map((x) => x)),
    taxLabel: List<dynamic>.from(json["tax_label"].map((x) => x)),
    fixedTax: List<dynamic>.from(json["fixed_Tax"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "item_sub_total": itemSubTotal,
    "tax": tax,
    "discount": discount,
    "shipping": shipping,
    "fixed_tax_amount": fixedTaxAmount,
    "tax_detail": List<dynamic>.from(taxDetail.map((x) => x)),
    "tax_label": List<dynamic>.from(taxLabel.map((x) => x)),
    "fixed_Tax": List<dynamic>.from(fixedTax.map((x) => x)),
  };
}
