import 'dart:convert';
import 'package:zabaner/models/urls.dart';

List<OnlineClass> onlineClassListModelFromJson(String str) => List<OnlineClass>.from(json.decode(str).map((x) => OnlineClass.fromJson(x)));

String onlineClassListModelToJson(List<OnlineClass> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OnlineClass {
  OnlineClass({
    required  this.id,
    required  this.teacherId,
    required  this.userId,
    required  this.userName,
    required  this.language,
    required  this.classPrice,
    required  this.classTimes,
    required  this.classLink,
    required  this.classStatus,
    required  this.classCount,
    required  this.lastUpdate,
  });

  final String id;
  final String teacherId;
  final String userName;
  final String userId;
  final String language;
  final String classPrice;
  final String classTimes;
  final String classLink;
  final String classCount;
  final String classStatus;
  final String lastUpdate;

  factory OnlineClass.fromJson(Map<String, dynamic> json){
    return OnlineClass(
      id: json["_id"],
      teacherId: json["teacherId"] ?? "",
      userId: json["userId"] ?? "",
      userName: json["userName"] ?? "",
      language: json["language"] ?? "",
      classPrice: json["classPrice"] ?? "",
      classTimes: json["classTimes"] ?? "",
      classLink: json["classLink"] ?? "",
      classStatus: json["classStatus"] ?? "",
      classCount: json["classCount"] ?? "",
      lastUpdate: json["lastUpdate"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "teacherId": teacherId,
    "userId": userId,
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
