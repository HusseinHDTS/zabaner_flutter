import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/tabbar_item_controller.dart';
import 'package:zabaner/models/tabbar_item.dart';
import 'package:zabaner/models/level.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/widgets/bottom_player.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/custom_video_player.dart';
import 'package:zabaner/widgets/my_app_bar.dart';
import 'dart:io' as io;

class TabbarItemScreen extends StatefulWidget {
  TabbarItem item;

  TabbarItemScreen(this.item);

  @override
  State<TabbarItemScreen> createState() => _TabbarItemScreen(item);
}

class _TabbarItemScreen extends State<TabbarItemScreen> {
  TabbarItem item;

  _TabbarItemScreen(this.item);

  final TabbarItemController controller = Get.put(TabbarItemController());

  @override
  void initState() {
    super.initState();
    controller.customeInit(item);
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
            appBar: ColoredAppBar(),
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: Column(children: [
                Expanded(flex:0,child: Container(margin:EdgeInsets.all(8),child: AspectRatio(aspectRatio: 16/9,child: Obx(() => controller.appDocInit.value ? getVideoView(io.File(getUrlFileName(controller.appDoc.path,  item.id,
                    item.video)),
                    CustomVideoType.STORAGE,
                    withThumb: true,
                    retryImage: customVideoPlayerTag.value == getUrlFileName(controller.appDoc.path, item.id,
                        item.video),showPreviewOverlay: false) : Container()),),)),
                Expanded(flex: 1,child: Container(height: double.infinity,),),
                Expanded(flex:0,
                  child: Align(alignment: Alignment.bottomCenter,child: Obx(()=>AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: controller.isHide.value
                        ? hiddenHeight
                        : normalHeight,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: BottomPlayer(
                          isVideo: true,
                          isSingleSetting: true,
                          forward: () {
                            // var data = getPlayerIndex(
                            //     controller
                            //         .getParAsLang(
                            //         null),
                            //     controller
                            //         .playIndexList,
                            //     controller
                            //         .playIndexInList,
                            //     true);
                            // controller.currentSavedTime.value = data[2];
                            // controller.playerPosition.value = Duration(milliseconds: data[2]);
                            // controller.playIndexList = data[0];
                            // controller.playIndexInList = data[1];
                            var newPos = controller.playerPosition.value.inMilliseconds+5100;
                            if(newPos > controller.duration.value.inMilliseconds) newPos = controller.duration.value.inMilliseconds -100;
                            controller.playerPosition.value = Duration(milliseconds: newPos);
                            customVideoPlayerController!.seekTo(newPos.toDouble());
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
                            var newPos = controller.playerPosition.value.inMilliseconds-5100;
                            if(newPos < 0) newPos = 0;
                            controller.playerPosition.value = Duration(milliseconds: newPos);
                            customVideoPlayerController!.seekTo(newPos.toDouble());
                          },
                          isFileExists: controller.isVideoExists,
                          isInitialized:controller.videoInitialized,
                          isPlaying: controller.isPlaying,
                          onInitialize: (){
                            controller.initVideo(item.id,item.video);
                          },
                          resumePlayer: () =>
                          controller.videoInitialized.value
                              ? customVideoPlayerController!.togglePause()
                              : {},
                          pausePlayer: () => controller
                              .videoInitialized.value
                              ? customVideoPlayerController!.togglePause()
                              : {},
                          downloadRequest: (){
                            if (item.video.substring(item.video.lastIndexOf(".") + 1) == "mp4") {
                              controller.download(item.video, item.id, item.title);
                            } else {
                              Get.back();
                              ColoredSnack(
                                  title: "ویدیویی برای این بخش وجود ندارد", type: SnackType.ERROR);
                            }
                          },
                          togglePlayer: () async{
                            customVideoPlayerController!.togglePause();
                            return true;
                          },
                          toggleHide: ()=>controller.isHide.toggle(),
                          togglePlayerSpeed: (){
                            if (controller.isPlaying.value) {
                              if (controller.playSpeed.value ==
                                  0.5) {
                                controller.playSpeed.value = 1;
                                customVideoPlayerController!.videoPlayerController.setPlaybackSpeed(1);
                              } else if (controller.playSpeed.value ==1) {
                                controller.playSpeed.value = 2;
                                customVideoPlayerController!.videoPlayerController.setPlaybackSpeed(2);
                              } else if (controller.playSpeed.value ==2) {
                                controller.playSpeed.value = 0.5;
                                customVideoPlayerController!.videoPlayerController.setPlaybackSpeed(0.5);
                              }
                            }
                          },
                          playSpeed: controller.playSpeed,
                          player: controller.videoInitialized.value ? customVideoPlayerController!.videoPlayerController : null,
                          isHide: controller.isHide,
                          repeat: controller.repeat,
                          duration: controller.duration.value,
                          position: controller.playerPosition),
                    ),
                  )),),
                ),
              ],),
            ),
          )),
    );
  }
}
