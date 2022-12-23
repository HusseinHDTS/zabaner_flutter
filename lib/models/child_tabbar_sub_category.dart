// To parse this JSON data, do
//
//     final bookListModel = bookListModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<SubCategoryItem> subCategoryListModelFromJson(String str) => List<SubCategoryItem>.from(json.decode(str).map((x) => SubCategoryItem.fromJson(x)));

String subCategoryListModelToJson(List<SubCategoryItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SubCategoryItem {
  SubCategoryItem({
    required  this.id,
    required  this.image,
    required  this.title,
    required  this.category,
  });

  final String id;
  final String image;
  final String title;
  final String category;

  factory SubCategoryItem.fromJson(Map<String, dynamic> json){
    String imagePath = getUrl(json["imagePath"]);
    return  SubCategoryItem(
          id: json["_id"],
          image: imagePath,
          title: json["title"],
          category: json["category"],
);
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "image": image,
    "title": title,
    "category": category,
  };
}
