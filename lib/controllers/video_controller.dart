import 'package:cached_video_player/cached_video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:srt_parser/srt_parser.dart' as strP;
import 'package:zabaner/controllers/custom_video_player_controller.dart';
import 'package:zabaner/models/html.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/models/video_items_model.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'dart:io' as io;

import 'package:zabaner/widgets/custom_lyric/christian_lyrics.dart';

class VideoController extends GetxController {
  // late VideoModel videoModel;
  late VideoPlayerController _videoController;

  // late ChewieController chewieController;
  var faParagraph = <SentenceModel>[].obs;
  var enParagraph = <SentenceModel>[].obs;
  var isSubtitlesLoaded = false.obs;
  var errorData = false.obs;
  RefreshController refreshController = RefreshController();

  var isHide = false.obs;
  var videoInitialized = false.obs;
  var isDataLoaded = false.obs;
  var fa = true.obs;
  var en = true.obs;
  var enDisable = false.obs, faDisable = false.obs;
  var repeat = false.obs;
  var duration = const Duration().obs;
  bool? forcedScreen;

  var playSpeed = 1.0.obs;
  late io.Directory appDoc;

  var downloadingPercent = 0.0.obs;

  var downloadingState = "".obs;

  var playerPosition = const Duration().obs;
  late DateTime _dateTime;
  var playingText = "".obs;
  var playingTextFa = "".obs;
  Rx<VideoItemsModel> videoItems = VideoItemsModel(
          id: "id",
          faTitle: "faTitle",
          title: "title",
          subtitle: "title",
          subtitleFa: "title",
          type: "type",
          imagePath: "imagePath",
          paragraphs: [],
          videoPath: "podcastPath")
      .obs;
  final GetConnect _getConnect = GetConnect();
  final GetStorage _getStorage = GetStorage();
  var isPlaying = false.obs;
  var isSubtitleLoaded = false.obs;
  var isVideoExists = false.obs;
  final Dio dio = Dio();
  var playIndex = 0;
  var playIndexList = 0;
  var playIndexInList = 0;
  RxBool autoScroll = true.obs;
  late ScrollController scrollController;
  var bookmark = false.obs;
  var faRawSub = "", enRawSub = "";
  var lsFaRawSub = "", lsEnRawSub = "";
  final christianLyrics = ChristianLyrics();

  @override
  void onInit() async {
    super.onInit();
    _getConnect.allowAutoSignedCert = true;
    scrollController = ScrollController();
    appDoc = await path.getApplicationDocumentsDirectory();
  }

  @override
  void dispose() async {
    super.dispose();
    onClose();
    customVideoPlayerController != null
        ? customVideoPlayerController!.pause()
        : {};
  }

  bool isFileExists(String filePath) {
    io.File audioFile = io.File(filePath);
    return audioFile.existsSync();
  }

  void changeSubAsLang() {
    String cFa = "", cEn = "";
    if (fa.value) {
      cFa = faRawSub;
    }
    if (en.value) {
      cEn = enRawSub;
    }
    if (cFa == lsFaRawSub && cEn == lsEnRawSub) {
      return;
    }
    lsEnRawSub = cEn;
    lsFaRawSub = cFa;
    christianLyrics.setLyricContent(cEn, faLyrics: cFa);
    christianLyrics.resetLyric();
  }

  void customeInit(id, isGuest, {String itemType = "video"}) async {
    forcedScreen = await isScreenForced();
    _dateTime = DateTime.now();
    isPlaying = false.obs;
    isHide = false.obs;
    fa = true.obs;
    en = true.obs;
    playSpeed.value = 1;
    downloadingPercent = 0.0.obs;
    downloadingState = "".obs;
    repeat = false.obs;
    playingText = "".obs;
    duration = const Duration(milliseconds: 0).obs;
    playerPosition = const Duration(milliseconds: 0).obs;
    getVideoItemData(id, isGuest, itemType).then((value) {
      if (!value) {
        errorData.value = true;
      }
      if (videoItems.value.videoPath.isEmpty ||
          videoItems.value.videoPath.contains("/undefined") ||
          videoItems.value.videoPath.trim().toLowerCase() ==
              "podcastPath".trim().toLowerCase()) {
        Get.back();
        ColoredSnack(
            title: "ویدئویی برای نمایش وجود ندارد", type: SnackType.ERROR);
        return;
      }
      isVideoExists.value = fileExists(getUrlFileName(
          appDoc.path, videoItems.value.id, videoItems.value.videoPath));
      initSubtitle(id, itemType);
    });
  }

