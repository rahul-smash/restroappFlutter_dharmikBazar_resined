class TaxCalculationResponse {

  bool success;
  TaxCalculationModel taxCalculation;

  TaxCalculationResponse({this.success, this.taxCalculation});

  TaxCalculationResponse.fromJson(String couponCode, Map<String, dynamic> json) {
    success = json['success'];
    taxCalculation = json['data'] != null ? TaxCalculationModel.fromJson(couponCode, json['data']): null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.taxCalculation != null) {
      data['data'] = this.taxCalculation.toJson();
    }
    return data;
  }
}

class TaxCalculationModel {

  /*String total;
  int itemSubTotal;
  int tax;
  int discount;
  String shipping;
  int fixedTaxAmount;
  List<dynamic> taxDetail;
  List<dynamic> taxLabel;
  List<dynamic> fixedTax;*/

  String total;
  int itemSubTotal;
  int tax;
  int discount;
  String shipping;
  String couponCode;
  int fixedTaxAmount;
  List<TaxDetail> taxDetail;
  List<TaxLabel> taxLabel;
  List<FixedTax> fixedTax;

  TaxCalculationModel(
      {this.total,
      this.itemSubTotal,
      this.tax,
      this.discount,
      this.shipping,
      this.couponCode,
      this.fixedTaxAmount,
      this.taxDetail,
      this.taxLabel,
      this.fixedTax});

  factory TaxCalculationModel.fromJson(
      String couponCode, Map<String, dynamic> json) {
    TaxCalculationModel model = TaxCalculationModel();

    model.total = json['total'];
    model.itemSubTotal = json['item_sub_total'];
    model.tax = json['tax'];
    model.discount = json['discount'];
    model.shipping = json['shipping'];
    model.couponCode = couponCode;
    model.fixedTaxAmount = json['fixed_tax_amount'];
    if (json['tax_detail'] != null) {
      model.taxDetail = new List<TaxDetail>();
      json['tax_detail'].forEach((v) {
        model.taxDetail.add(new TaxDetail.fromJson(v));
      });
    }
    if (json['tax_label'] != null) {
      model.taxLabel = new List<TaxLabel>();
      json['tax_label'].forEach((v) {
        model.taxLabel.add(new TaxLabel.fromJson(v));
      });
    }
    if (json['fixed_Tax'] != null) {
      model.fixedTax = new List<FixedTax>();
      json['fixed_Tax'].forEach((v) {
        model.fixedTax.add(new FixedTax.fromJson(v));
      });
    }
    return model;
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
