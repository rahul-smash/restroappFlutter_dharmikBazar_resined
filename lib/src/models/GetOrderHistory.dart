class GetOrderHistory {
  bool success;
  List<OrderData> orders;
  GetOrderHistory();

  factory GetOrderHistory.fromJson(Map<String, dynamic> json) {
    GetOrderHistory history = GetOrderHistory();
    history.success = json["success"];
    history.orders = json["data"] == null
        ? []
        : List<OrderData>.from(json["data"].map((x) => OrderData.fromJson(x)));
    return history;
  }
}

class OrderData {
  String orderId;
  String displayOrderId;
  int paid;
  String runnerId;
  String paymentMethod;
  String note;
  String deliveryTimeSlot;
  String orderDate;
  String status;
  String total;
  String discount;
  String checkout;
  String orderFacility;
  String shippingCharges;
  String tax;
  List<Null> storeTaxRateDetail;
  List<Null> calculatedTaxDetail;
  List<Null> storeFixedTaxDetail;
  String address;
  List<OrderItems> orderItems;

  OrderData(
      {this.orderId,
      this.displayOrderId,
      this.paid,
      this.runnerId,
      this.paymentMethod,
      this.note,
      this.deliveryTimeSlot,
      this.orderDate,
      this.status,
      this.total,
      this.discount,
      this.checkout,
      this.orderFacility,
      this.shippingCharges,
      this.tax,
      this.storeTaxRateDetail,
      this.calculatedTaxDetail,
      this.storeFixedTaxDetail,
      this.address,
      this.orderItems});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    displayOrderId = json['display_order_id'];
    paid = json['paid'];
    runnerId = json['runner_id'];
    paymentMethod = json['payment_method'];
    note = json['note'];
    deliveryTimeSlot = json['delivery_time_slot'];
    orderDate = json['order_date'];
    status = json['status'];
    total = json['total'];
    discount = json['discount'];
    checkout = json['checkout'];
    orderFacility = json['order_facility'];
    shippingCharges = json['shipping_charges'];
    tax = json['tax'];
    address = json['address'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
  }
}

class OrderItems {
  String id;
  String storeId;
  String userId;
  String orderId;
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
  String unitType;
  String quantity;
  String comment;
  String isTaxEnable;
  String status;
  String subcategoryId;
  String subcategoryName;
  String categoryId;
  String productImage;
  String productBrand;
  List<Null> gst;

  OrderItems(
      {this.id,
      this.storeId,
      this.userId,
      this.orderId,
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
      this.unitType,
      this.quantity,
      this.comment,
      this.isTaxEnable,
      this.status,
      this.subcategoryId,
      this.subcategoryName,
      this.categoryId,
      this.productImage,
      this.productBrand,
      this.gst});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    deviceId = json['device_id'];
    deviceToken = json['device_token'];
    platform = json['platform'];
    productId = json['product_id'];
    productName = json['product_name'] ?? "";
    variantId = json['variant_id'];
    weight = json['weight'];
    mrpPrice = json['mrp_price'];
    price = json['price'];
    discount = json['discount'];
    unitType = json['unit_type'];
    quantity = json['quantity'];
    comment = json['comment'];
    isTaxEnable = json['isTaxEnable'];
    status = json['status'];
    subcategoryId = json['subcategory_id'];
    subcategoryName = json['subcategory_name'];
    categoryId = json['category_id'];
    productImage = json['product_image'];
    productBrand = json['product_brand'];
    if (json['gst'] != null) {
      gst = new List<Null>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;
    data['device_id'] = this.deviceId;
    data['device_token'] = this.deviceToken;
    data['platform'] = this.platform;
    data['product_id'] = this.productId;
    data['product_name'] = this.productName;
    data['variant_id'] = this.variantId;
    data['weight'] = this.weight;
    data['mrp_price'] = this.mrpPrice;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['unit_type'] = this.unitType;
    data['quantity'] = this.quantity;
    data['comment'] = this.comment;
    data['isTaxEnable'] = this.isTaxEnable;
    data['status'] = this.status;
    data['subcategory_id'] = this.subcategoryId;
    data['subcategory_name'] = this.subcategoryName;
    data['category_id'] = this.categoryId;
    data['product_image'] = this.productImage;
    data['product_brand'] = this.productBrand;
    return data;
  }
}
