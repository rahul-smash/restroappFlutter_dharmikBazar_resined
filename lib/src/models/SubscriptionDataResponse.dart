// To parse this JSON data, do
//
//     final subscriptionDataResponse = subscriptionDataResponseFromJson(jsonString);

import 'dart:convert';

class SubscriptionDataResponse {
  SubscriptionDataResponse({
    this.success,
    this.data,
  });

  bool success;
  List<SubscriptionOrderData> data;

  SubscriptionDataResponse copyWith({
    bool success,
    List<SubscriptionOrderData> data,
  }) =>
      SubscriptionDataResponse(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory SubscriptionDataResponse.fromRawJson(String str) => SubscriptionDataResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionDataResponse.fromJson(Map<String, dynamic> json) => SubscriptionDataResponse(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : List<SubscriptionOrderData>.from(json["data"].map((x) => SubscriptionOrderData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SubscriptionOrderData {
  SubscriptionOrderData({
    this.subscriptionOrderId,
    this.displaySubscriptionId,
    this.paid,
    this.paymentMethod,
    this.note,
    this.deliveryTimeSlot,
    this.orderDate,
    this.status,
    this.total,
    this.discount,
    this.cartSaving,
    this.checkout,
    this.orderFacility,
    this.startDate,
    this.endDate,
    this.totalDeliveries,
    this.pendingDeliveries,
    this.pausedDeliveries,
    this.shippingCharges,
    this.tax,
    this.walletRefund,
    this.orderRejectionNote,
    this.storeTaxRateDetail,
    this.calculatedTaxDetail,
    this.storeFixedTaxDetail,
    this.couponType,
    this.couponCode,
    this.address,
    this.image,
    this.subscriptionType,
    this.deliveryAddress,
    this.orderItems,
  });

  String subscriptionOrderId;
  String displaySubscriptionId;
  int paid;
  String paymentMethod;
  String note;
  String deliveryTimeSlot;
  String orderDate;
  String status;
  String total;
  String discount;
  String cartSaving;
  String checkout;
  String orderFacility;
  DateTime startDate;
  DateTime endDate;
  String totalDeliveries;
  String pendingDeliveries;
  String pausedDeliveries;
  String shippingCharges;
  String tax;
  String walletRefund;
  String orderRejectionNote;
  List<StoreTaxRateDetail> storeTaxRateDetail;
  List<dynamic> calculatedTaxDetail;
  List<dynamic> storeFixedTaxDetail;
  String couponType;
  String couponCode;
  String address;
  String subscriptionType;
  String image;
  List<DeliveryAddress> deliveryAddress;
  List<OrderItem> orderItems;

  SubscriptionOrderData copyWith({
    String subscriptionOrderId,
    String displaySubscriptionId,
    int paid,
    String paymentMethod,
    String note,
    String deliveryTimeSlot,
    String orderDate,
    String status,
    String total,
    String discount,
    String cartSaving,
    String checkout,
    String orderFacility,
    DateTime startDate,
    DateTime endDate,
    String totalDeliveries,
    String pendingDeliveries,
    String pausedDeliveries,
    String shippingCharges,
    String tax,
    String walletRefund,
    String orderRejectionNote,
    List<StoreTaxRateDetail> storeTaxRateDetail,
    List<dynamic> calculatedTaxDetail,
    List<dynamic> storeFixedTaxDetail,
    String couponType,
    String couponCode,
    String address,
    String subscriptionType,
    String image,
    List<DeliveryAddress> deliveryAddress,
    List<OrderItem> orderItems,
  }) =>
      SubscriptionOrderData(
        subscriptionOrderId: subscriptionOrderId ?? this.subscriptionOrderId,
        displaySubscriptionId: displaySubscriptionId ?? this.displaySubscriptionId,
        paid: paid ?? this.paid,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        note: note ?? this.note,
        deliveryTimeSlot: deliveryTimeSlot ?? this.deliveryTimeSlot,
        orderDate: orderDate ?? this.orderDate,
        status: status ?? this.status,
        total: total ?? this.total,
        discount: discount ?? this.discount,
        cartSaving: cartSaving ?? this.cartSaving,
        checkout: checkout ?? this.checkout,
        orderFacility: orderFacility ?? this.orderFacility,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        totalDeliveries: totalDeliveries ?? this.totalDeliveries,
        pendingDeliveries: pendingDeliveries ?? this.pendingDeliveries,
        pausedDeliveries: pausedDeliveries ?? this.pausedDeliveries,
        shippingCharges: shippingCharges ?? this.shippingCharges,
        tax: tax ?? this.tax,
        walletRefund: walletRefund ?? this.walletRefund,
        orderRejectionNote: orderRejectionNote ?? this.orderRejectionNote,
        storeTaxRateDetail: storeTaxRateDetail ?? this.storeTaxRateDetail,
        calculatedTaxDetail: calculatedTaxDetail ?? this.calculatedTaxDetail,
        storeFixedTaxDetail: storeFixedTaxDetail ?? this.storeFixedTaxDetail,
        couponType: couponType ?? this.couponType,
        couponCode: couponCode ?? this.couponCode,
        address: address ?? this.address,
        image: image ?? this.image,
        subscriptionType: subscriptionType ?? this.subscriptionType,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        orderItems: orderItems ?? this.orderItems,
      );

  factory SubscriptionOrderData.fromRawJson(String str) => SubscriptionOrderData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SubscriptionOrderData.fromJson(Map<String, dynamic> json) => SubscriptionOrderData(
    subscriptionOrderId: json["subscription_order_id"] == null ? null : json["subscription_order_id"],
    displaySubscriptionId: json["display_subscription_id"] == null ? null : json["display_subscription_id"],
    paid: json["paid"] == null ? null : json["paid"],
    paymentMethod: json["payment_method"] == null ? null : json["payment_method"],
    note: json["note"] == null ? null : json["note"],
    deliveryTimeSlot: json["delivery_time_slot"] == null ? null : json["delivery_time_slot"],
    orderDate: json["order_date"] == null ? null : json["order_date"],
    status: json["status"] == null ? null : json["status"],
    total: json["total"] == null ? null : json["total"],
    discount: json["discount"] == null ? null : json["discount"],
    cartSaving: json["cart_saving"] == null ? null : json["cart_saving"],
    checkout: json["checkout"] == null ? null : json["checkout"],
    orderFacility: json["order_facility"] == null ? null : json["order_facility"],
    startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
    endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
    totalDeliveries: json["total_deliveries"] == null ? null : json["total_deliveries"],
    pendingDeliveries: json["pending_deliveries"] == null ? null : json["pending_deliveries"],
    pausedDeliveries: json["paused_deliveries"] == null ? null : json["paused_deliveries"],
    shippingCharges: json["shipping_charges"] == null ? null : json["shipping_charges"],
    tax: json["tax"] == null ? null : json["tax"],
    walletRefund: json["wallet_refund"] == null ? null : json["wallet_refund"],
    orderRejectionNote: json["order_rejection_note"] == null ? null : json["order_rejection_note"],
    storeTaxRateDetail: json["store_tax_rate_detail"] == null ? null : List<StoreTaxRateDetail>.from(json["store_tax_rate_detail"].map((x) => StoreTaxRateDetail.fromJson(x))),
    calculatedTaxDetail: json["calculated_tax_detail"] == null ? null : List<dynamic>.from(json["calculated_tax_detail"].map((x) => x)),
    storeFixedTaxDetail: json["store_fixed_tax_detail"] == null ? null : List<dynamic>.from(json["store_fixed_tax_detail"].map((x) => x)),
    couponType: json["coupon_type"] == null ? null : json["coupon_type"],
    couponCode: json["coupon_code"] == null ? null : json["coupon_code"],
    address: json["address"] == null ? null : json["address"],
    image: json["image"] == null ? null : json["image"],
    subscriptionType: json["subscription_type"] == null ? null : json["subscription_type"],
    deliveryAddress: json["delivery_address"] == null ? null : List<DeliveryAddress>.from(json["delivery_address"].map((x) => DeliveryAddress.fromJson(x))),
    orderItems: json["order_items"] == null ? null : List<OrderItem>.from(json["order_items"].map((x) => OrderItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "subscription_order_id": subscriptionOrderId == null ? null : subscriptionOrderId,
    "display_subscription_id": displaySubscriptionId == null ? null : displaySubscriptionId,
    "paid": paid == null ? null : paid,
    "payment_method": paymentMethod == null ? null : paymentMethod,
    "note": note == null ? null : note,
    "delivery_time_slot": deliveryTimeSlot == null ? null : deliveryTimeSlot,
    "order_date": orderDate == null ? null : orderDate,
    "status": status == null ? null : status,
    "total": total == null ? null : total,
    "discount": discount == null ? null : discount,
    "cart_saving": cartSaving == null ? null : cartSaving,
    "checkout": checkout == null ? null : checkout,
    "order_facility": orderFacility == null ? null : orderFacility,
    "start_date": startDate == null ? null : "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
    "end_date": endDate == null ? null : "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
    "total_deliveries": totalDeliveries == null ? null : totalDeliveries,
    "pending_deliveries": pendingDeliveries == null ? null : pendingDeliveries,
    "paused_deliveries": pausedDeliveries == null ? null : pausedDeliveries,
    "shipping_charges": shippingCharges == null ? null : shippingCharges,
    "tax": tax == null ? null : tax,
    "wallet_refund": walletRefund == null ? null : walletRefund,
    "order_rejection_note": orderRejectionNote == null ? null : orderRejectionNote,
    "store_tax_rate_detail": storeTaxRateDetail == null ? null : List<dynamic>.from(storeTaxRateDetail.map((x) => x.toJson())),
    "calculated_tax_detail": calculatedTaxDetail == null ? null : List<dynamic>.from(calculatedTaxDetail.map((x) => x)),
    "store_fixed_tax_detail": storeFixedTaxDetail == null ? null : List<dynamic>.from(storeFixedTaxDetail.map((x) => x)),
    "coupon_type": couponType == null ? null : couponType,
    "coupon_code": couponCode == null ? null : couponCode,
    "address": address == null ? null : address,
    "image": image == null ? null : image,
    "subscription_type": subscriptionType == null ? null : subscriptionType,
    "delivery_address": deliveryAddress == null ? null : List<dynamic>.from(deliveryAddress.map((x) => x.toJson())),
    "order_items": orderItems == null ? null : List<dynamic>.from(orderItems.map((x) => x.toJson())),
  };
}

class DeliveryAddress {
  DeliveryAddress({
    this.id,
    this.userId,
    this.storeId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.address,
    this.address2,
    this.areaId,
    this.areaName,
    this.city,
    this.state,
    this.zipcode,
    this.country,
    this.lat,
    this.lng,
    this.created,
    this.modified,
    this.softdelete,
  });

  String id;
  String userId;
  String storeId;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String address;
  String address2;
  String areaId;
  String areaName;
  String city;
  String state;
  String zipcode;
  String country;
  String lat;
  String lng;
  DateTime created;
  DateTime modified;
  bool softdelete;

  DeliveryAddress copyWith({
    String id,
    String userId,
    String storeId,
    String firstName,
    String lastName,
    String mobile,
    String email,
    String address,
    String address2,
    String areaId,
    String areaName,
    String city,
    String state,
    String zipcode,
    String country,
    String lat,
    String lng,
    DateTime created,
    DateTime modified,
    bool softdelete,
  }) =>
      DeliveryAddress(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        storeId: storeId ?? this.storeId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        address: address ?? this.address,
        address2: address2 ?? this.address2,
        areaId: areaId ?? this.areaId,
        areaName: areaName ?? this.areaName,
        city: city ?? this.city,
        state: state ?? this.state,
        zipcode: zipcode ?? this.zipcode,
        country: country ?? this.country,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        created: created ?? this.created,
        modified: modified ?? this.modified,
        softdelete: softdelete ?? this.softdelete,
      );

  factory DeliveryAddress.fromRawJson(String str) => DeliveryAddress.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) => DeliveryAddress(
    id: json["id"] == null ? null : json["id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    storeId: json["store_id"] == null ? null : json["store_id"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    email: json["email"] == null ? null : json["email"],
    address: json["address"] == null ? null : json["address"],
    address2: json["address2"] == null ? null : json["address2"],
    areaId: json["area_id"] == null ? null : json["area_id"],
    areaName: json["area_name"] == null ? null : json["area_name"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
    zipcode: json["zipcode"] == null ? null : json["zipcode"],
    country: json["country"] == null ? null : json["country"],
    lat: json["lat"] == null ? null : json["lat"],
    lng: json["lng"] == null ? null : json["lng"],
    created: json["created"] == null ? null : DateTime.parse(json["created"]),
    modified: json["modified"] == null ? null : DateTime.parse(json["modified"]),
    softdelete: json["softdelete"] == null ? null : json["softdelete"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "user_id": userId == null ? null : userId,
    "store_id": storeId == null ? null : storeId,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "mobile": mobile == null ? null : mobile,
    "email": email == null ? null : email,
    "address": address == null ? null : address,
    "address2": address2 == null ? null : address2,
    "area_id": areaId == null ? null : areaId,
    "area_name": areaName == null ? null : areaName,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "zipcode": zipcode == null ? null : zipcode,
    "country": country == null ? null : country,
    "lat": lat == null ? null : lat,
    "lng": lng == null ? null : lng,
    "created": created == null ? null : created.toIso8601String(),
    "modified": modified == null ? null : modified.toIso8601String(),
    "softdelete": softdelete == null ? null : softdelete,
  };
}

class OrderItem {
  OrderItem({
    this.id,
    this.storeId,
    this.userId,
    this.subscriptionOrderId,
    this.deviceId,
    this.deviceToken,
    this.platform,
    this.productId,
    this.productName,
    this.variantId,
    this.weight,
    this.mrpPrice,
    this.price,
    this.discount,
    this.walletRefundAmount,
    this.refundStatus,
    this.unitType,
    this.quantity,
    this.comment,
    this.isTaxEnable,
    this.hsnCode,
    this.cgst,
    this.sgst,
    this.igst,
    this.gstType,
    this.gstTaxRate,
    this.gstState,
    this.status,
    this.subcategoryId,
    this.subcategoryName,
    this.categoryId,
    this.productImage,
    this.productBrand,
    this.gst,
    this.image,
  });

  String id;
  String storeId;
  String userId;
  String subscriptionOrderId;
  String deviceId;
  String deviceToken;
  String platform;
  String productId;
  String productName;
  String variantId;
  String weight;
  String mrpPrice;
  String price;
  String discount;
  String walletRefundAmount;
  String refundStatus;
  String unitType;
  String quantity;
  String comment;
  String isTaxEnable;
  String hsnCode;
  String cgst;
  String sgst;
  String igst;
  String gstType;
  String gstTaxRate;
  String gstState;
  String status;
  String subcategoryId;
  String subcategoryName;
  String categoryId;
  String productImage;
  String productBrand;
  String image;
  List<dynamic> gst;

  OrderItem copyWith({
    String id,
    String storeId,
    String userId,
    String subscriptionOrderId,
    String deviceId,
    String deviceToken,
    String platform,
    String productId,
    String productName,
    String variantId,
    String weight,
    String mrpPrice,
    String price,
    String discount,
    String walletRefundAmount,
    String refundStatus,
    String unitType,
    String quantity,
    String comment,
    String isTaxEnable,
    String hsnCode,
    String cgst,
    String sgst,
    String igst,
    String gstType,
    String gstTaxRate,
    String gstState,
    String status,
    String subcategoryId,
    String subcategoryName,
    String categoryId,
    String productImage,
    String productBrand,
    String image,
    List<dynamic> gst,
  }) =>
      OrderItem(
        id: id ?? this.id,
        storeId: storeId ?? this.storeId,
        userId: userId ?? this.userId,
        subscriptionOrderId: subscriptionOrderId ?? this.subscriptionOrderId,
        deviceId: deviceId ?? this.deviceId,
        deviceToken: deviceToken ?? this.deviceToken,
        platform: platform ?? this.platform,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        variantId: variantId ?? this.variantId,
        weight: weight ?? this.weight,
        mrpPrice: mrpPrice ?? this.mrpPrice,
        price: price ?? this.price,
        discount: discount ?? this.discount,
        walletRefundAmount: walletRefundAmount ?? this.walletRefundAmount,
        refundStatus: refundStatus ?? this.refundStatus,
        unitType: unitType ?? this.unitType,
        quantity: quantity ?? this.quantity,
        comment: comment ?? this.comment,
        isTaxEnable: isTaxEnable ?? this.isTaxEnable,
        hsnCode: hsnCode ?? this.hsnCode,
        cgst: cgst ?? this.cgst,
        sgst: sgst ?? this.sgst,
        igst: igst ?? this.igst,
        gstType: gstType ?? this.gstType,
        gstTaxRate: gstTaxRate ?? this.gstTaxRate,
        gstState: gstState ?? this.gstState,
        status: status ?? this.status,
        subcategoryId: subcategoryId ?? this.subcategoryId,
        subcategoryName: subcategoryName ?? this.subcategoryName,
        categoryId: categoryId ?? this.categoryId,
        productImage: productImage ?? this.productImage,
        productBrand: productBrand ?? this.productBrand,
        image: image ?? this.image,
        gst: gst ?? this.gst,
      );

  factory OrderItem.fromRawJson(String str) => OrderItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"] == null ? null : json["id"],
    storeId: json["store_id"] == null ? null : json["store_id"],
    userId: json["user_id"] == null ? null : json["user_id"],
    subscriptionOrderId: json["subscription_order_id"] == null ? null : json["subscription_order_id"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    deviceToken: json["device_token"] == null ? null : json["device_token"],
    platform: json["platform"] == null ? null : json["platform"],
    productId: json["product_id"] == null ? null : json["product_id"],
    productName: json["product_name"] == null ? null : json["product_name"],
    variantId: json["variant_id"] == null ? null : json["variant_id"],
    weight: json["weight"] == null ? null : json["weight"],
    mrpPrice: json["mrp_price"] == null ? null : json["mrp_price"],
    price: json["price"] == null ? null : json["price"],
    discount: json["discount"] == null ? null : json["discount"],
    walletRefundAmount: json["wallet_refund_amount"] == null ? null : json["wallet_refund_amount"],
    refundStatus: json["refund_status"] == null ? null : json["refund_status"],
    unitType: json["unit_type"] == null ? null : json["unit_type"],
    quantity: json["quantity"] == null ? null : json["quantity"],
    comment: json["comment"] == null ? null : json["comment"],
    isTaxEnable: json["isTaxEnable"] == null ? null : json["isTaxEnable"],
    hsnCode: json["hsn_code"] == null ? null : json["hsn_code"],
    cgst: json["cgst"] == null ? null : json["cgst"],
    sgst: json["sgst"] == null ? null : json["sgst"],
    igst: json["igst"] == null ? null : json["igst"],
    gstType: json["gst_type"] == null ? null : json["gst_type"],
    gstTaxRate: json["gst_tax_rate"] == null ? null : json["gst_tax_rate"],
    gstState: json["gst_state"] == null ? null : json["gst_state"],
    status: json["status"] == null ? null : json["status"],
    subcategoryId: json["subcategory_id"] == null ? null : json["subcategory_id"],
    subcategoryName: json["subcategory_name"] == null ? null : json["subcategory_name"],
    categoryId: json["category_id"] == null ? null : json["category_id"],
    productImage: json["product_image"] == null ? null : json["product_image"],
    productBrand: json["product_brand"] == null ? null : json["product_brand"],
    image: json["image"] == null ? null : json["image"],
    gst: json["gst"] == null ? null : List<dynamic>.from(json["gst"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "store_id": storeId == null ? null : storeId,
    "user_id": userId == null ? null : userId,
    "subscription_order_id": subscriptionOrderId == null ? null : subscriptionOrderId,
    "device_id": deviceId == null ? null : deviceId,
    "device_token": deviceToken == null ? null : deviceToken,
    "platform": platform == null ? null : platform,
    "product_id": productId == null ? null : productId,
    "product_name": productName == null ? null : productName,
    "variant_id": variantId == null ? null : variantId,
    "weight": weight == null ? null : weight,
    "mrp_price": mrpPrice == null ? null : mrpPrice,
    "price": price == null ? null : price,
    "discount": discount == null ? null : discount,
    "wallet_refund_amount": walletRefundAmount == null ? null : walletRefundAmount,
    "refund_status": refundStatus == null ? null : refundStatus,
    "unit_type": unitType == null ? null : unitType,
    "quantity": quantity == null ? null : quantity,
    "comment": comment == null ? null : comment,
    "isTaxEnable": isTaxEnable == null ? null : isTaxEnable,
    "hsn_code": hsnCode == null ? null : hsnCode,
    "cgst": cgst == null ? null : cgst,
    "sgst": sgst == null ? null : sgst,
    "igst": igst == null ? null : igst,
    "gst_type": gstType == null ? null : gstType,
    "gst_tax_rate": gstTaxRate == null ? null : gstTaxRate,
    "gst_state": gstState == null ? null : gstState,
    "status": status == null ? null : status,
    "subcategory_id": subcategoryId == null ? null : subcategoryId,
    "subcategory_name": subcategoryName == null ? null : subcategoryName,
    "category_id": categoryId == null ? null : categoryId,
    "product_image": productImage == null ? null : productImage,
    "product_brand": productBrand == null ? null : productBrand,
    "image": image == null ? null : image,
    "gst": gst == null ? null : List<dynamic>.from(gst.map((x) => x)),
  };
}

class StoreTaxRateDetail {
  StoreTaxRateDetail({
    this.label,
    this.rate,
  });

  String label;
  String rate;

  StoreTaxRateDetail copyWith({
    String label,
    String rate,
  }) =>
      StoreTaxRateDetail(
        label: label ?? this.label,
        rate: rate ?? this.rate,
      );

  factory StoreTaxRateDetail.fromRawJson(String str) => StoreTaxRateDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoreTaxRateDetail.fromJson(Map<String, dynamic> json) => StoreTaxRateDetail(
    label: json["label"] == null ? null : json["label"],
    rate: json["rate"] == null ? null : json["rate"],
  );

  Map<String, dynamic> toJson() => {
    "label": label == null ? null : label,
    "rate": rate == null ? null : rate,
  };
}
