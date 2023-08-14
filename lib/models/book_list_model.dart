// To parse this JSON data, do
//
//     final bookListModel = bookListModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<BookListModel> bookListModelFromJson(String str) => List<BookListModel>.from(json.decode(str).map((x) => BookListModel.fromJson(x)));

String bookListModelToJson(List<BookListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookListModel {
    BookListModel({
      required  this.id,
      required  this.podcastTime,
      required  this.wordsCount,
      required  this.customText,
      required  this.level,
      required  this.genre,
      required  this.faTitle,
      required  this.accent,
      required  this.title,
      required  this.category,
      required  this.imagePath,
    });

    final String id;
    final int podcastTime;
    final int wordsCount;
    final String accent;
    final String level;
    final String genre;
    final String faTitle;
    final String title;
    final String customText;
    final String category;
    final String imagePath;

    factory BookListModel.fromJson(Map<String, dynamic> json){
      String imagePath = getUrl(json["imagePath"]);
      return BookListModel(
        id: json["_id"],
        podcastTime: json["podcastTime"],
        wordsCount: json["wordsCount"],
        accent: json["accent"] ?? "",
        level: json["itemLevel"] ?? "",
        genre: json["itemGenre"] ?? "",
        customText: json["customText"] ?? "",
        faTitle: json["faTitle"],
        title: json["title"],
        category: json["category"],
        imagePath: imagePath ,
      );
    }

    Map<String, dynamic> toJson() => {
        "_id": id,
        "podcastTime": podcastTime,
        "wordsCount": wordsCount,
        "customText": customText,
        "itemLevel": level,
        "itemGenre": genre,
        "accent": accent,
        "faTitle": faTitle,
        "title": title,
        "category": category,
        "imagePath": imagePath,
    };
}
