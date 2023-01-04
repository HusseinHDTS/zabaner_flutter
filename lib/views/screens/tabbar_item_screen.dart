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
                Expanded(flex:0,child: Container(margin:EdgeInsets.all(8),child: AspectRatio(aspectRatio: 16/9,child: Obx(()=> controller.videoInitialized.isTrue ? ClipRRect(borderRadius:BorderRadius.circular(16),child: Chewie(controller: controller.chewieController)) : Container() ),),)),
                Expanded(flex: 1,child: Container(height: double.infinity,),),
                Expanded(flex:0,
                  child: Obx(() =>
                      AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: controller.isHide.value
                              ? Get.height / 10 / 1.5
                              : Get.height / 10,
                          child: Column(children: [
                            // hide or show icon
                            SizedBox(
                              height: Get.height / 37,
                              child: InkWell(
                                onTap: () => controller.isHide.toggle(),
                                child: Image.asset(
                                  controller.isHide.value
                                      ? "assets/images/upward2.png"
                                      : "assets/images/downward2.png",
                                  height: double.infinity,
                                ),
                              ),
                            ),

                            // seekbar
                            Expanded(
                                flex: controller.isHide.value ? 1 : 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
                                  children: [
                                    Obx(() =>
                                        Text((controller.duration.value
                                            .inSeconds -
                                            controller.playerPosition
                                                .value.inSeconds)
                                            .formatTimer())),
                                    SizedBox(
                                        width: Get.width / 1.3,
                                        child: Obx(() =>
                                            Slider(
                                              value: controller
                                                  .playerPosition.value
                                                  .inMilliseconds
                                                  .toDouble(),
                                              min: 0,
                                              max: controller
                                                  .duration.value
                                                  .inMilliseconds
                                                  .toDouble(),
                                              onChanged: (value) {
                                                controller.playerPosition
                                                    .value =
                                                    Duration(
                                                        milliseconds: value
                                                            .toInt());
                                              },
                                              onChangeEnd: (value) {
                                                controller.chewieController
                                                    .seekTo(
                                                    Duration(
                                                        milliseconds: value
                                                            .toInt()));
                                              },
                                            ))),
                                    Text(
                                        controller.duration.value
                                            .inSeconds.formatTimer())
                                  ],
                                )),

                            // controll option buttons
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: controller.isHide.value
                                  ? const SizedBox()
                                  : Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceAround,
                                  children: [
                                    // play speed
                                    InkWell(
                                        onTap: () {
                                          if (controller.isPlaying
                                              .value) {
                                            if (controller.playSpeed
                                                .value == 0.5) {
                                              controller.playSpeed.value =
                                              1;
                                              controller.chewieController.videoPlayerController.setPlaybackSpeed(1);
                                            } else
                                            if (controller.playSpeed
                                                .value ==
                                                1) {
                                              controller.playSpeed.value =
                                              2;
                                              controller.chewieController.videoPlayerController.setPlaybackSpeed(2);
                                            } else
                                            if (controller.playSpeed
                                                .value ==
                                                2) {
                                              controller.playSpeed.value =
                                              0.5;
                                              controller.chewieController.videoPlayerController.setPlaybackSpeed(0.5);
                                            }
                                          }
                                        },
                                        child: Obx(() =>
                                            Text(
                                              controller.playSpeed.value
                                                  .toString() +
                                                  "x",
                                              style: const TextStyle(
                                                  fontSize: 18),
                                            ))),

                                    // forward
                                    InkWell(
                                        onTap: () {
                                        },
                                        child: const Icon(
                                            Icons.arrow_back)),

                                    // play or pause
                                    Obx(() =>
                                        InkWell(
                                            onTap: () {
                                              if (!controller.isPlaying
                                                  .value) {
                                                controller
                                                    .chewieController
                                                    .play();
                                              } else {
                                                controller
                                                    .chewieController
                                                    .pause();
                                                controller.isPlaying
                                                    .value = false;
                                              }
                                            },
                                            child: Icon(
                                                controller.isPlaying.value
                                                    ? Icons.pause
                                                    : Icons.play_arrow))),

                                    // backward
                                    InkWell(
                                        onTap: () {
                                        },
                                        child: const Icon(
                                            Icons.arrow_forward)),

                                    // repeat
                                    InkWell(
                                        onTap: () {
                                          // controller.repeat.toggle();
                                        },
                                        child: Obx(() =>
                                            Icon(
                                                controller.repeat.value
                                                    ? Icons.repeat_one
                                                    : Icons.repeat))),
                                  ],
                                ),
                              ),
                            )
                          ]))),
                ),

                SizedBox(
                  height: Get.height / 60,
                )
              ],),
            ),
          )),
    );
  }
}
