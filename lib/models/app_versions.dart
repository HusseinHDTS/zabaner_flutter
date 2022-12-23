// To parse this JSON data, do
//
//     final bookListModel = bookListModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<AppVersions> versionListModelFromJson(String str) => List<AppVersions>.from(json.decode(str).map((x) => AppVersions.fromJson(x)));

String versionListModelToJson(List<AppVersions> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AppVersions {
  AppVersions({
    required  this.id,
    required  this.isActive,
    required  this.isForce,
    required  this.version,
    required  this.googlePlayLink,
    required  this.bazaarLink,
    required  this.directLink,
    required  this.description,
  });

  final String id;
  final bool isActive;
  final bool isForce;
  final String version;
  final String googlePlayLink;
  final String bazaarLink;
  final String directLink;
  final String description;

  factory AppVersions.fromJson(Map<String, dynamic> json){
    String isF = json["isForce"] ?? "";
    return AppVersions(
      id: json["_id"],
      isActive: json["isActive"] == "active",
      isForce: isF == "yes" ? true : false,
      version: json["version"] ?? "",
      googlePlayLink: json["googlePlayLink"] ?? "",
      bazaarLink: json["bazarLink"] ?? "",
      directLink: json["directLink"] ?? "",
      description: json["description"] ?? "" ,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "isActive": isActive == true ? "active" : "deActive",
    "isForce": isActive == true ? "yes" : "no",
    "version": version,
    "googlePlayLink": googlePlayLink,
    "bazarLink": bazaarLink,
    "directLink": directLink,
    "description": description,
  };
}
