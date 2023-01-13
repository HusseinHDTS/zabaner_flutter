import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:srt_parser/srt_parser.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zabaner/models/html.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/views/colors.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:zabaner/widgets/colored_text.dart';
import 'package:html/parser.dart' as parser;


final BUILD_MODE = "BAZAAR";
// final BUILD_MODE = "OTHER";

int lvl1 = 1680;
int lvl2 = 3600;
int lvl3 = 7200;
int lvl4 = 4800;
int lvl5 = lvl4;
int lvl6 = lvl4;
double hiddenHeight = Get.height / 7.5 / 1.5 , normalHeight = Get.height / 7.5;

downloadDialog({required RxDouble downloadingPercent , required title}){
  Get.defaultDialog(
      title: title,
      onWillPop: () async => downloadingPercent.value == 1 ? true : false,
      backgroundColor: orange,
      content: Obx(() => Stack(children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: downloadingPercent.value,
          ),
        ),
        SizedBox(width:60,height: 60,child: Center(child: ColoredText("${parseDownloadPercent((downloadingPercent.value * 100).toDouble())} %",textAlign: TextAlign.center) ))
      ],)));
}

String parseDownloadPercent(double download){
  String res = "";
  var content = download.toString().split(".");
  res = content[0];
  String secondPart = content[1].toString();
  if(secondPart.length >= 2){
    secondPart = secondPart.substring(0,2);
  }
  // if(int.tryParse(secondPart) != null && int.parse(secondPart) == 0){
  //   secondPart = "";
  // }else{
    secondPart = ".$secondPart";
  // }
  // if(secondPart != "00" && secondPart == "0"){
    res += secondPart;
  // }
  return res;
}

loadingDialog(title){
  Get.defaultDialog(
      title: title,
      barrierDismissible: false,
      content: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: const CircularProgressIndicator()));
}

TextStyle getSubtitleTextStyle(isNowCurrentText) {
  return TextStyle(
      // fontSize: isNowCurrentText ? 17.0 : 18,
      fontWeight: isNowCurrentText ? FontWeight.w900 : FontWeight.w900,
      fontFamily: isNowCurrentText ? "Iransans_Fa_MD" : "Iransans_Fa_MD" ,
      color: isNowCurrentText ? Colors.black : Colors.grey);
}

TextStyle getSubDefault(isFa) {
  return TextStyle(fontSize: isFa ? 17 : 18, color: Colors.black, fontFamily: "Neue_MD");
}

Widget ErrorLoading() {
  return Center(
      child: Container(
        child: Column(
          children: [
            Lottie.asset('assets/animations/server_error.json', height: 350),
            ColoredText(
              "خطا هنگام دریافت اطلاعات از سرور! لطفا مجددا تلاش کنید.",
              textDirection: TextDirection.rtl,
              textColor: Colors.red,
            ),
          ],
        ),
      ));
}

Widget Loading() {
  return Center(
      child: Container(
        child: Lottie.asset('assets/animations/loading_main.json', height: 350),
      ));
}

Future<String> getUrlContent(String url) async {
  String result = "";
  HttpClient client = HttpClient();
  var request = await client.postUrl(Uri.parse(url));
  request.close().then((response) {
    utf8.decoder.bind(response.cast<List<int>>()).listen((content) {
      result = content;
    });
  });
  return result;
}

Widget NoData({String? message}) {
  String mC = "";
  mC = message ?? "هیچ اطلاعاتی یافت نشد!";
  return Center(
      child: Container(
        child: Column(
          children: [
            Lottie.asset('assets/animations/no_data.json', height: 350),
            ColoredText(
              mC,
              textDirection: TextDirection.rtl,
              textColor: Colors.deepOrange,
            ),
          ],
        ),
      ));
}

String whiteSpaceForSentence(String sentence) {
  return sentence
      .replaceAll('!', "! ")
      .replaceAll('?', "? ")
      .replaceAll('؟', "؟ ")
      .replaceAll(".", ". ")
      .replaceAll("  \"", " \"")
      // .replaceAll(" \"", "\"")
      .replaceAll(". \"", ".\"")
      .replaceAll("? \"", "?\"")
      .replaceAll("؟ \"", "؟\"")
      .replaceAll("! \"", "!\"")
      .replaceAll(RegExp(r"(?! )\s+| \s+"), " ")
  ;
}

