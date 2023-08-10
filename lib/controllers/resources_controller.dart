import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/models/resource_search_model.dart';
import 'package:zabaner/models/resources_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/screens/resources_screen.dart';

class ResourcesController extends GetxController with StateMixin {
  final GetConnect _getConnect = GetConnect();
  FocusNode focus = FocusNode();
  var dataError = false.obs;
  var isDataLoaded = false.obs;
  var categories = [];
  var podcastCategories = [];
  var videoCategories = [];
  var ieltsCategories = [];
  var tedCategories = [];
  var ieltsGeneralCategories = [];
  var anyCatLength = [];
  List<ResourcesData> resourcesList = [];
  TextEditingController textController = TextEditingController();
  RefreshController refreshController = RefreshController();

  @override
  void onInit() async {
    super.onInit();
    GetStorage.init();
    _getConnect.allowAutoSignedCert = true;
    getResources();
  }

  void closeSearch(){
    ResourcesScreen.onSearchClick.value=false;
    textController.clear();
    focus.unfocus();
  }

  Future<void> getResources() async {
    dataError.value = false;
    isDataLoaded.value = false;
    _getConnect.allowAutoSignedCert = true;
    var request = await _getConnect.get(resourcesUrl);
    var request1 = await _getConnect.get(subCategoryUrl);
    var request2 = await _getConnect.get(videoCategoryUrl);
    var request3 = await _getConnect.get(podcastCategoryUrl);
    var request4 = await _getConnect.get(getMagooshCategory);
    var request6 = await _getConnect.get(getTedCategory);
    var request5 = await _getConnect.get(getGeneralMagooshCategory);
    refreshController.refreshCompleted();
    if (request.statusCode == 200 && request1.statusCode == 200) {
      resourcesList = (resourcesFromJson(request.bodyString ?? ""));
      categories = (jsonDecode(request1.bodyString ?? ""));
      videoCategories = (jsonDecode(request2.bodyString ?? ""));
      podcastCategories = (jsonDecode(request3.bodyString ?? ""));
      ieltsCategories = (jsonDecode(request4.bodyString ?? ""));
      ieltsGeneralCategories = (jsonDecode(request5.bodyString ?? ""));
      tedCategories = (jsonDecode(request6.bodyString ?? ""));
      isDataLoaded.value = true;
    } else {
      dataError.value = true;
    }


  }

  get getProfileImage {
    final GetStorage _getStorage = GetStorage();
    return _getStorage.read('profile_image');
  }
}

class ResourcesSearch extends GetConnect {
  var searchState = "".obs;
  List<ResourceSearchModel> searchContent = [];
  void search(String title) async {
    allowAutoSignedCert = true;
    searchState.value = "loading";
    var _request = await get(resourcesSearchUrl, query: {'title': title});
    if (_request.statusCode == 200) {
      searchContent.clear();
      searchContent
          .addAll(resourceSearchModelFromJson(_request.bodyString ?? ""));
      if (searchContent.isNotEmpty) {
        searchState.value = "success";
      }
      if (searchContent.isEmpty) {
        searchContent.clear();
        searchState.value = "empty";
      }
    } else {
      searchState.value = "error";
    }
  }
}
