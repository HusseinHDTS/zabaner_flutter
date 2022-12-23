// To parse this JSON data, do
//
//     final profileInformation = profileInformationFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<UserSubModel> userSubModelFromJson(String str) => List<UserSubModel>.from(
    json.decode(str).map((x) => UserSubModel.fromJson(x)));

class UserSubModel {
  UserSubModel({
    required this.title,
    required this.userId,
    required this.timeOfSub,
    required this.type,
    required this.date,
    required this.status,
    required this.amount,
  });

  final String title;
  final String userId;
  final String timeOfSub;
  final String type;
  final String date;
  final String status;
  final String amount;

  factory UserSubModel.fromJson(Map<String, dynamic> json) => UserSubModel(
        title: json["title"] ?? "",
        userId: json["userId"] ?? "",
        timeOfSub: json["timeOfSub"] ?? "",
        type: json["type"] ?? "",
        date: json["date"] ?? "",
        status: json["status"] ?? "",
        amount: json["amount"] ?? "",
      );
}
