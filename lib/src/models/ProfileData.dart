
import 'dart:convert';

ProfileData registerUserFromJson(String str) => ProfileData.fromJson(json.decode(str));

String registerUserToJson(ProfileData data) => json.encode(data.toJson());

class ProfileData {
  bool success;
  String message;

  ProfileData({this.success, this.message});

  ProfileData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}
