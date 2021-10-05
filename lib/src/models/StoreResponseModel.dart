import 'dart:convert';

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
  String wallet_setting;
  Subscription subscription;
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
  String social_login;
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
  WebAppThemeColors webAppThemeColors;

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
  bool areaWisePaymentOption;//true, false
  String poweredByLink;
  String reviewRatingDisplay;
  String allowCustomerForGst;
  StoreOffer storeOffer;

  WalletSettings walletSettings;
  String hideSignup;
  String promiseToPay;
  String promiseToPayForAll;
  StoreModel({
    this.id,
    this.storeName,
    this.aboutusBanner,
    this.location,
    this.wallet_setting,
    this.subscription,
    this.city,
    this.state,
    this.country,
    this.cod,
    this.zipcode,
    this.lat,
    this.lng,
    this.social_login,
    this.appThemeColors,
    this.webAppThemeColors,
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
    this.homePageDisplayNumberType,
    this.domain,
    this.poweredByText,
    this.areaWisePaymentOption,
    this.poweredByLink,
    this.promiseToPay,
    this.promiseToPayForAll,
    this.reviewRatingDisplay,
    this.allowCustomerForGst,
    this.storeOffer,
    this.walletSettings,
    this.hideSignup,
  });

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
    social_login = json['social_login'];
    wallet_setting = json['wallet_setting'];
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
    promiseToPay = json['promise_to_pay'];
    promiseToPayForAll = json['promise_to_pay_for_all'];
    paymentGateway = json["payment_gateway"];
    subscription = Subscription.fromJson(json["Subscription"]);
    paymentSetting = PaymentSetting.fromJson(json["payment_setting"]);
    if (json['payment_gateway_settings'] != null) {
      if (json['payment_gateway_settings'] is String) {
        paymentGatewaySettings = null;
      } else {
        paymentGatewaySettings = json["payment_gateway_settings"] == null
            ? null
            : List<PaymentGatewaySettings>.from(json["payment_gateway_settings"]
                .map((x) => PaymentGatewaySettings.fromJson(x)));
//    paymentGatewaySettings = new List<PaymentGatewaySettings>();
//    json['payment_gateway_settings'].forEach((v) {
//    paymentGatewaySettings.add(new PaymentGatewaySettings.fromJson(v));
//    });
      }
    }
    appThemeColors = AppThemeColors.fromJson(json["app_theme_colors"]);
    webAppThemeColors = json["web_app_theme_colors"] == null
        ? null
        : WebAppThemeColors.fromJson(json["web_app_theme_colors"]);
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
    domain = json["domain"];
    poweredByText = json["powered_by_text"];
    areaWisePaymentOption:
    json["area_wise_payment_option"] == null
        ? null
        : json["area_wise_payment_option"];
    poweredByLink = json["powered_by_link"];
    reviewRatingDisplay = json["review_rating_display"] == null
        ? null
        : json["review_rating_display"];
    allowCustomerForGst = json["allow_customer_for_gst"] == null
        ? null
        : json["allow_customer_for_gst"];
    storeOffer = json["store_offer"] == null
        ? null
        : json["store_offer"] is List<dynamic>
            ? null
            : StoreOffer.fromJson(json["store_offer"]);

    walletSettings = json['wallet_setting'] == '0'
        ? null
        : json["wallet_settings"] == null
            ? null
            : WalletSettings.fromJson(json["wallet_settings"]);
    hideSignup = json["hide_signup"];
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
    data['Subscription'] = this.subscription.toJson();
    data['contact_person'] = this.contactPerson;
    data['contact_number'] = this.contactNumber;
    data['contact_email'] = this.contactEmail;
    data['about_us'] = this.aboutUs;
    data['wallet_setting'] = this.wallet_setting;
    data['otp_skip'] = this.otpSkip;
    data['app_theme_colors'] = this.appThemeColors;
    data['web_app_theme_colors'] = this.webAppThemeColors;
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
    data['social_login'] = this.social_login;
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
    data['promise_to_pay'] = this.promiseToPay;
    data['promise_to_pay_for_all'] = this.promiseToPayForAll;
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
    data['domain'] = this.domain;
    data['powered_by_text'] = this.poweredByText;
    data["area_wise_payment_option"] =
        areaWisePaymentOption == null ? null : areaWisePaymentOption;
    data['powered_by_link'] = this.poweredByLink;
    data['review_rating_display'] = this.reviewRatingDisplay;
    data['allow_customer_for_gst'] = this.allowCustomerForGst;
    data['store_offer'] = this.storeOffer;
    data['wallet_settings'] =
        walletSettings == null ? null : walletSettings.toJson();
    data['hide_signup'] = this.hideSignup;
    return data;
  }
}

