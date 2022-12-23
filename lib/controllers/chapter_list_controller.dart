import 'package:get/get.dart';
import 'package:zabaner/models/book_chapter_model.dart';
import 'package:zabaner/models/urls.dart';

class ChapterController extends GetxController with StateMixin {
  ChapterController({required this.id, required this.type});
  final String id, type;
  late final BookChapterModel bookModel;
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);

  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    if(type=="book"){
      await getBookData();
    }
  }

  String getFullTime(){
    int size = bookModel.items.length;
    int fullTime = 0;
    for(int i = 0 ; i < size ; i ++){
      var item = bookModel.items[i];
      fullTime+=item.podcastTime;
    }
    return fullTime.toString();
  }
  String getFullWordsCount(){
    int size = bookModel.items.length;
    int fullTime = 0;
    for(int i = 0 ; i < size ; i ++){
      var item = bookModel.items[i];
      fullTime+=item.wordsCount;
    }
    return fullTime.toString();
  }

  Future<void> getBookData() async {
    final _request = await _getConnect.get(getBookDetailUrl + id);
    if (_request.statusCode == 200) {
      bookModel = bookChapterModelFromJson(_request.bodyString ?? "");
      change(null, status: RxStatus.success());
    } else {
      getBookData();
    }
  }
}
