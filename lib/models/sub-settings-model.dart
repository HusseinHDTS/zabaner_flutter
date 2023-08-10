// To parse this JSON data, do
//
//     final profileInformation = profileInformationFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

SubSettingsModel profileInformationFromJson(String str) =>
    SubSettingsModel.fromJson(json.decode(str)[0]);

class SubSettingsModel {
  SubSettingsModel({
    required this.childOMPrice,
    required this.childTMPrice,
    required this.childOYPrice,

    required this.adultOMPrice,
    required this.adultTMPrice,
    required this.adultOYPrice,

    required this.nationalOMPrice,
    required this.nationalTMPrice,
    required this.nationalOYPrice,
  });

  final int childOMPrice;
  final int childTMPrice;
  final int childOYPrice;

  final int adultOMPrice;
  final int adultTMPrice;
  final int adultOYPrice;

  final int nationalOMPrice;
  final int nationalTMPrice;
  final int nationalOYPrice;

  factory SubSettingsModel.fromJson(Map<String, dynamic> json) =>
      SubSettingsModel(
        childOMPrice: json["childOMPrice"] ?? 0,
        childTMPrice: json["childTMPrice"] ?? 0,
        childOYPrice: json["childOYPrice"] ?? 0,

        adultOMPrice: json["adultOMPrice"] ?? 0,
        adultTMPrice: json["adultTMPrice"] ?? 0,
        adultOYPrice: json["adultOYPrice"] ?? 0,

        nationalOMPrice: json["nationalOMPrice"] ?? 0,
        nationalTMPrice: json["nationalTMPrice"] ?? 0,
        nationalOYPrice: json["nationalOYPrice"] ?? 0,

      );
}
