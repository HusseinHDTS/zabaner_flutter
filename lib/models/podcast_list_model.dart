// To parse this JSON data, do
//
//     final podcastListModel = podcastListModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<PodcastListModel> podcastListModelFromJson(String str) => List<PodcastListModel>.from(json.decode(str).map((x) => PodcastListModel.fromJson(x)));

String podcastListModelToJson(List<PodcastListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PodcastListModel {
    PodcastListModel({
      required  this.id,
      required  this.podcastTime,
      required  this.category,
      required  this.description,
      required  this.faTitle,
      required  this.title,
      required  this.imagePath,
      required  this.podcastPath,
    });

    final String id;
    final int podcastTime;
    final String description;
    final String category;
    final String faTitle;
    final String title;
    final String imagePath;
    final String podcastPath;

    factory PodcastListModel.fromJson(Map<String, dynamic> json) {
      String imagePath = getUrl(json["imagePath"].toString());
      String podcastPath = getUrl(json["podcastPath"].toString());
      return PodcastListModel(
        id: json["_id"],
        podcastTime: json["podcastTime"],
        category: json["category"] ?? "",
        description: json["description"],
        faTitle: json["faTitle"],
        title: json["title"],
        imagePath:imagePath,
        podcastPath: podcastPath,
      );
    }

    Map<String, dynamic> toJson() => {
        "_id": id,
        "podcastTime": podcastTime,
        "description": description,
        "category": category,
        "faTitle": faTitle,
        "title": title,
        "imagePath": imagePath,
        "podcastPath": podcastPath,
    };
}
