import 'dart:convert';

TaxCalulationResponse taxCalulationResponseFromJson(String str) => TaxCalulationResponse.fromJson(json.decode(str));

String taxCalulationResponseToJson(TaxCalulationResponse data) => json.encode(data.toJson());
class TaxCalulationResponse {
  bool success;
  Data data;

  TaxCalulationResponse({this.success, this.data});

  TaxCalulationResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String total;
  double itemSubTotal;
  double tax;
  String discount;
  String shipping;
  int fixedTaxAmount;
  List<TaxDetail> taxDetail;
  List<TaxLabel> taxLabel;
  List<FixedTax> fixedTax;

  Data(
      {this.total,
        this.itemSubTotal,
        this.tax,
        this.discount,
        this.shipping,
        this.fixedTaxAmount,
        this.taxDetail,
        this.taxLabel,
        this.fixedTax});

  Data.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    itemSubTotal = json['item_sub_total'];
    tax = json['tax'];
    discount = json['discount'];
    shipping = json['shipping'];
    fixedTaxAmount = json['fixed_tax_amount'];
    if (json['tax_detail'] != null) {
      taxDetail = new List<TaxDetail>();
      json['tax_detail'].forEach((v) {
        taxDetail.add(new TaxDetail.fromJson(v));
      });
    }
    if (json['tax_label'] != null) {
      taxLabel = new List<TaxLabel>();
      json['tax_label'].forEach((v) {
        taxLabel.add(new TaxLabel.fromJson(v));
      });
    }
    if (json['fixed_Tax'] != null) {
      fixedTax = new List<FixedTax>();
      json['fixed_Tax'].forEach((v) {
        fixedTax.add(new FixedTax.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['item_sub_total'] = this.itemSubTotal;
    data['tax'] = this.tax;
    data['discount'] = this.discount;
    data['shipping'] = this.shipping;
    data['fixed_tax_amount'] = this.fixedTaxAmount;
    if (this.taxDetail != null) {
      data['tax_detail'] = this.taxDetail.map((v) => v.toJson()).toList();
    }
    if (this.taxLabel != null) {
      data['tax_label'] = this.taxLabel.map((v) => v.toJson()).toList();
    }
    if (this.fixedTax != null) {
      data['fixed_Tax'] = this.fixedTax.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaxDetail {
  String label;
  String rate;
  String tax;

  TaxDetail({this.label, this.rate, this.tax});

  TaxDetail.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    rate = json['rate'];
    tax = json['tax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['rate'] = this.rate;
    data['tax'] = this.tax;
    return data;
  }
}

class TaxLabel {
  String label;
  String rate;

  TaxLabel({this.label, this.rate});

  TaxLabel.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['rate'] = this.rate;
    return data;
  }
}

class FixedTax {
  String sort;
  String fixedTaxLabel;
  String fixedTaxAmount;
  String isTaxEnable;
  String isDiscountApplicable;

  FixedTax(
      {this.sort,
        this.fixedTaxLabel,
        this.fixedTaxAmount,
        this.isTaxEnable,
        this.isDiscountApplicable});

  FixedTax.fromJson(Map<String, dynamic> json) {
    sort = json['sort'];
    fixedTaxLabel = json['fixed_tax_label'];
    fixedTaxAmount = json['fixed_tax_amount'];
    isTaxEnable = json['is_tax_enable'];
    isDiscountApplicable = json['is_discount_applicable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sort'] = this.sort;
    data['fixed_tax_label'] = this.fixedTaxLabel;
    data['fixed_tax_amount'] = this.fixedTaxAmount;
    data['is_tax_enable'] = this.isTaxEnable;
    data['is_discount_applicable'] = this.isDiscountApplicable;
    return data;
  }
}





/*
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
  //String discount;
  String shipping;
  int fixedTaxAmount;
  List<dynamic> taxDetail;
  List<dynamic> taxLabel;
  List<dynamic> fixedTax;

  Data({
    this.total,
    this.itemSubTotal,
    this.tax,
    //this.discount,
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
    //discount: json["discount"],
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
    //"discount": discount,
    "shipping": shipping,
    "fixed_tax_amount": fixedTaxAmount,
    "tax_detail": List<dynamic>.from(taxDetail.map((x) => x)),
    "tax_label": List<dynamic>.from(taxLabel.map((x) => x)),
    "fixed_Tax": List<dynamic>.from(fixedTax.map((x) => x)),
  };
}
*/
