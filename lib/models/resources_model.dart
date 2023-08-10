// To parse this JSON data, do
//
//     final resources = resourcesFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<ResourcesData> resourcesFromJson(String str) => List<ResourcesData>.from(
    json.decode(str).map((x) => ResourcesData.fromJson(x)));

class ResourcesData {
  ResourcesData({
    required this.type,
    required this.resources,
  });

  final String type;
  final List<Resource> resources;

  factory ResourcesData.fromJson(Map<String, dynamic> json) => ResourcesData(
        type: json["type"],
        resources: List<Resource>.from(
            json["resources"].map((x) => Resource.fromJson(x))),
      );
}

class Resource {
  Resource({
    required this.id,
    required this.title,
    required this.imagePath,
  });

  final String id;
  final String title;
  final String imagePath;


  factory Resource.fromJson(Map<String, dynamic> json) {
    String imagePath = getUrl(json["imagePath"]);
    return Resource(
      id: json["_id"],
      title: json["title"],
      imagePath: imagePath,
    );
  }
}
