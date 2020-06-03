
class CategoryResponse {
  bool success;
  List<CategoryModel> categories;

  CategoryResponse({
    this.success,
    this.categories,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) => new CategoryResponse(
    success: json["success"],
    categories: new List<CategoryModel>.from(json["data"].map((x) => CategoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": new List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class CategoryModel {
  String id;
  String version;
  String title;
  String image300200;
  List<SubCategory> subCategory;

  CategoryModel({
    this.id,
    this.title,
    this.version,
    this.image300200,
    this.subCategory,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => new CategoryModel(
    id: json["id"],
    title: json["title"],
    version: json["version"],
    image300200: json["image_300_200"],
    subCategory: new List<SubCategory>.from(json["sub_category"].map((x) => SubCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "version": version,
    "image_300_200": image300200,
    "sub_category": new List<dynamic>.from(subCategory.map((x) => x.toJson())),
  };

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["title"] = title;
    map["version"] = version;
    map["image_300_200"] = image300200;
    List jsonList = SubCategory.encodeToJson(subCategory);
    map["sub_category"] = jsonList.toString();
    return map;
  }
}

class SubCategory {
  String id;
  String title;
  String version;

  SubCategory({
    this.id,
    this.title,
    this.version,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => new SubCategory(
    id: json["id"],
    title: json["title"],
    version: json["version"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "version": version,
  };

  Map<String, dynamic> toMap(String parentId) {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["parent_id"] = parentId;
    map["title"] = title;
    map["version"] = version;
    return map;
  }

  static List encodeToJson(List<SubCategory>list){
    List jsonList = List();
    list.map((item)=>
        jsonList.add(item.toJson())
    ).toList();
    return jsonList;
  }
}
