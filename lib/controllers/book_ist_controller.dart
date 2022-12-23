import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/book_chapter_model.dart';
import 'package:zabaner/models/book_list_model.dart';
import 'package:zabaner/models/urls.dart';

class BookListController extends GetxController with StateMixin {
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  late final BookChapterModel bookModel;

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
    int size = bookModel.items.length;
    int fullTime = 0;
    for(int i = 0 ; i < size ; i ++){
      var item = bookModel.items[i];
      fullTime+=item.podcastTime;
    }

    return fullTime.toString();
  }
  late final List<BookListModel> model;
  Future<void> getData() async {
    final _request = await _getConnect.get(getBookDetailUrl);
    if (_request.statusCode == 200) {
      model = bookListModelFromJson(_request.bodyString ?? "").reversed.toList();
      model.removeWhere(((element) {
        filter ??= "";
        return element.category.trim().toString() != filter!.trim().toString();
      }));
      change(null, status: RxStatus.success());
    } else {
      getData();
    }
  }
}
