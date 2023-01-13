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
import 'package:zabaner/views/widgets/text_highlight.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';

class VideoDetailScreen extends StatefulWidget {
  VideoDetailScreen({Key? key, required this.isGuest, required this.id})
      : super(key: key);
  final bool isGuest;
  final String id;

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  final VideoController controller = Get.put(VideoController());

  @override
  void initState() {
    super.initState();
    controller.customeInit(widget.id, widget.isGuest);
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
              leading: InkWell(
                  onTap: () {
                    controller.onClose();
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back)),
              backgroundColor: orange,
            ),
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: Obx(()=>controller.isDataLoaded.isTrue ? Column(
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: Get.width / 50, vertical: 5),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          children: [
                            Obx(() => controller.videoInitialized.value
                                ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Chewie(
                                    controller:
                                    controller.chewieController))
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(decoration: BoxDecoration(color: Colors.grey),),
                            ))
                          ],
                        ),
                      )),

                  // Icons
                  SizedBox(
                    width: Get.width / 1.1,
                    height: Get.height / 20,
                    child:
                    // download and text visible icon
                    Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // bookmark icon
                              Row(
                                children: [
                                  const Text("   انگلیسی:",
                                      style: TextStyle(
                                          fontFamily: "Yekan",
                                          fontSize: 16)),
                                  Obx(() => Switch(
                                    value: controller.en.value,
                                    onChanged: (value) {
                                      controller.en.value = value;
                                    },
                                  ))
                                ],
                              ),

                              Row(
                                children: [
                                  const Text(" فارسی:",
                                      style: TextStyle(
                                          fontFamily: "Yekan",
                                          fontSize: 16)),
                                  Obx(() => Switch(
                                    value: controller.fa.value,
                                    onChanged: (value) {
                                      controller.fa.value = value;
                                    },
                                  ))
                                ],
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => controller.autoScroll.toggle(),
                            child: Obx(() => Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: Get.height / 100),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(8),
                                  color: controller.autoScroll.value
                                      ? Colors.blue
                                      : Colors.red),
                              child: Row(children: const [
                                Icon(Icons.arrow_drop_down_sharp,
                                    color: Colors.black),
                                Icon(Icons.arrow_drop_up_sharp,
                                    color: Colors.black),
                              ]),
                            )),
                          ),
                        ]),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            child: GetBuilder<VideoController>(
                              init: controller,
                              builder: (_ctrler) {
                                return SingleChildScrollView(
                                  controller: _ctrler.scrollController,
                                  child: Column(
                                      children: List.generate(
                                          _ctrler.getParAsLang(null).length,
                                              (index) {
                                            Widget returnWidget = Obx(() => Column(
                                              children: [
                                                _ctrler.en.value == true
                                                    ? Directionality(
                                                  textDirection:
                                                  TextDirection.ltr,
                                                  child: FutureBuilder<
                                                      List<InlineSpan>>(
                                                    future: _ctrler
                                                        .getCurrentText(
                                                        index, false),
                                                    builder:
                                                        (_context, item) {
                                                      return RichText(
                                                        text: TextSpan(
                                                          style:
                                                          getSubDefault(
                                                              false),
                                                          children:
                                                          item.data,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                                    : Container(),
                                                const SizedBox(
                                                  height: 6,
                                                ),
                                                _ctrler.fa.value == true
                                                    ? Directionality(
                                                  textDirection:
                                                  TextDirection.rtl,
                                                  child: FutureBuilder<
                                                      List<InlineSpan>>(
                                                    future: _ctrler
                                                        .getCurrentText(
                                                        index, true),
                                                    builder:
                                                        (_context, item) {
                                                      return RichText(
                                                        text: TextSpan(
                                                          style:
                                                          getSubDefault(
                                                              true),
                                                          children:
                                                          item.data,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                                    : Container(),
                                                const SizedBox(
                                                  height: 24,
                                                ),
                                              ],
                                            ));
                                            if (index ==
                                                controller
                                                    .getParAsLang(null)
                                                    .length -
                                                    1) {
                                              return Column(
                                                children: [
                                                  returnWidget,
                                                  Obx(() => SizedBox(
                                                    height: _ctrler.isHide.value
                                                        ? hiddenHeight
                                                        : normalHeight,
                                                  )),
                                                ],
                                              );
                                            }
                                            return returnWidget;
                                          })),
                                );
                              },
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Obx(() => Directionality(
                                textDirection: TextDirection.rtl,
                                child: AnimatedContainer(
                                  duration:
                                  const Duration(milliseconds: 500),
                                  height: controller.isHide.value
                                      ? hiddenHeight
                                      : normalHeight,
                                  child: BottomPlayer(
                                      isVideo: true,
                                      isFileExists: controller.isVideoExists,
                                      isInitialized:
                                      controller.videoInitialized,
                                      isPlaying:
                                      controller.isPlaying,
                                      onInitialize: () {
                                        controller.initVideo(
                                            controller
                                                .videoItems.value.id,
                                            controller.videoItems.value
                                                .videoPath);
                                      },
                                      resumePlayer: () {
                                        if(!controller.videoInitialized.value) return;
                                        controller.chewieController.togglePause();
                                        controller.chewieController.showControls;
                                        // controller.chewieController.notifyListeners();
                                      },
                                      pausePlayer: () {
                                        if(!controller.videoInitialized.value) return;
                                        controller.chewieController.togglePause();
                                      },
                                      downloadRequest: () => controller.download(
                                          controller.videoItems.value.videoPath,
                                          controller.videoItems.value.id,
                                          controller.videoItems.value.title),
                                      togglePlayer: () async {
                                        controller.chewieController
                                            .togglePause();
                                        return true;
                                      },
                                      toggleHide: () => controller.isHide.toggle(),
                                      togglePlayerSpeed: () {
                                        if (controller
                                            .isPlaying.value) {
                                          if (controller
                                              .playSpeed.value ==
                                              0.5) {
                                            controller.playSpeed.value =
                                            1;
                                            controller.chewieController
                                                .videoPlayerController
                                                .setPlaybackSpeed(1);
                                          } else if (controller
                                              .playSpeed.value ==
                                              1) {
                                            controller.playSpeed.value =
                                            2;
                                            controller.chewieController
                                                .videoPlayerController
                                                .setPlaybackSpeed(2);
                                          } else if (controller
                                              .playSpeed.value ==
                                              2) {
                                            controller.playSpeed.value =
                                            0.5;
                                            controller.chewieController
                                                .videoPlayerController
                                                .setPlaybackSpeed(0.5);
                                          }
                                        }
                                      },
                                      playSpeed: controller.playSpeed,
                                      player: controller.videoInitialized.value ? controller.chewieController : null,
                                      isHide: controller.isHide,
                                      repeat: controller.repeat,
                                      duration: controller.duration.value,
                                      position: controller.playerPosition),
                                ),
                              ))),
                        ],
                      ),
                    ),
                  ),
                ],
              ) : Loading()),
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
