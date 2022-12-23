import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SentenceModel{
  List<SentenceIndex> sentencesList;
  SentenceModel({required this.sentencesList});
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
  String? text;
  SentenceIndex({required this.listIndex , required this.sentenceIndex , required this.time, this.text});
}