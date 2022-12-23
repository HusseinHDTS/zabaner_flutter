// To parse this JSON data, do
//
//     final bookListModel = bookListModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<SupportTickets> ticketsListModelFromJson(String str) => List<SupportTickets>.from(json.decode(str).map((x) => SupportTickets.fromJson(x)));

String ticketsListModelToJson(List<SupportTickets> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SupportTickets {
  SupportTickets({
    required  this.id,
    required  this.status,
    required  this.mobile,
    required  this.mTitle,
    required  this.title,
  });

  final String id;
  final String status;
  final String mobile;
  final String mTitle;
  final String title;

  factory SupportTickets.fromJson(Map<String, dynamic> json){
    return SupportTickets(
      id: json["_id"],
      status: json["status"] ?? "",
      mobile: json["mobile"] ?? "",
      mTitle: json["mTitle"] ?? "",
      title: json["title"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "status": status,
    "mobile": mobile,
    "mTitle": mTitle,
    "title": title,
  };
}
