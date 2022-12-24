import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:srt_parser/srt_parser.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/widgets/colored_text.dart';

TextStyle getSubtitleTextStyle(isNowCurrentText) {
  return TextStyle(
      fontSize: isNowCurrentText ? 17.0 : 18,
      fontWeight: isNowCurrentText ? FontWeight.w900 : null,
      color: isNowCurrentText ? Colors.black : Colors.black38);
}

TextStyle getSubDefault() {
  return TextStyle(fontSize: 18, color: Colors.black, fontFamily: "arial");
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

Future<String> getUrlContent(String url) async {
  debugPrint("asdsadsadsadsad : $url");
  String result = "";
  HttpClient client = HttpClient();
  var request = await client.postUrl(Uri.parse(url));
  request.close().then((response) {
    utf8.decoder.bind(response.cast<List<int>>()).listen((content) {
      debugPrint("asdsadsadsadsad : $content");
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
      .replaceAll(" \"", "\"")
      .replaceAll(". \"", ".\"")
      .replaceAll("? \"", "?\"")
      .replaceAll("؟ \"", "؟\"")
      .replaceAll("! \"", "!\"")
      .replaceAll(RegExp(r"(?! )\s+| \s+"), " ");
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

List<SentenceModel> getFullParagraphs(bool fa, var paragraphs) {
  List<SentenceModel> listItemsFa = [];
  List<SentenceModel> listItemsEn = [];
  int size = paragraphs.length;
  String fullFa = "",
      fullEn = "";
  int time = 0;
  var times = <int>[];
  String timesString = "";
  for (int i = 0; i < size; i++) {
    fullFa += paragraphs[i].fa;
    fullEn += paragraphs[i].en;

    timesString += paragraphs[i].pst.toString() + "__NEWSENTENCE__";
    if (paragraphs[i].en.toString().contains("__NEWPARAGRAPH__")) {
      timesString += "__NEWPARAGRAPH__";
    }
  }
  List<String> faListItems = fullFa.split("__NEWPARAGRAPH__");
  List<String> enListItems = fullEn.split("__NEWPARAGRAPH__");
  List<String> timesStrings = timesString.split("__NEWPARAGRAPH__");
  for (int i = 0; i < faListItems.length; i++) {
    String currentFullText = faListItems[i];
    String currentFullTimes = timesStrings[i];
    List<String> currentSentences = currentFullText.split("__NEWSENTENCE__");

    List<String> currentTimes = currentFullTimes.split("__NEWSENTENCE__");

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
      currentSentence.replaceAll("__NEWSENTENCE__", " ");
      sentencesList.add(SentenceIndex(
          listIndex: i,
          sentenceIndex: o,
          time: currentTime,
          endTime: 0,
          text: currentSentence.replaceAll(RegExp(r"(?! )\s+| \s+"), " ")));
    }
    // debugPrint("Lists : " + listItemsFa.toString());
    listItemsFa.add(SentenceModel(sentencesList: sentencesList));
  }

  for (int i = 0; i < enListItems.length; i++) {
    String currentFullText = enListItems[i];
    String currentFullTimes = timesStrings[i];
    List<String> currentSentences = currentFullText.split("__NEWSENTENCE__");
    List<String> currentTimes = currentFullTimes.split("__NEWSENTENCE__");
    List<SentenceIndex> sentencesList = [];
    for (int o = 0; o < currentSentences.length; o++) {
      int currentTime = 0;
      if (StringHelper()
          .filterString(currentTimes[o].toString().trim())
          .isNumericOnly) {
        currentTime = int.parse(
            StringHelper().filterString(currentTimes[o].toString().trim()));
      }
      String currentSentence = currentSentences[o];
      currentSentence.replaceAll("__NEWSENTENCE__", " ");
      sentencesList.add(SentenceIndex(
          listIndex: i,
          sentenceIndex: o,
          time: currentTime,
          endTime: 0,
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

List<SentenceModel> getFullFromSrt(bool fa, List<Subtitle> paragraphs,
    List<Subtitle> paragraphsFa) {
  List<SentenceModel> listItems = [];
  List<Subtitle> currentP;
  if (fa) {
    currentP = paragraphsFa;
  } else {
    currentP = paragraphs;
  }
  String result = "";
  String timeResult = "";
  String eTimeResult = "";
  for (var res in currentP) {
    var a = res.lines.join("__NEWSENTENCE__");
    result += a;
    timeResult += res.range.begin.toString() + "__NEWSENTENCE__";
    eTimeResult += res.range.end.toString() + "__NEWSENTENCE__";
    if (a.contains("\\nl")) {
      timeResult += "\\nl";
      eTimeResult += "\\nl";
    }
  }
  List<String> b = result.split("\\nl");
  List<String> tb = timeResult.split("\\nl");
  List<String> etb = eTimeResult.split("\\nl");
  for (int i = 0; i < b.length; i ++) {
    String parag = b[i];
    List<SentenceIndex> sentencesList = [];
    List<String> a = parag.split("__NEWSENTENCE__");
    List<String> ta = tb[i].toString().split("__NEWSENTENCE__");
    List<String> eta = etb[i].toString().split("__NEWSENTENCE__");
    for (int o = 0; o < a.length; o ++) {
      String sentens = a[o].replaceAll("__NEWSENTENCE__", "").replaceAll(
          "\\nl", "");
      String forCheck = ta[o].replaceAll("__NEWSENTENCE__", "").replaceAll(
          "\\nl", "");
      String eForCheck = eta[o].replaceAll("__NEWSENTENCE__", "").replaceAll(
          "\\nl", "");
      int currentTime = 0;
      int currentETime = 0;
      if (StringHelper()
          .filterString(forCheck.toString().trim())
          .isNumericOnly) {
        currentTime = int.parse(
            StringHelper().filterString(forCheck.toString().trim()));
      }
      if (StringHelper()
          .filterString(eForCheck.toString().trim())
          .isNumericOnly) {
        currentTime = int.parse(
            StringHelper().filterString(eForCheck.toString().trim()));
      }
      sentencesList.add(SentenceIndex(
          listIndex: i,
          sentenceIndex: o,
          time: currentTime,
          endTime:currentETime,
          text: sentens.replaceAll("__NEWSENTENCE__", "")
              .replaceAll("\\nl", "")
              .replaceAll(RegExp(r"(?! )\s+| \s+"), " ")));
    }
    listItems.add(SentenceModel(sentencesList: sentencesList));
  }

  // debugPrint("Lists : " + listItemsFa.toString());

  return listItems;
}
