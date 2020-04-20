import 'dart:convert';

OtpVerified otpVerifiedFromJson(String str) => OtpVerified.fromJson(json.decode(str));

String otpVerifiedToJson(OtpVerified data) => json.encode(data.toJson());

class OtpVerified {
  bool success;
  String message;

  OtpVerified({
    this.success,
    this.message,
  });

  factory OtpVerified.fromJson(Map<String, dynamic> json) => OtpVerified(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
