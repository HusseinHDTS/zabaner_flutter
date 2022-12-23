import 'package:get/get.dart';
import 'package:zabaner/models/book_list_model.dart';
import 'package:zabaner/models/podcast_list_model.dart';
import 'package:zabaner/models/urls.dart';

class PodcastListController extends GetxController with StateMixin {
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  String? filter;
  PodcastListController({this.filter});

  @override
  void onInit() async {
    super.onInit();
    await getData();
  }

  late final List<PodcastListModel> model;

  Future<void> getData() async {
    final _request = await _getConnect.get(getPodcastDetailUrl);
    if (_request.statusCode == 200) {
      model = podcastListModelFromJson(_request.bodyString ?? "").reversed.toList();
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
