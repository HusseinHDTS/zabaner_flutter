// To parse this JSON data, do
//
//     final bookListModel = bookListModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:zabaner/models/urls.dart';

List<UserTeachers> userTeachersListModelFromJson(String str) => List<UserTeachers>.from(json.decode(str).map((x) => UserTeachers.fromJson(x)));

String userTeachersListModelToJson(List<UserTeachers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserTeachers {
  UserTeachers({
    required  this.id,
    required  this.teacherId,
    required  this.totalCTime,
    required  this.userId,
    required  this.showProfile,
    required  this.imagePath,
    required  this.name,
    required  this.family,
    required  this.description,
    required  this.freeTimes,
    required  this.videoPath,
    required  this.educationLevel,
    required  this.educationIn,
    required  this.videoImagePath,
    required  this.ageRating,
    required  this.expertise,
    required  this.rating,
    required  this.ratingCount,
    required  this.expertiseString,
    required  this.testClassPrice,
    required  this.normal1ClassPrice,
    required  this.normal3ClassPrice,
    required  this.normal5ClassPrice,
    required  this.normal10ClassPrice,
  });

  final String id;
  final String teacherId;
  final String totalCTime;
  final String userId;
  final bool showProfile;
  final String imagePath;
  final String name;
  final String family;
  final String description;
  final String videoPath;
  final String videoImagePath;
  final String educationLevel;
  final String educationIn;
  final String ageRating;
  final String expertise;
  final String freeTimes;
  final String expertiseString;
  final String rating;
  final String ratingCount;
  final String normal1ClassPrice;
  final String normal3ClassPrice;
  final String normal5ClassPrice;
  final String normal10ClassPrice;
  final String testClassPrice;

  factory UserTeachers.fromJson(Map<String, dynamic> json){
    String imagePath = getUrl(json["showingImagePath"]);
    return UserTeachers(
      id: json["_id"],
      showProfile: json["showProfile"] == "true",
      teacherId: json["title"] ?? "",
      userId: json["userId"] ?? "",
      totalCTime: json["totalCTime"] ?? "0",
      imagePath: imagePath,
      name: json["name"] ?? "",
      family: json["family"] ?? "",
      description: json["description"] ?? "",
      videoPath: json["videoPath"] ?? "",
      videoImagePath: json["videoImagePath"] ?? "",
      educationLevel: json["educationLevel"] ?? "" ,
      freeTimes: json["freeTimes"] ?? "" ,
      educationIn: json["educationIn"] ?? "" ,
      ageRating: json["ageRating"] ?? "" ,
      expertise: json["expertise"] ?? "" ,
      rating: (json["rating"] ?? "0").toString().replaceAll("NaN", "") ,
      ratingCount: (json["ratingCount"] ?? "0").toString().replaceAll("NaN", ""),
      expertiseString: json["expertiseString"] ?? "" ,
      testClassPrice: json["testClassPrice"] ?? "0" ,
      normal1ClassPrice: json["normal1ClassPrice"] ?? "0" ,
      normal3ClassPrice: json["normal3ClassPrice"] ?? "0" ,
      normal5ClassPrice: json["normal5ClassPrice"] ?? "0" ,
      normal10ClassPrice: json["normal10ClassPrice"] ?? "0" ,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "showProfile": showProfile == true ? "true" : "false",
    "imagePath": imagePath,
    "totalCTime": totalCTime,
    "userId": userId,
    "title": teacherId,
    "name": name,
    "family": family,
    "videoImagePath": videoImagePath,
    "description": description,
    "videoPath": videoPath,
    "educationLevel": educationLevel,
    "educationIn": educationIn,
    "ageRating": ageRating,
    "freeTimes": freeTimes,
    "expertise": expertise,
    "rating": rating,
    "ratingCount": ratingCount,
    "expertiseString": expertiseString,
    "normal1ClassPrice": normal1ClassPrice,
    "normal3ClassPrice": normal3ClassPrice,
    "normal5ClassPrice": normal5ClassPrice,
    "normal10ClassPrice": normal10ClassPrice,
    "testClassPrice": testClassPrice,
  };
}
