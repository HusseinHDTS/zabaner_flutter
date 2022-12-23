// To parse this JSON data, do
//
//     final bookParagraphModel = bookParagraphModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

BookParagraphModel bookParagraphModelFromJson(String str) =>
    BookParagraphModel.fromJson(json.decode(str));

String bookParagraphModelToJson(BookParagraphModel data) =>
    json.encode(data.toJson());

class BookParagraphModel {
  BookParagraphModel({
    required this.id,
    required this.faTitle,
    required this.title,
    required this.type,
    required this.imagePath,
    required this.paragraphs,
    required this.itemTitle,
    required this.itemFaTitle,
    required this.podcastPath,
  });

  final String id;
  final String faTitle;
  final String title;
  final String type;
  final String imagePath;
  final List<Paragraph> paragraphs;
  final String itemTitle;
  final String itemFaTitle;
  final String podcastPath;

  factory BookParagraphModel.fromJson(Map<String, dynamic> json) {
    String imagePath = getUrl(json["imagePath"]);
    String podcastPath = getUrl(json["podcastPath"]);
    return BookParagraphModel(
      id: json["_id"],
      faTitle: json["faTitle"],
      title: json["title"],
      type: json["type"],
      imagePath: imagePath,
      paragraphs: List<Paragraph>.from(
          json["paragraphs"].map((x) => Paragraph.fromJson(x))),
      itemTitle: json["itemTitle"],
      itemFaTitle: json["itemFaTitle"],
      podcastPath: podcastPath,
    );
  }


  Map<String, dynamic> toJson() => {
        "_id": id,
        "faTitle": faTitle,
        "title": title,
        "type": type,
        "imagePath": imagePath,
        "paragraphs": List<dynamic>.from(paragraphs.map((x) => x.toJson())),
        "itemTitle": itemTitle,
        "itemFaTitle": itemFaTitle,
        "podcastPath": podcastPath,
      };
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
        // pst: 7000,
        fa: json["fa"],
        en: json["en"],
        startTime: json["startTime"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "pst": pst,
        "pstEnd": pstEnd,
        "fa": fa,
        "en": en,
        "startTime": startTime,
      };
}
