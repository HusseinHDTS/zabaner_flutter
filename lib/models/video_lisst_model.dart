// To parse this JSON data, do
//
//     final videoListModel = videoListModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<VideoListModel> videoListModelFromJson(String str) => List<VideoListModel>.from(json.decode(str).map((x) => VideoListModel.fromJson(x)));

String videoListModelToJson(List<VideoListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoListModel {
    VideoListModel({
      required  this.videoPath,
      required  this.description,
      required  this.id,
      required  this.title,
      required  this.faTitle,
      required  this.level,
      required  this.category,
      required  this.imagePath,
      required  this.podcastTime,
    });

    final String videoPath;
    final String description;
    final String level;
    final String id;
    final String title;
    final String faTitle;
    final String category;
    final String imagePath;
    final int podcastTime;

    factory VideoListModel.fromJson(Map<String, dynamic> json) {
      String imagePath = getUrl(json["imagePath"]);
      String videoPath = getUrl(json["videoPath"]);
      return VideoListModel(
        videoPath: videoPath,
        description: json["description"],
        id: json["_id"],
        title: json["title"],
        level: json["itemLevel"] ?? "",
        category: json["category"],
        faTitle: json["faTitle"],
        imagePath: imagePath,
        podcastTime: json["podcastTime"],
      );
    }

    Map<String, dynamic> toJson() => {
        "videoPath": videoPath,
        "description": description,
        "itemLevel": level,
        "_id": id,
        "title": title,
        "faTitle": faTitle,
        "imagePath": imagePath,
        "podcastTime": podcastTime,
    };
}