Future<bool> isScreenForced() async {
  return await Wakelock.enabled;
}

int getExtendedVersionNumber(String version) {
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
}

keepScreenOn() {
  Wakelock.enable();
}

keepScreenNormal() {
  Wakelock.disable();
}

writeString(String text,String itemId) async {
  final Directory directory = await path.getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/$itemId.txt');
  await file.writeAsString(text);
}

Future<bool> readExists(String itemId)async{
  bool exists = false;
  final Directory directory = await path.getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/$itemId.txt');
  exists = file.existsSync();
  return exists;
}

Future<String> readString(String itemId) async {
  String text = "";
  try {
    final Directory directory = await path.getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$itemId.txt');
    text = await file.readAsString();
  } catch (e) {
  }
  return text;
}

Future<SrtResult> getFullFromSrt(bool fa, List<Subtitle> paragraphs) async{
  List<SentenceModel> listItems = [];
  List<List<InlineSpan>> textsSpans = [];
  List<Subtitle> currentP = paragraphs;
  String result = "";
  String timeResult = "";
  String eTimeResult = "";
  for (var res in currentP)  {
    var a = res.lines.join(" ");
    if(a.contains("/l")){
      result += a.replaceAll("/l", "") + "__NEWSENTENCE__" + "/l";
    }else{
      result += a+ "__NEWSENTENCE__" ;
    }
    timeResult += res.range.begin.toString() + "__NEWSENTENCE__";
    eTimeResult += res.range.end.toString() + "__NEWSENTENCE__";
    if (a.contains("/l")) {
      timeResult += "/l";
      eTimeResult += "/l";
    }
  }

  List<String> b = result.split("/l");
  List<String> tb = timeResult.split("/l");
  List<String> etb = eTimeResult.split("/l");
  for (int i = 0; i < b.length; i ++) {
    String parag = b[i];
    List<SentenceIndex> sentencesList = [];
    List<InlineSpan> inlineSpan = [];
    List<String> a = parag.split("__NEWSENTENCE__");
    List<String> ta = tb[i].toString().split("__NEWSENTENCE__");
    List<String> eta = etb[i].toString().split("__NEWSENTENCE__");

    for (int o = 0; o < a.length; o ++) {
      String sentens = a[o].replaceAll("__NEWSENTENCE__", " ").replaceAll(
          "/l", " ");
      String forCheck = ta[o].replaceAll("__NEWSENTENCE__", " ").replaceAll(
          "/l", " ");
      String eForCheck = eta[o].replaceAll("__NEWSENTENCE__", " ").replaceAll(
          "/l", " ");
      int currentTime = 0;
      int currentETime = 0;
      int diffrence = 350;
      if (StringHelper()
          .filterString(forCheck.toString().trim())
          .isNumericOnly) {
        currentTime = int.parse(
            StringHelper().filterString(forCheck.toString().trim())) - diffrence;
      }
      if (StringHelper()
          .filterString(eForCheck.toString().trim())
          .isNumericOnly) {
        currentETime = int.parse(
            StringHelper().filterString(eForCheck.toString().trim())) - diffrence;
      }
      String txt = sentens
          .replaceAll(RegExp(r"(?! )\s+| \s+"), " ");
      inlineSpan.add(parseHtmlToTextSpan(whiteSpaceForSentence(txt.toString()), getSubtitleTextStyle(false)));
      sentencesList.add(SentenceIndex(
          listIndex: i,
          sentenceIndex: o,
          time: currentTime,
          endTime:currentETime,
          text: txt));
    }
    listItems.add(SentenceModel(sentencesList: sentencesList));
    textsSpans.add(inlineSpan);
  }
  return SrtResult(sentenceModel: listItems,subtitleTimes: textsSpans);
}

