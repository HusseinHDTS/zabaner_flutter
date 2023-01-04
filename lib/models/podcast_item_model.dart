// To parse this JSON data, do
//
//     final podcastItemModel = podcastItemModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

PodcastItemModel podcastItemModelFromJson(String str) =>
    PodcastItemModel.fromJson(json.decode(str));

class PodcastItemModel {
  PodcastItemModel({
    required this.id,
    required this.faTitle,
    required this.title,
    required this.subtitle,
    required this.subtitleFa,
    required this.type,
    required this.imagePath,
    required this.paragraphs,
    required this.podcastPath,
  });

  final String id;
  final String faTitle;
  final String title;
  final String subtitle;
  final String subtitleFa;
  final String type;
  final String imagePath;
  final List<Paragraph> paragraphs;
  final String podcastPath;

  factory PodcastItemModel.fromJson(Map<String, dynamic> json) {
    String imagePath = getUrl(json["imagePath"]);
    String podcastPath = getUrl(json["podcastPath"]);
    return PodcastItemModel(
      id: json["_id"],
      faTitle: json["faTitle"],
      title: json["title"],
      subtitle: json["subtitleString"]?? "",
      subtitleFa: json["subtitleStringFa"]??"",
      type: json["type"],
      imagePath: imagePath,
      paragraphs: List<Paragraph>.from(
          json["paragraphs"].map((x) => Paragraph.fromJson(x))),
      podcastPath: podcastPath,
    );
  }

}

class Paragraph {
  Paragraph({
    required this.id,
    required this.pst,
    required this.pstEnd,
    required this.fa,
    required this.en,
    required this.startTime,
  });

  final String id;
  final int pst;
  final int pstEnd;
  final String fa;
  final String en;
  final String startTime;

  factory Paragraph.fromJson(Map<String, dynamic> json) => Paragraph(
        id: json["_id"],
        pst: json["pst"],
        pstEnd: json["pstEnd"] ?? -1,
        fa: json["fa"] ?? "",
        en: json["en"] ?? "",
        startTime: json["startTime"],
      );
}
