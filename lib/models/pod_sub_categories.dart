import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<PodSubCategories> podSubCatListModelFromJson(String str) => List<PodSubCategories>.from(json.decode(str).map((x) => PodSubCategories.fromJson(x)));

String podSubCatListModelToJson(List<PodSubCategories> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PodSubCategories {
  PodSubCategories({
    required  this.id,
    required  this.title,
    required  this.category,
    required  this.isDirect,
    required  this.imagePath,
  });

  final String id;
  final String title;
  final String isDirect;
  final String category;
  final String imagePath;

  factory PodSubCategories.fromJson(Map<String, dynamic> json){
    String imagePath = getUrl(json["imagePath"] ?? "");
    return PodSubCategories(
      id: json["_id"],
      title: json["title"] ?? "",
      isDirect: json["isDirect"] ?? "",
      category: json["category"] ?? "",
      imagePath: imagePath,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "title": title,
    "category": category,
    "isDirect": isDirect,
    "imagePath": imagePath,
  };
}
