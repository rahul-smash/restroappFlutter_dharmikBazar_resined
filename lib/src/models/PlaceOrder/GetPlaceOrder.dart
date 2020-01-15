import 'dart:convert';



GetPlaceOrder registerUserFromJson(String str) => GetPlaceOrder.fromJson(json.decode(str));

String getPlaceOrderUserToJson(GetPlaceOrder data) => json.encode(data.toJson());

class GetPlaceOrder {
  bool success;
  String message;

  GetPlaceOrder({this.success, this.message});

  GetPlaceOrder.fromJson(Map<String, dynamic> json) {
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
