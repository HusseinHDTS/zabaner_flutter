import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/widgets/colored_text.dart';

TextStyle getSubtitleTextStyle(isNowCurrentText) {
  return TextStyle(
      fontSize: isNowCurrentText ? 17.0 : 18,
      fontWeight: isNowCurrentText ? FontWeight.w800 : FontWeight.w300);
}

TextStyle getSubDefault() {
  return TextStyle(fontSize: 18, color: Colors.black);
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
  String fullFa = "", fullEn = "";
  int time = 0;
  var times = <int>[];
  String timesString = "";
  for (int i = 0; i < size; i++) {
    fullFa += paragraphs[i].fa;
    fullEn += paragraphs[i].en;

    // fullFa.replaceAll("!", "!\t\t");
    // fullFa.replaceAll("?", "?\t\t");
    // fullFa.replaceAll("؟", "؟\t\t");
    // fullFa.replaceAll(".", ".\t\t");
    //
    // fullEn.replaceAll("!", "!\t\t");
    // fullEn.replaceAll("?", "?\t\t");
    // fullEn.replaceAll("؟", "؟\t\t");
    // fullEn.replaceAll(".", ".\t\t");
    //
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
