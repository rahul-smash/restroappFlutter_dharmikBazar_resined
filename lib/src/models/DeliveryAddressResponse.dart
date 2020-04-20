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

  DeliveryAddressData({
    this.id,
    this.userId,
    this.storeId,
    this.firstName,
    this.lastName,
    this.mobile,
    this.email,
    this.address,
    this.areaId,
    this.areaName,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.notAllow,
    this.areaCharges,
    this.minAmount,
    this.note,
    this.cityId,
  });

  factory DeliveryAddressData.fromJson(Map<String, dynamic> json) =>
      DeliveryAddressData(
        id: json["id"],
        userId: json["user_id"],
        storeId: json["store_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        mobile: json["mobile"],
        email: json["email"],
        address: json["address"],
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
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "store_id": storeId,
        "first_name": firstName,
        "last_name": lastName,
        "mobile": mobile,
        "email": email,
        "address": address,
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
      };
}