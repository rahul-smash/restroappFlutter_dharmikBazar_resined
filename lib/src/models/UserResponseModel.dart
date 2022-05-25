class ResponseModel {
  bool success;
  String message;
  String notification;

  ResponseModel({
    this.success,
    this.message,
    this.notification,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) => ResponseModel(
        success: json["success"],
        message: json["message"],
        notification: json["notification"],
      );
}

class UserResponse {
  bool success;
  String message;
  UserModel user;

  UserResponse({
    this.success,
    this.user,
    this.message,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        success: json["success"],
        user: json["data"] == null ? null : UserModel.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": user.toJson(),
        "message": message,
      };
}

class UserModel {
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

  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
