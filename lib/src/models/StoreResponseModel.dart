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
  String country;
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
  String currency_unicode;
  String appShareLink;
  String androidShareLink;
  String iphoneShareLink;
  String theme;
  String cod;
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
  String updatedPlanType;
  String newPlanToBeUpdate;
  String laterUpdatePlanType;
  String paymentId;
  String payment;
  String gstNo;
  String laterUpdateDate;
  String modifiedPlanDate;
  String banner;
  String videoLink;
  String taxLabelName;
  String taxRate;
  String istaxenable;
  List<Null> taxDetail;
  List<Null> fixedTaxDetail;
  String storeStatus;
  String storeMsg;
  String masterCategory;
  String recommendedProducts;
  String deliverySlot;
  String geofencing;
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
  String deliveryArea;
  String radiusIn;
  String productImage;
  List<Null> deliverySlots;
  String is24x7Open;
  String openhoursFrom;
  String openhoursTo;
  String closehoursMessage;
  String storeOpenDays;
  String timeZone;
  String androidAppShare;
  String iphoneAppShare;
  String windowAppShare;
  List<Banners> banners;
  List<Banner> aboutusBanner;
  List<ForceDownload> forceDownload;

/*  List<Geofencing> geofencing;*/
  List<AppLabels> appLabels;
  String banner10080;
  String banner300200;
  String currencyAbbr;
  bool blDeviceIdUnique;
  bool isRefererFnEnable;
  String paymentGateway;
  PaymentSetting paymentSetting;
  List<PaymentGatewaySettings> paymentGatewaySettings;
  AppThemeColors appThemeColors;

  //new keys added
  bool homePageTitleStatus;
  String homePageTitle;
  bool homePageSubtitleStatus;
  String homePageSubtitle;
  String homePageHeaderRight; //0=>Contact Number,1=>App Icon,2=>None
  String homePageDisplayNumber; //Dispaly Number On App Home Page
  String homePageDisplayNumberType; //0=>Whats app, 1=>Phone Call

  String domain;
  String poweredByText;
  String poweredByLink;
  String reviewRatingDisplay;

  StoreModel(
      {this.id,
      this.storeName,
      this.aboutusBanner,
      this.location,
      this.city,
      this.state,
      this.country,
      this.cod,
      this.zipcode,
      this.lat,
      this.lng,
      this.appThemeColors,
      this.contactPerson,
      this.contactNumber,
      this.contactEmail,
      this.aboutUs,
      this.otpSkip,
      this.version,
      this.currency,
      this.showCurrency,
      this.currency_unicode,
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
      this.updatedPlanType,
      this.newPlanToBeUpdate,
      this.laterUpdatePlanType,
      this.paymentId,
      this.payment,
      this.gstNo,
      this.laterUpdateDate,
      this.deliveryArea,
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
      this.geofencing,
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
      this.deliverySlots,
      this.is24x7Open,
      this.openhoursFrom,
      this.openhoursTo,
      this.closehoursMessage,
      this.storeOpenDays,
      this.timeZone,
      this.androidAppShare,
      this.iphoneAppShare,
      this.windowAppShare,
      this.banners,
      this.forceDownload,
      /* this.geofencing,*/
      this.appLabels,
      this.banner10080,
      this.banner300200,
      this.currencyAbbr,
      this.blDeviceIdUnique,
      this.paymentGateway,
      this.paymentSetting,
      this.paymentGatewaySettings,
      this.isRefererFnEnable,
      this.homePageTitleStatus,
        this.homePageTitle,
        this.homePageSubtitleStatus,
        this.homePageSubtitle,
        this.homePageHeaderRight,
        this.homePageDisplayNumber,
        this.homePageDisplayNumberType,this.domain,this.poweredByText,this.poweredByLink,this.reviewRatingDisplay});

  StoreModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeName = json['store_name'];
    aboutusBanner = json["aboutus_banner"] == null
        ? null
        : List<Banner>.from(
            json["aboutus_banner"].map((x) => Banner.fromJson(x)));
    location = json['location'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipcode = json['zipcode'];
    cod = json['cod'];
    lat = json['lat'];
    lng = json['lng'];
    contactPerson = json['contact_person'];
    contactNumber = json['contact_number'];
    contactEmail = json['contact_email'];
    aboutUs = json['about_us'];
    otpSkip = json['otp_skip'];
    version = json['version'];
    currency = json['currency'];
    showCurrency = json['show_currency'];
    currency_unicode = json['currency_unicode'];
    appShareLink = json['app_share_link'];
    androidShareLink = json['android_share_link'];
    iphoneShareLink = json['iphone_share_link'];
    theme = json['theme'];
    webTheme = json['web_theme'];
    type = json['type'];
    catType = json['cat_type'];
    storeApp = json['store_app'];
    storeLogo = json['store_logo'];
    favIcon = json['fav_icon'];
    bannerTime = json['banner_time'];
    webCache = json['web_cache'];
    currentGoldRate = json['current_gold_rate'];
    scoMetaTitle = json['sco_meta_title'];
    scoMetaDescription = json['sco_meta_description'];
    scoMetaKeywords = json['sco_meta_keywords'];
    planType = json['plan_type'];
    updatedPlanType = json['updated_plan_type'];
    newPlanToBeUpdate = json['new_plan_to_be_update'];
    laterUpdatePlanType = json['later_update_plan_type'];
    paymentId = json['payment_id'];
    payment = json['payment'];
    gstNo = json['gst_no'];
    laterUpdateDate = json['later_update_date'];
    modifiedPlanDate = json['modified_plan_date'];
    banner = json['banner'];
    videoLink = json['video_link'];
    taxLabelName = json['tax_label_name'];
    taxRate = json['tax_rate'];
    istaxenable = json['istaxenable'];
    paymentGateway = json["payment_gateway"];
    paymentSetting = PaymentSetting.fromJson(json["payment_setting"]);
    if (json['payment_gateway_settings'] != null) {
      if (json['payment_gateway_settings'] is String) {
        paymentGatewaySettings = null;
      } else {
        paymentGatewaySettings=
        json["payment_gateway_settings"] == null ? null : List<
            PaymentGatewaySettings>.from(
            json["payment_gateway_settings"].map((x) =>
                PaymentGatewaySettings.fromJson(x)));
//    paymentGatewaySettings = new List<PaymentGatewaySettings>();
//    json['payment_gateway_settings'].forEach((v) {
//    paymentGatewaySettings.add(new PaymentGatewaySettings.fromJson(v));
//    });
      }
    }
    appThemeColors = AppThemeColors.fromJson(json["app_theme_colors"]);
    /* if (json['tax_detail'] != null) {
      taxDetail = new List<Null>();
      json['tax_detail'].forEach((v) {
        taxDetail.add(new Null.fromJson(v));
      });
    }
    if (json['fixed_tax_detail'] != null) {
      fixedTaxDetail = new List<Null>();
      json['fixed_tax_detail'].forEach((v) {
        fixedTaxDetail.add(new Null.fromJson(v));
      });
    }*/
    storeStatus = json['store_status'];
    storeMsg = json['store_msg'];
    masterCategory = json['master_category'];
    recommendedProducts = json['recommended_products'];
    deliverySlot = json['delivery_slot'];
    geofencing = json['geofencing'];
    loyality = json['loyality'];
    onlinePayment = json['online_payment'];
    pickupFacility = json['pickup_facility'];
    deliveryFacility = json['delivery_facility'];
    inStore = json['in_store'];
    internationalOtp = json['international_otp'];
    multipleStore = json['multiple_store'];
    webMenuSetting = json['web_menu_setting'];
    mobileNotifications = json['mobile_notifications'];
    emailNotifications = json['email_notifications'];
    smsNotifications = json['sms_notifications'];
    gst = json['gst'];
    gaCode = json['ga_code'];
    categoryLayout = json['category_layout'];
    deliveryArea = json["delivery_area"];
    radiusIn = json['radius_in'];
    productImage = json['product_image'];
    /*  if (json['delivery_slots'] != null) {
      deliverySlots = new List<Null>();
      json['delivery_slots'].forEach((v) {
        deliverySlots.add(new Null.fromJson(v));
      });
    }*/
    is24x7Open = json['is24x7_open'];
    openhoursFrom = json['openhours_from'];
    openhoursTo = json['openhours_to'];
    closehoursMessage = json['closehours_message'];
    storeOpenDays = json['store_open_days'];
    timeZone = json['time_zone'];
    androidAppShare = json['android_app_share'];
    iphoneAppShare = json['iphone_app_share'];
    windowAppShare = json['window_app_share'];
    if (json['banners'] != null) {
      banners = new List<Banners>();
      json['banners'].forEach((v) {
        banners.add(new Banners.fromJson(v));
      });
    }
    if (json['force_download'] != null) {
      forceDownload = new List<ForceDownload>();
      json['force_download'].forEach((v) {
        forceDownload.add(new ForceDownload.fromJson(v));
      });
    }
    /* if (json['Geofencing'] != null) {
      geofencing = new List<Geofencing>();
      json['Geofencing'].forEach((v) {
        geofencing.add(new Geofencing.fromJson(v));
      });
    }*/
    if (json['app_labels'] != null) {
      appLabels = new List<AppLabels>();
      json['app_labels'].forEach((v) {
        appLabels.add(new AppLabels.fromJson(v));
      });
    }
    banner10080 = json['banner_100_80'];
    banner300200 = json['banner_300_200'];
    currencyAbbr = json['currency_abbr'];
    blDeviceIdUnique = json['bl_device_id_unique'];
    isRefererFnEnable = json['is_referer_fn_enable'];
    homePageTitleStatus = json['home_page_title_status'];
    homePageTitle = json['home_page_title'];
    homePageSubtitleStatus = json['home_page_subtitle_status'];
    homePageSubtitle = json['home_page_subtitle'];
    homePageHeaderRight = json['home_page_header_right'];
    homePageDisplayNumber = json['home_page_display_number'];
    homePageDisplayNumberType = json['home_page_display_number_type'];
    domain=json["domain"];
    poweredByText=json["powered_by_text"];
    poweredByLink=json["powered_by_link"];
    reviewRatingDisplay=json["review_rating_display"]==null?null:json["review_rating_display"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_name'] = this.storeName;
    data['cod'] = this.cod;
    data['location'] = this.location;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zipcode'] = this.zipcode;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['contact_person'] = this.contactPerson;
    data['contact_number'] = this.contactNumber;
    data['contact_email'] = this.contactEmail;
    data['about_us'] = this.aboutUs;
    data['otp_skip'] = this.otpSkip;
    data['app_theme_colors'] = this.appThemeColors;
    data['version'] = this.version;
    data['currency'] = this.currency;
    data['show_currency'] = this.showCurrency;
    data['currency_unicode'] = this.currency_unicode;
    data['app_share_link'] = this.appShareLink;
    data['android_share_link'] = this.androidShareLink;
    data['iphone_share_link'] = this.iphoneShareLink;
    data['theme'] = this.theme;
    data['web_theme'] = this.webTheme;
    data['aboutus_banner'] = this.aboutusBanner;
    data['type'] = this.type;
    data['cat_type'] = this.catType;
    data['store_app'] = this.storeApp;
    data['store_logo'] = this.storeLogo;
    data['fav_icon'] = this.favIcon;
    data['banner_time'] = this.bannerTime;
    data['web_cache'] = this.webCache;
    data['current_gold_rate'] = this.currentGoldRate;
    data['sco_meta_title'] = this.scoMetaTitle;
    data['sco_meta_description'] = this.scoMetaDescription;
    data['sco_meta_keywords'] = this.scoMetaKeywords;
    data['plan_type'] = this.planType;
    data['updated_plan_type'] = this.updatedPlanType;
    data['new_plan_to_be_update'] = this.newPlanToBeUpdate;
    data['later_update_plan_type'] = this.laterUpdatePlanType;
    data['payment_id'] = this.paymentId;
    data['payment'] = this.payment;
    data['gst_no'] = this.gstNo;
    data['later_update_date'] = this.laterUpdateDate;
    data['modified_plan_date'] = this.modifiedPlanDate;
    data['banner'] = this.banner;
    data['video_link'] = this.videoLink;
    data['tax_label_name'] = this.taxLabelName;
    data['tax_rate'] = this.taxRate;
    data['istaxenable'] = this.istaxenable;
    data['payment_gateway'] = this.paymentGateway;
    data['payment_setting'] = this.paymentSetting.toJson();
    if (this.paymentGatewaySettings != null) {
      data['payment_gateway_settings'] =
          this.paymentGatewaySettings.map((v) => v.toJson()).toList();
    }
    /*if (this.taxDetail != null) {
      data['tax_detail'] = this.taxDetail.map((v) => v.toJson()).toList();
    }
    if (this.fixedTaxDetail != null) {
      data['fixed_tax_detail'] =
          this.fixedTaxDetail.map((v) => v.toJson()).toList();
    }*/
    data['delivery_area'] = this.deliveryArea;
    data['store_status'] = this.storeStatus;
    data['store_msg'] = this.storeMsg;
    data['master_category'] = this.masterCategory;
    data['recommended_products'] = this.recommendedProducts;
    data['delivery_slot'] = this.deliverySlot;
    data['geofencing'] = this.geofencing;
    data['loyality'] = this.loyality;
    data['online_payment'] = this.onlinePayment;
    data['pickup_facility'] = this.pickupFacility;
    data['delivery_facility'] = this.deliveryFacility;
    data['in_store'] = this.inStore;
    data['international_otp'] = this.internationalOtp;
    data['multiple_store'] = this.multipleStore;
    data['web_menu_setting'] = this.webMenuSetting;
    data['mobile_notifications'] = this.mobileNotifications;
    data['email_notifications'] = this.emailNotifications;
    data['sms_notifications'] = this.smsNotifications;
    data['gst'] = this.gst;
    data['ga_code'] = this.gaCode;
    data['category_layout'] = this.categoryLayout;
    data['radius_in'] = this.radiusIn;
    data['product_image'] = this.productImage;
    /*  if (this.deliverySlots != null) {
      data['delivery_slots'] =
          this.deliverySlots.map((v) => v.toJson()).toList();
    }*/
    data['is24x7_open'] = this.is24x7Open;
    data['openhours_from'] = this.openhoursFrom;
    data['openhours_to'] = this.openhoursTo;
    data['closehours_message'] = this.closehoursMessage;
    data['store_open_days'] = this.storeOpenDays;
    data['time_zone'] = this.timeZone;
    data['android_app_share'] = this.androidAppShare;
    data['iphone_app_share'] = this.iphoneAppShare;
    data['window_app_share'] = this.windowAppShare;
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    if (this.forceDownload != null) {
      data['force_download'] =
          this.forceDownload.map((v) => v.toJson()).toList();
    }
    /* if (this.geofencing != null) {
      data['Geofencing'] = this.geofencing.map((v) => v.toJson()).toList();
    }*/
    if (this.appLabels != null) {
      data['app_labels'] = this.appLabels.map((v) => v.toJson()).toList();
    }
    data['banner_100_80'] = this.banner10080;
    data['banner_300_200'] = this.banner300200;
    data['currency_abbr'] = this.currencyAbbr;
    data['bl_device_id_unique'] = this.blDeviceIdUnique;
    data['is_referer_fn_enable'] = this.isRefererFnEnable;

    data['home_page_title_status'] = this.homePageTitleStatus;
    data['home_page_title'] = this.homePageTitle;
    data['home_page_subtitle_status'] = this.homePageSubtitleStatus;
    data['home_page_subtitle'] = this.homePageSubtitle;
    data['home_page_header_right'] = this.homePageHeaderRight;
    data['home_page_display_number'] = this.homePageDisplayNumber;
    data['home_page_display_number_type'] = this.homePageDisplayNumberType;
    data['domain']=this.domain;
    data['powered_by_text']=this.poweredByText;
    data['powered_by_link']=this.poweredByLink;
    data['review_rating_display']=this.reviewRatingDisplay;
    return data;
  }
}

