import 'dart:convert';
import 'dart:io' as io;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:zabaner/models/html.dart';
import 'package:zabaner/models/podcast_item_model.dart';
import 'package:zabaner/models/podcast_model.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/my_app_bar.dart';
import 'package:srt_parser/srt_parser.dart' as strP;


class PlayPodcastController extends GetxController{
  final GetConnect _getConnect = GetConnect();
  late DateTime _dateTime;
  final FlutterSoundPlayer player = FlutterSoundPlayer();
  final Dio dio = Dio();
  final GetStorage _getStorage = GetStorage();
  late PodcastItemModel podcastItem;
  late io.Directory appDoc;
  AutoScrollController scrollController = AutoScrollController();
  var isPlaying = false.obs;
  var isSubtitleLoaded = false.obs;
  var isDataLoaded = false.obs;
  var ind = 0;
  var faParagraph = <SentenceModel>[].obs;
  var enParagraph = <SentenceModel>[].obs ;
  RxBool autoScroll = true.obs;
  var en = true.obs, fa = true.obs;
  var playingText = "".obs;
  var playingTextFa = "".obs;
  var isHide = false.obs;
  var isPodcastExists = false.obs;
  var isInEndTime = false.obs;
  var playSpeed = 1.0.obs;
  var currentSavedTime = 0.obs;
  var lastPoss = 0.obs;
  var percentPlayed = 0.0.obs;
  var downloadingPercent = 0.0.obs;
  var duration = const Duration().obs;
  var playerPosition = const Duration().obs;
  var repeat = false.obs;
  var downloadingState = "".obs;
  @override
  void onInit() async {
    super.onInit();
    _getConnect.allowAutoSignedCert = true;
    appDoc = await path.getApplicationDocumentsDirectory();
    GetStorage.init();
    percentPlayed = 0.0.obs;
    downloadingPercent = 0.0.obs;
    downloadingState = "".obs;
  }



  void customeInit() {
    _dateTime = DateTime.now();
    isHide = false.obs;
    ind = 0;
    playingText = "".obs;
    en = true.obs;
    fa = true.obs;
    percentPlayed = 0.0.obs;
    downloadingPercent = 0.0.obs;
    duration = const Duration(milliseconds: 0).obs;
    playerPosition = const Duration(milliseconds: 0).obs;
    downloadingState = "".obs;
    repeat = false.obs;
    playSpeed.value = 1;
  }

  void initSubtitle(id)async{
    var shouldR = false;
    if (podcastItem.subtitle.toString().trim().isNotEmpty) {
      bool exists = await readExists("${id}en");
      if(!exists){
        var en = await _getConnect.get(podcastItem.subtitle);
        writeString(en.bodyString ??  "", "${id}en");
      }
      String data = await readString("${id}en");
      var list = await getFullFromSrt(false, strP.parseSrt(data));
      enParagraph.value = list.sentenceModel;
      shouldR = true;
    }
    if (podcastItem.subtitleFa.toString().trim().isNotEmpty) {
      bool exists = await readExists("${id}en");
      if(!exists){
        var fa = await _getConnect.get(podcastItem.subtitleFa);
        writeString(fa.bodyString ??  "", "${id}en");
      }
      String data = await readString("${id}en");
      var list = await getFullFromSrt(true, strP.parseSrt(data));
      faParagraph.value = list.sentenceModel;

      shouldR = true;
    }
    if (shouldR) {
      isSubtitleLoaded.value = true;
      return;
    }
    isSubtitleLoaded.value = true;
    faParagraph.value = getFullParagraphs(true, podcastItem.paragraphs);
    enParagraph.value = getFullParagraphs(false, podcastItem.paragraphs);
  }

