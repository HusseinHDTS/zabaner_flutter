import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/models/urls.dart';

class SubTabbarItemController extends GetxController{
  String filter;
  SubTabbarItemController({required this.filter});
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  RefreshController refreshController = RefreshController();
  var data = [];
  var isDataLoaded = false.obs;
  var errorData = false.obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }
  
  void getData() async{
    isDataLoaded.value =false;
    var requestBody = {
      "filter":filter.toString(),
    };
    var result = await _getConnect.post(getChildTabbarSubCategory, requestBody);
    data = jsonDecode(result.bodyString ?? "");
    isDataLoaded.value = true;
    refreshController.refreshCompleted();

  }
  
}