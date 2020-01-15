import 'dart:convert';
GetOrderHistory registerUserFromJson(String str) => GetOrderHistory.fromJson(json.decode(str));

String getOrderHistoryUserToJson(GetOrderHistory data) => json.encode(data.toJson());

class GetOrderHistory {
  bool success;
  List<OrderData> dataItems;

  GetOrderHistory({this.success, this.dataItems});




  GetOrderHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      dataItems = new List<OrderData>();
      print('@@ModelClass----$dataItems');
      json['data'].forEach((v) {
        dataItems.add(new OrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.dataItems != null) {
      data['data'] = this.dataItems.map((v) => v.toJson()).toList();
    }
    return data;
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
   /* if (json['store_tax_rate_detail'] != null) {
      storeTaxRateDetail = new List<Null>();
      json['store_tax_rate_detail'].forEach((v) {
        storeTaxRateDetail.add(new Null.fromJson(v));
      });
    }
    if (json['calculated_tax_detail'] != null) {
      calculatedTaxDetail = new List<Null>();
      json['calculated_tax_detail'].forEach((v) {
        calculatedTaxDetail.add(new Null.fromJson(v));
      });
    }
    if (json['store_fixed_tax_detail'] != null) {
      storeFixedTaxDetail = new List<Null>();
      json['store_fixed_tax_detail'].forEach((v) {
        storeFixedTaxDetail.add(new Null.fromJson(v));
      });
    }*/
    address = json['address'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['display_order_id'] = this.displayOrderId;
    data['paid'] = this.paid;
    data['runner_id'] = this.runnerId;
    data['payment_method'] = this.paymentMethod;
    data['note'] = this.note;
    data['delivery_time_slot'] = this.deliveryTimeSlot;
    data['order_date'] = this.orderDate;
    data['status'] = this.status;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['checkout'] = this.checkout;
    data['order_facility'] = this.orderFacility;
    data['shipping_charges'] = this.shippingCharges;
    data['tax'] = this.tax;
   /* if (this.storeTaxRateDetail != null) {
      data['store_tax_rate_detail'] =
          this.storeTaxRateDetail.map((v) => v.toJson()).toList();
    }
    if (this.calculatedTaxDetail != null) {
      data['calculated_tax_detail'] =
          this.calculatedTaxDetail.map((v) => v.toJson()).toList();
    }
    if (this.storeFixedTaxDetail != null) {
      data['store_fixed_tax_detail'] =
          this.storeFixedTaxDetail.map((v) => v.toJson()).toList();
    }*/
    data['address'] = this.address;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
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
    productName = json['product_name'] ?? "";;
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
      /*json['gst'].forEach((v) {
        gst.add(new Null.fromJson(v));
      });*/
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
   /* if (this.gst != null) {
      data['gst'] = this.gst.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}





/*import 'dart:convert';



GetOrderHistory registerUserFromJson(String str) => GetOrderHistory.fromJson(json.decode(str));

String getOrderHistoryUserToJson(GetOrderHistory data) => json.encode(data.toJson());*//*




import 'dart:convert';

GetOrderHistory validateCouponsResponseFromJson(String str) => GetOrderHistory.fromJson(json.decode(str));

String validateCouponsResponseToJson(GetOrderHistory data) => json.encode(data.toJson());
class GetOrderHistory {
  bool success;
  List<OrderData> data;

  GetOrderHistory({this.success, this.data});

  GetOrderHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<OrderData>();
      json['data'].forEach((v) {
        data.add(new OrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
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
    if (json['store_tax_rate_detail'] != null) {
      storeTaxRateDetail = new List<Null>();
     */
/* json['store_tax_rate_detail'].forEach((v) {
        storeTaxRateDetail.add(new Null.fromJson(v));
      });*//*

    }
    if (json['calculated_tax_detail'] != null) {
      calculatedTaxDetail = new List<Null>();
     */
/* json['calculated_tax_detail'].forEach((v) {
        calculatedTaxDetail.add(new Null.fromJson(v));
      });*//*

    }
    if (json['store_fixed_tax_detail'] != null) {
      storeFixedTaxDetail = new List<Null>();
     */
/* json['store_fixed_tax_detail'].forEach((v) {
        storeFixedTaxDetail.add(new Null.fromJson(v));
      });*//*

    }
    address = json['address'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['display_order_id'] = this.displayOrderId;
    data['paid'] = this.paid;
    data['runner_id'] = this.runnerId;
    data['payment_method'] = this.paymentMethod;
    data['note'] = this.note;
    data['delivery_time_slot'] = this.deliveryTimeSlot;
    data['order_date'] = this.orderDate;
    data['status'] = this.status;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['checkout'] = this.checkout;
    data['order_facility'] = this.orderFacility;
    data['shipping_charges'] = this.shippingCharges;
    data['tax'] = this.tax;
    if (this.storeTaxRateDetail != null) {
    */
/*  data['store_tax_rate_detail'] =
          this.storeTaxRateDetail.map((v) => v.toJson()).toList();*//*

    }
    if (this.calculatedTaxDetail != null) {
     */
/* data['calculated_tax_detail'] =
          this.calculatedTaxDetail.map((v) => v.toJson()).toList();*//*

    }
    if (this.storeFixedTaxDetail != null) {
    */
/*  data['store_fixed_tax_detail'] =
          this.storeFixedTaxDetail.map((v) => v.toJson()).toList();*//*

    }
    data['address'] = this.address;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
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
    productName = json['product_name'];
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
      json['gst'].forEach((v) {
       // gst.add(new Null.fromJson(v));
      });
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
    if (this.gst != null) {
      //data['gst'] = this.gst.map((v) => v.toJson()).toList();
    }
    return data;
  }
}












*/
/*
class GetOrderHistory {
  bool success;
  List<OrderData> data;

  GetOrderHistory(
      {this.success, this.data});


  GetOrderHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<OrderData>();
      json['data'].forEach((v) {
        data.add(new OrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
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
*//*

*/
/*
  List<Null> storeTaxRateDetail;
  List<Null> calculatedTaxDetail;
  List<Null> storeFixedTaxDetail;
*//*
*/
/*

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
       *//*

*/
/* this.storeTaxRateDetail,
        this.calculatedTaxDetail,
        this.storeFixedTaxDetail,*//*
*/
/*

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
  *//*

*/
/*  if (json['store_tax_rate_detail'] != null) {
      storeTaxRateDetail = new List<Null>();
      json['store_tax_rate_detail'].forEach((v) {
      //  storeTaxRateDetail.add(new Null.fromJson(v));
      });
    }
    if (json['calculated_tax_detail'] != null) {
      calculatedTaxDetail = new List<Null>();
      json['calculated_tax_detail'].forEach((v) {
     //   calculatedTaxDetail.add(new Null.fromJson(v));
      });
    }
    if (json['store_fixed_tax_detail'] != null) {
      storeFixedTaxDetail = new List<Null>();
      json['store_fixed_tax_detail'].forEach((v) {
      //  storeFixedTaxDetail.add(new Null.fromJson(v));
      });
    }*//*
*/
/*

    address = json['address'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['display_order_id'] = this.displayOrderId;
    data['paid'] = this.paid;
    data['runner_id'] = this.runnerId;
    data['payment_method'] = this.paymentMethod;
    data['note'] = this.note;
    data['delivery_time_slot'] = this.deliveryTimeSlot;
    data['order_date'] = this.orderDate;
    data['status'] = this.status;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['checkout'] = this.checkout;
    data['order_facility'] = this.orderFacility;
    data['shipping_charges'] = this.shippingCharges;
    data['tax'] = this.tax;
   *//*

*/
/* if (this.storeTaxRateDetail != null) {
      *//*
*/
/*
*//*

*/
/*data['store_tax_rate_detail'] =
          this.storeTaxRateDetail.map((v) => v.toJson()).toList();*//*
*/
/*
*//*

*/
/*
    }
    if (this.calculatedTaxDetail != null) {
      *//*
*/
/*
*//*

*/
/*data['calculated_tax_detail'] =
          this.calculatedTaxDetail.map((v) => v.toJson()).toList();*//*
*/
/*
*//*

*/
/*
    }
    if (this.storeFixedTaxDetail != null) {
     *//*
*/
/*
*//*

*/
/* data['store_fixed_tax_detail'] =
          this.storeFixedTaxDetail.map((v) => v.toJson()).toList();*//*
*/
/*
*//*

*/
/*
    }*//*
*/
/*

    data['address'] = this.address;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
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
    productName = json['product_name'];
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
      json['gst'].forEach((v) {
       // gst.add(new Null.fromJson(v));
      });
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
    if (this.gst != null) {
  //    data['gst'] = this.gst.map((v) => v.toJson()).toList();
    }
    return data;
  }
}







*//*

*/
/*class GetOrderHistory {
  bool success;
  List<OrderHistoryData> data;

  GetOrderHistory({this.success, this.data});

  GetOrderHistory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<OrderHistoryData>();
      json['data'].forEach((v) {
        data.add(new OrderHistoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class OrderHistoryData {
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

  OrderHistoryData(
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

  OrderHistoryData.fromJson(Map<String, dynamic> json) {
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
    if (json['store_tax_rate_detail'] != null) {
      storeTaxRateDetail = new List<Null>();
      json['store_tax_rate_detail'].forEach((v) {
      //  storeTaxRateDetail.add(new Null.fromJson(v));
      });
    }
    if (json['calculated_tax_detail'] != null) {
      calculatedTaxDetail = new List<Null>();
      json['calculated_tax_detail'].forEach((v) {
       // calculatedTaxDetail.add(new Null.fromJson(v));
      });
    }
    if (json['store_fixed_tax_detail'] != null) {
      storeFixedTaxDetail = new List<Null>();
     *//*
*/
/*
*//*

*/
/* json['store_fixed_tax_detail'].forEach((v) {
        storeFixedTaxDetail.add(new Null.fromJson(v));
      });*//*
*/
/*
*//*

*/
/*
    }
    address = json['address'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['display_order_id'] = this.displayOrderId;
    data['paid'] = this.paid;
    data['runner_id'] = this.runnerId;
    data['payment_method'] = this.paymentMethod;
    data['note'] = this.note;
    data['delivery_time_slot'] = this.deliveryTimeSlot;
    data['order_date'] = this.orderDate;
    data['status'] = this.status;
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['checkout'] = this.checkout;
    data['order_facility'] = this.orderFacility;
    data['shipping_charges'] = this.shippingCharges;
    data['tax'] = this.tax;
    if (this.storeTaxRateDetail != null) {
     *//*
*/
/*
*//*

*/
/* data['store_tax_rate_detail'] =
          this.storeTaxRateDetail.map((v) => v.toJson()).toList();*//*
*/
/*
*//*

*/
/*
    }
    if (this.calculatedTaxDetail != null) {
     *//*
*/
/*
*//*

*/
/* data['calculated_tax_detail'] =
          this.calculatedTaxDetail.map((v) => v.toJson()).toList();*//*
*/
/*
*//*

*/
/*
    }
    if (this.storeFixedTaxDetail != null) {
     *//*
*/
/*
*//*

*/
/* data['store_fixed_tax_detail'] =
          this.storeFixedTaxDetail.map((v) => v.toJson()).toList();*//*
*/
/*
*//*

*/
/*
    }
    data['address'] = this.address;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
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
    productName = json['product_name'];
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
      json['gst'].forEach((v) {
      //  gst.add(new Null.fromJson(v));
      });
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
    if (this.gst != null) {
     // data['gst'] = this.gst.map((v) => v.toJson()).toList();
    }
    return data;
  }
}*//*


*/
