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
    required this.subscribes,
    required this.startSubJalali,
    required this.endSubJalali,
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
  final String startSubJalali;
  final String endSubJalali;
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
        startSubJalali: json["startSubJalali"] ?? "",
        endSubJalali: json["endSubJalali"] ?? "",
        timeOfSub: json["timeOfSub"] ?? "",
        hasChildSub: json["hasChildSub"],
        hasAdultSub: json["hasAdultSub"],
        hasNationalSub: json["hasNationalSub"],
      );
}
