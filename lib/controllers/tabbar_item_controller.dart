import 'package:better_player/better_player.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/models/video_items_model.dart';
import 'package:video_player/video_player.dart';
import 'package:zabaner/views/colors.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:zabaner/views/screens/login_screen.dart';
import 'dart:io' as io;

import 'package:zabaner/widgets/colored_snack.dart';

class TabbarItemController extends GetxController with StateMixin {
  // late VideoModel videoModel;
  late VideoPlayerController _videoController;
  late ChewieController chewieController;

  var isHide = false.obs;
  var videoInitialized = false.obs;
  var fa = true.obs;
  var en = true.obs;
  var repeat = false.obs;
  var duration = const Duration().obs;
  var playSpeed = 1.0.obs;
  late io.Directory appDoc;

  var downloadingPercent = 0.0.obs;
  var downloadingPercentPDF = 0.0.obs;

  var downloadingState = "".obs;

  var playerPosition = const Duration().obs;
  late DateTime _dateTime;
  var playingText = "".obs;
  var playingTextFa = "".obs;
  final GetConnect _getConnect = GetConnect();
  final GetStorage _getStorage = GetStorage();
  RefreshController refreshController = RefreshController();
  var errorData = false.obs;
  var isPlaying = false.obs;
  final Dio dio = Dio();
  var playIndex = -1;
  RxBool autoScroll = true.obs;
  late AutoScrollController scrollController;
  var bookmark = false.obs;
  @override
  void onInit() async {
    super.onInit();
    _getConnect.allowAutoSignedCert = true;
    scrollController = AutoScrollController();
  }

  @override
  void dispose() async {
    super.dispose();
    onClose();
    chewieController.dispose();
  }

  void customeInit(item) {
    _dateTime = DateTime.now();
    playIndex = 0;
    isPlaying = false.obs;
    isHide = false.obs;
    fa = true.obs;
    en = true.obs;
    playSpeed.value = 1;
    playIndex = 0;
    downloadingPercent = 0.0.obs;
    downloadingPercentPDF = 0.0.obs;
    downloadingState = "".obs;
    repeat = false.obs;
    playingText = "".obs;
    duration = const Duration(milliseconds: 0).obs;
    playerPosition = const Duration(milliseconds: 0).obs;
    if (item.video.substring(item.video.lastIndexOf(".") + 1) == "mp4") {
      download(item.video, item.id, item.title);
    } else {
      Get.back();
      ColoredSnack(
          title: "ویدیویی برای این بخش وجود ندارد", type: SnackType.ERROR);
    }
  }

  @override
  void onClose() async {
    // TODO: implement onClose
    super.onClose();
    Map times = _getStorage.read('timers') ?? {};
    var lastTimer = times[
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'] ??
        0;
    if (times[
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'] ==
        null) {
      times.addAll(<String, int>{
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}':
            ((DateTime.now().difference(_dateTime).inSeconds / 3 * 2) +
                    lastTimer)
                .toInt()
      });
    } else {
      times['${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'] =
          ((DateTime.now().difference(_dateTime).inSeconds / 3 * 2) + lastTimer)
              .toInt();
    }
    if (times['totall'] == null) {
      times.addAll(<String, dynamic>{
        'totall': ((DateTime.now().difference(_dateTime).inSeconds / 3 * 2) +
                lastTimer)
            .toInt()
      });
    } else {
      var n = DateTime.now();
      print(_dateTime);
      print(n);
      var add = n.difference(_dateTime);
      print(add.inSeconds);
      times['totall'] = times['totall'] + (add.inSeconds).toInt();
    }
    await _getStorage.write('timers', times);
    // _getStorage.remove('timers');
    print(_getStorage.read('timers'));
    try{
      chewieController.pause();
    }catch(e){
      e.printError();
    }
  }




  void play() async{
    bool forced = await isScreenForced();

    if (chewieController.isPlaying) {
      isPlaying.value = true;
      duration.value = chewieController.videoPlayerController.value.duration;
      playerPosition.value = chewieController.videoPlayerController.value.position;
      if(!forced){
        keepScreenOn();
      }
    } else {
      if(forced){
        keepScreenNormal();
      }
      isPlaying.value = false;
    }
  }

  void bookmarkToggle(String id) async {
    _getConnect.allowAutoSignedCert = true;

    var _request = await _getConnect.post(
        bookmarkToggleUrl, {'type': 'videos', 'bookmarkAbleId': id},
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${_getStorage.read('token')}'
        },
        contentType: "application/json");
    print(_request.body);
    if (_request.statusCode == 201) {
      _request.body['action'] == "created"
          ? bookmark.value = true
          : bookmark.value = false;
    } else {
      ColoredSnack(title: "Error",description: _request.statusText.toString(),type: SnackType.ERROR);
    }
  }
  AndroidInitializationSettings initializationSettingsAndroid =const AndroidInitializationSettings('podcast');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =FlutterLocalNotificationsPlugin();