class PaymentSetting {
  String apiKey;
  String secretKey;

  PaymentSetting({
    this.apiKey,
    this.secretKey,
  });

  factory PaymentSetting.fromJson(Map<String, dynamic> json) => PaymentSetting(
        apiKey: json["api_key"],
        secretKey: json["secret_key"],
      );

  Map<String, dynamic> toJson() => {
        "api_key": apiKey,
        "secret_key": secretKey,
      };
}

class PaymentGatewaySettings {
  String apiKey;
  String secretKey;
  String paymentGateway;

  PaymentGatewaySettings({this.apiKey, this.secretKey, this.paymentGateway});

  PaymentGatewaySettings.fromJson(Map<String, dynamic> json) {
    apiKey = json['api_key'];
    secretKey = json['secret_key'];
    paymentGateway = json['payment_gateway'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['api_key'] = this.apiKey;
    data['secret_key'] = this.secretKey;
    data['payment_gateway'] = this.paymentGateway;
    return data;
  }
}


class AppThemeColors {
  String id;
  String appThemeColor;
  String leftMenuIconColor;
  String leftMenuBackgroundColor;
  String leftMenuTitleColor;
  String leftMenuUsernameColor;
  String bottomBarIconColor;
  String bottomBarTextColor;
  String dotIncreasedColor;
  String leftMenuHeaderBackgroundColor;
  String bottom_bar_background_color;
  String left_menu_label_Color;

