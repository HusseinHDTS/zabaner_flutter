import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/models/book_chapter_model.dart';
import 'package:zabaner/models/book_list_model.dart';
import 'package:zabaner/models/urls.dart';

class BookListController extends GetxController {
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  BookChapterModel? bookModel;
  RefreshController refreshController = RefreshController();
  var errorData = false.obs;
  var isDataLoaded = false.obs;
  String? filter;
  BookListController({this.filter});

  @override
  void onInit() async {
    super.onInit();
    await getData();
  }

  Future<String> calculateTime(String id) async{
    final _request = await _getConnect.get(getBookDetailUrl + id);
    if (_request.statusCode == 200) {
      bookModel = bookChapterModelFromJson(_request.bodyString ?? "");
    }
    int size = bookModel!.items.length;
    int fullTime = 0;
    for(int i = 0 ; i < size ; i ++){
      var item = bookModel!.items[i];
      fullTime+=int.tryParse(item.podcastTime.toString()) ?? 0;
    }

    return fullTime.toString();
  }
  List<BookListModel>? model;
  var modelTimes = <String>[].obs;
  Future<void> getData() async {
    isDataLoaded.value = false;
    errorData.value = false;
    final _request = await _getConnect.get(getBookDetailUrl);
    if (_request.statusCode == 200) {
      refreshController.refreshCompleted();
      model = bookListModelFromJson(_request.bodyString ?? "").reversed.toList();
      model!.removeWhere(((element) {
        filter ??= "";
        return element.category.trim().toString() != filter!.trim().toString();
      }));
      for (var element in model!) {
          modelTimes.add(await calculateTime(element.id));
      }
      isDataLoaded.value = true;
    } else {
      errorData.value = true;
      // getData();
    }
  }
}
