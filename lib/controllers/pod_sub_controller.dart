import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/models/book_chapter_model.dart';
import 'package:zabaner/models/book_list_model.dart';
import 'package:zabaner/models/pod_sub_categories.dart';
import 'package:zabaner/models/urls.dart';

class PodcSubController extends GetxController {
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  RefreshController refreshController = RefreshController();
  var subCategories = <PodSubCategories>[].obs;
  var errorData = false.obs;
  var isDataLoaded = false.obs;
  String? filter;
  String? link;
  PodcSubController({this.filter,this.link});

  @override
  void onInit() async {
    super.onInit();
    await getData();
  }

  Future<void> getData({String? tLink}) async {
    errorData.value = false;
    isDataLoaded.value = false;
    link??=getPodcastSub1Categories;
    tLink??=link;
    var bodyRequest = {
      "category": filter.toString(),
    };
    final _request = await _getConnect.post(tLink,bodyRequest);
      subCategories.value = podSubCatListModelFromJson(_request.bodyString ?? "");
      refreshController.refreshCompleted();
      isDataLoaded.value = true;
      // change(null, status: RxStatus.success());
      // errorData.value = true;
      // getData();
    // }
  }
}
class PodcSub1Controller extends GetxController {
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  RefreshController refreshController = RefreshController();
  var subCategories = <PodSubCategories>[].obs;
  var errorData = false.obs;
  var isDataLoaded = false.obs;
  String? filter;
  String? link;
  bool? normal;
  PodcSub1Controller({this.filter,this.link,this.normal});

  @override
  void onInit() async {
    normal??=true;
    super.onInit();
    await getData();
  }

  Future<void> getData({String? tLink}) async {
    errorData.value = false;
    isDataLoaded.value = false;
    link??=getPodcastSub1Categories;
    tLink??=link;
    var bodyRequest = {
      "category": filter.toString(),
      "wtu": normal.toString(),
    };
    final _request = await _getConnect.post(tLink,bodyRequest);
      subCategories.value = podSubCatListModelFromJson(_request.bodyString ?? "");
      refreshController.refreshCompleted();
      isDataLoaded.value = true;
      // change(null, status: RxStatus.success());
      // errorData.value = true;
      // getData();
    // }
  }
}
