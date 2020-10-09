// To parse this JSON data, do
//
//     final recommendedProductsResponse = recommendedProductsResponseFromJson(jsonString);

import 'dart:convert';

import 'SubCategoryResponse.dart';

class RecommendedProductsResponse {
  RecommendedProductsResponse({
    this.success,
    this.data,
  });

  bool success;
  List<Datum> data;

  RecommendedProductsResponse copyWith({
    bool success,
    List<Datum> data,
  }) =>
      RecommendedProductsResponse(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory RecommendedProductsResponse.fromRawJson(String str) => RecommendedProductsResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RecommendedProductsResponse.fromJson(Map<String, dynamic> json) => RecommendedProductsResponse(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.version,
    this.parentId,
    this.status,
    this.deleted,
    this.sort,
    this.parentCategory,
    this.image10080,
    this.image300200,
    this.image,
    this.products,
  });

  String id;
  String title;
  String version;
  String parentId;
  String status;
  bool deleted;
  String sort;
  String parentCategory;
  String image10080;
  String image300200;
  String image;
  List<Product> products;

  Datum copyWith({
    String id,
    String title,
    String version,
    String parentId,
    String status,
    bool deleted,
    String sort,
    String parentCategory,
    String image10080,
    String image300200,
    String image,
    List<Product> products,
  }) =>
      Datum(
        id: id ?? this.id,
        title: title ?? this.title,
        version: version ?? this.version,
        parentId: parentId ?? this.parentId,
        status: status ?? this.status,
        deleted: deleted ?? this.deleted,
        sort: sort ?? this.sort,
        parentCategory: parentCategory ?? this.parentCategory,
        image10080: image10080 ?? this.image10080,
        image300200: image300200 ?? this.image300200,
        image: image ?? this.image,
        products: products ?? this.products,
      );

  factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
    version: json["version"] == null ? null : json["version"],
    parentId: json["parent_id"] == null ? null : json["parent_id"],
    status: json["status"] == null ? null : json["status"],
    deleted: json["deleted"] == null ? null : json["deleted"],
    sort: json["sort"] == null ? null : json["sort"],
    parentCategory: json["parent_category"] == null ? null : json["parent_category"],
    image10080: json["image_100_80"] == null ? null : json["image_100_80"],
    image300200: json["image_300_200"] == null ? null : json["image_300_200"],
    image: json["image"] == null ? null : json["image"],
    products: json["products"] == null ? null : List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "title": title == null ? null : title,
    "version": version == null ? null : version,
    "parent_id": parentId == null ? null : parentId,
    "status": status == null ? null : status,
    "deleted": deleted == null ? null : deleted,
    "sort": sort == null ? null : sort,
    "parent_category": parentCategory == null ? null : parentCategory,
    "image_100_80": image10080 == null ? null : image10080,
    "image_300_200": image300200 == null ? null : image300200,
    "image": image == null ? null : image,
    "products": products == null ? null : List<dynamic>.from(products.map((x) => x.toJson())),
  };
}

enum GstTaxType { INCLUSIVE }

final gstTaxTypeValues = EnumValues({
  "inclusive": GstTaxType.INCLUSIVE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
