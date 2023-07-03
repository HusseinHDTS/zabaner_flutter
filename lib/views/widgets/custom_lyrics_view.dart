import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/models/html.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/models/utils.dart';

class CustomLyricsView extends StatelessWidget {
  List<SentenceModel> faLyrics;
  List<SentenceModel> enLyrics;
  ScrollController scrollController;
  Rx<int> currentPoss;
  Rx<Duration> currentDuration;
  int lyricsLength;
  var notifier = ValueNotifier<List<int>>([0, 0]);

  CustomLyricsView(
      {required this.faLyrics,
      required this.enLyrics,
      required this.scrollController,
      required this.lyricsLength,
      required this.notifier,
      required this.currentPoss,
      required this.currentDuration,
      Key? key})
      : super(key: key);

  int savedTime = 0, savedEndTime = 0;
  double savedOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    // return ListView.builder(
    //     shrinkWrap: true,
    //     addAutomaticKeepAlives: false,
    //     itemCount: lyricsLength,
    //     itemBuilder: (context, index) {
    //       return Container(
    //         width: double.infinity,
    //         margin: EdgeInsets.symmetric(horizontal: 3),
    //         child: Obx(() => Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Align(
    //                     alignment: Alignment.centerLeft,
    //                     child: Directionality(
    //                         textDirection: TextDirection.ltr,
    //                         child: Container(
    //                           child: Text.rich(TextSpan(
    //                               style: getSubDefault(false),
    //                               children: List.generate(
    //                                   enLyrics[index].sentencesList.length,
    //                                   (index1) {
    //                                 var item =
    //                                     enLyrics[index].sentencesList[index1];
    //                                 bool isBold = false;
    //                                 if (item.time <= currentPoss.value &&
    //                                     currentPoss.value <= item.endTime) {
    //                                   savedTime = item.time;
    //                                   savedEndTime = item.endTime;
    //                                   isBold = true;
    //                                 } else {
    //                                   isBold = false;
    //                                 }
    //                                 return parseHtmlToTextSpan(
    //                                     whiteSpaceForSentence(
    //                                         item.text.toString()),
    //                                     getSubtitleTextStyle(isBold));
    //                               }))),
    //                         ))),
    //                 SizedBox(
    //                   height: 6,
    //                 ),
    //                 Align(
    //                     alignment: Alignment.centerLeft,
    //                     child: Directionality(
    //                         textDirection: TextDirection.rtl,
    //                         child: Container(
    //                           child: Text.rich(TextSpan(
    //                               style: getSubDefault(false),
    //                               children: List.generate(
    //                                   faLyrics[index].sentencesList.length,
    //                                       (index1) {
    //                                     var item =
    //                                     faLyrics[index].sentencesList[index1];
    //                                     bool isBold = false;
    //                                     if (item.time <= currentPoss.value &&
    //                                         currentPoss.value <= item.endTime) {
    //                                       savedTime = item.time;
    //                                       savedEndTime = item.endTime;
    //                                       isBold = true;
    //                                     } else {
    //                                       isBold = false;
    //                                     }
    //                                     return parseHtmlToTextSpan(
    //                                         whiteSpaceForSentence(
    //                                             item.text.toString()),
    //                                         getSubtitleTextStyle(isBold));
    //                                   }))),
    //                         ))),
    //                 SizedBox(
    //                   height: 24,
    //                 ),
    //               ],
    //             )),
    //       );
    //     });
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: List.generate(lyricsLength, (index) {
          return Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 3),
            child: Obx(() => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              child: Text.rich(TextSpan(
                                  style: getSubDefault(false),
                                  children: List.generate(
                                      enLyrics[index].sentencesList.length,
                                          (index1) {
                                        var item =
                                        enLyrics[index].sentencesList[index1];
                                        bool isBold = false;
                                        if (item.time <= currentDuration.value.inMilliseconds &&
                                            currentDuration.value.inMilliseconds <= item.endTime) {
                                          savedTime = item.time;
                                          savedEndTime = item.endTime;
                                          isBold = true;
                                        } else {
                                          isBold = false;
                                        }
                                        // return TextSpan(text: item.text.toString(),style: getSubtitleTextStyle(isBold));
                                        return parseHtmlToTextSpan(
                                            whiteSpaceForSentence(
                                                item.text.toString()),
                                            getSubtitleTextStyle(isBold));
                                      }))),
                            ))),
                    SizedBox(
                      height: 6,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Container(
                              child: Text.rich(TextSpan(
                                  style: getSubDefault(false),
                                  children: List.generate(
                                      faLyrics[index].sentencesList.length,
                                          (index1) {
                                        var item =
                                        faLyrics[index].sentencesList[index1];
                                        bool isBold = false;
                                        if (item.time <= currentPoss.value &&
                                            currentPoss.value <= item.endTime) {
                                          savedTime = item.time;
                                          savedEndTime = item.endTime;
                                          isBold = true;
                                        } else {
                                          isBold = false;
                                        }
                                        return TextSpan(text: item.text.toString(),style: getSubtitleTextStyle(isBold));
                                        return parseHtmlToTextSpan(
                                            whiteSpaceForSentence(
                                                item.text.toString()),
                                            getSubtitleTextStyle(isBold));
                                      }))),
                            ))),

                    SizedBox(
                      height: 24,
                    ),
                  ],
                )),
          );
        }),
      ),
    );
  }
}