  @override
  void onClose() async {
    // TODO: implement onClose
    super.onClose();
    customVideoPlayerController == null
        ? {}
        : customVideoPlayerController!.isPlaying.value
            ? () {}
            : customVideoPlayerController!.pause();
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
      var add = n.difference(_dateTime);
      times['totall'] = times['totall'] + (add.inSeconds).toInt();
    }
    await _getStorage.write('timers', times);
    customVideoPlayerController != null
        ? customVideoPlayerController!.pause()
        : {};
  }

  var currentSavedTime = (-1).obs;
  var nextTime = 0;
  var preTime = 0;
  var isInEndTime = false.obs;
  var hasBoldText = false;
  GlobalKey? ckey;

  Future<List<InlineSpan>> getCurrentText(int index, bool _fa) async {
    List<InlineSpan> texts = [];
    if (index >= getParAsLang(_fa).length) {
      return texts;
    }
    SentenceModel model = getParAsLang(_fa)[index];

    for (int i = 0; i < model.sentencesList.length; i++) {
      SentenceIndex cm = model.sentencesList[i];
      bool isNowCurrentText = false;
      isNowCurrentText =
          currentSavedTime.value == cm.time && isInEndTime.value == false;
      String textForCheck = StringHelper().filterString(playingText.value);
      var cckey = GlobalKey();

      if (isNowCurrentText && textForCheck.trim().isNotEmpty) {
        if (fa.value == true && en.value == true) {
          if (_fa == false) {
            ckey = cckey;
          }
        } else {
          ckey = cckey;
        }
      }
      texts.add(parseHtmlToTextSpan(whiteSpaceForSentence(cm.text.toString()),
          getSubtitleTextStyle(isNowCurrentText)));
      texts.add(WidgetSpan(
        child: SizedBox.fromSize(
          size: Size.zero,
          key: cckey,
        ),
      ));
    }
    return texts;
  }

  List<SentenceModel> getParAsLang(bool? fa) {
    if (fa == null) {
      if (faParagraph.length > enParagraph.length) {
        return faParagraph;
      } else {
        return enParagraph;
      }
    }
    if (fa) {
      return faParagraph;
    } else {
      return enParagraph;
    }
  }

  void play() async {
    if (customVideoPlayerController!.isPlaying.value) {
      isPlaying.value = true;
      duration.value =
          customVideoPlayerController!.videoPlayerController.value.duration;
      playerPosition.value =
          customVideoPlayerController!.videoPlayerController.value.position;
      if (!forcedScreen!) {
        forcedScreen = true;
        keepScreenOn();
      }
      christianLyrics.resetLyric();
      var event = customVideoPlayerController!.videoPlayerController.value;
      christianLyrics.setPositionWithOffset(
          position: event.position.inMilliseconds,
          duration: event.duration.inMilliseconds);
      // checkForTime(customVideoPlayerController!.videoPlayerController.value);
    } else {
      if (forcedScreen!) {
        forcedScreen = false;
        keepScreenNormal();
      }
      isPlaying.value = false;
    }
  }

  initSubtitle(id, String itemType) async {
    dynamic itemSettings = getItemSettings("$itemType/$id");
    if(itemSettings['autoScrollItem'] == "null"){
      if(itemSettings['autoScroll'] == "on"){
        autoScroll.value = true;
      }else{
        autoScroll.value = false;
      }
    }else{
      if(itemSettings['autoScrollItem'] == "on"){
        autoScroll.value = true;
      }else{
        autoScroll.value = false;
      }
    }
    if (itemSettings['faTitle'] == "on") {
      fa.value = true;
    } else {
      fa.value = false;
    }
    if (itemSettings['enTitle'] == "on") {
      en.value = true;
    } else {
      en.value = false;
    }
    if (itemSettings['repeat'] == "on") {
      repeat.value = true;
    } else {
      repeat.value = false;
    }
    var shouldR = false;
    isSubtitleLoaded.value = false;
    var faLink = videoItems.value.subtitleFa.toString();
    var enLink = videoItems.value.subtitle.toString();
    var resEn = await getSrtSubTitle("en", id, enLink);
    var resFa = await getSrtSubTitle("fa", id, faLink);
    var rawEn = await getRawSrtSubTitle("en", id, enLink);
    var rawFa = await getRawSrtSubTitle("fa", id, faLink);
    faRawSub = rawFa.replaceAll("/l", "");
    enRawSub = rawEn.replaceAll("/l", "");
    if(enLink.trim().isEmpty){
      en.value = false;
      enDisable.value = true;
    }
    if(faLink.trim().isEmpty){
      fa.value = false;
      faDisable.value = true;
    }
    lsFaRawSub = faRawSub;
    lsEnRawSub = enRawSub;
    christianLyrics.setLyricContent(enRawSub, faLyrics: faRawSub);

    if (resEn != null) {
      enParagraph.value = resEn;
      shouldR = true;
    }
    if (resFa != null) {
      faParagraph.value = resFa;
      shouldR = true;
    }

    if (shouldR) {
      isSubtitleLoaded.value = true;
      return;
    }
    isSubtitleLoaded.value = true;
    faParagraph.value = getFullParagraphs(true, videoItems.value.paragraphs);
    enParagraph.value = getFullParagraphs(false, videoItems.value.paragraphs);
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
    if (_request.statusCode == 201) {
      _request.body['action'] == "created"
          ? bookmark.value = true
          : bookmark.value = false;
    } else {
      ColoredSnack(
          title: "Error",
          description: _request.statusText.toString(),
          type: SnackType.WARNING);
    }
  }

  Future<bool> getVideoItemData(
      String podcastId, bool isGuest, String itemType) async {
    isDataLoaded.value = false;
    _getConnect.allowAutoSignedCert = true;
    String link = "";
    if (itemType == "video") {
      link = getVideoDataUrl;
    } else if (itemType == "ielts") {
      link = getIeltsData;
    }else if(itemType == "ielts-general"){
      link = getIeltsGeneralData;
    }else if(itemType == "ted"){
      link = getTedData;
    }
    var _request = isGuest
        ? await _getConnect.get(link + podcastId)
        : await _getConnect.get(
            link + podcastId,
            headers: {
              'accept': 'application/json',
              'Authorization': 'Bearer ${_getStorage.read('token')}'
            },
          );

    if (_request.statusCode == 200) {
      videoItems.value = videoItemsModelFromJson(_request.bodyString ?? "");

      for (var item in videoItems.value.paragraphs) {
        if (item.fa.isNotEmpty) {
          break;
        } else {}
      }
      for (var item in videoItems.value.paragraphs) {
        if (item.en.isNotEmpty) {
          break;
        } else {}
      }
      isDataLoaded.value = true;
      return true;
    } else if (_request.statusCode == 401) {
      _getStorage.remove('timers');
      _getStorage.remove('token');
      _getStorage.remove('timers');
      Get.offAll(LoginScreen());
    } else {
      errorData.value = true;
    }
    return false;
  }

  initVideo(id, urlPath) {
    if (customVideoPlayerController != null) {
      customVideoPlayerController!.dispose();
    }
    customVideoPlayerController = CustomVideoPlayerController(
        CachedVideoPlayerController.file(
            io.File(getUrlFileName(appDoc.path, id, urlPath)),
            videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true)),
        autoInit: false,
        fullscreenOnStart: false);

    customVideoPlayerController!.init(autoPlay: true).then((value) {
      customVideoPlayerTag.value =
          io.File(getUrlFileName(appDoc.path, id, urlPath)).path;
      customVideoPlayerController!.videoPlayerController.addListener(play);
      videoInitialized.value = true;
    });
    return;
    // _videoController = VideoPlayerController.file(
    //     io.File(getUrlFileName(appDoc.path, id, urlPath)));
    // chewieController = ChewieController(
    //   videoPlayerController: _videoController,
    //   autoPlay: false,
    //   looping: false,
    //   hideControlsTimer: const Duration(seconds: 2),
    //   aspectRatio: 16 / 9,
    //   showControls: true,
    //   showControlsOnInitialize: false,
    //   placeholder: Container(
    //     color: Colors.grey,
    //   ),
    //   showOptions: false,
    //   autoInitialize: true,
    // );
  }

  Future<void> download(String urlPath, String id, String title) async {
    io.File _checkFile = io.File(getUrlFileName(appDoc.path, id, urlPath));


    // io.File _checkFile = io.File(getUrlFileName(appDoc.path, getRandomString(15), urlPath));
    if (!_checkFile.existsSync()) {
      CancelToken cancelToken = CancelToken();
      downloadDialog(
          downloadingPercent: downloadingPercent,
          title: "در حال دانلود ویدیو",
          onDownloadCancel: () {
            cancelToken.cancel();
            Get.back();
            Get.back();
            ColoredSnack(title: "دانلود لغو شد", type: SnackType.ERROR);
          });
      try {
        var _downloadRequest = await dio
            .download(urlPath, getUrlFileName(appDoc.path, id, urlPath),
          onReceiveProgress: (recive, total) {
            downloadingState.value = "downloading";
            downloadingPercent.value = recive / total;
          }, deleteOnError: true, cancelToken: cancelToken,);
        Get.closeAllSnackbars();
        Get.back();

        if (_downloadRequest.statusCode == 200) {
          ColoredSnack(
              title: "دانلود با موفقیت به اتمام رسید", type: SnackType.SUCCESS);
          downloadingPercent.value = 0;
          // _videoController.addListener(play);
        }
        isVideoExists.value = true;
      }catch(e){
        Get.closeAllSnackbars();
        Get.back();
        Get.back();
        ColoredSnack(title: "خطا هنگام دانلود!", type: SnackType.ERROR);
        downloadingPercent.value = 0;
      }
    }
  }

  bool fileExists(String path) {
    io.File _checkFile = io.File(path);
    return _checkFile.existsSync();
  }
}
