// To parse this JSON data, do
//
//     final bookListModel = bookListModelFromJson(jsonString);

import 'dart:convert';

import 'package:zabaner/models/urls.dart';

List<Conversation> conversationListModelFromJson(String str) => List<Conversation>.from(json.decode(str).map((x) => Conversation.fromJson(x)));

String conversationListModelToJson(List<Conversation> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Conversation {
  Conversation({
    required  this.id,
    required  this.description,
    required  this.createAt,
    required  this.type,
    required  this.forS,
  });

  final String id;
  final String description;
  final String createAt;
  final String type;
  final String forS;

  factory Conversation.fromJson(Map<String, dynamic> json){
    return Conversation(
      id: json["_id"],
      description: json["description"] ?? "",
      createAt: json["createAt"] ?? "",
      type: json["type"] ?? "",
      forS: json["forS"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "description": description,
    "createAt": createAt,
    "type": type,
    "forS": forS,
  };
}
