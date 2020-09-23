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

  factory FaqModel.fromRawJson(String str) =>
      FaqModel.fromJson(json.decode(str));

//  String toRawJson() => json.encode(toJson());

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

//  Map<String, dynamic> toJson() => {
//        "success": success == null ? null : success,
//        "data": data == null ? null : data.toJson(),
//      };
}

class Data {
  Data(this.keysList, this.faqCategoriesList);

  List<String> keysList;
  Map<String, List<FAQCategory>> faqCategoriesList;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

//  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) {
    Map<String, List<FAQCategory>> faqCategoriesList = Map();
    List<String> keysList = List();
    json.keys;
    keysList.add("All");
    List<FAQCategory> allFaq=List();
    for (String jsonKey in json.keys) {
      keysList.add(jsonKey);

      List<FAQCategory> delivery = json[jsonKey] == null
          ? null
          : List<FAQCategory>.from(
              json[jsonKey].map((x) => FAQCategory.fromJson(x)));
      allFaq.addAll(json[jsonKey] == null
          ? null
          : List<FAQCategory>.from(
          json[jsonKey].map((x) => FAQCategory.fromJson(x))));

      faqCategoriesList.putIfAbsent(jsonKey, () => delivery);
    }
    faqCategoriesList.putIfAbsent('All', () => allFaq);

    return Data(keysList, faqCategoriesList);
  }

}

class FAQCategory {
  FAQCategory({
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

  FAQCategory copyWith({
    String id,
    String question,
    String answer,
    String category,
    DateTime modified,
  }) =>
      FAQCategory(
        id: id ?? this.id,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        category: category ?? this.category,
        modified: modified ?? this.modified,
      );

  factory FAQCategory.fromRawJson(String str) =>
      FAQCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FAQCategory.fromJson(Map<String, dynamic> json) => FAQCategory(
        id: json["id"] == null ? null : json["id"],
        question: json["question"] == null ? null : json["question"],
        answer: json["answer"] == null ? null : json["answer"],
        category: json["category"] == null ? null : json["category"],
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "question": question == null ? null : question,
        "answer": answer == null ? null : answer,
        "category": category == null ? null : category,
        "modified": modified == null ? null : modified.toIso8601String(),
      };
}
