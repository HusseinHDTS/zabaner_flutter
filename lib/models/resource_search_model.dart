// To parse this JSON data, do
//
//     final resourceSearchModel = resourceSearchModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<ResourceSearchModel> resourceSearchModelFromJson(String str) =>
    List<ResourceSearchModel>.from(
        json.decode(str).map((x) => ResourceSearchModel.fromJson(x)));

class ResourceSearchModel {
  ResourceSearchModel({
    required this.id,
    required this.title,
    required this.faTitle,
    required this.type,
    required this.imagePath,
  });

  final String id;
  final String title;
  final String faTitle;
  final String type;
  final String imagePath;

  factory ResourceSearchModel.fromJson(Map<String, dynamic> json) {
    String imagePath = getUrl(json["imagePath"]);
    return ResourceSearchModel(
      id: json["_id"],
      title: json["title"],
      faTitle: json["faTitle"],
      type: json["type"],
      imagePath: imagePath,
    );
  }

}
