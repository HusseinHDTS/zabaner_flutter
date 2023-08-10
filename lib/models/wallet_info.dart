import 'dart:convert';

import 'package:zabaner/models/urls.dart';

WalletInfo walletInfoModelFromJson(String str) => WalletInfo.fromJson(json.decode(str));
String walletInfoListModelToJson(List<WalletInfo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WalletInfo {
  WalletInfo({
    required  this.currentPrice,
    required  this.blockPrice,
    required  this.totalPrice,
    required  this.lastMonthPrice,
    required  this.pays,
  });

  final String currentPrice;
  final String blockPrice;
  final String totalPrice;
  final String lastMonthPrice;
  final String pays;
  factory WalletInfo.fromJson(Map<String, dynamic> json){
    return WalletInfo(
      currentPrice: (json["currentPrice"] ?? 0).toString(),
      blockPrice: (json["blockPrice"] ?? 0).toString(),
      totalPrice: (json["totalPrice"] ?? 0).toString(),
      lastMonthPrice: (json["lastMonthPrice"] ?? 0).toString(),
      pays: json["pays"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
    "currentPrice": currentPrice,
    "blockPrice": blockPrice,
    "totalPrice": totalPrice,
    "lastMonthPrice": lastMonthPrice,
    "pays": pays,
  };
}
