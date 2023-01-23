import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/level.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/widgets/play_button.dart';
import 'package:zabaner/widgets/colored_text.dart';

class BottomPlayer extends StatelessWidget {

  RxBool isHide, repeat , isFileExists , isInitialized,isPlaying;
  bool isVideo ;
  Rx<Duration> position;
  Duration duration;
  var pausePlayer , resumePlayer , backward , forward;
  var player, playSpeed, togglePlayer,downloadRequest, togglePlayerSpeed, toggleHide, onInitialize;

  BottomPlayer({Key? key, required this.isPlaying,
    required this.isVideo,
    required this.isInitialized,
    required this.playSpeed,
    required this.downloadRequest,
    this.backward,
    this.forward,
    required this.resumePlayer,
    required this.pausePlayer,
    required this.togglePlayer,
    required this.onInitialize,
    required this.toggleHide,
    required this.togglePlayerSpeed,
    required this.player,
    required this.isFileExists,
    required this.isHide,
    required this.repeat,
    required this.duration,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: orangeDarkTransparent,
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(38, 48))),
      padding: const EdgeInsets.only(right: 14,left: 14,top: 10,bottom: 2),
      child: Column(children: [
        // SizedBox(
        //   height: Get.height / 30,
        //   child: InkWell(
        //     onTap: toggleHide,
        //     child: Image.asset(
        //       isHide.value
        //           ? "assets/images/upward2.png"
        //           : "assets/images/downward2.png",
        //       color: Colors.white,
        //       height: double.infinity,
        //     ),
        //   ),
        // ),

        if (isHide.value) const SizedBox() else Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceAround,
            children: [
              // play speed
              InkWell(
                  onTap: togglePlayerSpeed,
                  child: Obx(() =>
                      ColoredText(
                        "${playSpeed.value}x", textSize: 18,
                        textColor: Colors.white,
                      ))),

              // forward
              InkWell(
                onTap: forward,
                  // onTap: () {
                    // if (controller.ind !=
                    //     controller.podcastItem.paragraphs
                    //         .length -
                    //         1) {
                    //   controller.player.seekToPlayer(
                    //       Duration(
                    //           milliseconds: controller
                    //               .podcastItem
                    //               .paragraphs[
                    //           controller.ind + 1]
                    //               .pst));
                    // }
                  // },
                  child: const Icon(Icons.fast_forward_rounded, color: Colors.white,size: 30)),

              // play or pause
              // Obx(() => InkWell(
              //     onTap: togglePlayer,
              //     child: Icon(isPlaying.value
              //         ? Icons.pause
              //         : Icons.play_arrow,color: Colors.white,))),

              SizedBox(
                width: 40,
                height: 40,
                child: Obx(()=>PlayButton(
                  initialIsPlaying: isPlaying,
                  pauseIcon: const Icon(Icons.pause, color: Colors.black, size: 20),
                  playIcon: Icon(isFileExists.value ? Icons.play_arrow : Icons.download_rounded, color: Colors.black, size: 20),
                  onPressed:()async {
                    if(!isFileExists.value){
                      downloadRequest();
                      return false;
                    }
                    if(!isInitialized.value){
                      onInitialize();
                    }
                    return await togglePlayer();
                  },)),
              ),

              // backward
              InkWell(
                  onTap: backward,
                  // onTap: () {
                    // if (controller.ind != 0) {
                    //   controller.player.seekToPlayer(
                    //       Duration(
                    //           milliseconds: controller
                    //               .podcastItem
                    //               .paragraphs[
                    //           controller.ind - 1]
                    //               .pst));
                    // }
                  // },
                  child: const Icon(Icons.fast_rewind_rounded, color: Colors.white,size: 30,)),

              // repeat
              InkWell(
                  onTap: () {
                    repeat.toggle();
                  },
                  child: Obx(() =>
                      Icon(
                        repeat.value
                            ? Icons.repeat_one
                            : Icons.repeat, color: Colors.white,))),
            ],
          ),
        ),

        Directionality(
          textDirection: TextDirection.ltr,
          child: Expanded(
              flex: isHide.value ? 1 : 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(flex: 0, child: Obx(() =>
                      ColoredText(isInitialized.value ? (position.value.inSeconds).formatedTime() : "--:--", textColor: Colors.white,))),
                  Flexible(flex: 1, child: SizedBox(
                      width: double.infinity,
                      child: Obx(() =>
                          Slider(
                            value: position.value.inMilliseconds.toDouble(),
                            min: 0,
                            max: duration.inMilliseconds.toDouble(),
                            onChanged: (value) {
                              position.value =
                                  Duration(milliseconds: value.toInt());
                              requestForSeekBar(false);
                            },
                            onChangeEnd: (value) {
                              if(isVideo){
                                if(player == null){
                                  return;
                                }
                                player.seekTo(Duration(
                                    milliseconds:
                                    value.toInt()));
                              }else{
                                player.seekToPlayer(
                                    Duration(
                                        milliseconds:
                                        value.toInt()));
                              }
                              requestForSeekBar(true);
                            },
                          )))),
                  Flexible(flex: 0,
                      child: Obx(()=>ColoredText(isInitialized.value ? duration.inSeconds.formatTimer() : "--:--",textColor: Colors.white,))),
                ],
              )),
        ),

      ]),
    );
  }

  bool _playerStateForSekkbar = false;

  requestForSeekBar(bool hasToPlay) {
    if (hasToPlay == false) {
      if (isPlaying.isTrue) {
        _playerStateForSekkbar = true;
      } else {
        _playerStateForSekkbar = false;
      }
      pausePlayer();
    } else {
      if (_playerStateForSekkbar) {
        resumePlayer();
      }
    }
  }



}