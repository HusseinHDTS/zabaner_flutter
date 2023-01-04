import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator;
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:zabaner/models/book_paragraph_model.dart';
import 'package:zabaner/models/html.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'dart:io' as io;
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:srt_parser/srt_parser.dart' as strP;


class BookController extends GetxController with StateMixin {
  final GetConnect _getConnect = GetConnect();
  final GetStorage _getStorage = GetStorage();
  late BookParagraphModel bookItemModel;
  final FlutterSoundPlayer player = FlutterSoundPlayer();
  RefreshController refreshController = RefreshController();
  AutoScrollController scrollController = AutoScrollController();
  var faParagraph = <SentenceModel>[].obs;
  var enParagraph = <SentenceModel>[].obs;
  var errorData = false.obs;
  late DateTime _dateTime;
  final Dio dio = Dio();
  late io.Directory appDoc;
  var seconds = 0;
  var en = true.obs, fa = true.obs;
  var isPlaying = false.obs;
  var isInEndTime = false.obs;
  var isSubtitleLoaded = false.obs;
  var ind = 0;
  var playingText = "".obs;
  var playingTextFa = "".obs;
  var playSpeed = 1.0.obs;
  var isHide = false.obs;
  var autoScroll = true.obs;
  var percentPlayed = 0.0.obs;
  var nextTime = 0;
  var preTime = 0;
  var downloadingPercent = 0.0.obs;
  var duration = const Duration().obs;
  var playerPosition = const Duration().obs;
  var repeat = false.obs;
  var downloadingState = "".obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    print("Init");
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

  void customeInit(bookId,itemId,isGuest) {
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
    getPodcastItemData(bookId, itemId, isGuest);
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
    player.stopPlayer();
    isPlaying.value = false;
  }

  var currentSavedTime = 0.obs;
  GlobalKey? ckey;

  Future<List<InlineSpan>> getCurrentText(int index, bool _fa) async {
    List<InlineSpan> texts = [];
    SentenceModel model = getParAsLang(_fa)[index];

    int size = model.sentencesList.length;
    for (int i = 0; i < size; i++) {
      SentenceIndex cm = model.sentencesList[i];
      bool isNowCurrentText = false;
      isNowCurrentText =
          currentSavedTime.value == cm.time && isInEndTime.value == false;
      String textForCheck = StringHelper().filterString(playingText.value);
      texts.add(parseHtmlToTextSpan(whiteSpaceForSentence(cm.text.toString()), getSubtitleTextStyle(isNowCurrentText)));

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
    }
    return texts;
  }

  Future<void> checkForTime(event) async {
    List<SentenceModel> a = getParAsLang(false);
    var posEv = event;
    for (int i = 0; i < a.length; i++) {
      for (var b in a[i].sentencesList) {
        if (posEv.position.inMilliseconds >
            b.time &&
            b.time > currentSavedTime.value ||
            posEv.position.inMilliseconds <
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
        if (posEv.position.inMilliseconds >
            b.endTime &&
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
        debugPrint("sadsadsadsadsappooooooo : " + y.toString());
        // scrollController.jumpTo(y+40);

        scrollController.animateTo(y - 400 + (scrollController.offset),
            duration: Duration(milliseconds: 2000), curve: Curves.linear);
        // scrollController.jumpTo(y - 400 + (scrollController.offset));
      }
    }
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

        player.setSubscriptionDuration(const Duration(milliseconds: 900));
        player.onProgress!.listen((event) async {
          isPlaying.value = player.isPlaying;
          duration.value = event.duration;
          playerPosition.value = event.position;
          await checkForTime(event);
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
    isSubtitleLoaded.value = false;
    io.File _checkFile = io.File(getUrlFileName(appDoc.path, id, urlPath));
    if (!_checkFile.existsSync()) {
      downloadDialog(downloadingPercent: downloadingPercent, title: "در حال دانلود فایل صوتی");

      var _downloadRequest = await dio
          .download(urlPath, getUrlFileName(appDoc.path, id, urlPath),
              onReceiveProgress: (recive, total) {
        downloadingState.value = "downloading";
        downloadingPercent.value = recive / total;

        print(downloadingPercent);
      });
      Get.closeAllSnackbars();
      Get.back();

      if (_downloadRequest.statusCode == 200) {
        ColoredSnack(
            title: "دانلود با موفقیت به اتمام رسید", type: SnackType.SUCCESS);
        downloadingPercent.value = 0;
      }
    } else {}
    var shouldR = false;
    if (bookItemModel.subtitle.toString().trim().isNotEmpty) {
      var en = await _getConnect.get(bookItemModel.subtitle);
      var list =
      await getFullFromSrt(false, strP.parseSrt(en.bodyString ?? ""));
      enParagraph.value = list.sentenceModel;
      // subTimes.value = list.subtitleTimes;
      shouldR = true;
    }
    if (bookItemModel.subtitleFa.toString().trim().isNotEmpty) {
      var fa = await _getConnect.get(bookItemModel.subtitleFa);
      var list = await getFullFromSrt(true, strP.parseSrt(fa.bodyString ?? ""));
      faParagraph.value = list.sentenceModel;
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

  void getPodcastItemData(String bookId, String itemId, bool isGuest) async {
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
      download(bookItemModel.podcastPath, itemId, bookItemModel.title);
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
      change(null, status: RxStatus.success());
    } else if (_request.statusCode == 401) {
      _getStorage.remove('timers');
      _getStorage.remove('token');
      _getStorage.remove('timers');
      Get.offAll(LoginScreen());
    } else {
      errorData.value = true;
      // getPodcastItemData(bookId,itemId,isGuest);
    }
  }
}
