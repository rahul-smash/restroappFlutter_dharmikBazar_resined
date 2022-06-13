// To parse this JSON data, do
//
//     final weightWiseChargesResponse = weightWiseChargesResponseFromJson(jsonString);

import 'dart:convert';

class WeightWiseChargesResponse {
  WeightWiseChargesResponse({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  WeightWiseChargesResponse copyWith({
    bool success,
    Data data,
  }) =>
      WeightWiseChargesResponse(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory WeightWiseChargesResponse.fromRawJson(String str) => WeightWiseChargesResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WeightWiseChargesResponse.fromJson(Map<String, dynamic> json) => WeightWiseChargesResponse(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.orderDetail,
    this.totalDeliveryCharge,
  });

  List<OrderDetail> orderDetail;
  dynamic totalDeliveryCharge;

  Data copyWith({
    List<OrderDetail> orderDetail,
    dynamic totalDeliveryCharge,
  }) =>
      Data(
        orderDetail: orderDetail ?? this.orderDetail,
        totalDeliveryCharge: totalDeliveryCharge ?? this.totalDeliveryCharge,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    orderDetail: json["order_detail"] == null ? null : List<OrderDetail>.from(json["order_detail"].map((x) => OrderDetail.fromJson(x))),
    totalDeliveryCharge: json["total_delivery_charge"] == null ? null : json["total_delivery_charge"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "order_detail": orderDetail == null ? null : List<dynamic>.from(orderDetail.map((x) => x.toJson())),
    "total_delivery_charge": totalDeliveryCharge == null ? null : totalDeliveryCharge.toString(),
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
    this.deliveryCharges,
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
  int deliveryCharges;

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
    int deliveryCharges,
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
        deliveryCharges: deliveryCharges ?? this.deliveryCharges,
      );

  factory OrderDetail.fromRawJson(String str) => OrderDetail.fromJson(json.decode(str));

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
    deliveryCharges: json["delivery_charges"] == null ? null : json["delivery_charges"],
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
    "delivery_charges": deliveryCharges == null ? null : deliveryCharges,
  };
}
