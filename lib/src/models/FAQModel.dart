// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

class FaqModel {
  FaqModel({
    this.success,
    this.data,
  });

  bool success;
  Data data;

  FaqModel copyWith({
    bool success,
    Data data,
  }) =>
      FaqModel(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory FaqModel.fromRawJson(String str) => FaqModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.ordering,
    this.delivery,
    this.refundReturn,
  });

  List<Delivery> ordering;
  List<Delivery> delivery;
  List<Delivery> refundReturn;

  Data copyWith({
    List<Delivery> ordering,
    List<Delivery> delivery,
    List<Delivery> refundReturn,
  }) =>
      Data(
        ordering: ordering ?? this.ordering,
        delivery: delivery ?? this.delivery,
        refundReturn: refundReturn ?? this.refundReturn,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    ordering: json["Ordering"] == null ? null : List<Delivery>.from(json["Ordering"].map((x) => Delivery.fromJson(x))),
    delivery: json["Delivery"] == null ? null : List<Delivery>.from(json["Delivery"].map((x) => Delivery.fromJson(x))),
    refundReturn: json["Refund & Return"] == null ? null : List<Delivery>.from(json["Refund & Return"].map((x) => Delivery.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Ordering": ordering == null ? null : List<dynamic>.from(ordering.map((x) => x.toJson())),
    "Delivery": delivery == null ? null : List<dynamic>.from(delivery.map((x) => x.toJson())),
    "Refund & Return": refundReturn == null ? null : List<dynamic>.from(refundReturn.map((x) => x.toJson())),
  };
}

class Delivery {
  Delivery({
    this.id,
    this.question,
    this.answer,
    this.category,
    this.modified,
  });

  String id;
  String question;
  String answer;
  String category;
  DateTime modified;

  Delivery copyWith({
    String id,
    String question,
    String answer,
    String category,
    DateTime modified,
  }) =>
      Delivery(
        id: id ?? this.id,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        category: category ?? this.category,
        modified: modified ?? this.modified,
      );

  factory Delivery.fromRawJson(String str) => Delivery.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
    id: json["id"] == null ? null : json["id"],
    question: json["question"] == null ? null : json["question"],
    answer: json["answer"] == null ? null : json["answer"],
    category: json["category"] == null ? null : json["category"],
    modified: json["modified"] == null ? null : DateTime.parse(json["modified"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "question": question == null ? null : question,
    "answer": answer == null ? null : answer,
    "category": category == null ? null : category,
    "modified": modified == null ? null : modified.toIso8601String(),
  };
}