class Subscription {
  Subscription({
    this.status,
    this.feeType,
    this.cycleType,
    this.minimumOrderDaily,
  });

  String status;
  dynamic feeType;
  List<CycleType> cycleType;
  String minimumOrderDaily;

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        status: json["status"],
        feeType: json["fee_type"],
        cycleType: List<CycleType>.from(
            json["cycle_type"].map((x) => CycleType.fromJson(x))),
        minimumOrderDaily: json["minimum_order_daily"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "fee_type": feeType,
        //"cycle_type": cycleType,
        "cycle_type": List<dynamic>.from(cycleType.map((x) => x.toJson())),
        "minimum_order_daily": minimumOrderDaily,
      };
}

class CycleType {
  CycleType({
    this.label,
    this.days,
    this.key,
  });

  String label;
  String days;
  String key;

  factory CycleType.fromJson(Map<String, dynamic> json) => CycleType(
        label: json["label"],
        days: json["days"],
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "days": days,
        "key": key,
      };
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

class WebAppThemeColors {
  WebAppThemeColors({
    this.id,
    this.storeId,
    this.webThemePrimaryColor,
    this.webThemeSecondaryColor,
    this.webThemeCategoryOpenColor,
    this.stripsColor,
    this.footerColor,
    this.listingBackgroundColor,
    this.listingBorderColor,
    this.listingBoxBackgroundColor,
    this.homeSubHeadingColor,
    this.homeDescriptionColor,
    this.categoryListingButtonBorderColor,
    this.categoryListingBoxBackgroundColor,
  });

  String id;
  String storeId;
  String webThemePrimaryColor;
  String webThemeSecondaryColor;
  String webThemeCategoryOpenColor;
  String stripsColor;
  String footerColor;
  String listingBackgroundColor;
  String listingBorderColor;
  String listingBoxBackgroundColor;
  String homeSubHeadingColor;
  String homeDescriptionColor;
  String categoryListingButtonBorderColor;
  String categoryListingBoxBackgroundColor;

  WebAppThemeColors copyWith({
    String id,
    String storeId,
    String webThemePrimaryColor,
    String webThemeSecondaryColor,
    String webThemeCategoryOpenColor,
    String stripsColor,
    String footerColor,
    String listingBackgroundColor,
    String listingBorderColor,
    String listingBoxBackgroundColor,
    String homeSubHeadingColor,
    String homeDescriptionColor,
    String categoryListingButtonBorderColor,
    String categoryListingBoxBackgroundColor,
  }) =>
      WebAppThemeColors(
        id: id ?? this.id,
        storeId: storeId ?? this.storeId,
        webThemePrimaryColor: webThemePrimaryColor ?? this.webThemePrimaryColor,
        webThemeSecondaryColor:
            webThemeSecondaryColor ?? this.webThemeSecondaryColor,
        webThemeCategoryOpenColor:
            webThemeCategoryOpenColor ?? this.webThemeCategoryOpenColor,
        stripsColor: stripsColor ?? this.stripsColor,
        footerColor: footerColor ?? this.footerColor,
        listingBackgroundColor:
            listingBackgroundColor ?? this.listingBackgroundColor,
        listingBorderColor: listingBorderColor ?? this.listingBorderColor,
        listingBoxBackgroundColor:
            listingBoxBackgroundColor ?? this.listingBoxBackgroundColor,
        homeSubHeadingColor: homeSubHeadingColor ?? this.homeSubHeadingColor,
        homeDescriptionColor: homeDescriptionColor ?? this.homeDescriptionColor,
        categoryListingButtonBorderColor: categoryListingButtonBorderColor ??
            this.categoryListingButtonBorderColor,
        categoryListingBoxBackgroundColor: categoryListingBoxBackgroundColor ??
            this.categoryListingBoxBackgroundColor,
      );