  @override
  void onClose() async {
    // TODO: implement onClose
    super.onClose();
    player.isPlaying ? {} : player.pausePlayer();
    Map times = _getStorage.read('timers') ?? {};
    var lastTimer = times[
    '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'] ??
        0;
    if (times[
    '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'] ==
        null) {
      times.addAll(<String, int>{
        '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}':
        (DateTime.now().difference(_dateTime).inSeconds + lastTimer).toInt()
      });
    } else {
      times['${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}'] =
          (DateTime.now().difference(_dateTime).inSeconds + lastTimer).toInt();
    }
    if (times['totall'] == null) {
      times.addAll(<String, dynamic>{
        'totall':
        (DateTime.now().difference(_dateTime).inSeconds + lastTimer).toInt()
      });
    } else {
      var n = DateTime.now();
      var add = n.difference(_dateTime);
      times['totall'] = times['totall'] + (add.inSeconds).toInt();
    }
    await _getStorage.write('timers', times);
    // _getStorage.remove('timers');
    player.stopPlayer();
    isPlaying.value = false;
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


  bool isFileExists(String filePath){
    io.File audioFile = io.File(filePath);
    return audioFile.existsSync();
  }

  Future<void> download(String urlPath, String id, String title) async {
    io.File _checkFile = io.File(getUrlFileName(appDoc.path,id,urlPath));
    if (!_checkFile.existsSync()) {
      downloadDialog(downloadingPercent: downloadingPercent, title: "در حال دانلود فایل صوتی");

      var _downloadRequest = await dio
          .download(urlPath,  getUrlFileName(appDoc.path,id,urlPath),
          onReceiveProgress: (recive, total) {
            downloadingState.value = "downloading";
            downloadingPercent.value = recive / total;

          });
      Get.closeAllSnackbars();
      Get.back();

      if (_downloadRequest.statusCode == 200) {
        ColoredSnack(title: "دانلود با موفقیت به اتمام رسید",type: SnackType.SUCCESS);
        downloadingPercent.value = 0;
      }
    } else {

    }
    isPodcastExists.value = true;
  }


  Future<String> getLyrData(id) async{
    return await readString("${id}en");
  }

  GlobalKey? ckey;
  Future<List<InlineSpan>> getCurrentText(int index, bool _fa) async {
    List<InlineSpan> texts = [];
    try{
    SentenceModel model = getParAsLang(_fa)[index];
    int size = model.sentencesList.length;
    for (int i = 0; i < size; i++) {
      SentenceIndex cm = model.sentencesList[i];
      bool isNowCurrentText = false;
      isNowCurrentText =
          currentSavedTime.value == cm.time && isInEndTime.value == false;
      String textForCheck = StringHelper().filterString(playingText.value);

      var cckey = GlobalObjectKey(getRandomString(15));

      if (isNowCurrentText &&
          textForCheck.trim().isNotEmpty) {
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
      texts.add(parseHtmlToTextSpan(whiteSpaceForSentence(cm.text.toString()), getSubtitleTextStyle(isNowCurrentText)));
    }
    }catch(e){
      e.printError();
    }
    return texts;
  }

  Future<void> getPodcastItemData(String podcastId, bool isGuest) async {
    isDataLoaded.value = false;
    _getConnect.allowAutoSignedCert = true;
    var _request = isGuest
        ? await _getConnect.get(getPodcastDetailUrl + podcastId)
        : await _getConnect.get(
      getPodcastDetailUrl + podcastId,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${_getStorage.read('token')}'
      },
    );

    if (_request.statusCode == 200) {
      podcastItem = podcastItemModelFromJson(_request.bodyString ?? "");
      for (var item in podcastItem.paragraphs) {
        if (item.fa.isNotEmpty) {
          break;
        } else {
        }
      }
      for (var item in podcastItem.paragraphs) {
        if (item.en.isNotEmpty) {
          break;
        } else {
        }
      }
      for (var item in podcastItem.paragraphs) {
        if (item.en.isNotEmpty) {
          break;
        }
      }
      for (var item in podcastItem.paragraphs) {
        if (item.fa.isNotEmpty) {
          break;
        }
      }
    } else if (_request.statusCode == 401) {
      _getStorage.remove('timers');
      _getStorage.remove('token');
      _getStorage.remove('timers');
      Get.offAll(LoginScreen());
    } else {
      // errorData.value = true;
      // getPodcastItemData(podcastId, isGuest);
    }
    isDataLoaded.value = true;
  }
  int nextTime= 0 , preTime = 0;
  checkForTime(event) {
    List<SentenceModel> a = getParAsLang(false);
    var posEv = event;
    for (int i = 0; i < a.length; i++) {
      for (int o = 0; o < a[i].sentencesList.length; o++) {
        var b = a[i].sentencesList[o];
        if (posEv.position.inMilliseconds >
            b.time &&
            b.time > currentSavedTime.value ||
            posEv.position.inMilliseconds <
                b.time &&
                b.time < currentSavedTime.value) {
          if (currentSavedTime.value == b.time) {
            return;
          }
          isInEndTime.value = false;
          currentSavedTime.value = b.time;
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

        scrollController.animateTo(y - 200 + (scrollController.offset),
            duration: Duration(milliseconds: 2000), curve: Curves.linear);
      }
    }
  }



  void togglePlayer(String filePath) async{
    bool forced = await isScreenForced();
    if (!isPlaying.value) {
      playAudio(filePath);
      if(!forced){
        keepScreenOn();
      }
    } else {
      player.pausePlayer();
      isPlaying.value = false;
      if(forced){
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

          percentPlayed.value =
              event.position.inMilliseconds / event.duration.inMilliseconds;
          checkForTime(event);
        });
      } else {
        ColoredSnack(title: "ابتدا فایل صورتی را دانلود کنید",type: SnackType.WARNING);
      }
    } catch (e) {
      ColoredSnack(title: "Error",description: "$e",type: SnackType.ERROR);
    }
  }
}