  Future<void> _initNotification(String filePath) async {
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,);
     AndroidNotificationDetails androidNotificationDetails =  AndroidNotificationDetails("Zabaner", "Zabaner");
    NotificationDetails notificationDetails =NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.show(0, "دانلود فایل تکمیل شد!", "برای باز کردن فایل کلیک کنید",notificationDetails ,payload: filePath);
  }

  void downloadPDF(String urlPath, String id, String title) async{
    title += ".pdf";
    appDoc = await path.getApplicationDocumentsDirectory();
      Get.defaultDialog(
          title: "در حال دانلود ویدیو",
          onWillPop: () async => downloadingPercent.value == 1 ? true : false,
          backgroundColor: orange,
          content: Obx(() =>
              CircularProgressIndicator(
                value: downloadingPercent.value,
              )));
      var _downloadRequest = await dio
          .download(urlPath, appDoc.path + id + title,
          onReceiveProgress: (recive, total) {
            downloadingState.value = "downloading";
            downloadingPercent.value = recive / total;
          });
      try {
        Get.closeAllSnackbars();
        Get.back();
      } catch (e) {
        e.printError();
      }

      if (_downloadRequest.statusCode == 200) {
        try{
          ColoredSnack(title: "دانلود با موفقیت به اتمام رسید",type: SnackType.SUCCESS);
        }catch (e){
          e.printError();
        }
        downloadingPercent.value = 0;
        _initNotification(io.File(appDoc.path + id + title).path);
      }
  }


  Future<void> download(String urlPath, String id, String title) async {
    errorData.value = false;
    appDoc = await path.getApplicationDocumentsDirectory();
    io.File _checkFile = io.File(getUrlFileName(appDoc.path,id,urlPath));
    if (!_checkFile.existsSync()) {
      downloadDialog(downloadingPercent: downloadingPercent, title: "در حال دانلود ویدیو");
      var _downloadRequest = await dio
          .download(urlPath,  getUrlFileName(appDoc.path,id,urlPath),
          onReceiveProgress: (recive, total) {
            downloadingState.value = "downloading";
            downloadingPercent.value = recive / total;

            print(downloadingPercent);
          });
      Get.closeAllSnackbars();
      Get.back();

      if (_downloadRequest.statusCode == 200) {
        ColoredSnack(title: "دانلود با موفقیت به اتمام رسید",type: SnackType.SUCCESS);
        downloadingPercent.value = 0;
        // _videoController.addListener(play);
      }
    } else {
    }
    BetterPlayerConfiguration betterPlayerConfiguration =
    const BetterPlayerConfiguration(
      aspectRatio: 16/9,
      fit: BoxFit.contain,
      controlsConfiguration: BetterPlayerControlsConfiguration(showControlsOnInitialize: false),
    );
    BetterPlayerDataSource dataSource;
    dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, urlPath);
    if (fileExists( getUrlFileName(appDoc.path,id,urlPath))) {
      debugPrint("sdasdsadsaeqwesad : FILE" );
      dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.file, getUrlFileName(appDoc.path,id,urlPath));
      _videoController = VideoPlayerController.file(
          io.File(getUrlFileName(appDoc.path,id,urlPath)));

    }
    else {
      dataSource = BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, urlPath);
      _videoController =
          VideoPlayerController.network(urlPath);

    }
    videoInitialized.value = true;

    chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: false,
      hideControlsTimer: const Duration(seconds: 2),
      aspectRatio: 16 / 9,
      showControls: true,
      showControlsOnInitialize: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
    );
    _videoController.addListener(play);
    refreshController.refreshCompleted();
  }

  bool fileExists(String path) {
    io.File _checkFile = io.File(path);
    return _checkFile.existsSync();
  }

}
