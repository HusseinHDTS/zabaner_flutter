// To parse this JSON data, do
//
//     final bookListModel = bookListModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<TabbarItem> tabbarItemListModelFromJson(String str) => List<TabbarItem>.from(json.decode(str).map((x) => TabbarItem.fromJson(x)));

String tabbarItemListModelToJson(List<TabbarItem> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TabbarItem {
  TabbarItem({
      required  this.id,
      required  this.image,
      required  this.title,
      required  this.subCategory,
      required  this.category,
      required  this.video,
      required  this.pdf,
    });

    final String id;
    final String image;
    final String title;
    final String subCategory;
    final String category;
    final String video;
    final String pdf;

    factory TabbarItem.fromJson(Map<String, dynamic> json) {
      String imagePath = getUrl(json["imagePath"]);
      String filePath = getUrl(json["videoPath"]);
      String pdfPath = getUrl(json["pdfPath"]);
      return TabbarItem(
        id: json["_id"],
        image: imagePath,
        title: json["title"],
        subCategory: json["subCategory"],
        category: json["category"],
        video: filePath,
        pdf: pdfPath,
      );
    }

    Map<String, dynamic> toJson() => {
        "_id": id,
        "image": image,
        "title": title,
        "subCategory": subCategory,
        "category": category,
        "video": video,
        "pdf": pdf,
    };
}
