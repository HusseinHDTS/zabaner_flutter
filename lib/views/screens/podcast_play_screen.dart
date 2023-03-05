import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:zabaner/controllers/play_podcast_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/widgets/bottom_player.dart';
import 'package:zabaner/views/widgets/subtitle_tile.dart';
import 'package:zabaner/views/widgets/text_highlight.dart';
import 'package:zabaner/models/level.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'dart:io' as io;

import '../../widgets/my_app_bar.dart';

class PodcastPlay extends StatefulWidget {
  PodcastPlay({Key? key, required this.isGuest, required this.id})
      : super(key: key);
  final String id;
  final bool isGuest;

  @override
  State<PodcastPlay> createState() => _PodcastPlayState();
}

class _PodcastPlayState extends State<PodcastPlay> {
  final PlayPodcastController controller = Get.put(PlayPodcastController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.customeInit();

    controller.getPodcastItemData(widget.id, widget.isGuest).then((value) {
      controller.initSubtitle(widget.id);
      controller.isPodcastExists.value = controller.isFileExists(getUrlFileName(controller.appDoc.path,widget.id,controller.podcastItem.podcastPath));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //!controller.en.value && !controller.fa.value
    var screenSize = MediaQuery.of(context).size;
    // controller.podcastItem.title
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
              backgroundColor: primary,
              actions: [
                InkWell(
                  onTap: () => controller.autoScroll.toggle(),
                  child: Obx(() => Container(
                        margin:
                            EdgeInsets.symmetric(vertical: Get.height / 60),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: controller.autoScroll.value
                                ? Colors.blue
                                : Colors.red
                            // border: Border.all(
                            // color: controller.autoScroll.value
                            //     ? Colors.black
                            //     : Colors.grey,
                            // width: 0.6)
                            ),
                        child: Row(children: const [
                          Icon(Icons.arrow_drop_down_sharp,
                              color: Colors.black),
                          Icon(Icons.arrow_drop_up_sharp,
                              color: Colors.black),
                        ]),
                      )),
                ),
                Row(
                  children: [
                    const Text("   انگلیسی:",
                        style:
                            TextStyle(fontFamily: "Yekan", fontSize: 16)),
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
                        style:
                            TextStyle(fontFamily: "Yekan", fontSize: 16)),
                    Obx(() => Switch(
                          value: controller.fa.value,
                          onChanged: (value){
                            controller.fa.value = value;
                          },
                        ))
                  ],
                )
              ]),
          body: Obx(()=>controller.isDataLoaded.isTrue ? Stack(children: [
            // Paragraph
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
              child: GetBuilder<PlayPodcastController>(init: controller,builder: (_ctrler){
                return SingleChildScrollView(
                  controller: _ctrler.scrollController,
                  child: Obx(()=> _ctrler.isSubtitleLoaded.isFalse ? Center(child: Container(margin:EdgeInsets.only(top: 20),child: Loading()),) : Column(children: List.generate(controller.getParAsLang(null).length +1, (index){
                    Widget returnWidget = index == 0
                        ? SizedBox(
                        width: Get.width,
                        child: Text(
                          "\n" +
                              controller
                                  .podcastItem.title +
                              " \n",
                          style: const TextStyle(
                            fontFamily: "Yekan",
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,
                        ))
                        : Obx(()=>SubtitleTile(faVisible: _ctrler.fa.value, enVisible: _ctrler.en.value, faTile: _ctrler.getCurrentText(index-1, true),enTile: _ctrler.getCurrentText(index-1, false)));
                    if(index == controller.getParAsLang(null).length){
                      return Column(children: [
                        returnWidget,
                        Obx(()=>SizedBox(height: _ctrler.isHide.value ? hiddenHeight : normalHeight,)),
                      ],);
                    }
                    return returnWidget;
                  }) ) ),
                );
              },),
            ),
            Align(alignment: Alignment.bottomCenter,child: Obx(()=>AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: controller.isHide.value
                  ? hiddenHeight
                  : normalHeight,
              child: BottomPlayer(
                  isVideo: false,
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
                    controller.player.seekToPlayer(Duration(
                        milliseconds: newPos));
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
                    controller.player.seekToPlayer(Duration(
                        milliseconds: newPos));
                  },
                  isFileExists: controller.isPodcastExists,
                  isInitialized:true.obs,
                  onInitialize: (){

                  },
                  isPlaying: controller.isPlaying,
                  resumePlayer: ()=> controller.player.resumePlayer(),
                  pausePlayer: ()=> controller.player.pausePlayer(),
                  downloadRequest: ()=>controller.download(controller.podcastItem.podcastPath, widget.id,controller.podcastItem.title),
                  togglePlayer: () async{
                    var filePath = getUrlFileName(controller.appDoc.path,widget.id,controller.podcastItem.podcastPath);
                    controller.togglePlayer(filePath);
                    return true;
                  },
                  toggleHide: ()=>controller.isHide.toggle(),
                  togglePlayerSpeed: (){
                    if (controller.isPlaying.value) {
                      if (controller.playSpeed.value ==
                          0.5) {
                        controller.playSpeed.value = 1;
                        controller.player.setSpeed(1);
                      } else if (controller.playSpeed.value ==1) {
                        controller.playSpeed.value = 2;
                        controller.player.setSpeed(2);
                      } else if (controller.playSpeed.value ==2) {
                        controller.playSpeed.value = 0.5;
                        controller.player.setSpeed(0.5);
                      }
                    }
                  },
                  playSpeed: controller.playSpeed,
                  player: controller.player,
                  isHide: controller.isHide,
                  repeat: controller.repeat,
                  duration: controller.duration.value,
                  position: controller.playerPosition),
            )),),
          ]) : Loading())),
        ),
    );
  }
}
