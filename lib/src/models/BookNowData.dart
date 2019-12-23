import 'dart:convert';



BookNowData registerUserFromJson(String str) => BookNowData.fromJson(json.decode(str));

String registerUserToJson(BookNowData data) => json.encode(data.toJson());
class BookNowData {
  bool success;
  String message;
  List<Null> data;

  BookNowData({this.success, this.message, this.data});

  BookNowData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Null>();
      json['data'].forEach((v) {
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;

    return data;
  }
}