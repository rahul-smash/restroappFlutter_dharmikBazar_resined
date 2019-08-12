import 'dart:convert';

StoreData storeDataFromJson(String str) => StoreData.fromJson(json.decode(str));

String storeDataToJson(StoreData data) => json.encode(data.toJson());

class StoreData {
  bool success;
  Store store;

  StoreData({this.success,this.store,});

  factory StoreData.fromJson(Map<String, dynamic> json) => new StoreData(
    success: json["success"],
    store: Store.fromJson(json["store"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,"store": store.toJson(),
  };
}

class Store {
  String id;
  String storeName;
  String location;
  String city;
  String state;
  String country;
  String timezone;
  String zipcode;
  String lat;
  String lng;
  String contactPerson;
  String contactNumber;
  String contactEmail;
  String aboutUs;
  String otpSkip;
  String version;
  String currency;
  String showCurrency;
  String appShareLink;
  String androidShareLink;
  String iphoneShareLink;
  String theme;
  String webTheme;
  String type;
  String catType;
  String storeApp;
  String storeLogo;
  String favIcon;
  String bannerTime;
  String webCache;
  String currentGoldRate;
  String scoMetaTitle;
  String scoMetaDescription;
  String scoMetaKeywords;
  String planType;
  String currentPlanId;
  String updatedPlanType;
  String newPlanToBeUpdate;
  String laterUpdatePlanType;
  String paymentId;
  String payment;
  String laterUpdateDate;
  String modifiedPlanDate;
  String banner;
  String videoLink;
  String taxLabelName;
  String taxRate;
  String istaxenable;
  List<dynamic> taxDetail;
  List<dynamic> fixedTaxDetail;
  String storeStatus;
  String storeMsg;
  String masterCategory;
  String recommendedProducts;
  String deliverySlot;
  String storeGeofencing;
  String loyality;
  String onlinePayment;
  String pickupFacility;
  String deliveryFacility;
  String inStore;
  String internationalOtp;
  String multipleStore;
  String webMenuSetting;
  String mobileNotifications;
  String emailNotifications;
  String smsNotifications;
  String gst;
  String gaCode;
  String categoryLayout;
  String radiusIn;
  String productImage;
  String is24X7Open;
  String openhoursFrom;
  String openhoursTo;
  String closehoursMessage;
  String storeOpenDays;
  String androidAppShare;
  String iphoneAppShare;
  String windowAppShare;
  List<Banner> banners;
  List<ForceDownload> forceDownload;
  List<Geofencing> geofencing;
  String banner10080;
  String banner300200;
  String currencyAbbr;
  bool blDeviceIdUnique;
  bool isRefererFnEnable;

  Store({
    this.id,
    this.storeName,
    this.location,
    this.city,
    this.state,
    this.country,
    this.timezone,
    this.zipcode,
    this.lat,
    this.lng,
    this.contactPerson,
    this.contactNumber,
    this.contactEmail,
    this.aboutUs,
    this.otpSkip,
    this.version,
    this.currency,
    this.showCurrency,
    this.appShareLink,
    this.androidShareLink,
    this.iphoneShareLink,
    this.theme,
    this.webTheme,
    this.type,
    this.catType,
    this.storeApp,
    this.storeLogo,
    this.favIcon,
    this.bannerTime,
    this.webCache,
    this.currentGoldRate,
    this.scoMetaTitle,
    this.scoMetaDescription,
    this.scoMetaKeywords,
    this.planType,
    this.currentPlanId,
    this.updatedPlanType,
    this.newPlanToBeUpdate,
    this.laterUpdatePlanType,
    this.paymentId,
    this.payment,
    this.laterUpdateDate,
    this.modifiedPlanDate,
    this.banner,
    this.videoLink,
    this.taxLabelName,
    this.taxRate,
    this.istaxenable,
    this.taxDetail,
    this.fixedTaxDetail,
    this.storeStatus,
    this.storeMsg,
    this.masterCategory,
    this.recommendedProducts,
    this.deliverySlot,
    this.storeGeofencing,
    this.loyality,
    this.onlinePayment,
    this.pickupFacility,
    this.deliveryFacility,
    this.inStore,
    this.internationalOtp,
    this.multipleStore,
    this.webMenuSetting,
    this.mobileNotifications,
    this.emailNotifications,
    this.smsNotifications,
    this.gst,
    this.gaCode,
    this.categoryLayout,
    this.radiusIn,
    this.productImage,
    this.is24X7Open,
    this.openhoursFrom,
    this.openhoursTo,
    this.closehoursMessage,
    this.storeOpenDays,
    this.androidAppShare,
    this.iphoneAppShare,
    this.windowAppShare,
    this.banners,
    this.forceDownload,
    this.geofencing,
    this.banner10080,
    this.banner300200,
    this.currencyAbbr,
    this.blDeviceIdUnique,
    this.isRefererFnEnable,
  });

  factory Store.fromJson(Map<String, dynamic> json) => new Store(
    id: json["id"],
    storeName: json["store_name"],
    location: json["location"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    timezone: json["timezone"],
    zipcode: json["zipcode"],
    lat: json["lat"],
    lng: json["lng"],
    contactPerson: json["contact_person"],
    contactNumber: json["contact_number"],
    contactEmail: json["contact_email"],
    aboutUs: json["about_us"],
    otpSkip: json["otp_skip"],
    version: json["version"],
    currency: json["currency"],
    showCurrency: json["show_currency"],
    appShareLink: json["app_share_link"],
    androidShareLink: json["android_share_link"],
    iphoneShareLink: json["iphone_share_link"],
    theme: json["theme"],
    webTheme: json["web_theme"],
    type: json["type"],
    catType: json["cat_type"],
    storeApp: json["store_app"],
    storeLogo: json["store_logo"],
    favIcon: json["fav_icon"],
    bannerTime: json["banner_time"],
    webCache: json["web_cache"],
    currentGoldRate: json["current_gold_rate"],
    scoMetaTitle: json["sco_meta_title"],
    scoMetaDescription: json["sco_meta_description"],
    scoMetaKeywords: json["sco_meta_keywords"],
    planType: json["plan_type"],
    currentPlanId: json["current_plan_id"],
    updatedPlanType: json["updated_plan_type"],
    newPlanToBeUpdate: json["new_plan_to_be_update"],
    laterUpdatePlanType: json["later_update_plan_type"],
    paymentId: json["payment_id"],
    payment: json["payment"],
    laterUpdateDate: json["later_update_date"],
    modifiedPlanDate: json["modified_plan_date"],
    banner: json["banner"],
    videoLink: json["video_link"],
    taxLabelName: json["tax_label_name"],
    taxRate: json["tax_rate"],
    istaxenable: json["istaxenable"],
    taxDetail: new List<dynamic>.from(json["tax_detail"].map((x) => x)),
    fixedTaxDetail: new List<dynamic>.from(json["fixed_tax_detail"].map((x) => x)),
    storeStatus: json["store_status"],
    storeMsg: json["store_msg"],
    masterCategory: json["master_category"],
    recommendedProducts: json["recommended_products"],
    deliverySlot: json["delivery_slot"],
    storeGeofencing: json["geofencing"],
    loyality: json["loyality"],
    onlinePayment: json["online_payment"],
    pickupFacility: json["pickup_facility"],
    deliveryFacility: json["delivery_facility"],
    inStore: json["in_store"],
    internationalOtp: json["international_otp"],
    multipleStore: json["multiple_store"],
    webMenuSetting: json["web_menu_setting"],
    mobileNotifications: json["mobile_notifications"],
    emailNotifications: json["email_notifications"],
    smsNotifications: json["sms_notifications"],
    gst: json["gst"],
    gaCode: json["ga_code"],
    categoryLayout: json["category_layout"],
    radiusIn: json["radius_in"],
    productImage: json["product_image"],
    is24X7Open: json["is24x7_open"],
    openhoursFrom: json["openhours_from"],
    openhoursTo: json["openhours_to"],
    closehoursMessage: json["closehours_message"],
    storeOpenDays: json["store_open_days"],
    androidAppShare: json["android_app_share"],
    iphoneAppShare: json["iphone_app_share"],
    windowAppShare: json["window_app_share"],
    banners: new List<Banner>.from(json["banners"].map((x) => Banner.fromJson(x))),
    forceDownload: new List<ForceDownload>.from(json["force_download"].map((x) => ForceDownload.fromJson(x))),
    geofencing: new List<Geofencing>.from(json["Geofencing"].map((x) => Geofencing.fromJson(x))),
    banner10080: json["banner_100_80"],
    banner300200: json["banner_300_200"],
    currencyAbbr: json["currency_abbr"],
    blDeviceIdUnique: json["bl_device_id_unique"],
    isRefererFnEnable: json["is_referer_fn_enable"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "store_name": storeName,
    "location": location,
    "city": city,
    "state": state,
    "country": country,
    "timezone": timezone,
    "zipcode": zipcode,
    "lat": lat,
    "lng": lng,
    "contact_person": contactPerson,
    "contact_number": contactNumber,
    "contact_email": contactEmail,
    "about_us": aboutUs,
    "otp_skip": otpSkip,
    "version": version,
    "currency": currency,
    "show_currency": showCurrency,
    "app_share_link": appShareLink,
    "android_share_link": androidShareLink,
    "iphone_share_link": iphoneShareLink,
    "theme": theme,
    "web_theme": webTheme,
    "type": type,
    "cat_type": catType,
    "store_app": storeApp,
    "store_logo": storeLogo,
    "fav_icon": favIcon,
    "banner_time": bannerTime,
    "web_cache": webCache,
    "current_gold_rate": currentGoldRate,
    "sco_meta_title": scoMetaTitle,
    "sco_meta_description": scoMetaDescription,
    "sco_meta_keywords": scoMetaKeywords,
    "plan_type": planType,
    "current_plan_id": currentPlanId,
    "updated_plan_type": updatedPlanType,
    "new_plan_to_be_update": newPlanToBeUpdate,
    "later_update_plan_type": laterUpdatePlanType,
    "payment_id": paymentId,
    "payment": payment,
    "later_update_date": laterUpdateDate,
    "modified_plan_date": modifiedPlanDate,
    "banner": banner,
    "video_link": videoLink,
    "tax_label_name": taxLabelName,
    "tax_rate": taxRate,
    "istaxenable": istaxenable,
    "tax_detail": new List<dynamic>.from(taxDetail.map((x) => x)),
    "fixed_tax_detail": new List<dynamic>.from(fixedTaxDetail.map((x) => x)),
    "store_status": storeStatus,
    "store_msg": storeMsg,
    "master_category": masterCategory,
    "recommended_products": recommendedProducts,
    "delivery_slot": deliverySlot,
    "geofencing": storeGeofencing,
    "loyality": loyality,
    "online_payment": onlinePayment,
    "pickup_facility": pickupFacility,
    "delivery_facility": deliveryFacility,
    "in_store": inStore,
    "international_otp": internationalOtp,
    "multiple_store": multipleStore,
    "web_menu_setting": webMenuSetting,
    "mobile_notifications": mobileNotifications,
    "email_notifications": emailNotifications,
    "sms_notifications": smsNotifications,
    "gst": gst,
    "ga_code": gaCode,
    "category_layout": categoryLayout,
    "radius_in": radiusIn,
    "product_image": productImage,
    "is24x7_open": is24X7Open,
    "openhours_from": openhoursFrom,
    "openhours_to": openhoursTo,
    "closehours_message": closehoursMessage,
    "store_open_days": storeOpenDays,
    "android_app_share": androidAppShare,
    "iphone_app_share": iphoneAppShare,
    "window_app_share": windowAppShare,
    "banners": new List<dynamic>.from(banners.map((x) => x.toJson())),
    "force_download": new List<dynamic>.from(forceDownload.map((x) => x.toJson())),
    "Geofencing": new List<dynamic>.from(geofencing.map((x) => x.toJson())),
    "banner_100_80": banner10080,
    "banner_300_200": banner300200,
    "currency_abbr": currencyAbbr,
    "bl_device_id_unique": blDeviceIdUnique,
    "is_referer_fn_enable": isRefererFnEnable,
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

  factory ForceDownload.fromJson(Map<String, dynamic> json) => new ForceDownload(
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
