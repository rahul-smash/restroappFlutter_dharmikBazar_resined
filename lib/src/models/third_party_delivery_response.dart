// To parse this JSON data, do
//
//     final thirdPartyDeliveryResponse = thirdPartyDeliveryResponseFromJson(jsonString);

import 'dart:convert';

class ThirdPartyDeliveryResponse {
  ThirdPartyDeliveryResponse({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  ThirdPartyDeliveryResponse copyWith({
    bool success,
    Data data,
  }) =>
      ThirdPartyDeliveryResponse(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory ThirdPartyDeliveryResponse.fromRawJson(String str) =>
      ThirdPartyDeliveryResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ThirdPartyDeliveryResponse.fromJson(Map<String, dynamic> json) =>
      ThirdPartyDeliveryResponse(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
      };
}

class Data {
  Data({this.orderDetail, this.shippingCharges, this.errorMsg});

  List<OrderDetail> orderDetail;
  List<ShippingCharge> shippingCharges;
  String errorMsg;

  Data copyWith({
    List<OrderDetail> orderDetail,
    List<ShippingCharge> shippingCharges,
    String errorMsg,
  }) =>
      Data(
        orderDetail: orderDetail ?? this.orderDetail,
        shippingCharges: shippingCharges ?? this.shippingCharges,
        errorMsg: errorMsg ?? this.errorMsg,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        orderDetail: json["order_detail"] == null
            ? null
            : List<OrderDetail>.from(
                json["order_detail"].map((x) => OrderDetail.fromJson(x))),
        shippingCharges: json["shipping_charges"] == null
            ? null
            : json["shipping_charges"] is List
                ? List<ShippingCharge>.from(json["shipping_charges"]
                    .map((x) => ShippingCharge.fromJson(x)))
                : null,
        errorMsg: json["shipping_charges"] == null
            ? null
            : json["shipping_charges"] is String
                ? json["shipping_charges"]
                : null,
      );

  Map<String, dynamic> toJson() => {
        "order_detail": orderDetail == null
            ? null
            : List<dynamic>.from(orderDetail.map((x) => x.toJson())),
        "shipping_charges": shippingCharges == null
            ? null
            : List<dynamic>.from(shippingCharges.map((x) => x.toJson())),
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
    this.length,
    this.breadth,
    this.height,
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
  String length;
  String breadth;
  String height;

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
    String length,
    String breadth,
    String height,
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
        length: length ?? this.length,
        breadth: breadth ?? this.breadth,
        height: height ?? this.height,
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
        length: json["length"] == null ? null : json["length"],
        breadth: json["breadth"] == null ? null : json["breadth"],
        height: json["height"] == null ? null : json["height"],
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
        "length": length == null ? null : length,
        "breadth": breadth == null ? null : breadth,
        "height": height == null ? null : height,
      };
}

class ShippingCharge {
  ShippingCharge({
    this.courierCompanyId,
    this.courierName,
    this.estimatedDeliveryDays,
    this.etd,
    this.etdHours,
    this.freightCharge,
    this.rate,
    this.rtoCharges,
    this.postcode,
    this.city,
    this.state,
    this.orderPaymentMode,
  });

  int courierCompanyId;
  String courierName;
  String estimatedDeliveryDays;
  String etd;
  int etdHours;
  double freightCharge;
  double rate;
  double rtoCharges;
  String postcode;
  String city;
  String state;
  String orderPaymentMode;

  ShippingCharge copyWith({
    int courierCompanyId,
    String courierName,
    String estimatedDeliveryDays,
    String etd,
    int etdHours,
    double freightCharge,
    double rate,
    double rtoCharges,
    String postcode,
    String city,
    String state,
    String orderPaymentMode,
  }) =>
      ShippingCharge(
        courierCompanyId: courierCompanyId ?? this.courierCompanyId,
        courierName: courierName ?? this.courierName,
        estimatedDeliveryDays:
            estimatedDeliveryDays ?? this.estimatedDeliveryDays,
        etd: etd ?? this.etd,
        etdHours: etdHours ?? this.etdHours,
        freightCharge: freightCharge ?? this.freightCharge,
        rate: rate ?? this.rate,
        rtoCharges: rtoCharges ?? this.rtoCharges,
        postcode: postcode ?? this.postcode,
        city: city ?? this.city,
        state: state ?? this.state,
        orderPaymentMode: orderPaymentMode ?? this.orderPaymentMode,
      );

  factory ShippingCharge.fromRawJson(String str) =>
      ShippingCharge.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShippingCharge.fromJson(Map<String, dynamic> json) => ShippingCharge(
        courierCompanyId: json["courier_company_id"] == null
            ? null
            : json["courier_company_id"],
        courierName: json["courier_name"] == null ? null : json["courier_name"],
        estimatedDeliveryDays: json["estimated_delivery_days"] == null
            ? null
            : json["estimated_delivery_days"],
        etd: json["etd"] == null ? null : json["etd"],
        etdHours: json["etd_hours"] == null ? null : json["etd_hours"],
        freightCharge: json["freight_charge"] == null
            ? null
            : json["freight_charge"].toDouble(),
        rate: json["rate"] == null ? null : json["rate"].toDouble(),
        rtoCharges:
            json["rto_charges"] == null ? null : json["rto_charges"].toDouble(),
        postcode: json["postcode"] == null ? null : json["postcode"],
        city: json["city"] == null ? null : json["city"],
        state: json["state"] == null ? null : json["state"],
        orderPaymentMode: json["order_payment_mode"] == null
            ? null
            : json["order_payment_mode"],
      );

  Map<String, dynamic> toJson() => {
        "courier_company_id":
            courierCompanyId == null ? null : courierCompanyId,
        "courier_name": courierName == null ? null : courierName,
        "estimated_delivery_days":
            estimatedDeliveryDays == null ? null : estimatedDeliveryDays,
        "etd": etd == null ? null : etd,
        "etd_hours": etdHours == null ? null : etdHours,
        "freight_charge": freightCharge == null ? null : freightCharge,
        "rate": rate == null ? null : rate,
        "rto_charges": rtoCharges == null ? null : rtoCharges,
        "postcode": postcode == null ? null : postcode,
        "city": city == null ? null : city,
        "state": state == null ? null : state,
        "order_payment_mode":
            orderPaymentMode == null ? null : orderPaymentMode,
      };
}
