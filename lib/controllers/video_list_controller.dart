import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/book_list_model.dart';
import 'package:zabaner/models/podcast_list_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/video_lisst_model.dart';

class VideoListController extends GetxController {
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  String? filter;
  VideoListController({this.filter});
  var isDataLoaded = false.obs;
  @override
  void onInit() async {
    super.onInit();
    await getData();
  }

  late final List<VideoListModel> model;

  Future<void> getData() async {
    isDataLoaded.value = false;
    final _request = await _getConnect.get(getVideoDataUrl);
    if (_request.statusCode == 200) {
      model = videoListModelFromJson(_request.bodyString ?? "").reversed.toList();
      model.removeWhere(((element) {
        filter ??= "";
        return element.category.trim().toString() != filter!.trim().toString();
      }));
      isDataLoaded.value = true;
    } else {
      // errorData.value = true;
      // getData();
    }
  }
}
