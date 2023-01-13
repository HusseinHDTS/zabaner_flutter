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
            appBar: AppBar(
                leadingWidth: Get.width,
                backgroundColor: orange,
                elevation: 0,
                leading: Padding(
                  padding: EdgeInsets.only(right: Get.width / 40),
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Colors.white,
                        ),
                        Text(
                          "بازگشت",
                          style: TextStyle(
                              fontFamily: "Yekan", color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )),
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: Column(children: [
                Expanded(flex:0,child: Container(margin:EdgeInsets.all(8),child: AspectRatio(aspectRatio: 16/9,child: Obx(() => controller.videoInitialized.value
                    ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Chewie(
                        controller:
                        controller.chewieController))
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(decoration: BoxDecoration(color: Colors.grey),),
                )),),)),
                Expanded(flex: 1,child: Container(height: double.infinity,),),
                Expanded(flex:0,
                  child: Align(alignment: Alignment.bottomCenter,child: Obx(()=>AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: controller.isHide.value
                        ? hiddenHeight
                        : normalHeight,
                    child: BottomPlayer(
                        isVideo: true,
                        isFileExists: controller.isVideoExists,
                        isInitialized:controller.videoInitialized,
                        isPlaying: controller.isPlaying,
                        onInitialize: (){
                          controller.initVideo(item.id,item.video);
                        },
                        resumePlayer: () =>
                        controller.videoInitialized.value
                            ? controller.chewieController.togglePause()
                            : {},
                        pausePlayer: () => controller
                            .videoInitialized.value
                            ? controller.chewieController.togglePause()
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
                          controller.chewieController.togglePause();
                          return true;
                        },
                        toggleHide: ()=>controller.isHide.toggle(),
                        togglePlayerSpeed: (){
                          if (controller.isPlaying.value) {
                            if (controller.playSpeed.value ==
                                0.5) {
                              controller.playSpeed.value = 1;
                              controller.chewieController.videoPlayerController.setPlaybackSpeed(1);
                            } else if (controller.playSpeed.value ==1) {
                              controller.playSpeed.value = 2;
                              controller.chewieController.videoPlayerController.setPlaybackSpeed(2);
                            } else if (controller.playSpeed.value ==2) {
                              controller.playSpeed.value = 0.5;
                              controller.chewieController.videoPlayerController.setPlaybackSpeed(0.5);
                            }
                          }
                        },
                        playSpeed: controller.playSpeed,
                        player: controller.videoInitialized.value ? controller.chewieController : null,
                        isHide: controller.isHide,
                        repeat: controller.repeat,
                        duration: controller.duration.value,
                        position: controller.playerPosition),
                  )),),
                ),

              ],),
            ),
          )),
    );
  }
}
