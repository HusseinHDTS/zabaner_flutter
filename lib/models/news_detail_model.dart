// To parse this JSON data, do
//
//     final newsItemModel = newsItemModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

NewsItemModel newsItemModelFromJson(String str) => NewsItemModel.fromJson(json.decode(str));

String newsItemModelToJson(NewsItemModel data) => json.encode(data.toJson());

class NewsItemModel {
    NewsItemModel({
        required this.id,
        required this.faTitle,
        required this.title,
        required this.paragraphs,
        required this.wordsList,
        required this.bookmark,
        required this.imagePath,
        required this.podcastPath,
    });

    final String id;
    final String faTitle;
    final String title;
    final List<Paragraph> paragraphs;
    final List<dynamic> wordsList;
    final bool bookmark;
    final String imagePath;
    final String podcastPath;

    factory NewsItemModel.fromJson(Map<String, dynamic> json) {
        String imagePath = getUrl(json["imagePath"]);
        String podcastPath = getUrl(json["podcastPath"]);
        return NewsItemModel(
            id: json["_id"],
            faTitle: json["faTitle"],
            title: json["title"],
            paragraphs: List<Paragraph>.from(json["paragraphs"].map((x) => Paragraph.fromJson(x))),
            wordsList: List<dynamic>.from(json["wordsList"].map((x) => x)),
            bookmark: json["bookmark"],
            imagePath: imagePath,
            podcastPath: podcastPath,
        );
    }

    Map<String, dynamic> toJson() => {
        "_id": id,
        "faTitle": faTitle,
        "title": title,
        "paragraphs": List<dynamic>.from(paragraphs.map((x) => x.toJson())),
        "wordsList": List<dynamic>.from(wordsList.map((x) => x)),
        "bookmark": bookmark,
        "imagePath": imagePath,
        "podcastPath": podcastPath,
    };
}

class Paragraph {
    Paragraph({
        required this.id,
        required this.pst,
        required this.fa,
        required this.en,
        required this.startTime,
    });

    final String id;
    final int pst;
    final String fa;
    final String en;
    final String startTime;

    factory Paragraph.fromJson(Map<String, dynamic> json) => Paragraph(
        id: json["_id"],
        pst: json["pst"],
        fa: json["fa"],
        en: json["en"],
        startTime: json["startTime"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "pst": pst,
        "fa": fa,
        "en": en,
        "startTime": startTime,
    };
}
