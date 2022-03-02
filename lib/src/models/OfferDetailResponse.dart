import 'dart:convert';
/// success : true
/// data : {"id":"81","store_id":"393","discount_type":"4","is_for_all_or_segment":"0","order_facilities":"3","all_categories":"0","payment_method":"1","name":"2% DISCOUNT ON Products","coupon_code":"5952","discount":"15","discount_upto":"150","minimum_order_amount":"250","usage_limit":"0","valid_from":"2022-02-16","valid_to":"2022-03-03","offer_notification":"","offer_term_condition":"YOUR AGREEMENT, PRIVACY, LINKED SITES, FORWARD LOOKING STATEMENTS","offer_description":"","banner":"","status":"1","show":"1","sort":"10","created":"2021-08-10 08:29:37","modified":"2022-03-01 06:50:18"}

OfferDetailResponse offerDetailResponseFromJson(String str) => OfferDetailResponse.fromJson(json.decode(str));
String offerDetailResponseToJson(OfferDetailResponse data) => json.encode(data.toJson());
class OfferDetailResponse {
  OfferDetailResponse({
      bool success,
      Data data,}){
    _success = success;
    _data = data;
}

  OfferDetailResponse.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool _success;
  Data _data;

  bool get success => _success;
  Data get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// id : "81"
/// store_id : "393"
/// discount_type : "4"
/// is_for_all_or_segment : "0"
/// order_facilities : "3"
/// all_categories : "0"
/// payment_method : "1"
/// name : "2% DISCOUNT ON Products"
/// coupon_code : "5952"
/// discount : "15"
/// discount_upto : "150"
/// minimum_order_amount : "250"
/// usage_limit : "0"
/// valid_from : "2022-02-16"
/// valid_to : "2022-03-03"
/// offer_notification : ""
/// offer_term_condition : "YOUR AGREEMENT, PRIVACY, LINKED SITES, FORWARD LOOKING STATEMENTS"
/// offer_description : ""
/// banner : ""
/// status : "1"
/// show : "1"
/// sort : "10"
/// created : "2021-08-10 08:29:37"
/// modified : "2022-03-01 06:50:18"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      String id,
      String storeId,
      String discountType,
      String isForAllOrSegment,
      String orderFacilities,
      String allCategories,
      String paymentMethod,
      String name,
      String couponCode,
      String discount,
      String discountUpto,
      String minimumOrderAmount,
      String usageLimit,
      String validFrom,
      String validTo,
      String offerNotification,
      String offerTermCondition,
      String offerDescription,
      String banner,
      String status,
      String show,
      String sort,
      String created,
      String modified,}){
    _id = id;
    _storeId = storeId;
    _discountType = discountType;
    _isForAllOrSegment = isForAllOrSegment;
    _orderFacilities = orderFacilities;
    _allCategories = allCategories;
    _paymentMethod = paymentMethod;
    _name = name;
    _couponCode = couponCode;
    _discount = discount;
    _discountUpto = discountUpto;
    _minimumOrderAmount = minimumOrderAmount;
    _usageLimit = usageLimit;
    _validFrom = validFrom;
    _validTo = validTo;
    _offerNotification = offerNotification;
    _offerTermCondition = offerTermCondition;
    _offerDescription = offerDescription;
    _banner = banner;
    _status = status;
    _show = show;
    _sort = sort;
    _created = created;
    _modified = modified;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _storeId = json['store_id'];
    _discountType = json['discount_type'];
    _isForAllOrSegment = json['is_for_all_or_segment'];
    _orderFacilities = json['order_facilities'];
    _allCategories = json['all_categories'];
    _paymentMethod = json['payment_method'];
    _name = json['name'];
    _couponCode = json['coupon_code'];
    _discount = json['discount'];
    _discountUpto = json['discount_upto'];
    _minimumOrderAmount = json['minimum_order_amount'];
    _usageLimit = json['usage_limit'];
    _validFrom = json['valid_from'];
    _validTo = json['valid_to'];
    _offerNotification = json['offer_notification'];
    _offerTermCondition = json['offer_term_condition'];
    _offerDescription = json['offer_description'];
    _banner = json['banner'];
    _status = json['status'];
    _show = json['show'];
    _sort = json['sort'];
    _created = json['created'];
    _modified = json['modified'];
  }
  String _id;
  String _storeId;
  String _discountType;
  String _isForAllOrSegment;
  String _orderFacilities;
  String _allCategories;
  String _paymentMethod;
  String _name;
  String _couponCode;
  String _discount;
  String _discountUpto;
  String _minimumOrderAmount;
  String _usageLimit;
  String _validFrom;
  String _validTo;
  String _offerNotification;
  String _offerTermCondition;
  String _offerDescription;
  String _banner;
  String _status;
  String _show;
  String _sort;
  String _created;
  String _modified;

  String get id => _id;
  String get storeId => _storeId;
  String get discountType => _discountType;
  String get isForAllOrSegment => _isForAllOrSegment;
  String get orderFacilities => _orderFacilities;
  String get allCategories => _allCategories;
  String get paymentMethod => _paymentMethod;
  String get name => _name;
  String get couponCode => _couponCode;
  String get discount => _discount;
  String get discountUpto => _discountUpto;
  String get minimumOrderAmount => _minimumOrderAmount;
  String get usageLimit => _usageLimit;
  String get validFrom => _validFrom;
  String get validTo => _validTo;
  String get offerNotification => _offerNotification;
  String get offerTermCondition => _offerTermCondition;
  String get offerDescription => _offerDescription;
  String get banner => _banner;
  String get status => _status;
  String get show => _show;
  String get sort => _sort;
  String get created => _created;
  String get modified => _modified;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['store_id'] = _storeId;
    map['discount_type'] = _discountType;
    map['is_for_all_or_segment'] = _isForAllOrSegment;
    map['order_facilities'] = _orderFacilities;
    map['all_categories'] = _allCategories;
    map['payment_method'] = _paymentMethod;
    map['name'] = _name;
    map['coupon_code'] = _couponCode;
    map['discount'] = _discount;
    map['discount_upto'] = _discountUpto;
    map['minimum_order_amount'] = _minimumOrderAmount;
    map['usage_limit'] = _usageLimit;
    map['valid_from'] = _validFrom;
    map['valid_to'] = _validTo;
    map['offer_notification'] = _offerNotification;
    map['offer_term_condition'] = _offerTermCondition;
    map['offer_description'] = _offerDescription;
    map['banner'] = _banner;
    map['status'] = _status;
    map['show'] = _show;
    map['sort'] = _sort;
    map['created'] = _created;
    map['modified'] = _modified;
    return map;
  }

}