import 'package:better_player/better_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:video_player/video_player.dart';
import 'package:zabaner/controllers/video_controller.dart';
import 'package:zabaner/models/level.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/widgets/bottom_player.dart';
import 'package:zabaner/views/widgets/subtitle_tile.dart';
import 'package:zabaner/views/widgets/text_highlight.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/custom_video_player.dart';
import 'package:zabaner/widgets/my_app_bar.dart';
import 'dart:io' as io;

class VideoDetailScreen extends StatefulWidget {
  VideoDetailScreen(
      {Key? key,
      required this.isGuest,
      required this.id,
      required this.itemType})
      : super(key: key);
  final bool isGuest;
  String itemType;
  final String id;

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  final VideoController controller = Get.put(VideoController());

  @override
  void initState() {
    super.initState();
    controller.customeInit(widget.id, widget.isGuest,
        itemType: widget.itemType);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.onClose();
        return true;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: ColoredAppBar(actions: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(builder: (context) {
                        var itemSettings = getItemSettings(
                            "${widget.itemType}/${widget.id}");
                        controller.fa.value =
                            itemSettings['faTitle'] == "on";
                        controller.en.value =
                            itemSettings['enTitle'] == "on";
                        return Obx(() => langChange(
                            fa: itemSettings['faTitle'] == "on",
                            en: itemSettings['enTitle'] == "on",
                            enDisable: controller.enDisable.value,
                            faDisable: controller.faDisable.value,
                            onEnChange: (value) {
                              controller.en.value = value;
                              writeSetting(
                                  "${widget.itemType}/${widget.id}/enTitle",
                                  value == true ? "on" : "off");
                              // controller.christianLyrics.resetLyric(faEnable: controller.fa.value , enEnable: controller.en.value);
                            },
                            onFaChange: (value) {
                              controller.fa.value = value;
                              writeSetting(
                                  "${widget.itemType}/${widget.id}/faTitle",
                                  value == true ? "on" : "off");
                              // controller.christianLyrics.resetLyric(faEnable: controller.fa.value , enEnable: controller.en.value);
                            }));
                      }),
                    ],
                  ),
                ),
              )
            ],),
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: Obx(() => controller.isDataLoaded.isTrue
                  ? Column(
                      children: [
                        SizedBox(height: 8,),
                        ColoredText(controller.videoItems.value.faTitle,textColor: Colors.black,textSize: 18,),
                        SizedBox(height: 8,),
                        Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: Get.width / 50, vertical: 5),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Obx(() => getVideoView(
                                    io.File(getUrlFileName(
                                        controller.appDoc.path,
                                        controller.videoItems.value.id,
                                        controller.videoItems.value.videoPath)),
                                    CustomVideoType.STORAGE,
                                    withThumb: true,
                                    retryImage: customVideoPlayerTag.value ==
                                        getUrlFileName(
                                            controller.appDoc.path,
                                            controller.videoItems.value.id,
                                            controller
                                                .videoItems.value.videoPath),
                                    showPreviewOverlay: false)),
                              ),
                            )),
                        SizedBox(height: 8,),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                            child: Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  child: Obx(() => controller
                                      .isSubtitleLoaded.value
                                      ? Obx(() {
                                    if (controller.fa.value ||
                                        controller.en.value) {}
                                    return controller.christianLyrics
                                        .getLyric(context,
                                        scrollOffset: -20,
                                        isPlaying: controller
                                            .isPlaying.value,
                                        faE: controller.fa.value,
                                        enE: controller.en.value,
                                        autoScrollE: controller
                                            .autoScroll.value,
                                        tStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                            height: 1.5,
                                            fontSize: 20,
                                            color:
                                            Colors.black));
                                  })
                                      : subtitleLoading(hasFirstItem: false)),
                                ),
                                Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Obx(() => Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            height: controller.isHide.value
                                                ? hiddenHeight
                                                : normalHeight,
                                            child: BottomPlayer(
                                                isVideo: true,
                                                autoScroll:
                                                    controller.autoScroll,
                                                faTitle: controller.fa,
                                                enTitle: controller.en,
                                                settingsId:
                                                    "${widget.itemType}/${widget.id}",
                                                forward: () {
                                                  var newPos = controller
                                                          .currentSavedTime
                                                          .value +
                                                      5100;
                                                  if (newPos >
                                                      controller.duration.value
                                                          .inMilliseconds)
                                                    newPos = controller
                                                            .duration
                                                            .value
                                                            .inMilliseconds -
                                                        100;
                                                  controller.currentSavedTime
                                                      .value = newPos;
                                                  controller.playerPosition
                                                          .value =
                                                      Duration(
                                                          milliseconds: newPos);
                                                  customVideoPlayerController!
                                                      .seekTo(
                                                          newPos.toDouble());
                                                },
                                                backward: () {
                                                  // var data = getPlayerIndex(
                                                  //     controller
                                                  //         .getParAsLang(
                                                  //         null),
                                                  //     controller
                                                  //         .playIndexList,
                                                  //     controller
                                                  //         .playIndexInList,
                                                  //     false);
                                                  // controller.currentSavedTime.value = data[2];
                                                  // controller.playerPosition.value = Duration(milliseconds: data[2]);
                                                  // controller.playIndexList = data[0];
                                                  // controller.playIndexInList = data[1];
                                                  var newPos = controller
                                                          .currentSavedTime
                                                          .value -
                                                      5100;
                                                  if (newPos < 0) newPos = 0;
                                                  controller.currentSavedTime
                                                      .value = newPos;
                                                  controller.playerPosition
                                                          .value =
                                                      Duration(
                                                          milliseconds: newPos);
                                                  customVideoPlayerController!
                                                      .seekTo(
                                                          newPos.toDouble());
                                                },
                                                isFileExists:
                                                    controller.isVideoExists,
                                                isInitialized:
                                                    controller.videoInitialized,
                                                isPlaying: controller.isPlaying,
                                                onInitialize: () {
                                                  controller.initVideo(
                                                      controller
                                                          .videoItems.value.id,
                                                      controller.videoItems
                                                          .value.videoPath);
                                                },
                                                resumePlayer: () {
                                                  if (!controller
                                                      .videoInitialized
                                                      .value) return;
                                                  customVideoPlayerController!
                                                      .togglePlay();
                                                  // controller.chewieController
                                                  //     .showControls;
                                                  // controller.chewieController.notifyListeners();
                                                },
                                                pausePlayer: () {
                                                  if (!controller
                                                      .videoInitialized
                                                      .value) return;
                                                  customVideoPlayerController!
                                                      .togglePlay();
                                                },
                                                downloadRequest: () =>
                                                    controller.download(
                                                        controller.videoItems
                                                            .value.videoPath,
                                                        controller.videoItems
                                                            .value.id,
                                                        controller.videoItems
                                                            .value.title),
                                                togglePlayer: () async {
                                                  customVideoPlayerController!
                                                      .togglePlay();
                                                  return true;
                                                },
                                                toggleHide: () =>
                                                    controller.isHide.toggle(),
                                                togglePlayerSpeed: () {
                                                  if (controller
                                                      .isPlaying.value) {
                                                    if (controller
                                                            .playSpeed.value ==
                                                        0.5) {
                                                      controller
                                                          .playSpeed.value = 1;
                                                      customVideoPlayerController!
                                                          .videoPlayerController
                                                          .setPlaybackSpeed(1);
                                                    } else if (controller
                                                            .playSpeed.value ==
                                                        1) {
                                                      controller
                                                          .playSpeed.value = 2;
                                                      customVideoPlayerController!
                                                          .videoPlayerController
                                                          .setPlaybackSpeed(2);
                                                    } else if (controller
                                                            .playSpeed.value ==
                                                        2) {
                                                      controller.playSpeed
                                                          .value = 0.5;
                                                      customVideoPlayerController!
                                                          .videoPlayerController
                                                          .setPlaybackSpeed(
                                                              0.5);
                                                    }
                                                  }
                                                },
                                                playSpeed: controller.playSpeed,
                                                player: controller
                                                        .videoInitialized.value
                                                    ? customVideoPlayerController!
                                                        .videoPlayerController
                                                    : null,
                                                isHide: controller.isHide,
                                                repeat: controller.repeat,
                                                duration:
                                                    controller.duration.value,
                                                position:
                                                    controller.playerPosition),
                                          ),
                                        ))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Loading()),
            )),
      ),
    );
  }
}

