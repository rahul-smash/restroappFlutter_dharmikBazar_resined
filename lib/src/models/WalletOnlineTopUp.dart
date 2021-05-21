
import 'dart:convert';

class WalletOnlineTopUp {
  WalletOnlineTopUp({
    this.success,
    this.message,
  });

  bool success;
  String message;

  WalletOnlineTopUp copyWith({
    bool success,
    String message,
  }) =>
      WalletOnlineTopUp(
        success: success ?? this.success,
        message: message ?? this.message,
      );

  factory WalletOnlineTopUp.fromRawJson(String str) => WalletOnlineTopUp.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WalletOnlineTopUp.fromJson(Map<String, dynamic> json) => WalletOnlineTopUp(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
