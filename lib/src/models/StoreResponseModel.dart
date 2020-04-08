class StoreResponse {
  bool success;
  StoreModel store;

  StoreResponse({
    this.success,
    this.store,
  });

  factory StoreResponse.fromJson(Map<String, dynamic> json) =>
      new StoreResponse(
        success: json["success"],
        store: StoreModel.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "store": store.toJson(),
      };
}

class StoreModel {
  String id;
  String storeName;
  String location;
  String city;
  String state;
  String lat;
  String lng;
  String contactNumber;
  String aboutUs;
  String androidShareLink;
  String storeLogo;
  List<Banner> banners;

  StoreModel({
    this.id,
    this.storeName,
    this.location,
    this.city,
    this.state,
    this.lat,
    this.lng,
    this.contactNumber,
    this.aboutUs,
    this.androidShareLink,
    this.storeLogo,
    this.banners,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => new StoreModel(
        id: json["id"],
        storeName: json["store_name"],
        location: json["location"],
        city: json["city"],
        state: json["state"],
        lat: json["lat"],
        lng: json["lng"],
        contactNumber: json["contact_number"],
        aboutUs: json["about_us"],
        androidShareLink: json["android_share_link"],
        storeLogo: json["store_logo"],
        banners: json["banners"] == null
            ? null
            : List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_name": storeName,
        "location": location,
        "city": city,
        "state": state,
        "lat": lat,
        "lng": lng,
        "contact_number": contactNumber,
        "about_us": aboutUs,
        "android_share_link": androidShareLink,
        "store_logo": storeLogo,
        "banners": new List<dynamic>.from(banners.map((x) => x.toJson())),
      };
}

class Banner {
  String id;
  String storeId;
  String link;
  String title;
  String categoryId;
  String subCategoryId;
  String productId;
  String offerId;
  String image;
  String linkTo;
  String pageId;
  bool status;

  Banner({
    this.id,
    this.storeId,
    this.link,
    this.title,
    this.categoryId,
    this.subCategoryId,
    this.productId,
    this.offerId,
    this.image,
    this.linkTo,
    this.pageId,
    this.status,
  });

  factory Banner.fromJson(Map<String, dynamic> json) => new Banner(
        id: json["id"],
        storeId: json["store_id"],
        link: json["link"],
        title: json["title"],
        categoryId: json["category_id"],
        subCategoryId: json["sub_category_id"],
        productId: json["product_id"],
        offerId: json["offer_id"],
        image: json["image"],
        linkTo: json["link_to"],
        pageId: json["page_id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_id": storeId,
        "link": link,
        "title": title,
        "category_id": categoryId,
        "sub_category_id": subCategoryId,
        "product_id": productId,
        "offer_id": offerId,
        "image": image,
        "link_to": linkTo,
        "page_id": pageId,
        "status": status,
      };
}