  factory WebAppThemeColors.fromRawJson(String str) =>
      WebAppThemeColors.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WebAppThemeColors.fromJson(Map<String, dynamic> json) =>
      WebAppThemeColors(
        id: json["id"] == null ? null : json["id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        webThemePrimaryColor: json["web_theme_primary_color"] == null
            ? null
            : json["web_theme_primary_color"],
        webThemeSecondaryColor: json["web_theme_secondary_color"] == null
            ? null
            : json["web_theme_secondary_color"],
        webThemeCategoryOpenColor: json["web_theme_category_open_color"] == null
            ? null
            : json["web_theme_category_open_color"],
        stripsColor: json["strips_color"] == null ? null : json["strips_color"],
        footerColor: json["footer_color"] == null ? null : json["footer_color"],
        listingBackgroundColor: json["listing_background_color"] == null
            ? null
            : json["listing_background_color"],
        listingBorderColor: json["listing_border_color"] == null
            ? null
            : json["listing_border_color"],
        listingBoxBackgroundColor: json["listing_box_background_color"] == null
            ? null
            : json["listing_box_background_color"],
        homeSubHeadingColor: json["home_sub_heading_color"] == null
            ? null
            : json["home_sub_heading_color"],
        homeDescriptionColor: json["home_description_color"] == null
            ? null
            : json["home_description_color"],
        categoryListingButtonBorderColor:
            json["category_listing_button_border_color"] == null
                ? null
                : json["category_listing_button_border_color"],
        categoryListingBoxBackgroundColor:
            json["category_listing_box_background_color"] == null
                ? null
                : json["category_listing_box_background_color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "store_id": storeId == null ? null : storeId,
        "web_theme_primary_color":
            webThemePrimaryColor == null ? null : webThemePrimaryColor,
        "web_theme_secondary_color":
            webThemeSecondaryColor == null ? null : webThemeSecondaryColor,
        "web_theme_category_open_color": webThemeCategoryOpenColor == null
            ? null
            : webThemeCategoryOpenColor,
        "strips_color": stripsColor == null ? null : stripsColor,
        "footer_color": footerColor == null ? null : footerColor,
        "listing_background_color":
            listingBackgroundColor == null ? null : listingBackgroundColor,
        "listing_border_color":
            listingBorderColor == null ? null : listingBorderColor,
        "listing_box_background_color": listingBoxBackgroundColor == null
            ? null
            : listingBoxBackgroundColor,
        "home_sub_heading_color":
            homeSubHeadingColor == null ? null : homeSubHeadingColor,
        "home_description_color":
            homeDescriptionColor == null ? null : homeDescriptionColor,
        "category_listing_button_border_color":
            categoryListingButtonBorderColor == null
                ? null
                : categoryListingButtonBorderColor,
        "category_listing_box_background_color":
            categoryListingBoxBackgroundColor == null
                ? null
                : categoryListingBoxBackgroundColor,
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

class StoreOffer {
  StoreOffer({
    this.id,
    this.title,
    this.detail,
    this.image,
    this.linkTo,
    this.categoryId,
    this.subCategoryId,
    this.productId,
    this.image300200,
    this.image10080,
  });

  String id;
  String title;
  String detail;
  String image;
  String linkTo;
  String categoryId;
  String subCategoryId;
  String productId;
  String image300200;
  String image10080;

  StoreOffer copyWith({
    String id,
    String title,
    String detail,
    String image,
    String linkTo,
    String categoryId,
    String subCategoryId,
    String productId,
    String image300200,
    String image10080,
  }) =>
      StoreOffer(
        id: id ?? this.id,
        title: title ?? this.title,
        detail: detail ?? this.detail,
        image: image ?? this.image,
        linkTo: linkTo ?? this.linkTo,
        categoryId: categoryId ?? this.categoryId,
        subCategoryId: subCategoryId ?? this.subCategoryId,
        productId: productId ?? this.productId,
        image300200: image300200 ?? this.image300200,
        image10080: image10080 ?? this.image10080,
      );

  factory StoreOffer.fromRawJson(String str) =>
      StoreOffer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StoreOffer.fromJson(Map<String, dynamic> json) => StoreOffer(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        detail: json["detail"] == null ? null : json["detail"],
        image: json["image"] == null ? null : json["image"],
        linkTo: json["link_to"] == null ? null : json["link_to"],
        categoryId: json["category_id"] == null ? null : json["category_id"],
        subCategoryId:
            json["sub_category_id"] == null ? null : json["sub_category_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        image300200:
            json["image_300_200"] == null ? null : json["image_300_200"],
        image10080: json["image_100_80"] == null ? null : json["image_100_80"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "detail": detail == null ? null : detail,
        "image": image == null ? null : image,
        "link_to": linkTo == null ? null : linkTo,
        "category_id": categoryId == null ? null : categoryId,
        "sub_category_id": subCategoryId == null ? null : subCategoryId,
        "product_id": productId == null ? null : productId,
        "image_300_200": image300200 == null ? null : image300200,
        "image_100_80": image10080 == null ? null : image10080,
      };
}

class WalletSettings {
  WalletSettings({
    this.id,
    this.storeId,
    this.status,
    this.customerWalletTopUpStatus,
    this.adminWalletTopUpStatus,
    this.minTopUpAmount,
    this.maxTopUpAmount,
    this.minTopUpHoldAmount,
    this.maxTopUpHoldAmount,
    this.defaultTopUpAmount,
    this.created,
    this.modified,
  });

  String id;
  String storeId;
  String status;
  String customerWalletTopUpStatus;
  String adminWalletTopUpStatus;
  String minTopUpAmount;
  String maxTopUpAmount;
  String minTopUpHoldAmount;
  String maxTopUpHoldAmount;
  String defaultTopUpAmount;
  DateTime created;
  DateTime modified;

  WalletSettings copyWith({
    String id,
    String storeId,
    String status,
    String customerWalletTopUpStatus,
    String adminWalletTopUpStatus,
    String minTopUpAmount,
    String maxTopUpAmount,
    String minTopUpHoldAmount,
    String maxTopUpHoldAmount,
    String defaultTopUpAmount,
    DateTime created,
    DateTime modified,
  }) =>
      WalletSettings(
        id: id ?? this.id,
        storeId: storeId ?? this.storeId,
        status: status ?? this.status,
        customerWalletTopUpStatus:
            customerWalletTopUpStatus ?? this.customerWalletTopUpStatus,
        adminWalletTopUpStatus:
            adminWalletTopUpStatus ?? this.adminWalletTopUpStatus,
        minTopUpAmount: minTopUpAmount ?? this.minTopUpAmount,
        maxTopUpAmount: maxTopUpAmount ?? this.maxTopUpAmount,
        minTopUpHoldAmount: minTopUpHoldAmount ?? this.minTopUpHoldAmount,
        maxTopUpHoldAmount: maxTopUpHoldAmount ?? this.maxTopUpHoldAmount,
        defaultTopUpAmount: defaultTopUpAmount ?? this.defaultTopUpAmount,
        created: created ?? this.created,
        modified: modified ?? this.modified,
      );

  factory WalletSettings.fromRawJson(String str) =>
      WalletSettings.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WalletSettings.fromJson(Map<String, dynamic> json) => WalletSettings(
        id: json["id"] == null ? null : json["id"],
        storeId: json["store_id"] == null ? null : json["store_id"],
        status: json["status"] == null ? null : json["status"],
        customerWalletTopUpStatus: json["customer_wallet_top_up_status"] == null
            ? null
            : json["customer_wallet_top_up_status"],
        adminWalletTopUpStatus: json["admin_wallet_top_up_status"] == null
            ? null
            : json["admin_wallet_top_up_status"],
        minTopUpAmount: json["min_top_up_amount"] == null
            ? null
            : json["min_top_up_amount"],
        maxTopUpAmount: json["max_top_up_amount"] == null
            ? null
            : json["max_top_up_amount"],
        minTopUpHoldAmount: json["min_top_up_hold_amount"] == null
            ? null
            : json["min_top_up_hold_amount"],
        maxTopUpHoldAmount: json["max_top_up_hold_amount"] == null
            ? null
            : json["max_top_up_hold_amount"],
        defaultTopUpAmount: json["default_top_up_amount"] == null
            ? null
            : json["default_top_up_amount"],
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "store_id": storeId == null ? null : storeId,
        "status": status == null ? null : status,
        "customer_wallet_top_up_status": customerWalletTopUpStatus == null
            ? null
            : customerWalletTopUpStatus,
        "admin_wallet_top_up_status":
            adminWalletTopUpStatus == null ? null : adminWalletTopUpStatus,
        "min_top_up_amount": minTopUpAmount == null ? null : minTopUpAmount,
        "max_top_up_amount": maxTopUpAmount == null ? null : maxTopUpAmount,
        "min_top_up_hold_amount":
            minTopUpHoldAmount == null ? null : minTopUpHoldAmount,
        "max_top_up_hold_amount":
            maxTopUpHoldAmount == null ? null : maxTopUpHoldAmount,
        "default_top_up_amount":
            defaultTopUpAmount == null ? null : defaultTopUpAmount,
        "created": created == null ? null : created.toIso8601String(),
        "modified": modified == null ? null : modified.toIso8601String(),
      };
}
