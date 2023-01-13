import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SentenceModel{
  List<SentenceIndex> sentencesList;
  SentenceModel({required this.sentencesList});
}

class SubtitleTimes{
  int start , end;
  String text;
  SubtitleTimes({required this.text , required this.start,required this.end});
}

class SrtResult{
  List<SentenceModel> sentenceModel;
  List<List<InlineSpan>> subtitleTimes;
  SrtResult({required this.sentenceModel,required this.subtitleTimes});

}

class StringHelper{
  String filterString(String data){
    String result = data.replaceAll(RegExp(r"(?! )\s+| \s+"), " ");
    result = result.replaceAll("\r\n", "");
    result = result.replaceAll(".", "");
    result = result.replaceAll(",", "");
    result = result.replaceAll("!", "");
    result = result.replaceAll(" ", "");
    result = result.replaceAll("__NEWPARAGRAPH__", "");
    result = result.replaceAll("__NEWSENTENCE__", "");
    result = result.replaceAll("\'", "");
    result = result.replaceAll("\"", "");
    result = result.trim();
    return result;
  }
}

class GlobalKeyModel{
  int time;
  GlobalKey? key;
  GlobalKeyModel({required this.time}){
    key = new GlobalKey(debugLabel: time.toString()+"");
  }
}

class SentenceIndex{
  int listIndex , sentenceIndex;
  int time;
  int endTime;
  String? text;
  SentenceIndex({required this.listIndex , required this.sentenceIndex , required this.time,required this.endTime, this.text});
}