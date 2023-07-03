import 'dart:isolate';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:zabaner/models/book_paragraph_model.dart';
import 'package:zabaner/models/html.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/book_screen.dart';
import 'dart:io' as io;
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/custom_lyric/christian_lyrics.dart';

class BookController extends GetxController {
  final GetConnect _getConnect = GetConnect();
  final GetStorage _getStorage = GetStorage();
  late BookParagraphModel bookItemModel;
  final FlutterSoundPlayer player = FlutterSoundPlayer();
  RefreshController refreshController = RefreshController();
  AutoScrollController scrollController = AutoScrollController();
  AutoScrollController autoScrollController = AutoScrollController();
  BookScreenState? bookScreenState;
  var faParagraph = <SentenceModel>[].obs;
  var enParagraph = <SentenceModel>[].obs;
  late Stream<List<InlineSpan>> inlineSpansStream;
  late Stream<List<InlineSpan>> inlineSpansFaStream;
  var inlineSpans = <List<InlineSpan>>[];
  var inlineSpansFa = <List<InlineSpan>>[];
  var errorData = false.obs;
  var isDataLoaded = false.obs;
  late DateTime _dateTime;
  final Dio dio = Dio();
  late io.Directory appDoc;
  var seconds = 0;
  var en = true.obs, fa = true.obs;
  var enDisable = false.obs, faDisable = false.obs;
  var isPlaying = false.obs;
  var isInitialized = false.obs;
  var isInEndTime = false.obs;
  var isSubtitleLoaded = false.obs;
  var isBookExists = false.obs;
  var ind = 0;
  var playingText = "".obs;
  var playingTextFa = "".obs;
  var playSpeed = 1.0.obs;
  var isHide = false.obs;
  var autoScroll = true.obs;
  var percentPlayed = 0.0.obs;
  var savedLastIndex = 0;
  var nextTime = 0;
  var preTime = 0;
  var downloadingPercent = 0.0.obs;
  var duration = const Duration().obs;
  var playerPosition = const Duration().obs;
  var playerLyricNotifier = ValueNotifier<List<int>>([0, 0]);
  var repeat = false.obs;
  var downloadingState = "".obs;
  bool isCheckingDone = false;
  bool _playerStateForSekkbar = false;
  var faRawSub = "" , enRawSub = "";
  var lsFaRawSub = "" , lsEnRawSub = "";
  ChristianLyrics christianLyrics = ChristianLyrics();

  requestForSeekBar(bool hasToPlay) {
    if (hasToPlay == false) {
      if (isPlaying.isTrue) {
        _playerStateForSekkbar = true;
      } else {
        _playerStateForSekkbar = false;
      }
      player.isOpen() ?
      player.pausePlayer() : {};
    } else {
      if (_playerStateForSekkbar) {
        player.isOpen() ?
        player.resumePlayer() : {};
      }
    }
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    appDoc = await path.getApplicationDocumentsDirectory();
    percentPlayed = 0.0.obs;
    downloadingPercent = 0.0.obs;
    downloadingState = "".obs;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    scrollController.dispose();
    player.closeAudioSession();
  }

  bool isFileExists(String filePath) {
    io.File audioFile = io.File(filePath);
    return audioFile.existsSync();
  }

