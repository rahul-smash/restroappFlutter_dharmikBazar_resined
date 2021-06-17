// To parse this JSON data, do
//
//     final razorpayError = razorpayErrorFromJson(jsonString);

import 'dart:convert';

class RazorpayError {
  RazorpayError({
    this.error,
  });

  Error error;

  RazorpayError copyWith({
    Error error,
  }) =>
      RazorpayError(
        error: error ?? this.error,
      );

  factory RazorpayError.fromRawJson(String str) => RazorpayError.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RazorpayError.fromJson(Map<String, dynamic> json) => RazorpayError(
    error: json["error"] == null ? null : Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error == null ? null : error.toJson(),
  };
}

class Error {
  Error({
    this.code,
    this.description,
    this.source,
    this.step,
    this.reason,
  });

  String code;
  String description;
  String source;
  String step;
  String reason;

  Error copyWith({
    String code,
    String description,
    String source,
    String step,
    String reason,
  }) =>
      Error(
        code: code ?? this.code,
        description: description ?? this.description,
        source: source ?? this.source,
        step: step ?? this.step,
        reason: reason ?? this.reason,
      );

  factory Error.fromRawJson(String str) => Error.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    code: json["code"] == null ? null : json["code"],
    description: json["description"] == null ? null : json["description"],
    source: json["source"] == null ? null : json["source"],
    step: json["step"] == null ? null : json["step"],
    reason: json["reason"] == null ? null : json["reason"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "description": description == null ? null : description,
    "source": source == null ? null : source,
    "step": step == null ? null : step,
    "reason": reason == null ? null : reason,
  };
}
