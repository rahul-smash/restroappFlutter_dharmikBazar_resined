// To parse this JSON data, do
//
//     final registerUser = registerUserFromJson(jsonString);

import 'dart:convert';

RegisterUser registerUserFromJson(String str) => RegisterUser.fromJson(json.decode(str));

String registerUserToJson(RegisterUser data) => json.encode(data.toJson());

class RegisterUser {
  bool success;
  Data data;
  String message;

  RegisterUser({
    this.success,
    this.data,
    this.message,
  });

  factory RegisterUser.fromJson(Map<String, dynamic> json) => RegisterUser(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class Data {
  String id;
  String onDuty;
  String lat;
  String lng;
  String fullName;
  String fbId;
  String email;
  String decodedPassword;
  String phone;
  String profileImage;
  String otpVerify;
  String userReferCode;
  String status;
  String loginStatus;
  String deviceId;
  String deviceToken;
  String platform;
  String verificationCode;
  String verificationCodeStatus;
  bool blDeviceIdUnique;
  bool isRefererFnEnable;

  Data({
    this.id,
    this.onDuty,
    this.lat,
    this.lng,
    this.fullName,
    this.fbId,
    this.email,
    this.decodedPassword,
    this.phone,
    this.profileImage,
    this.otpVerify,
    this.userReferCode,
    this.status,
    this.loginStatus,
    this.deviceId,
    this.deviceToken,
    this.platform,
    this.verificationCode,
    this.verificationCodeStatus,
    this.blDeviceIdUnique,
    this.isRefererFnEnable,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    onDuty: json["on_duty"],
    lat: json["lat"],
    lng: json["lng"],
    fullName: json["full_name"],
    fbId: json["fb_id"],
    email: json["email"],
    decodedPassword: json["decoded_password"],
    phone: json["phone"],
    profileImage: json["profile_image"],
    otpVerify: json["otp_verify"],
    userReferCode: json["user_refer_code"],
    status: json["status"],
    loginStatus: json["login_status"],
    deviceId: json["device_id"],
    deviceToken: json["device_token"],
    platform: json["platform"],
    verificationCode: json["verification_code"],
    verificationCodeStatus: json["verification_code_status"],
    blDeviceIdUnique: json["bl_device_id_unique"],
    isRefererFnEnable: json["is_referer_fn_enable"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "on_duty": onDuty,
    "lat": lat,
    "lng": lng,
    "full_name": fullName,
    "fb_id": fbId,
    "email": email,
    "decoded_password": decodedPassword,
    "phone": phone,
    "profile_image": profileImage,
    "otp_verify": otpVerify,
    "user_refer_code": userReferCode,
    "status": status,
    "login_status": loginStatus,
    "device_id": deviceId,
    "device_token": deviceToken,
    "platform": platform,
    "verification_code": verificationCode,
    "verification_code_status": verificationCodeStatus,
    "bl_device_id_unique": blDeviceIdUnique,
    "is_referer_fn_enable": isRefererFnEnable,
  };
}
