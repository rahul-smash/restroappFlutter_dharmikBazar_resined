import 'dart:convert';

class RazorPayTopUP {
  RazorPayTopUP({
    this.success,
    this.message,
  });

  bool success;
  String message;

  RazorPayTopUP copyWith({
    bool success,
    String message,
  }) =>
      RazorPayTopUP(
        success: success ?? this.success,
        message: message ?? this.message,
      );

  factory RazorPayTopUP.fromRawJson(String str) => RazorPayTopUP.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RazorPayTopUP.fromJson(Map<String, dynamic> json) => RazorPayTopUP(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