List<SentenceModel> getFullParagraphs(bool fa, var paragraphs) {
  List<SentenceModel> listItemsFa = [];
  List<SentenceModel> listItemsEn = [];
  int size = paragraphs.length;
  String fullFa = "",
      fullEn = "";
  int time = 0;
  var times = <int>[];
  String timesString = "";
  String endTimesString = "";
  for (int i = 0; i < size; i++) {
    fullFa += paragraphs[i].fa;
    fullEn += paragraphs[i].en;

    timesString += paragraphs[i].pst.toString() + "__NEWSENTENCE__";
    endTimesString += paragraphs[i].pstEnd.toString() + "__NEWSENTENCE__";
    if (paragraphs[i].en.toString().contains("__NEWPARAGRAPH__")) {
      timesString += "__NEWPARAGRAPH__";
      endTimesString += "__NEWPARAGRAPH__";
    }
  }
  List<String> faListItems = fullFa.split("__NEWPARAGRAPH__");
  List<String> enListItems = fullEn.split("__NEWPARAGRAPH__");
  List<String> timesStrings = timesString.split("__NEWPARAGRAPH__");
  List<String> endTimesStrings = timesString.split("__NEWPARAGRAPH__");
  for (int i = 0; i < faListItems.length; i++) {
    String currentFullText = faListItems[i];
    String currentFullTimes = timesStrings[i];
    String currentEndFullTimes = endTimesStrings[i];
    List<String> currentSentences = currentFullText.split("__NEWSENTENCE__");

    List<String> currentTimes = currentFullTimes.split("__NEWSENTENCE__");
    List<String> currentEndTimes = currentEndFullTimes.split("__NEWSENTENCE__");

    List<SentenceIndex> sentencesList = [];
    for (int o = 0; o < currentSentences.length; o++) {
      String currentSentence = currentSentences[o];
      int currentTime = 0;
      if (StringHelper()
          .filterString(currentTimes[o].toString().trim())
          .isNumericOnly) {
        currentTime = int.parse(
            StringHelper().filterString(currentTimes[o].toString().trim()));
        }
        int currentEndTime = 0;
      if (StringHelper()
          .filterString(currentEndTimes[o].toString().trim())
          .isNumericOnly) {
        currentTime = int.parse(
            StringHelper().filterString(currentEndTimes[o].toString().trim()));
      }
      currentSentence.replaceAll("__NEWSENTENCE__", " ");
      sentencesList.add(SentenceIndex(
          listIndex: i,
          sentenceIndex: o,
          time: currentTime,
          endTime: currentEndTime,
          text: currentSentence.replaceAll(RegExp(r"(?! )\s+| \s+"), " ")));
    }
    listItemsFa.add(SentenceModel(sentencesList: sentencesList));
  }

  for (int i = 0; i < enListItems.length; i++) {
    String currentFullText = enListItems[i];
    String currentFullTimes = timesStrings[i];
    String currentEndFullTimes = endTimesStrings[i];
    List<String> currentSentences = currentFullText.split("__NEWSENTENCE__");
    List<String> currentTimes = currentFullTimes.split("__NEWSENTENCE__");
    List<String> currentEndTimes = currentEndFullTimes.split("__NEWSENTENCE__");
    List<SentenceIndex> sentencesList = [];
    for (int o = 0; o < currentSentences.length; o++) {
      int currentTime = 0;
      if (StringHelper()
          .filterString(currentTimes[o].toString().trim())
          .isNumericOnly) {
        currentTime = int.parse(
            StringHelper().filterString(currentTimes[o].toString().trim()));
      }
      int currentEndTime = 0;
      if (StringHelper()
          .filterString(currentEndTimes[o].toString().trim())
          .isNumericOnly) {
        currentEndTime = int.parse(
            StringHelper().filterString(currentEndTimes[o].toString().trim()));
      }
      String currentSentence = currentSentences[o];
      currentSentence.replaceAll("__NEWSENTENCE__", " ");
      sentencesList.add(SentenceIndex(
          listIndex: i,
          sentenceIndex: o,
          time: currentTime,
          endTime: currentEndTime,
          text: currentSentence));
    }
    listItemsEn.add(SentenceModel(sentencesList: sentencesList));
  }
  if (fa) {
    return listItemsFa;
  } else {
    return listItemsEn;
  }
}
