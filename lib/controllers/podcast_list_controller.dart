import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/models/book_list_model.dart';
import 'package:zabaner/models/podcast_list_model.dart';
import 'package:zabaner/models/urls.dart';

class PodcastListController extends GetxController {
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  String? filter;
  String? from;
  RxBool errorData = false.obs;
  RefreshController refreshController = RefreshController();
  var isDataLoaded = false.obs;
  PodcastListController({this.filter,this.from});

  @override
  void onInit() async {
    super.onInit();
    await getData();
    from??="none";
  }

  late final List<PodcastListModel> model;

  Future<void> getData() async {
    isDataLoaded.value = false;
    var request0 = await _getConnect.get(getPodcastDetailUrl);
    if(from == "mainS"){
      var bodyRequest = {
        "category": filter.toString(),
      };
      var request1 = await _getConnect.post(getPodcastSub1Categories,bodyRequest);
      var req1Json = jsonDecode(request1.bodyString ?? "");
      if(req1Json.isNotEmpty) {
        var re1 = req1Json[0];
        var bodyRequest2 = {
          "category":re1['_id'],
        };
        var request2 = await _getConnect.post(
            getPodcastSubCategories, bodyRequest2);
        var req2Json = jsonDecode(request2.bodyString ?? "");
        if(req2Json.isNotEmpty){
          var re2 = req2Json[0];
          filter=re2['_id'];
        }
      }
    }
    if(from == "L1S"){
      var bodyRequest = {
        "category": filter.toString(),
      };
      var request1 = await _getConnect.post(getPodcastSubCategories,bodyRequest);
      var req1Json = jsonDecode(request1.bodyString ?? "")[0];
      filter=req1Json['_id'];
    }
    if (request0.statusCode == 200) {
      model = podcastListModelFromJson(request0.bodyString ?? "").reversed.toList();
      model.removeWhere(((element) {
        filter ??= "";
        if(filter == ""){
          return false;
        }
        return element.category.trim().toString() != filter!.trim().toString();
      }));
      isDataLoaded.value = true;
      errorData.value = false;
    } else {
      errorData.value = true;
    }
  }
}
