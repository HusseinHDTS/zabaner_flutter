import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/level.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/widgets/play_button.dart';
import 'package:zabaner/widgets/colored_text.dart';

class BottomPlayer extends StatelessWidget {
  RxBool isHide, repeat, isFileExists, isInitialized, isPlaying;
  RxBool? autoScroll = false.obs , faTitle = false.obs , enTitle = false.obs;
  String? settingsId;
  bool isVideo;
  bool isSingleSetting;

  Rx<Duration> position;
  Duration duration;
  var pausePlayer, resumePlayer, backward, forward;
  var player,
      playSpeed,
      togglePlayer,
      downloadRequest,
      togglePlayerSpeed,
      toggleHide,
      onInitialize;

  BottomPlayer({
    Key? key,
    required this.isPlaying,
    required this.isVideo,
    required this.isInitialized,
    required this.playSpeed,
    required this.downloadRequest,
    this.backward,
    this.isSingleSetting = false,
    this.forward,
    this.settingsId,
    this.autoScroll,
    this.faTitle,
    this.enTitle,
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
    repeat = (getItemSettings(settingsId)['repeat'] == "on").obs;
    return Container(
      decoration: BoxDecoration(
          color: primaryDarkTransparent,
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(38, 48))),
      padding: const EdgeInsets.only(right: 14, left: 14, top: 10, bottom: 2),
      child: Column(children: [

        if (isHide.value)
          const SizedBox()
        else
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // play speed
                InkWell(
                    onTap: togglePlayerSpeed,
                    child: Obx(() => ColoredText(
                          "${playSpeed.value}x",
                          textSize: 18,
                          textColor: Colors.white,
                        ))),

                // forward
                InkWell(
                    onTap: forward,
                    child: const Icon(Icons.fast_forward_rounded,
                        color: Colors.white, size: 30)),

                SizedBox(
                  width: 40,
                  height: 40,
                  child: Obx(() => PlayButton(
                        initialIsPlaying: isPlaying,
                        pauseIcon: const Icon(Icons.pause,
                            color: Colors.black, size: 20),
                        playIcon: Icon(
                            isFileExists.value
                                ? Icons.play_arrow
                                : Icons.download_rounded,
                            color: Colors.black,
                            size: 20),
                        onPressed: () async {
                          if (!isFileExists.value) {
                            downloadRequest();
                            return false;
                          }
                          if (!isInitialized.value) {
                            onInitialize();
                          }
                          return await togglePlayer();
                        },
                      )),
                ),

                // backward
                InkWell(
                    onTap: backward,
                    child: const Icon(
                      Icons.fast_rewind_rounded,
                      color: Colors.white,
                      size: 30,
                    )),

                // repeat
                InkWell(
                    onTap: () {
                      if(isSingleSetting){
                        repeat.toggle();
                        writeSetting("$settingsId/repeat", repeat.value == true ? "on" : "off");
                        return;
                      }
                      Get.bottomSheet(
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              topRoundedMiniBar(title: "تنظیمات",height: 45),
                              Container(
                                decoration: BoxDecoration(color: Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 18),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      toggleItem("اسکرول خودکار",autoScroll!,onChange: (value){
                                        if(settingsId != null){
                                          writeSetting("$settingsId/autoScroll", value == true ? "on" : "off");
                                        }
                                      }),
                                      // SizedBox(height: 8,),
                                      // toggleItem("زیرنویس انگلیسی",enTitle!,onChange: (value){
                                      //   if(settingsId != null){
                                      //     writeSetting("$settingsId/enTitle", value == true ? "on" : "off");
                                      //   }
                                      // }),
                                      // SizedBox(height: 8,),
                                      // toggleItem("زیرنویس فارسی",faTitle!,onChange: (value){
                                      //   if(settingsId != null){
                                      //     writeSetting("$settingsId/faTitle", value == true ? "on" : "off");
                                      //   }
                                      // }),
                                      SizedBox(height: 8,),
                                      toggleItem("تکرار خودکار",repeat,onChange: (value){
                                        if(settingsId != null){
                                          writeSetting("$settingsId/repeat", value == true ? "on" : "off");
                                        }
                                      }),
                                      SizedBox(height: 8,),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          enableDrag: true,
                          elevation: 4);
                    },
                    child: isSingleSetting ? Obx(()=>repeat.value ? Icon(Icons.repeat_one_outlined,color: Colors.white,) : Icon(Icons.repeat,color: Colors.white,) ) : Icon(
                      Icons.settings,
                      color: Colors.white,
                    )),
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
                  Flexible(
                      flex: 0,
                      child: Obx(() => ColoredText(
                            isInitialized.value
                                ? (position.value.inSeconds).formatedTime()
                                : "--:--",
                            textColor: Colors.white,
                          ))),
                  Flexible(
                      flex: 1,
                      child: SizedBox(
                          width: double.infinity,
                          child: Obx(() => Slider(
                                value: position.value.inMilliseconds.toDouble(),
                                thumbColor: Colors.white,
                                inactiveColor: Colors.white24,
                                activeColor: Colors.white.withOpacity(0.8),
                                min: 0,
                                max: duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  position.value =
                                      Duration(milliseconds: value.toInt());
                                  requestForSeekBar(false);
                                },
                                onChangeEnd: (value) {
                                  if (isVideo) {
                                    if (player == null) {
                                      return;
                                    }
                                    player.seekTo(
                                        Duration(milliseconds: value.toInt()));
                                  } else {
                                    player.seekToPlayer(
                                        Duration(milliseconds: value.toInt()));
                                  }
                                  requestForSeekBar(true);
                                },
                              )))),
                  Flexible(
                      flex: 0,
                      child: Obx(() => ColoredText(
                            isInitialized.value
                                ? duration.inSeconds.formatTimer()
                                : "--:--",
                            textColor: Colors.white,
                          ))),
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
