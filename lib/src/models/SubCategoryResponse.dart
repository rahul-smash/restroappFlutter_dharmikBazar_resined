import 'dart:convert';

class SubCategoryResponse {
  bool success;
  List<SubCategoryModel> subCategories;

  SubCategoryResponse({
    this.success,
    this.subCategories,
  });

  factory SubCategoryResponse.fromJson(Map<String, dynamic> json) =>
      new SubCategoryResponse(
        success: json["success"],
        subCategories: new List<SubCategoryModel>.from(
            json["data"].map((x) => SubCategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": new List<dynamic>.from(subCategories.map((x) => x.toJson())),
      };
}

class SubCategoryModel {
  String id;
  String title;
  String version;
  String parentId;
  String status;
  bool deleted;
  String sort;
  String image10080;
  String image300200;
  String image;
  List<Product> products;


  SubCategoryModel({
    this.id,
    this.title,
    this.version,
    this.parentId,
    this.status,
    this.deleted,
    this.sort,
    this.image10080,
    this.image300200,
    this.image,
    this.products,

  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      new SubCategoryModel(
        id: json["id"],
        title: json["title"],
        version: json["version"],
        parentId: json["parent_id"],
        status: json["status"],
        deleted: json["deleted"],
        sort: json["sort"],
        image10080: json["image_100_80"],
        image300200: json["image_300_200"],
        image: json["image"],
        products: new List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "version": version,
        "parent_id": parentId,
        "status": status,
        "deleted": deleted,
        "sort": sort,
        "image_100_80": image10080,
        "image_300_200": image300200,
        "image": image,
        "products": new List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class Product {
  String id;
  String storeId;
  String categoryIds;
  String title;
  String isFav;
  String brand;
  String nutrient;
  String description;
  String image;
  String imageType;
  String imageUrl;
  String showPrice;
  String isTaxEnable;
  String gstTaxType;
  String gstTaxRate;
  String status;
  String sort;
  bool deleted;
  String image10080;
  String image300200;

  List<Variant> variants;
  SelectedVariant selectedVariant;

  String variantId;
  String weight;
  String mrpPrice;
  String price;
  String discount;
  String isUnitType;

  String quantity;


  Product({
    this.id,
    this.storeId,
    this.categoryIds,
    this.title,
    this.isFav,
    this.brand,
    this.nutrient,
    this.description,
    this.image,
    this.imageType,
    this.imageUrl,
    this.showPrice,
    this.isTaxEnable,
    this.gstTaxType,
    this.gstTaxRate,
    this.status,
    this.sort,
    this.deleted,
    this.image10080,
    this.image300200,
    this.variantId,
    this.weight,
    this.mrpPrice,
    this.price,
    this.discount,
    this.isUnitType,
    this.variants,
    this.selectedVariant,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    Product product = Product();
    product.id = json["id"];
    product.isFav = json["fav"];
    product.storeId = json["store_id"];
    product.categoryIds = json["category_ids"];
    product.title = json["title"];
    product.brand = json["brand"];
    product.nutrient = json["nutrient"];
    product.description = json["description"];
    product.image = json["image"];
    product.imageType = json["image_type"];
    product.imageUrl = json["image_url"] ?? "";
    product.showPrice = json["show_price"];
    product.isTaxEnable = json["isTaxEnable"];
    product.gstTaxType = json["gst_tax_type"];
    product.gstTaxRate = json["gst_tax_rate"];
    product.status = json["status"];
    product.sort = json["sort"];
    product.deleted = json["deleted"];
    product.image10080 = json["image_100_80"] ?? "";
    product.image300200 = json["image_300_200"] ?? "";

    product.variants = List<Variant>.from(json["variants"].map((x) => Variant.fromJson(x)));
    product.selectedVariant = SelectedVariant.fromJson(json["selectedVariant"]);

    dynamic variant = json["variants"] != null ? json["variants"].length > 0 ? json["variants"].first : null: null;
    product.variantId = variant == null ? null : variant["id"];
    product.weight = variant == null ? null : variant["weight"];
    product.mrpPrice = variant == null ? null : variant["mrp_price"];
    product.price = variant == null ? null : variant["price"];
    product.discount = variant == null ? null : variant["discount"];
    product.isUnitType = variant == null ? null : variant["unit_type"];
    return product;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "isFav": isFav,
        "store_id": storeId,
        "category_ids": categoryIds,
        "title": title,
        "brand": brand,
        "nutrient": nutrient,
        "description": description,
        "image": image,
        "image_type": imageType,
        "image_url": imageUrl,
        "show_price": showPrice,
        "isTaxEnable": isTaxEnable,
        "gst_tax_type": gstTaxType,
        "gst_tax_rate": gstTaxRate,
        "status": status,
        "sort": sort,
        "deleted": deleted,
        "image_100_80": image10080,
        "image_300_200": image300200,
        "variants": List<dynamic>.from(variants.map((x) => x.toJson())),
        "selectedVariant": selectedVariant.toJson(),
      };

  static List encodeToJson(List<Product> list) {
    List jsonList = List();
    list
        .map((item) => jsonList.add({
              "product_id": item.id,
              "product_name": item.title,
              "variant_id": item.variantId,
              "isTaxEnable": item.isTaxEnable,
              "quantity": item.quantity,
              "price": item.price,
              "weight": item.weight,
              "mrp_price": item.mrpPrice,
              "unit_type": item.isUnitType,
            }))
        .toList();
    return jsonList;
  }
}


class SelectedVariant {
  String variantId;
  String sku;
  String weight;
  String mrpPrice;
  String price;
  String discount;
  String unitType;
  String quantity;
  String customField1;
  String customField2;
  String customField3;
  String customField4;

  SelectedVariant({
    this.variantId,
    this.sku,
    this.weight,
    this.mrpPrice,
    this.price,
    this.discount,
    this.unitType,
    this.quantity,
    this.customField1,
    this.customField2,
    this.customField3,
    this.customField4,
  });

  factory SelectedVariant.fromJson(Map<String, dynamic> json) => SelectedVariant(
    variantId: json["variant_id"],
    sku: json["sku"],
    weight: json["weight"],
    mrpPrice: json["mrp_price"],
    price: json["price"],
    discount: json["discount"],
    unitType: json["unit_type"],
    quantity: json["quantity"],
    customField1: json["custom_field1"],
    customField2: json["custom_field2"],
    customField3: json["custom_field3"],
    customField4: json["custom_field4"],
  );

  Map<String, dynamic> toJson() => {
    "variant_id": variantId,
    "sku": sku,
    "weight": weight,
    "mrp_price": mrpPrice,
    "price": price,
    "discount": discount,
    "unit_type": unitType,
    "quantity": quantity,
    "custom_field1": customField1,
    "custom_field2": customField2,
    "custom_field3": customField3,
    "custom_field4": customField4,
  };
}

class Variant {
  String id;
  String storeId;
  String productId;
  String sku;
  String weight;
  String mrpPrice;
  String price;
  String discount;
  String unitType;
  String customField1;
  String customField2;
  String customField3;
  String customField4;
  String orderBy;
  String sort;
  String isExportFromFile;

  Variant({
    this.id,
    this.storeId,
    this.productId,
    this.sku,
    this.weight,
    this.mrpPrice,
    this.price,
    this.discount,
    this.unitType,
    this.customField1,
    this.customField2,
    this.customField3,
    this.customField4,
    this.orderBy,
    this.sort,
    this.isExportFromFile,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
    id: json["id"],
    storeId: json["store_id"],
    productId: json["product_id"],
    sku: json["sku"],
    weight: json["weight"],
    mrpPrice: json["mrp_price"],
    price: json["price"],
    discount: json["discount"],
    unitType: json["unit_type"],
    customField1: json["custom_field1"],
    customField2: json["custom_field2"],
    customField3: json["custom_field3"],
    customField4: json["custom_field4"],
    orderBy: json["order_by"],
    sort: json["sort"],
    isExportFromFile: json["is_export_from_file"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "store_id": storeId,
    "product_id": productId,
    "sku": sku,
    "weight": weight,
    "mrp_price": mrpPrice,
    "price": price,
    "discount": discount,
    "unit_type": unitType,
    "custom_field1": customField1,
    "custom_field2": customField2,
    "custom_field3": customField3,
    "custom_field4": customField4,
    "order_by": orderBy,
    "sort": sort,
    "is_export_from_file": isExportFromFile,
  };
}
