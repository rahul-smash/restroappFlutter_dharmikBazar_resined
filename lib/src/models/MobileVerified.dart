
class MobileVerified {
  int userExists;
  bool success;
  UserModelMobile user;

  MobileVerified.fromJson(Map<String, dynamic> json) {
    userExists = json['user_exists'];
    success = json['success'];
    user = json['data'] != null ? new UserModelMobile.fromJson(json['data']) : null;
  }
}

class UserModelMobile {
  String id;
  String fullName;
  String fbId;
  String email;
  String decodedPassword;
  String phone;
  String profileImage;
  String otp;
  String otpVerify;
  String userReferCode;
  String roleId;
  String status;
  String loginStatus;
  String type;
  String deviceId;
  String deviceToken;
  String platform;
  String verfCode;
  String verfStatus;
  String created;
  List<Null> deliveryAddress;
  bool isRefererFnEnable;

  UserModelMobile(
      {this.id,
        this.fullName,
        this.fbId,
        this.email,
        this.decodedPassword,
        this.phone,
        this.profileImage,
        this.otp,
        this.otpVerify,
        this.userReferCode,
        this.roleId,
        this.status,
        this.loginStatus,
        this.type,
        this.deviceId,
        this.deviceToken,
        this.platform,
        this.verfCode,
        this.verfStatus,
        this.created,
        this.deliveryAddress,
        this.isRefererFnEnable});

  UserModelMobile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    fbId = json['fb_id'];
    email = json['email'];
    decodedPassword = json['decoded_password'];
    phone = json['phone'];
    profileImage = json['profile_image'];
    otp = json['otp'];
    otpVerify = json['otp_verify'];
    userReferCode = json['user_refer_code'];
    roleId = json['role_id'];
    status = json['status'];
    loginStatus = json['login_status'];
    type = json['type'];
    deviceId = json['device_id'];
    deviceToken = json['device_token'];
    platform = json['platform'];
    verfCode = json['verf_code'];
    verfStatus = json['verf_status'];
    created = json['created'];
    isRefererFnEnable = json['is_referer_fn_enable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['fb_id'] = this.fbId;
    data['email'] = this.email;
    data['decoded_password'] = this.decodedPassword;
    data['phone'] = this.phone;
    data['profile_image'] = this.profileImage;
    data['otp'] = this.otp;
    data['otp_verify'] = this.otpVerify;
    data['user_refer_code'] = this.userReferCode;
    data['role_id'] = this.roleId;
    data['status'] = this.status;
    data['login_status'] = this.loginStatus;
    data['type'] = this.type;
    data['device_id'] = this.deviceId;
    data['device_token'] = this.deviceToken;
    data['platform'] = this.platform;
    data['verf_code'] = this.verfCode;
    data['verf_status'] = this.verfStatus;
    data['created'] = this.created;
    data['is_referer_fn_enable'] = this.isRefererFnEnable;
    return data;
  }
}
