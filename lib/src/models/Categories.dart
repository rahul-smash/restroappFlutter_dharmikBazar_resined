import 'dart:convert';

Categories categoriesFromJson(String str) => Categories.fromJson(json.decode(str));

String categoriesToJson(Categories data) => json.encode(data.toJson());

class Categories {
  bool success;
  List<CategoriesData> data;

  Categories({
    this.success,
    this.data,
  });

  factory Categories.fromJson(Map<String, dynamic> json) => new Categories(
    success: json["success"],
    data: new List<CategoriesData>.from(json["data"].map((x) => CategoriesData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": new List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class CategoriesData {
  String id;
  String title;
  String version;
  String status;
  bool deleted;
  String showProductImage;
  String sort;
  String image10080;
  String image300200;
  String image;
  List<SubCategory> subCategory;

  CategoriesData({
    this.id,
    this.title,
    this.version,
    this.status,
    this.deleted,
    this.showProductImage,
    this.sort,
    this.image10080,
    this.image300200,
    this.image,
    this.subCategory,
  });

  factory CategoriesData.fromJson(Map<String, dynamic> json) => new CategoriesData(
    id: json["id"],
    title: json["title"],
    version: json["version"],
    status: json["status"],
    deleted: json["deleted"],
    showProductImage: json["show_product_image"],
    sort: json["sort"],
    image10080: json["image_100_80"],
    image300200: json["image_300_200"],
    image: json["image"],
    subCategory: new List<SubCategory>.from(json["sub_category"].map((x) => SubCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "version": version,
    "status": status,
    "deleted": deleted,
    "show_product_image": showProductImage,
    "sort": sort,
    "image_100_80": image10080,
    "image_300_200": image300200,
    "image": image,
    "sub_category": new List<dynamic>.from(subCategory.map((x) => x.toJson())),
  };
}

class SubCategory {
  String id;
  String title;
  String version;
  String status;
  bool deleted;
  String sort;

  SubCategory({
    this.id,
    this.title,
    this.version,
    this.status,
    this.deleted,
    this.sort,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => new SubCategory(
    id: json["id"],
    title: json["title"],
    version: json["version"],
    status: json["status"],
    deleted: json["deleted"],
    sort: json["sort"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "version": version,
    "status": status,
    "deleted": deleted,
    "sort": sort,
  };
}