  AppThemeColors({
    this.id,
    this.appThemeColor,
    this.leftMenuIconColor,
    this.leftMenuBackgroundColor,
    this.leftMenuTitleColor,
    this.leftMenuUsernameColor,
    this.bottomBarIconColor,
    this.bottomBarTextColor,
    this.dotIncreasedColor,
    this.leftMenuHeaderBackgroundColor,
    this.bottom_bar_background_color,
    this.left_menu_label_Color,
  });

  factory AppThemeColors.fromJson(Map<String, dynamic> json) => AppThemeColors(
        id: json["id"],
        appThemeColor: json["app_theme_color"],
        leftMenuIconColor: json["left_menu_icon_color"],
        leftMenuBackgroundColor: json["left_menu_background_color"],
        leftMenuTitleColor: json["left_menu_title_color"],
        leftMenuUsernameColor: json["left_menu_username_color"],
        bottomBarIconColor: json["bottom_bar_icon_color"],
        bottomBarTextColor: json["bottom_bar_text_color"],
        dotIncreasedColor: json["dot_increased_color"],
        leftMenuHeaderBackgroundColor:
            json["left_menu_header_background_color"],
        bottom_bar_background_color: json["bottom_bar_background_color"],
        left_menu_label_Color: json["left_menu_label_color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "app_theme_color": appThemeColor,
        "left_menu_icon_color": leftMenuIconColor,
        "left_menu_background_color": leftMenuBackgroundColor,
        "left_menu_title_color": leftMenuTitleColor,
        "left_menu_username_color": leftMenuUsernameColor,
        "bottom_bar_icon_color": bottomBarIconColor,
        "bottom_bar_text_color": bottomBarTextColor,
        "dot_increased_color": dotIncreasedColor,
        "left_menu_header_background_color": leftMenuHeaderBackgroundColor,
        "bottom_bar_background_color": bottom_bar_background_color,
        "left_menu_label_color": left_menu_label_Color,
      };
}

class Banner {
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
    this.type,
    this.platform,
  });

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
  String type;
  String platform;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
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
        type: json["type"],
        platform: json["platform"],
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
        "type": type,
        "platform": platform,
      };
}

