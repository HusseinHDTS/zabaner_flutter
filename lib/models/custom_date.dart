import 'dart:convert';

List<CustomDate> customDateListModelFromJson(String str) =>
    List<CustomDate>.from(json.decode(str).map((x) => CustomDate.fromJson(x)));

String customDateListModelToJson(List<CustomDate> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CustomDate {
  var year;
  var month;
  var day;
  var hour;
  var isFree;

  CustomDate({
    required this.year,
    required this.month,
    required this.day,
    required this.hour,
    required this.isFree,
  });


  factory CustomDate.fromJson(Map<String, dynamic> json) {
    return CustomDate(
      year: json["year"] ?? "",
      month: json["month"] ?? "",
      day: json["day"] ?? "",
      hour: json["hour"] ?? "",
      isFree: (json["isFree"] ?? true) == "true",
    );
  }

  Map<String, dynamic> toJson({bool? removeFree}){
    removeFree??=false;
    var result = {
      "year": year.toString(),
      "month": month.toString(),
      "day": day.toString(),
      "hour": hour.toString(),
    };
    if(!removeFree) {
      result.addAll({"isFree": isFree.toString()});
    }
    return result;
  }
}
