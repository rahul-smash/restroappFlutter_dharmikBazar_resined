// To parse this JSON data, do
//
//     final subscriptionTaxCalculationResponse = subscriptionTaxCalculationResponseFromJson(jsonString);

import 'dart:convert';

class SubscriptionTaxCalculationResponse {
  SubscriptionTaxCalculationResponse({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  SubscriptionTaxCalculation data;
  String message;

  SubscriptionTaxCalculationResponse copyWith({
    bool success,
    SubscriptionTaxCalculation data,
    String message
  }) =>
      SubscriptionTaxCalculationResponse(
        success: success ?? this.success,
        data: data ?? this.data,
        message: message ?? this.message,
      );

  String toRawJson() => json.encode(toJson());

  factory SubscriptionTaxCalculationResponse.fromJson(
          String couponCode, Map<String, dynamic> json) =>
      SubscriptionTaxCalculationResponse(
        success: json["success"] == null ? null : json["success"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : SubscriptionTaxCalculation.fromJson(couponCode, json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "message": message == null ? null : message,
        "data": data == null ? null : data.toJson(),
      };
}

class SubscriptionTaxCalculation {
  SubscriptionTaxCalculation({
    this.total,
    this.singleDayTotal,
    this.walletRefund,
    this.itemSubTotal,
    this.singleDayItemSubTotal,
    this.tax,
    this.singleDayTax,
    this.discount,
    this.singleDayDiscount,
    this.shipping,
    this.singleDayShipping,
    this.fixedTaxAmount,
    this.singleDayFixedTaxAmount,
    this.taxDetail,
    this.taxLabel,
    this.fixedTax,
    this.orderDetail,
    this.isChanged,
    this.couponCode,
  });

  String total;
  String singleDayTotal;
  String walletRefund;
  String itemSubTotal;
  String singleDayItemSubTotal;
  String tax;
  String singleDayTax;
  String discount;
  String singleDayDiscount;
  String shipping;
  String singleDayShipping;
  String fixedTaxAmount;
  String singleDayFixedTaxAmount;
  List<TaxDetail> taxDetail;
  List<TaxLabel> taxLabel;
  List<dynamic> fixedTax;
  List<OrderDetail> orderDetail;
  bool isChanged;
  String couponCode;

  SubscriptionTaxCalculation copyWith({
    String total,
    String singleDayTotal,
    String walletRefund,
    String itemSubTotal,
    String singleDayItemSubTotal,
    String tax,
    String singleDayTax,
    String discount,
    String singleDayDiscount,
    String shipping,
    String singleDayShipping,
    String fixedTaxAmount,
    String singleDayFixedTaxAmount,
    List<TaxDetail> taxDetail,
    List<TaxLabel> taxLabel,
    List<dynamic> fixedTax,
    List<OrderDetail> orderDetail,
    bool isChanged,
    String couponCode,
  }) =>
      SubscriptionTaxCalculation(
          total: total ?? this.total,
          singleDayTotal: singleDayTotal ?? this.singleDayTotal,
          walletRefund: walletRefund ?? this.walletRefund,
          itemSubTotal: itemSubTotal ?? this.itemSubTotal,
          singleDayItemSubTotal:
              singleDayItemSubTotal ?? this.singleDayItemSubTotal,
          tax: tax ?? this.tax,
          singleDayTax: singleDayTax ?? this.singleDayTax,
          discount: discount ?? this.discount,
          singleDayDiscount: singleDayDiscount ?? this.singleDayDiscount,
          shipping: shipping ?? this.shipping,
          singleDayShipping: singleDayShipping ?? this.singleDayShipping,
          fixedTaxAmount: fixedTaxAmount ?? this.fixedTaxAmount,
          singleDayFixedTaxAmount:
              singleDayFixedTaxAmount ?? this.singleDayFixedTaxAmount,
          taxDetail: taxDetail ?? this.taxDetail,
          taxLabel: taxLabel ?? this.taxLabel,
          fixedTax: fixedTax ?? this.fixedTax,
          orderDetail: orderDetail ?? this.orderDetail,
          isChanged: isChanged ?? this.isChanged,
          couponCode: couponCode ?? this.couponCode);

  String toRawJson() => json.encode(toJson());

  factory SubscriptionTaxCalculation.fromJson(String couponCodePassed, Map<String, dynamic> json) =>
      SubscriptionTaxCalculation(
        total: json["total"] == null ? null : json["total"],
        singleDayTotal:
            json["single_day_total"] == null ? null : json["single_day_total"],
        walletRefund:
            json["wallet_refund"] == null ? null : json["wallet_refund"],
        itemSubTotal:
            json["item_sub_total"] == null ? null : json["item_sub_total"],
        singleDayItemSubTotal: json["single_day_item_sub_total"] == null
            ? null
            : json["single_day_item_sub_total"],
        tax: json["tax"] == null ? null : json["tax"],
        singleDayTax:
            json["single_day_tax"] == null ? null : json["single_day_tax"],
        discount: json["discount"] == null ? null : json["discount"],
        singleDayDiscount: json["single_day_discount"] == null
            ? null
            : json["single_day_discount"],
        shipping: json["shipping"] == null ? null : json["shipping"],
        singleDayShipping: json["single_day_shipping"] == null
            ? null
            : json["single_day_shipping"],
        fixedTaxAmount:
            json["fixed_tax_amount"] == null ? null : json["fixed_tax_amount"],
        singleDayFixedTaxAmount: json["single_day_fixed_tax_amount"] == null
            ? null
            : json["single_day_fixed_tax_amount"],
        taxDetail: json["tax_detail"] == null
            ? null
            : List<TaxDetail>.from(
                json["tax_detail"].map((x) => TaxDetail.fromJson(x))),
        taxLabel: json["tax_label"] == null
            ? null
            : List<TaxLabel>.from(
                json["tax_label"].map((x) => TaxLabel.fromJson(x))),
        fixedTax: json["fixed_Tax"] == null
            ? null
            : List<dynamic>.from(json["fixed_Tax"].map((x) => x)),
        orderDetail: json["order_detail"] == null
            ? null
            : List<OrderDetail>.from(
                json["order_detail"].map((x) => OrderDetail.fromJson(x))),
        isChanged: json["is_changed"] == null ? null : json["is_changed"],
        couponCode: couponCodePassed,
      );

  Map<String, dynamic> toJson() => {
        "total": total == null ? null : total,
        "single_day_total": singleDayTotal == null ? null : singleDayTotal,
        "wallet_refund": walletRefund == null ? null : walletRefund,
        "item_sub_total": itemSubTotal == null ? null : itemSubTotal,
        "single_day_item_sub_total":
            singleDayItemSubTotal == null ? null : singleDayItemSubTotal,
        "tax": tax == null ? null : tax,
        "single_day_tax": singleDayTax == null ? null : singleDayTax,
        "discount": discount == null ? null : discount,
        "single_day_discount":
            singleDayDiscount == null ? null : singleDayDiscount,
        "shipping": shipping == null ? null : shipping,
        "single_day_shipping":
            singleDayShipping == null ? null : singleDayShipping,
        "fixed_tax_amount": fixedTaxAmount == null ? null : fixedTaxAmount,
        "single_day_fixed_tax_amount":
            singleDayFixedTaxAmount == null ? null : singleDayFixedTaxAmount,
        "tax_detail": taxDetail == null
            ? null
            : List<dynamic>.from(taxDetail.map((x) => x.toJson())),
        "tax_label": taxLabel == null
            ? null
            : List<dynamic>.from(taxLabel.map((x) => x.toJson())),
        "fixed_Tax": fixedTax == null
            ? null
            : List<dynamic>.from(fixedTax.map((x) => x)),
        "order_detail": orderDetail == null
            ? null
            : List<dynamic>.from(orderDetail.map((x) => x.toJson())),
        "is_changed": isChanged == null ? null : isChanged,
      };
}

class OrderDetail {
  OrderDetail({
    this.productId,
    this.productName,
    this.isTaxEnable,
    this.variantId,
    this.weight,
    this.mrpPrice,
    this.price,
    this.discount,
    this.unitType,
    this.quantity,
    this.productType,
    this.outOfStock,
    this.hsnCode,
    this.gstState,
    this.igst,
    this.gstType,
    this.cgst,
    this.sgst,
    this.gstTaxRate,
    this.productStatus,
  });

  String productId;
  String productName;
  String isTaxEnable;
  String variantId;
  String weight;
  String mrpPrice;
  String price;
  String discount;
  String unitType;
  int quantity;
  int productType;
  bool outOfStock;
  String hsnCode;
  String gstState;
  int igst;
  String gstType;
  double cgst;
  double sgst;
  String gstTaxRate;
  String productStatus;

  OrderDetail copyWith({
    String productId,
    String productName,
    String isTaxEnable,
    String variantId,
    String weight,
    String mrpPrice,
    String price,
    String discount,
    String unitType,
    int quantity,
    int productType,
    bool outOfStock,
    String hsnCode,
    String gstState,
    int igst,
    String gstType,
    double cgst,
    double sgst,
    String gstTaxRate,
    String productStatus,
  }) =>
      OrderDetail(
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        isTaxEnable: isTaxEnable ?? this.isTaxEnable,
        variantId: variantId ?? this.variantId,
        weight: weight ?? this.weight,
        mrpPrice: mrpPrice ?? this.mrpPrice,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        unitType: unitType ?? this.unitType,
        quantity: quantity ?? this.quantity,
        productType: productType ?? this.productType,
        outOfStock: outOfStock ?? this.outOfStock,
        hsnCode: hsnCode ?? this.hsnCode,
        gstState: gstState ?? this.gstState,
        igst: igst ?? this.igst,
        gstType: gstType ?? this.gstType,
        cgst: cgst ?? this.cgst,
        sgst: sgst ?? this.sgst,
        gstTaxRate: gstTaxRate ?? this.gstTaxRate,
        productStatus: productStatus ?? this.productStatus,
      );

  factory OrderDetail.fromRawJson(String str) =>
      OrderDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        productId: json["product_id"] == null ? null : json["product_id"],
        productName: json["product_name"] == null ? null : json["product_name"],
        isTaxEnable: json["isTaxEnable"] == null ? null : json["isTaxEnable"],
        variantId: json["variant_id"] == null ? null : json["variant_id"],
        weight: json["weight"] == null ? null : json["weight"],
        mrpPrice: json["mrp_price"] == null ? null : json["mrp_price"],
        price: json["price"] == null ? null : json["price"],
        discount: json["discount"] == null ? null : json["discount"],
        unitType: json["unit_type"] == null ? null : json["unit_type"],
        quantity: json["quantity"] == null ? null : json["quantity"],
        productType: json["product_type"] == null ? null : json["product_type"],
        outOfStock: json["out_of_stock"] == null ? null : json["out_of_stock"],
        hsnCode: json["hsn_code"] == null ? null : json["hsn_code"],
        gstState: json["gst_state"] == null ? null : json["gst_state"],
        igst: json["igst"] == null ? null : json["igst"],
        gstType: json["gst_type"] == null ? null : json["gst_type"],
        cgst: json["cgst"] == null ? null : json["cgst"].toDouble(),
        sgst: json["sgst"] == null ? null : json["sgst"].toDouble(),
        gstTaxRate: json["gst_tax_rate"] == null ? null : json["gst_tax_rate"],
        productStatus:
            json["product_status"] == null ? null : json["product_status"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId == null ? null : productId,
        "product_name": productName == null ? null : productName,
        "isTaxEnable": isTaxEnable == null ? null : isTaxEnable,
        "variant_id": variantId == null ? null : variantId,
        "weight": weight == null ? null : weight,
        "mrp_price": mrpPrice == null ? null : mrpPrice,
        "price": price == null ? null : price,
        "discount": discount == null ? null : discount,
        "unit_type": unitType == null ? null : unitType,
        "quantity": quantity == null ? null : quantity,
        "product_type": productType == null ? null : productType,
        "out_of_stock": outOfStock == null ? null : outOfStock,
        "hsn_code": hsnCode == null ? null : hsnCode,
        "gst_state": gstState == null ? null : gstState,
        "igst": igst == null ? null : igst,
        "gst_type": gstType == null ? null : gstType,
        "cgst": cgst == null ? null : cgst,
        "sgst": sgst == null ? null : sgst,
        "gst_tax_rate": gstTaxRate == null ? null : gstTaxRate,
        "product_status": productStatus == null ? null : productStatus,
      };
}

class TaxDetail {
  TaxDetail({
    this.label,
    this.rate,
    this.tax,
  });

  String label;
  String rate;
  String tax;

  TaxDetail copyWith({
    String label,
    String rate,
    String tax,
  }) =>
      TaxDetail(
        label: label ?? this.label,
        rate: rate ?? this.rate,
        tax: tax ?? this.tax,
      );

  factory TaxDetail.fromRawJson(String str) =>
      TaxDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaxDetail.fromJson(Map<String, dynamic> json) => TaxDetail(
        label: json["label"] == null ? null : json["label"],
        rate: json["rate"] == null ? null : json["rate"],
        tax: json["tax"] == null ? null : json["tax"],
      );

  Map<String, dynamic> toJson() => {
        "label": label == null ? null : label,
        "rate": rate == null ? null : rate,
        "tax": tax == null ? null : tax,
      };
}

class TaxLabel {
  TaxLabel({
    this.label,
    this.rate,
  });

  String label;
  String rate;

  TaxLabel copyWith({
    String label,
    String rate,
  }) =>
      TaxLabel(
        label: label ?? this.label,
        rate: rate ?? this.rate,
      );

  factory TaxLabel.fromRawJson(String str) =>
      TaxLabel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TaxLabel.fromJson(Map<String, dynamic> json) => TaxLabel(
        label: json["label"] == null ? null : json["label"],
        rate: json["rate"] == null ? null : json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "label": label == null ? null : label,
        "rate": rate == null ? null : rate,
      };
}
