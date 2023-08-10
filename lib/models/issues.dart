// To parse this JSON data, do
//
//     final bookListModel = bookListModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<Issues> issueListModelFromJson(String str) => List<Issues>.from(json.decode(str).map((x) => Issues.fromJson(x)));

String issueListModelToJson(List<Issues> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Issues {
  Issues({
    required  this.id,
    required  this.description,
    required  this.title,
  });

  final String id;
  String title;
  String description;

  factory Issues.fromJson(Map<String, dynamic> json){
    return Issues(
      id: json["_id"],
      description: json["description"] ?? "",
      title: json["title"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "description": description,
    "title": title,
  };
}
