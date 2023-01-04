import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:srt_parser/srt_parser.dart' as strP;
import 'package:zabaner/models/html.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/models/video_items_model.dart';
import 'package:video_player/video_player.dart';
import 'package:zabaner/views/colors.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'dart:io' as io;

import 'package:zabaner/widgets/colored_text.dart';

class VideoController extends GetxController with StateMixin {
  // late VideoModel videoModel;
  late VideoPlayerController _videoController;
  late ChewieController chewieController;
  var faParagraph = <SentenceModel>[].obs;
  var enParagraph = <SentenceModel>[].obs;
  var subTimes = <SubtitleTimes>[].obs;
  var isSubtitlesLoaded = false.obs;
  var errorData = false.obs;
  RefreshController refreshController = RefreshController();

  var isHide = false.obs;
  var videoInitialized = false.obs;
  var fa = true.obs;
  var en = true.obs;
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
  final Dio dio = Dio();
  var playIndex = -1;
  RxBool autoScroll = true.obs;
  late ScrollController scrollController;
  var bookmark = false.obs;

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
    chewieController.dispose();
  }

  void customeInit(id,isGuest) async {
    forcedScreen = await isScreenForced();
    _dateTime = DateTime.now();
    playIndex = 0;
    isPlaying = false.obs;
    isHide = false.obs;
    fa = true.obs;
    en = true.obs;
    playSpeed.value = 1;
    playIndex = 0;
    downloadingPercent = 0.0.obs;
    downloadingState = "".obs;
    repeat = false.obs;
    playingText = "".obs;
    duration = const Duration(milliseconds: 0).obs;
    playerPosition = const Duration(milliseconds: 0).obs;
    getVideoItemData(id, isGuest).then((value) {
      if(!value){
        errorData.value = true;
      }
      refreshController.refreshCompleted();
      download(videoItems.value.videoPath, id,videoItems.value.title);
    });
  }

  @override
  void onClose() async {
    // TODO: implement onClose
    super.onClose();
    chewieController.isPlaying ? () {} : chewieController.pause();
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
    chewieController.pause();
  }

  var currentSavedTime = 0.obs;
  var nextTime = 0;
  var preTime = 0;
  var isInEndTime = false.obs;
  var hasBoldText = false;
  GlobalKey? ckey;

  Future<List<InlineSpan>> getCurrentText(int index, bool _fa) async {
    List<InlineSpan> texts = [];
    SentenceModel model = getParAsLang(_fa)[index];

    for (int i = 0; i < model.sentencesList.length; i++) {
      SentenceIndex cm = model.sentencesList[i];
      bool isNowCurrentText = false;
      isNowCurrentText =
          currentSavedTime.value == cm.time && isInEndTime.value == false;
      String textForCheck = StringHelper().filterString(playingText.value);
      texts.add(parseHtmlToTextSpan(whiteSpaceForSentence(cm.text.toString()), getSubtitleTextStyle(isNowCurrentText)));
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
      if (faParagraph.length == enParagraph.length) {
        return enParagraph;
      }
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

  // https://dl2.languagecentre.ir/zabaner-short-stories/Frozen.2013.Bluray.720p.MkvCage.srt

  Future<void> checkForTime2() async {
    for (int i = 0; i < videoItems.value.paragraphs.length; i++) {
      if (chewieController.videoPlayerController.value.position.inMilliseconds >
                  videoItems.value.paragraphs[i].pst &&
              videoItems.value.paragraphs[i].pst > currentSavedTime.value ||
          chewieController.videoPlayerController.value.position.inMilliseconds <
                  videoItems.value.paragraphs[i].pst &&
              videoItems.value.paragraphs[i].pst < currentSavedTime.value) {
        isInEndTime.value = false;
        try {
          if ((i + 1) >= videoItems.value.paragraphs.length - 1) {
            nextTime = videoItems
                .value.paragraphs[videoItems.value.paragraphs.length - 1].pst;
            preTime = videoItems.value.paragraphs[i - 1].pst;
          } else if (i == 0) {
            nextTime = videoItems.value.paragraphs[i + 1].pst;
            preTime = videoItems.value.paragraphs[0].pst;
          } else {
            nextTime = videoItems.value.paragraphs[i + 1].pst;
            preTime = videoItems.value.paragraphs[i - 1].pst;
          }
        } catch (e) {
          e.printError();
        }
        currentSavedTime.value = videoItems.value.paragraphs[i].pst;
        playingText.value = videoItems.value.paragraphs[i].en;
        playingTextFa.value = videoItems.value.paragraphs[i].fa;
        playIndex = i;
      }
      if (chewieController.videoPlayerController.value.position.inMilliseconds >
              videoItems.value.paragraphs[i].pstEnd &&
          videoItems.value.paragraphs[i].pstEnd > currentSavedTime.value) {
        isInEndTime.value = true;
      }
    }

    if (autoScroll.value &&
        isPlaying.value == true &&
        ckey != null &&
        isInEndTime.value != true) {
      if (ckey!.currentContext != null) {
        RenderBox box = ckey!.currentContext!.findRenderObject() as RenderBox;
        Offset position =
            box.localToGlobal(Offset.zero); //this is global position
        double y = position.dy;
        debugPrint("sadsadsadsadsappooooooo : " + y.toString());
        // scrollController.jumpTo(y+40);

        scrollController.animateTo(y - 400 + (scrollController.offset),
            duration: Duration(milliseconds: 2000), curve: Curves.linear);
        // scrollController.jumpTo(y - 400 + (scrollController.offset));
      }
    }
  }

  Future<void> checkForTime() async {
    List<SentenceModel> a = getParAsLang(false);
    int currentIndx = 0;
    for (int i = 0; i < a.length; i++) {
      var ab = a[i].sentencesList;
      for (int o = 0 ; o < ab.length; o ++) {
        var b = ab[o];
        if (chewieController
                        .videoPlayerController.value.position.inMilliseconds >
                    b.time &&
                b.time > currentSavedTime.value ||
            chewieController
                        .videoPlayerController.value.position.inMilliseconds <
                    b.time &&
                b.time < currentSavedTime.value) {
          if (currentSavedTime.value == b.time) {
            return;
          }
          // if(isInEndTime.isTrue){
            isInEndTime.value = false;
          // }
          if(b.time != currentSavedTime.value){
            currentSavedTime.value = b.time;
          }
          if(playingText.value != b.text.toString()){
            playingText.value = b.text.toString();
          }
          if(playingTextFa.value != b.text.toString()){
              playingTextFa.value = b.text.toString();
          }
        }
        if (chewieController
                    .videoPlayerController.value.position.inMilliseconds >
                b.endTime &&
            b.endTime > currentSavedTime.value) {
          // if(isInEndTime.isFalse){
            isInEndTime.value = true;
          // }
        }
        currentIndx ++;
      }
    }

    if (autoScroll.value &&
        isPlaying.value == true &&
        ckey != null &&
        isInEndTime.value != true) {
      if (ckey!.currentContext != null) {
        RenderBox box = ckey!.currentContext!.findRenderObject() as RenderBox;
        Offset position =
            box.localToGlobal(Offset.zero); //this is global position
        double y = position.dy;
        debugPrint("sadsadsadsadsappooooooo : " + y.toString());
        // scrollController.jumpTo(y+40);

        scrollController.animateTo(y - 400 + (scrollController.offset),
            duration: Duration(milliseconds: 2000), curve: Curves.linear);
        // scrollController.jumpTo(y - 400 + (scrollController.offset));
      }
    }
  }

  Future<void> checkForTime3() async {
    if (subTimes.isNotEmpty) {
      for (var b in subTimes) {
        if (chewieController
                        .videoPlayerController.value.position.inMilliseconds >
                    b.start &&
                b.start > currentSavedTime.value ||
            chewieController
                        .videoPlayerController.value.position.inMilliseconds <
                    b.start &&
                b.start < currentSavedTime.value) {
          isInEndTime.value = false;
          currentSavedTime.value = b.start;
          playingText.value = b.text.toString();
          playingTextFa.value = b.text.toString();
        }
        if (chewieController
                    .videoPlayerController.value.position.inMilliseconds >
                b.end &&
            b.end > currentSavedTime.value) {
          isInEndTime.value = true;
        }
      }
    }

    if (autoScroll.value &&
        isPlaying.value == true &&
        ckey != null &&
        isInEndTime.value != true) {
      if (ckey!.currentContext != null) {
        RenderBox box = ckey!.currentContext!.findRenderObject() as RenderBox;
        Offset position =
            box.localToGlobal(Offset.zero); //this is global position
        double y = position.dy;

        scrollController.animateTo(y - 300 + (scrollController.offset),
            duration: Duration(milliseconds: 2000), curve: Curves.linear);
        // scrollController.jumpTo(y - 400 + (scrollController.offset));
      }
    }
  }

  void play() async {
    if (chewieController.isPlaying) {
      isPlaying.value = true;
      duration.value = chewieController.videoPlayerController.value.duration;
      playerPosition.value =
          chewieController.videoPlayerController.value.position;
      if (!forcedScreen!) {
        forcedScreen = true;
        keepScreenOn();
      }
      await checkForTime();
    } else {
      if (forcedScreen!) {
        forcedScreen = false;
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
      ColoredSnack(
          title: "Error",
          description: _request.statusText.toString(),
          type: SnackType.WARNING);
    }
  }

  Future<bool> getVideoItemData(String podcastId, bool isGuest) async {
    _getConnect.allowAutoSignedCert = true;
    var _request = isGuest
        ? await _getConnect.get(getVideoDataUrl + podcastId)
        : await _getConnect.get(
            getVideoDataUrl + podcastId,
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
      change(null, status: RxStatus.success());
      return true;
    } else if (_request.statusCode == 401) {
      _getStorage.remove('timers');
      _getStorage.remove('token');
      _getStorage.remove('timers');
      Get.offAll(LoginScreen());
    } else {
      errorData.value=true;
    }
    return false;
  }

  Future<void> download(String urlPath, String id, String title) async {
    isSubtitleLoaded.value = false;
    io.File _checkFile = io.File(getUrlFileName(appDoc.path, id, urlPath));
    // io.File _checkFile = io.File(getUrlFileName(appDoc.path, getRandomString(15), urlPath));
    if (!_checkFile.existsSync()) {
      downloadDialog(downloadingPercent: downloadingPercent, title: "در حال دانلود ویدیو");
      // Get.defaultDialog(
      //     title: "در حال دانلود ویدیو",
      //     onWillPop: () async => downloadingPercent.value == 1 ? true : false,
      //     backgroundColor: orange,
      //     content: Obx(() => CircularProgressIndicator(
      //           value: downloadingPercent.value,
      //         )));
      var _downloadRequest = await dio
          .download(urlPath, getUrlFileName(appDoc.path, id, urlPath),
              onReceiveProgress: (recive, total) {
        downloadingState.value = "downloading";
        downloadingPercent.value = recive / total;

      });
      Get.closeAllSnackbars();
      Get.back();

      if (_downloadRequest.statusCode == 200) {
        ColoredSnack(
            title: "دانلود با موفقیت به اتمام رسید", type: SnackType.SUCCESS);
        downloadingPercent.value = 0;
        _videoController = VideoPlayerController.file(
            io.File(getUrlFileName(appDoc.path, id, urlPath)));
        // _videoController.addListener(play);
      }
    } else {
      _videoController = VideoPlayerController.file(
          io.File(getUrlFileName(appDoc.path, id, urlPath)));
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
      placeholder: Container(
        color: Colors.grey,
      ),
      showOptions: false,
      autoInitialize: true,
    );
    _videoController.addListener(play);
    var shouldR = false;
    if (videoItems.value.subtitle.toString().trim().isNotEmpty) {
      var en = await _getConnect.get(videoItems.value.subtitle);
      var list =
          await getFullFromSrt(false, strP.parseSrt(en.bodyString ?? ""));
      enParagraph.value = list.sentenceModel;
      subTimes.value = list.subtitleTimes;
      shouldR = true;
    }
    if (videoItems.value.subtitleFa.toString().trim().isNotEmpty) {
      var fa = await _getConnect.get(videoItems.value.subtitleFa);
      var list = await getFullFromSrt(true, strP.parseSrt(fa.bodyString ?? ""));
      faParagraph.value = list.sentenceModel;
      debugPrint("sadsadsadoaiwdoisoid : " + list.sentenceModel.toList().toString());
      subTimes.value = list.subtitleTimes;
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

  bool fileExists(String path) {
    io.File _checkFile = io.File(path);
    return _checkFile.existsSync();
  }
}