class Banners {
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

  Banners(
      {this.id,
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
      this.status});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    storeId = json['store_id'];
    link = json['link'];
    title = json['title'];
    categoryId = json['category_id'];
    subCategoryId = json['sub_category_id'];
    productId = json['product_id'];
    offerId = json['offer_id'];
    image = json['image'];
    linkTo = json['link_to'];
    pageId = json['page_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['store_id'] = this.storeId;
    data['link'] = this.link;
    data['title'] = this.title;
    data['category_id'] = this.categoryId;
    data['sub_category_id'] = this.subCategoryId;
    data['product_id'] = this.productId;
    data['offer_id'] = this.offerId;
    data['image'] = this.image;
    data['link_to'] = this.linkTo;
    data['page_id'] = this.pageId;
    data['status'] = this.status;
    return data;
  }
}

class ForceDownload {
  String iosAppVersion;
  String androidAppVerison;
  String windowAppVersion;
  String forceDownload;
  String forceDownloadMessage;

  ForceDownload(
      {this.iosAppVersion,
      this.androidAppVerison,
      this.windowAppVersion,
      this.forceDownload,
      this.forceDownloadMessage});

  ForceDownload.fromJson(Map<String, dynamic> json) {
    iosAppVersion = json['ios_app_version'];
    androidAppVerison = json['android_app_verison'];
    windowAppVersion = json['window_app_version'];
    forceDownload = json['force_download'];
    forceDownloadMessage = json['force_download_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ios_app_version'] = this.iosAppVersion;
    data['android_app_verison'] = this.androidAppVerison;
    data['window_app_version'] = this.windowAppVersion;
    data['force_download'] = this.forceDownload;
    data['force_download_message'] = this.forceDownloadMessage;
    return data;
  }
}

class Geofencing {
  String id;
  String message;
  String lat;
  String lng;
  String radius;
  String status;

  Geofencing(
      {this.id, this.message, this.lat, this.lng, this.radius, this.status});

  Geofencing.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    lat = json['lat'];
    lng = json['lng'];
    radius = json['radius'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['radius'] = this.radius;
    data['status'] = this.status;
    return data;
  }
}

class AppLabels {
  String id;
  String label;
  String labelIdentifier;
  String priority;
  String status;

  AppLabels(
      {this.id, this.label, this.labelIdentifier, this.priority, this.status});

  AppLabels.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    label = json['label'];
    labelIdentifier = json['label_identifier'];
    priority = json['priority'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['label'] = this.label;
    data['label_identifier'] = this.labelIdentifier;
    data['priority'] = this.priority;
    data['status'] = this.status;
    return data;
  }
}
