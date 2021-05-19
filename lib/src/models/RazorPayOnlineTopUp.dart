
import 'dart:convert';

class RazorPayOnlineTopUp {
  RazorPayOnlineTopUp({
    this.success,
    this.message,
  });

  bool success;
  String message;

  RazorPayOnlineTopUp copyWith({
    bool success,
    String message,
  }) =>
      RazorPayOnlineTopUp(
        success: success ?? this.success,
        message: message ?? this.message,
      );

  factory RazorPayOnlineTopUp.fromRawJson(String str) => RazorPayOnlineTopUp.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RazorPayOnlineTopUp.fromJson(Map<String, dynamic> json) => RazorPayOnlineTopUp(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
