import 'dart:convert';

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
  String cartSaving;
  String couponType;
  String couponCode;
  List<Null> storeTaxRateDetail;
  List<Null> calculatedTaxDetail;
  List<Null> storeFixedTaxDetail;
  String address;
  List<OrderItems> orderItems;
  List<DeliveryAddress> deliveryAddress;
  String rating;

  OrderData({
    this.orderId,
    this.displayOrderId,
    this.paid,
    this.runnerId,
    this.paymentMethod,
    this.note,
    this.deliveryTimeSlot,
    this.orderDate,
    this.status,
    this.rating,
    this.total,
    this.discount,
    this.checkout,
    this.orderFacility,
    this.shippingCharges,
    this.tax,
    this.cartSaving,
    this.couponType,
    this.couponCode,
    this.storeTaxRateDetail,
    this.calculatedTaxDetail,
    this.storeFixedTaxDetail,
    this.address,
    this.orderItems,
    this.deliveryAddress,
  });

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
    cartSaving = json['cart_saving'];
    couponType = json['coupon_type'];
    couponCode = json['coupon_code'];
    rating = json['rating'];
    address = json['address'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
    if (json['delivery_address'] != null) {
      deliveryAddress = new List<DeliveryAddress>();
      json['delivery_address'].forEach((v) {
        deliveryAddress.add(new DeliveryAddress.fromJson(v));
      });
    }
  }
}

class DeliveryAddress {
  String id;
  String userId;
  String storeId;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String address;
  String areaId;
  String areaName;
  String city;
  String state;
  String zipcode;
  String country;
  String lat;
  String lng;
  String created;
  String modified;
  bool softdelete;

  DeliveryAddress(
      {this.id,
      this.userId,
      this.storeId,
      this.firstName,
      this.lastName,
      this.mobile,
      this.email,
      this.address,
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
      this.softdelete});

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    storeId = json['store_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    mobile = json['mobile'];
    email = json['email'];
    address = json['address'];
    areaId = json['area_id'];
    areaName = json['area_name'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    country = json['country'];
    lat = json['lat'];
    lng = json['lng'];
    created = json['created'];
    modified = json['modified'];
    softdelete = json['softdelete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['store_id'] = this.storeId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['address'] = this.address;
    data['area_id'] = this.areaId;
    data['area_name'] = this.areaName;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zipcode'] = this.zipcode;
    data['country'] = this.country;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['softdelete'] = this.softdelete;
    return data;
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
  List<Review> review;

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
    review = json["review"] == null
        ? null
        : List<Review>.from(json["review"].map((x) => Review.fromJson(x)));
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
    data["review"] = review == null
        ? null
        : List<dynamic>.from(review.map((x) => x.toJson()));
    return data;
  }
}

class Review {
  Review({
    this.id,
    this.storeId,
    this.userId,
    this.title,
    this.description,
    this.productId,
    this.rating,
    this.image,
    this.orderId,
    this.platform,
    this.created,
    this.modified,
  });

  String id;
  String storeId;
  String userId;
  String title;
  String description;
  String productId;
  String rating;
  String image;
  String orderId;
  String platform;
  DateTime created;
  DateTime modified;

  Review copyWith({
    String id,
    String storeId,
    String userId,
    String title,
    String description,
    String productId,
    String rating,
    String image,
    String orderId,
    String platform,
    DateTime created,
    DateTime modified,
  }) =>
      Review(
        id: id ?? this.id,
        storeId: storeId ?? this.storeId,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        description: description ?? this.description,
        productId: productId ?? this.productId,
        rating: rating ?? this.rating,
        image: image ?? this.image,
        orderId: orderId ?? this.orderId,
        platform: platform ?? this.platform,
        created: created ?? this.created,
        modified: modified ?? this.modified,
      );

  factory Review.fromRawJson(String str) => Review.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"] == null ? null : json["id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        userId: json["user_id"] == null ? null : json["user_id"],
        title: json["title"] == null ? null : json["title"],
        description: json["description"] == null ? null : json["description"],
        productId: json["product_id"] == null ? null : json["product_id"],
        rating: json["rating"] == null ? null : json["rating"],
        image: json["image"] == null ? null : json["image"],
        orderId: json["order_id"] == null ? null : json["order_id"],
        platform: json["platform"] == null ? null : json["platform"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "store_id": storeId == null ? null : storeId,
        "user_id": userId == null ? null : userId,
        "title": title == null ? null : title,
        "description": description == null ? null : description,
        "product_id": productId == null ? null : productId,
        "rating": rating == null ? null : rating,
        "image": image == null ? null : image,
        "order_id": orderId == null ? null : orderId,
        "platform": platform == null ? null : platform,
        "created": created == null ? null : created.toIso8601String(),
        "modified": modified == null ? null : modified.toIso8601String(),
      };
}
