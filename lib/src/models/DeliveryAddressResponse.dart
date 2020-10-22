class DeliveryAddressResponse {
  bool success;
  String message;
  List<DeliveryAddressData> data;

  DeliveryAddressResponse({
    this.success,
    this.message,
    this.data,
  });

  factory DeliveryAddressResponse.fromJson(Map<String, dynamic> json) =>
      DeliveryAddressResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? null : List<DeliveryAddressData>.from(
            json["data"].map((x) => DeliveryAddressData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DeliveryAddressData {
  String id;
  String userId;
  String storeId;
  String firstName;
  String lastName;
  String mobile;
  String email;
  String address;
  String address2;
  String areaId;
  String areaName;
  String city;
  String state;
  String zipCode;
  String country;
  bool notAllow;
  String areaCharges;
  String minAmount;
  String note;
  String cityId;
  bool isDeleted;
  String lat;
  String lng;
  //DeliveryTimeSlot deliveryTimeSlot;

  DeliveryAddressData({
    this.id,
    this.userId,
    this.storeId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.address,
    this.address2,
    this.areaId,
    this.areaName,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.lat,
    this.lng,
    this.notAllow,
    this.areaCharges,
    this.minAmount,
    this.note,
    this.cityId,
    this.isDeleted
    //this.deliveryTimeSlot
  });

  factory DeliveryAddressData.fromJson(Map<String, dynamic> json) =>
      DeliveryAddressData(
        id: json["id"],
        lat: json["lat"],
        lng: json["lng"],
        userId: json["user_id"],
        storeId: json["store_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        mobile: json["mobile"],
        email: json["email"],
        address: json["address"],
        address2: json["address2"],
        areaId: json["area_id"],
        areaName: json["area_name"],
        city: json["city"],
        state: json["state"],
        zipCode: json["zipcode"],
        country: json["country"],
        notAllow: json["not_allow"],
        areaCharges: json["area_charges"],
        minAmount: json["min_amount"],
        note: json["note"],
        cityId: json["city_id"],
        isDeleted: json["is_deleted"],
        //deliveryTimeSlot: DeliveryTimeSlot.fromJson(json["delivery_time_slot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "lat": lat,
        "lng": lng,
        "user_id": userId,
        "store_id": storeId,
        "first_name": firstName,
        "last_name": lastName,
        "mobile": mobile,
        "email": email,
        "address": address,
        "address2": address2,
        "area_id": areaId,
        "area_name": areaName,
        "city": city,
        "state": state,
        "zipcode": zipCode,
        "country": country,
        "not_allow": notAllow,
        "area_charges": areaCharges,
        "min_amount": minAmount,
        "note": note,
        "city_id": cityId,
        "is_deleted": isDeleted,
        //"delivery_time_slot": deliveryTimeSlot.toJson(),
      };
}

class DeliveryTimeSlot {
  String zoneId;
  String is24X7Open;

  DeliveryTimeSlot({
    this.zoneId,
    this.is24X7Open,
  });

  factory DeliveryTimeSlot.fromJson(Map<String, dynamic> json) => DeliveryTimeSlot(
    zoneId: json["zone_id"],
    is24X7Open: json["is24x7_open"],
  );

  Map<String, dynamic> toJson() => {
    "zone_id": zoneId,
    "is24x7_open": is24X7Open,
  };
}