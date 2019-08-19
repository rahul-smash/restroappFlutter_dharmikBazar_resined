// To parse this JSON data, do
//
//     final subCategories = subCategoriesFromJson(jsonString);

import 'dart:convert';

SubCategories subCategoriesFromJson(String str) => SubCategories.fromJson(json.decode(str));

String subCategoriesToJson(SubCategories data) => json.encode(data.toJson());

class SubCategories {
  bool success;
  List<SubCatData> data;

  SubCategories({
    this.success,
    this.data,
  });

  factory SubCategories.fromJson(Map<String, dynamic> json) => new SubCategories(
    success: json["success"],
    data: new List<SubCatData>.from(json["data"].map((x) => SubCatData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class SubCatData {
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

  SubCatData({
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

  factory SubCatData.fromJson(Map<String, dynamic> json) => new SubCatData(
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
  String isExportFromFile;
  bool deleted;
  String image10080;
  String image300200;
  List<Variant> variants;
  SelectedVariant selectedVariant;
  int mCounter = 0;

  Product({
    this.id,
    this.storeId,
    this.categoryIds,
    this.title,
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
    this.isExportFromFile,
    this.deleted,
    this.image10080,
    this.image300200,
    this.variants,
    this.selectedVariant,
    this.mCounter,
  });

  factory Product.fromJson(Map<String, dynamic> json) => new Product(
    id: json["id"],
    storeId: json["store_id"],
    categoryIds: json["category_ids"],
    title: json["title"],
    brand: json["brand"],
    nutrient: json["nutrient"],
    description: json["description"],
    image: json["image"],
    imageType: json["image_type"],
    imageUrl: json["image_url"],
    showPrice: json["show_price"],
    isTaxEnable: json["isTaxEnable"],
    gstTaxType: json["gst_tax_type"],
    gstTaxRate: json["gst_tax_rate"],
    status: json["status"],
    sort: json["sort"],
    isExportFromFile: json["is_export_from_file"],
    deleted: json["deleted"],
    image10080: json["image_100_80"],
    image300200: json["image_300_200"],
    variants: new List<Variant>.from(json["variants"].map((x) => Variant.fromJson(x))),
    selectedVariant: SelectedVariant.fromJson(json["selectedVariant"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
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
    "is_export_from_file": isExportFromFile,
    "deleted": deleted,
    "image_100_80": image10080,
    "image_300_200": image300200,
    "variants": new List<dynamic>.from(variants.map((x) => x.toJson())),
    "selectedVariant": selectedVariant.toJson(),
  };
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

  factory SelectedVariant.fromJson(Map<String, dynamic> json) => new SelectedVariant(
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

  factory Variant.fromJson(Map<String, dynamic> json) => new Variant(
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