  Future<bool> customeInit(
      BookScreenState state, bookId, itemId, isGuest) async {
    bookScreenState = state;
    GetStorage.init();
    _dateTime = DateTime.now();
    isHide = false.obs;
    // en = true.obs;
    // fa = false.obs;
    ind = 0;
    playingText = "".obs;
    percentPlayed = 0.0.obs;
    downloadingPercent = 0.0.obs;
    duration = const Duration(milliseconds: 0).obs;
    playerPosition = const Duration(milliseconds: 0).obs;
    downloadingState = "".obs;
    repeat = false.obs;
    playSpeed.value = 1;
    await getPodcastItemData(bookId, itemId, isGuest);
    return true;
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

  @override
  void onClose() async {
    super.onClose();
    player.isOpen()
        ? player.isPlaying
            ? {}
            : player.pausePlayer()
        : {};
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
    player.stopPlayer();
    isPlaying.value = false;
  }

  var currentSavedTime = (-1).obs;
  var currentSavedEndTime = (-1).obs;
  GlobalKey? ckey;

  Future<List<InlineSpan>> getCurrentText(int index, bool _fa) async {
    List<InlineSpan> texts = [];
    try {
      SentenceModel model = getParAsLang(_fa)[index];
      int size = model.sentencesList.length;
      for (int i = 0; i < size; i++) {
        SentenceIndex cm = model.sentencesList[i];
        bool isNowCurrentText = false;
        isNowCurrentText =
            currentSavedTime.value == cm.time && isInEndTime.value == false;
        String textForCheck = StringHelper().filterString(playingText.value);

        var cckey = GlobalObjectKey(getRandomString(15));

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
        texts.add(parseHtmlToTextSpan(whiteSpaceForSentence(cm.text.toString()),
            getSubtitleTextStyle(isNowCurrentText)));
      }
    } catch (e) {
      e.printError();
    }
    return texts;
  }

  checkForTime(event) {
    List<SentenceModel> a = getParAsLang(false);
    var posEv = event;
    for (int i = 0; i < a.length; i++) {
      for (int o = 0; o < a[i].sentencesList.length; o++) {
        var b = a[i].sentencesList[o];
        if (posEv.position.inMilliseconds > b.time &&
            b.time > currentSavedTime.value ||
            posEv.position.inMilliseconds < b.time &&
                b.time < currentSavedTime.value) {
          if (currentSavedTime.value == b.time) {
            return;
          }
          isInEndTime.value = false;
          currentSavedTime.value = b.time;
          if (playingText.value != b.text.toString()) {
            playingText.value = b.text.toString();
          }
          if (playingTextFa.value != b.text.toString()) {
            playingTextFa.value = b.text.toString();
          }
        }
        if (posEv.position.inMilliseconds > b.endTime &&
            b.endTime > currentSavedTime.value) {
          // if(isInEndTime.isFalse){
          isInEndTime.value = true;
          // }
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

        scrollController.animateTo(y - 200 + (scrollController.offset),
            duration: Duration(milliseconds: 2000), curve: Curves.linear);
      }
    }
  }

  Future<void> checkForTime3(event) async {
    isCheckingDone = true;
    List<SentenceModel> a = getParAsLang(false);
    var posEv = event;
    var milli = posEv.position.inMilliseconds;
    if (currentSavedTime.value > milli) {
      savedLastIndex = 0;
    }
    if (currentSavedTime.value <= milli && milli <= currentSavedEndTime.value) {
    } else {
      for (int i = savedLastIndex; i < a.length; i++) {
        for (int o = 0; o < a[i].sentencesList.length; o++) {
          var b = a[i].sentencesList[o];
          if (milli > b.time && b.time > currentSavedTime.value ||
              milli < b.time && b.time < currentSavedTime.value) {
            if (currentSavedTime.value == b.time) {
              return;
            }
            debugPrint("sadkjsckjzxkjaskjdqwoioioi : " +
                milli.toString() +
                "      " +
                b.time.toString());

            isInEndTime.value = false;
            currentSavedTime.value = b.time;
            currentSavedEndTime.value = b.endTime;
            playerLyricNotifier.value = [b.time, b.endTime];
            if (playingText.value != b.text.toString()) {
              savedLastIndex = i;
              playingText.value = b.text.toString();
            }
            if (playingTextFa.value != b.text.toString()) {
              playingTextFa.value = b.text.toString();
            }
          }
          if (milli > b.endTime && b.endTime > currentSavedTime.value) {
            isInEndTime.value = true;
          }
        }
      }
      isCheckingDone = false;
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

        scrollController.animateTo(y - 200 + (scrollController.offset),
            duration: Duration(milliseconds: 2000), curve: Curves.linear);
        // scrollController.jumpTo(y - 400 + (scrollController.offset));
      }
    }
  }
  void changeSubAsLang(){
    // isSubtitleLoaded.value = false;
    // String lF = lsFaRawSub, lE = lsEnRawSub;
    // if(!fa.value){
    //   lF = "";
    // }
    // if(!en.value){
    //   lE = "";
    // }
    // debugPrint("daskjdksajdkasjdks : " + fa.value.toString());
    // bool savedFa = fa.value;
    // bool savedEn = en.value;
    // fa.value = false;
    // en.value = false;
    // Future.delayed(Duration(microseconds: 200),() {
    //   fa.value = savedFa;
    //   en.value = savedEn;
    // },);
    // isSubtitleLoaded.value = false;
    // christianLyrics.resetLyric();
    // christianLyrics.playingLyric!.setLyric(lyric: "" ,faLyric: "" );
    // christianLyrics.playingLyric!.setLyric(lyric: en.isFalse ? "" : lsEnRawSub,faLyric: fa.isFalse? "" : lsFaRawSub);
    // isSubtitleLoaded.value = true;
    // bool savedFa = fa.value;
    // bool savedEn = en.value;
    // fa.value = false;
    // en.value = false;
    // Future.delayed(Duration(microseconds: 200),() {
    //   fa.value = savedFa;
    //   en.value = savedEn;
    // },);
    // refresh();
    // isSubtitleLoaded.value = true;
  }

  Future<void> initSubtitle(bookId,id) async {
    dynamic itemSettings = getItemSettings("$bookId/$id");
    if(itemSettings['autoScrollItem'].toString() == "null"){
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
    if(itemSettings['faTitle'] == "on"){
      fa.value = true;
    }else{
      fa.value = false;
    }
    if(itemSettings['enTitle'] == "on"){
      en.value = true;
    }else{
      en.value = false;
    }
    if(itemSettings['repeat'] == "on"){
      repeat.value = true;
    }else{
      repeat.value = false;
    }
    var shouldR = false;
    var faLink = bookItemModel.subtitleFa.toString();
    var enLink = bookItemModel.subtitle.toString();
    var resEn = await getSrtSubTitle("en", id, enLink);
    var resFa = await getSrtSubTitle("fa", id, faLink);
    var rawEn = await getRawSrtSubTitle("en", id, enLink);
    var rawFa = await getRawSrtSubTitle("fa", id, faLink);
    faRawSub = rawFa.replaceAll("/l", "");
    enRawSub = rawEn.replaceAll("/l", "");
    lsFaRawSub = faRawSub;
    lsEnRawSub = enRawSub;
    if(enLink.trim().isEmpty){
      en.value = false;
      enDisable.value = true;
    }
    if(faLink.trim().isEmpty){
      fa.value = false;
      faDisable.value = true;
    }
    christianLyrics.setLyricContent(enRawSub,faLyrics: faRawSub);

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
    faParagraph.value = getFullParagraphs(true, bookItemModel.paragraphs);
    enParagraph.value = getFullParagraphs(false, bookItemModel.paragraphs);
  }

  Future<void> checkForTime1(event) async {
    var item = bookItemModel;
    var posEv = event;
    for (int i = 0; i < item.paragraphs.length; i++) {
      if (posEv.position.inMilliseconds > item.paragraphs[i].pst &&
              item.paragraphs[i].pst > currentSavedTime.value ||
          posEv.position.inMilliseconds < item.paragraphs[i].pst &&
              item.paragraphs[i].pst < currentSavedTime.value) {
        isInEndTime.value = false;
        try {
          if ((i + 1) >= item.paragraphs.length - 1) {
            nextTime = item.paragraphs[item.paragraphs.length - 1].pst;
            preTime = item.paragraphs[i - 1].pst;
          } else if (i == 0) {
            nextTime = item.paragraphs[i + 1].pst;
            preTime = item.paragraphs[0].pst;
          } else {
            nextTime = item.paragraphs[i + 1].pst;
            preTime = item.paragraphs[i - 1].pst;
          }
        } catch (e) {
          e.printError();
        }
        currentSavedTime.value = item.paragraphs[i].pst;
        playingText.value = item.paragraphs[i].en;
        playingTextFa.value = item.paragraphs[i].fa;
      }
      if (posEv.position.inMilliseconds > item.paragraphs[i].pstEnd &&
          item.paragraphs[i].pstEnd > currentSavedTime.value) {
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

        scrollController.animateTo(y - 400 + (scrollController.offset),
            duration: Duration(milliseconds: 2000), curve: Curves.linear);
        // scrollController.jumpTo(y - 400 + (scrollController.offset));
      }
    }
  }

  void togglePlayer(String filePath) async {
    bool forced = await isScreenForced();
    if (!isPlaying.value) {
      playAudio(filePath);
      if (!forced) {
        keepScreenOn();
      }
    } else {
      player.pausePlayer();
      isPlaying.value = false;
      if (forced) {
        keepScreenNormal();
      }
    }
  }

  void playAudio(String filePath) async {
    try {
      player.isOpen() ? {} : player.openAudioSession();
      io.File audioFile = io.File(filePath);
      // if (player.isOpen()) {
      if (audioFile.existsSync()) {
        if (player.isPaused) {
          await player.resumePlayer();
        } else {
          await player.startPlayer(
              fromDataBuffer: audioFile.readAsBytesSync(),
              whenFinished: () {
                isPlaying.value = false;

                repeat.value ? playAudio(filePath) : {};
              });
        }

        player.setSubscriptionDuration(const Duration(milliseconds: 90));
        player.onProgress!.listen((event) {
          isPlaying.value = player.isPlaying;
          duration.value = event.duration;
          playerPosition.value = event.position;
          // if(isCheckingDone) {
          // Isolate.spawn(checkForTime, event);
          //   checkForTime(event);
          christianLyrics.resetLyric();
          christianLyrics.setPositionWithOffset(position: event.position.inMilliseconds, duration: event.duration.inMilliseconds);
          // }
        });
      } else {
        ColoredSnack(
            title: "ابتدا فایل صورتی را دانلود کنید", type: SnackType.WARNING);
      }
    } catch (e) {
      ColoredSnack(title: "Error", description: "$e", type: SnackType.WARNING);
    }
  }

  void download(String urlPath, String id, String title) async {
    io.File _checkFile = io.File(getUrlFileName(appDoc.path, id, urlPath));
    if (!_checkFile.existsSync()) {
      CancelToken cancelToken = CancelToken();

      downloadDialog(
          downloadingPercent: downloadingPercent,
          title: "در حال دانلود فایل صوتی",
          onDownloadCancel: () {
            cancelToken.cancel();
            Get.back();
            Get.back();
            ColoredSnack(title: "دانلود لغو شد", type: SnackType.ERROR);
          });

      var _downloadRequest = await dio
          .download(urlPath, getUrlFileName(appDoc.path, id, urlPath),options: Options(headers:{"Keep-Alive" : "timeout=100, max=5"} ),
              onReceiveProgress: (recive, total) {
        downloadingState.value = "downloading";
        downloadingPercent.value = recive / total;
      }, deleteOnError: true, cancelToken: cancelToken);
      Get.closeAllSnackbars();
      Get.back();

      if (_downloadRequest.statusCode == 200) {
        ColoredSnack(
            title: "دانلود با موفقیت به اتمام رسید", type: SnackType.SUCCESS);
        downloadingPercent.value = 0;
      }
    } else {}
    isBookExists.value = true;
  }

  Future<void> getPodcastItemData(
      String bookId, String itemId, bool isGuest) async {
    isDataLoaded.value = false;
    errorData.value = false;
    _getConnect.allowAutoSignedCert = true;
    var _request = isGuest
        ? await _getConnect.get(getBookDetailUrl + bookId + "/item/" + itemId)
        : await _getConnect.get(
            getBookDetailUrl + bookId + "/item/" + itemId,
            headers: {'Authorization': 'Bearer ${_getStorage.read('token')}'},
          );

    if (_request.statusCode == 200) {
      refreshController.refreshCompleted();
      bookItemModel = bookParagraphModelFromJson(_request.bodyString ?? "");
      await initSubtitle(bookId,itemId);
      for (var item in bookItemModel.paragraphs) {
        if (item.fa.isNotEmpty) {
          break;
        } else {}
      }
      for (var item in bookItemModel.paragraphs) {
        if (item.en.isNotEmpty) {
          break;
        } else {}
      }
      isDataLoaded.value = true;
    } else if (_request.statusCode == 401) {
      _getStorage.remove('timers');
      _getStorage.remove('token');
      _getStorage.remove('timers');
      Get.offAll(LoginScreen());
    } else {
      errorData.value = true;
      // getPodcastItemData(bookId,itemId,isGuest);
    }
    try {
      isBookExists.value = isFileExists(
          getUrlFileName(appDoc.path, itemId, bookItemModel.podcastPath));
    } catch (e) {
      e.printError();
    }
  }
}
