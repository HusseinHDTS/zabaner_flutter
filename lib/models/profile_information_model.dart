// To parse this JSON data, do
//
//     final profileInformation = profileInformationFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

ProfileInformation profileInformationFromJson(String str) =>
    ProfileInformation.fromJson(json.decode(str));

class ProfileInformation {
  ProfileInformation({
    required this.userId,

    required this.email,
    required this.mobile,
    required this.firstName,
    required this.lastName,
    this.avatarPath,
    required this.bDay,
    required this.username,
    required this.registerMethod,
    required this.jalaliChildSubscribeStart,
    required this.jalaliChildSubscribeEnd,
    required this.jalaliAdultSubscribeStart,
    required this.jalaliAdultSubscribeEnd,
    required this.jalaliNationalSubscribeStart,
    required this.jalaliNationalSubscribeEnd,
    required this.subscribes,
    required this.timeOfSub,
    required this.hasChildSub,
    required this.hasAdultSub,
    required this.hasNationalSub,
  });

  final String userId;
  final String email;
  final String mobile;
  final String firstName;
  final String lastName;
  final String? avatarPath;
  final DateTime bDay;
  final String username;
  final String registerMethod;
  final String subscribes;
  final String jalaliChildSubscribeStart;
  final String jalaliChildSubscribeEnd;
  final String jalaliAdultSubscribeStart;
  final String jalaliAdultSubscribeEnd;
  final String jalaliNationalSubscribeStart;
  final String jalaliNationalSubscribeEnd;
  final String timeOfSub;
  final String? hasChildSub;
  final String? hasAdultSub;
  final String? hasNationalSub;

  factory ProfileInformation.fromJson(Map<String, dynamic> json) =>
      ProfileInformation(
        userId: json["userId"] ?? "",
        email: json["email"] ?? "",
        mobile: json["mobile"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        avatarPath: json["avatarPath"] == null
            ? "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Disc_Plain_cyan.svg/1200px-Disc_Plain_cyan.svg.png"
            : baseUrl + json["avatarPath"],
        bDay: DateTime.parse(json["bDay"] ?? "2020-07-10 15:00:00.000"),
        username: json["username"] ?? "",
        registerMethod: json["registerMethod"] ?? "",
        subscribes: json["subscribes"] ?? "",
        timeOfSub: json["timeOfSub"] ?? "",
        jalaliAdultSubscribeEnd: json["jalaliAdultSubscribeEnd"] ?? "",
        jalaliAdultSubscribeStart: json["jalaliAdultSubscribeStart"] ?? "",
        jalaliChildSubscribeEnd: json["jalaliChildSubscribeEnd"] ?? "",
        jalaliChildSubscribeStart: json["jalaliChildSubscribeStart"] ?? "",
        jalaliNationalSubscribeEnd: json["jalaliNationalSubscribeEnd"] ?? "",
        jalaliNationalSubscribeStart: json["jalaliNationalSubscribeStart"] ?? "",
        hasChildSub: (json["hasChildSub"] ?? ""),
        hasAdultSub: (json["hasAdultSub"] ?? ""),
        hasNationalSub: (json["hasNationalSub"] ?? ""),
      );
}
