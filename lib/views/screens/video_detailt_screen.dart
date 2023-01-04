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
    controller.customeInit(widget.id , widget.isGuest);
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
            body: Directionality(textDirection: TextDirection.ltr,child: controller.obx((state) =>  Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Get.width / 50, vertical: 5),
                    child: Obx(() =>
                    controller.videoInitialized.value
                        ?  AspectRatio(
                      aspectRatio:
                      // controller.videoController.value.aspectRatio,
                      16/9,
                      child: Stack(
                        children: [
                          ClipRRect(borderRadius:BorderRadius.circular(16),child: Chewie(controller: controller.chewieController))
                          // BetterPlayer.file(controller.getFile(widget.id,controller.videoItems.value.title)),
                          // VideoPlayer(controller.videoController),
                        ],
                      ),
                    )
                        :   Container(margin:EdgeInsets.all(18),width:100,height: 100,child: CircularProgressIndicator())
                    )
                ),

                // Icons
                SizedBox(
                  width: Get.width / 1.1,
                  height: Get.height / 20,
                  child:
                  // download and text visible icon
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                Obx(() =>
                                    Switch(
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
                                Obx(() =>
                                    Switch(
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
                          child: Obx(() =>
                              Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: Get.height / 100),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        8),
                                    color: controller.autoScroll.value
                                        ? Colors.blue
                                        : Colors.red
                                ),
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

                // paragraphs
                Expanded(
                  flex: 1,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                    child: SingleChildScrollView(
                      controller: controller.scrollController,
                      child:Obx(()=> Column(children: List.generate(controller.getParAsLang(null).length , (index){
                        debugPrint("dsakdjsakjdksajdlksajkdsja : Updateing");
                        Widget returnWidget = Column(
                          children: [
                            controller.en.value == true
                                ? Directionality(
                              textDirection: TextDirection.ltr,
                              child: FutureBuilder<List<InlineSpan>>(
                                future: controller.getCurrentText(index, false),
                                builder: (_context , item){
                                  return RichText(
                                    text: TextSpan(
                                      style: getSubDefault(false),
                                      children:item.data,
                                    ),
                                  );
                                },),
                            )
                                : Container(),
                            SizedBox(
                              height: 6,
                            ),
                            controller.fa.value == true
                                ? Directionality(
                              textDirection: TextDirection.rtl,
                              child: FutureBuilder<List<InlineSpan>>(
                                future: controller.getCurrentText(index, true),
                                builder: (_context , item){
                                  return RichText(
                                    text: TextSpan(
                                      style: getSubDefault(true),
                                      children:item.data,
                                    ),
                                  );
                                },),
                            )
                                : Container(),
                            SizedBox(
                              height: 24,
                            ),
                          ],
                        );
                        return returnWidget;
                      }))),
                    ),
                  ),
                ),

                Obx(() =>
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
                                        if (controller.playIndex !=
                                            controller.videoItems.value
                                                .paragraphs
                                                .length -
                                                1) {
                                          controller.chewieController
                                              .seekTo(
                                              Duration(
                                                  milliseconds: controller
                                                      .videoItems
                                                      .value
                                                      .paragraphs[
                                                  controller.playIndex +
                                                      1]
                                                      .pst));
                                        }
                                      },
                                      child: const Icon(
                                          Icons.arrow_back)),

                                  // play or pause
                                  Obx(() =>
                                      InkWell(
                                          onTap: () {
                                            controller
                                                .chewieController.togglePause();
                                            // if (!controller.isPlaying
                                            //     .value) {
                                            //   controller
                                            //       .chewieController
                                            //       .play();
                                            //   // controller.chewieController.isHide.value = true;
                                            // } else {
                                            //   controller
                                            //       .chewieController
                                            //       .pause();
                                            //   controller.isPlaying
                                            //       .value = false;
                                            // }
                                          },
                                          child: Icon(
                                              controller.isPlaying.value
                                                  ? Icons.pause
                                                  : Icons.play_arrow))),

                                  // backward
                                  InkWell(
                                      onTap: () {
                                        if (controller.playIndex != 0) {
                                          controller.chewieController
                                              .seekTo(
                                              Duration(
                                                  milliseconds: controller
                                                      .videoItems
                                                      .value
                                                      .paragraphs[
                                                  controller.playIndex -
                                                      1]
                                                      .pst));
                                        }
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

                SizedBox(
                  height: Get.height / 60,
                )
              ],
            )),)
        ),
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