//Obx(()=>ListView.builder(
//                                 physics: controller.autoScroll.value ? NeverScrollableScrollPhysics() : null,
//                                 controller: controller.scrollController,
//                                 itemCount: 1,
//                                 itemBuilder: (context, index) {
//                                   Widget returnWidget = Container(
//                                     child: Obx(() =>
//                                     controller.fa.value == true ||
//                                         controller.en.value == true
//                                         ? Column(
//                                       children: [
//                                         controller.en.value == true
//                                             ? Directionality(
//                                           textDirection: TextDirection.ltr,
//                                           child: FutureBuilder<List<InlineSpan>>(
//                                             future: controller.getCurrentText(index, false),
//                                             builder: (_context , item){
//                                               return Container(
//                                                   child: RichText(
//                                                     text: TextSpan(
//                                                       style: const TextStyle(
//                                                         fontSize: 18.0,
//                                                         color: Colors.black,
//                                                       ),
//                                                       children:item.data,
//                                                     ),
//                                                   ));
//                                             },),
//                                         )
//                                             : Container(),
//                                         SizedBox(
//                                           height: 6,
//                                         ),
//                                         controller.fa.value == true
//                                             ? Directionality(
//                                           textDirection: TextDirection.rtl,
//                                           child: FutureBuilder<List<InlineSpan>>(
//                                             future: controller.getCurrentText(index, true),
//                                             builder: (_context , item){
//                                               return Container(
//                                                   child: RichText(
//                                                     text: TextSpan(
//                                                       style: const TextStyle(
//                                                         fontSize: 18.0,
//                                                         color: Colors.black,
//                                                       ),
//                                                       children:item.data,
//                                                     ),
//                                                   ));
//                                             },),
//                                         )
//                                             : Container(),
//                                         SizedBox(
//                                           height: 24,
//                                         ),
//                                       ],
//                                     )
//                                         : Container()),
//                                   );
//                                   return returnWidget;
//                                 })
