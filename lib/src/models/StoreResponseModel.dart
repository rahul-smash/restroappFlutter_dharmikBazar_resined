class StoreListResponse {
  bool success;
  List<StoreModel> stores;

  StoreListResponse({
    this.success,
    this.stores,
  });

  factory StoreListResponse.fromJson(Map<String, dynamic> json) =>
      new StoreListResponse(
        success: json["success"],
        stores: List<StoreModel>.from(
            json["data"].map((x) => StoreModel.fromJson(x))),
      );
}

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
  String country;
  String lat;
  String lng;
  String aboutUs;
  String androidShareLink;
  String storeLogo;
  List<Banner> banners;

  StoreModel({
    this.id,
    this.storeName,
    this.country,
    this.lat,
    this.lng,
    this.aboutUs,
    this.androidShareLink,
    this.storeLogo,
    this.banners,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) => new StoreModel(
        id: json["id"],
        storeName: json["store_name"],
        country: json["country"],
        lat: json["lat"],
        lng: json["lng"],
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
        "country": country,
        "lat": lat,
        "lng": lng,
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

class ForceDownload {
  String iosAppVersion;
  String androidAppVerison;
  String windowAppVersion;
  String forceDownload;
  String forceDownloadMessage;

  ForceDownload({
    this.iosAppVersion,
    this.androidAppVerison,
    this.windowAppVersion,
    this.forceDownload,
    this.forceDownloadMessage,
  });

  factory ForceDownload.fromJson(Map<String, dynamic> json) =>
      new ForceDownload(
        iosAppVersion: json["ios_app_version"],
        androidAppVerison: json["android_app_verison"],
        windowAppVersion: json["window_app_version"],
        forceDownload: json["force_download"],
        forceDownloadMessage: json["force_download_message"],
      );

  Map<String, dynamic> toJson() => {
        "ios_app_version": iosAppVersion,
        "android_app_verison": androidAppVerison,
        "window_app_version": windowAppVersion,
        "force_download": forceDownload,
        "force_download_message": forceDownloadMessage,
      };
}

class Geofencing {
  String id;
  String message;
  String lat;
  String lng;
  String radius;
  String status;

  Geofencing({
    this.id,
    this.message,
    this.lat,
    this.lng,
    this.radius,
    this.status,
  });

  factory Geofencing.fromJson(Map<String, dynamic> json) => new Geofencing(
        id: json["id"],
        message: json["message"],
        lat: json["lat"],
        lng: json["lng"],
        radius: json["radius"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "lat": lat,
        "lng": lng,
        "radius": radius,
        "status": status,
      };
}
