import 'dart:convert';
import 'package:zabaner/models/urls.dart';

List<OnlineClass> onlineClassListModelFromJson(String str) => List<OnlineClass>.from(json.decode(str).map((x) => OnlineClass.fromJson(x)));

String onlineClassListModelToJson(List<OnlineClass> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OnlineClass {
  final String id;

  OnlineClass({
    required  this.id,
    required  this.teacherId,
    required  this.title,
    required  this.userId,
    required  this.teacherName,
    required  this.userName,
    required  this.language,
    required  this.classPrice,
    required  this.classTimes,
    required  this.paymentState,
    required  this.rating,
    required  this.classLink,
    required  this.classStatus,
    required  this.classCount,
    required  this.lastUpdate,
  });
  final String title;
  final String teacherId;
  final String userName;
  final String teacherName;
  final String userId;
  final String language;
  final String classPrice;
  final String classTimes;
  final String rating;
  final String paymentState;
  final String classLink;
  final String classCount;
  final String classStatus;
  final String lastUpdate;

  factory OnlineClass.fromJson(Map<String, dynamic> json){
    return OnlineClass(
      id: json["_id"],
      title: json["title"] ?? "",
      teacherId: json["teacherId"] ?? "",
      userId: json["userId"] ?? "",
      userName: json["userName"] ?? "",
      teacherName: json["teacherName"] ?? "",
      language: json["language"] ?? "",
      classPrice: json["classPrice"] ?? "",
      paymentState: (json["paymentState"] ?? "none") == "" ? "none" : (json["paymentState"] ?? "none"),
      classTimes: json["classTimes"] ?? "",
      rating: json["rating"] ?? "0",
      classLink: json["classLink"] ?? "",
      classStatus: json["classStatus"] ?? "",
      classCount: json["classCount"] ?? "0",
      lastUpdate: json["lastUpdate"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "teacherId": teacherId,
    "userId": userId,
    "teacherName": teacherName,
    "userName": userName,
    "language": language,
    "classPrice": classPrice,
    "classTimes": classTimes,
    "classLink": classLink,
    "classStatus": classStatus,
    "classCount": classCount,
    "lastUpdate": lastUpdate,
  };
}
