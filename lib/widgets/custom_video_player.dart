import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cached_video_preview/cached_video_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail_imageview/video_thumbnail_imageview.dart';
import 'package:zabaner/controllers/custom_video_controller.dart';
import 'package:zabaner/controllers/custom_video_player_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/video_fullscreen.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/models/level.dart';

enum CustomVideoType {
  NETWORK,
  ASSETS,
  STORAGE,
}

class CustomVideoPlayer extends StatefulWidget {
  var videoPath;
  bool? showThumbnail;
  bool isLoop;
  CustomVideoType? customVideoType;
  bool? isInitialized;

  CustomVideoPlayerController? initializedVideoPlayerController;

  CustomVideoPlayer(this.videoPath, this.customVideoType,
      {this.isInitialized,
      this.isLoop = false,
      this.initializedVideoPlayerController,
      this.showThumbnail}) {
    showThumbnail ??= true;
  }

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late CustomVideoPlayerController controller;
  late double iconBoxSize;
  late double iconSize;
  late double fullscreenPercentage;

  _CustomVideoPlayerState();

  CachedVideoPlayerController getCachedVideoController() {
    CachedVideoPlayerController cachedPlayerController;
    if (widget.customVideoType == CustomVideoType.NETWORK) {
      cachedPlayerController = CachedVideoPlayerController.network(widget.videoPath,
          videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true, allowBackgroundPlayback: true),httpHeaders: {"Keep-Alive":"timeout=1000 , max=100000"});
    } else {
      cachedPlayerController = CachedVideoPlayerController.file(widget.videoPath);
    }
    return cachedPlayerController;
  }

  @override
  void initState() {
    super.initState();
    iconBoxSize = 3.5;
    iconSize = iconBoxSize * 2;
    fullscreenPercentage = 2;
    widget.isInitialized ??= false;
    if(customVideoPlayerController != null){
      controller = customVideoPlayerController!;
      return;
    }
    if (widget.isInitialized!) {
      controller = widget.initializedVideoPlayerController!;
    } else {
      if(customVideoPlayerController == null) {
        controller = CustomVideoPlayerController(getCachedVideoController());
      }else{
        controller = customVideoPlayerController!;
      }
    }
    controller.videoPlayerController.setLooping(widget.isLoop);
  }

  RxBool videoReadyToShow = false.obs;

  @override
  Widget build(BuildContext context) {
    videoReadyToShow = true.obs;
    controller.videoPlayerController.setLooping(widget.isLoop);
    var screenSize = MediaQuery.of(context).size;
    return LayoutBuilder(builder: (context, BoxConstraints constraints) {
      return Container(
        width: controller.isFullscreen.value
            ? screenSize.width
            : constraints.minWidth,
        height: controller.isFullscreen.value
            ? screenSize.height
            : constraints.minHeight,
        child: Stack(children: [
          Obx(() => controller.isInitialize.value
              ? InkWell(
            onTap: () {
              controller.isOverlay.toggle();
            },
            child: Center(
              child: Container(
                  width: controller
                      .videoPlayerController.value.size.width,
                  height: controller
                      .videoPlayerController.value.size.height,
                  child: CachedVideoPlayer(
                    controller.videoPlayerController,
                  )),
            ),
          )
              : Container()),
          PlayerLayout(constraints),
        ]),
      );
    });
  }

  Widget PlayerLayout(BoxConstraints constraints) {
    return Obx(() => AnimatedOpacity(
          opacity: controller.isOverlay.value ? 1 : 0,
          duration: Duration(milliseconds: 400),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                        margin: EdgeInsets.only(
                            bottom: controller.isFullscreen.value
                                ? 0
                                : controller.isInitializeError.value
                                    ? 0
                                    : ((constraints.maxWidth * 8) / 100) /
                                        (controller.isFullscreen.value
                                            ? fullscreenPercentage
                                            : 1)),
                        decoration: controller.isInitialize.value ||
                                controller.isInitializeError.value
                            ? BoxDecoration(
                                color: Colors.black38,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white30, width: 1))
                            : null,
                        child: InkWell(
                          onTap: () {
                            if (controller.isInitializeError.value) {
                              controller
                                  .retryInitialize(getCachedVideoController());
                              return;
                            }
                            if (controller.isInitialize.value) {
                              if(controller.playerPosition.value == controller.playerDuration.value){
                                  controller.seekTo(0);
                                  controller.play();
                              }else{
                                controller.togglePlay();
                              }
                            }
                          },
                          child: SizedBox(
                              width: (constraints.maxWidth / iconBoxSize) /
                                  (controller.isFullscreen.value
                                      ? fullscreenPercentage
                                      : 1),
                              height: (constraints.maxHeight / iconBoxSize) /
                                  (controller.isFullscreen.value
                                      ? fullscreenPercentage
                                      : 1),
                              child: controller.isInitialize.value ||
                                      controller.isInitializeError.value
                                  ? Icon(
                                      controller.isInitializeError.value
                                          ? Icons.refresh
                                          : controller.isPlaying.value
                                              ? Icons.pause_rounded
                                              : Icons.play_arrow_rounded,
                                      color: Colors.white70,
                                      size: (constraints.maxWidth / iconSize) /
                                          (controller.isFullscreen.value
                                              ? fullscreenPercentage
                                              : 1),
                                    )
                                  : SizedBox(
                                      width: constraints.maxWidth / iconSize,
                                      height: constraints.maxHeight / iconSize,
                                      child: Loading())),
                        )),
                  )),
              controller.isInitialize.value
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: constraints.maxWidth,
                        height: ((constraints.maxWidth * 13) / 100) /
                            (controller.isFullscreen.value
                                ? fullscreenPercentage
                                : 1),
                        margin: EdgeInsets.symmetric(
                            horizontal: (constraints.maxWidth * 3) / 100,
                            vertical: (constraints.maxHeight * 6) / 100),
                        decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: Colors.white30, width: 1)),
                        padding: EdgeInsets.symmetric(
                            horizontal: ((constraints.maxWidth * 3) / 100) /
                                (controller.isFullscreen.value
                                    ? fullscreenPercentage
                                    : 1),
                            vertical: ((constraints.maxHeight * 2) / 100) /
                                (controller.isFullscreen.value
                                    ? fullscreenPercentage
                                    : 1)),
                        child: Row(
                          children: [
                            Flexible(
                              flex: 0,
                              child: Container(
                                child: Center(
                                    child: ColoredText(
                                  (Duration(
                                              milliseconds: controller
                                                  .playerPosition.value
                                                  .toInt())
                                          .inSeconds)
                                      .formatedTime(),
                                  textColor: Colors.white,
                                  textSize: ((constraints.maxWidth * 4) / 100) /
                                      (controller.isFullscreen.value
                                          ? fullscreenPercentage
                                          : 1),
                                )),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        (constraints.maxWidth * 3) / 100),
                                child: SliderTheme(
                                    data: SliderThemeData(
                                        thumbShape:
                                            SliderComponentShape.noOverlay,
                                        overlayShape:
                                            SliderComponentShape.noThumb),
                                    child: Slider(
                                      value: controller.playerValue.value,
                                      max: controller.playerDuration.value,
                                      thumbColor: Colors.white,
                                      inactiveColor:
                                          primaryDark.withOpacity(0.35),
                                      activeColor: Colors.white54,
                                      onChanged: (double value) {
                                        controller.seekTo(value);
                                      },
                                      min: 0,
                                    )),
                              ),
                            ),
                            Flexible(
                              flex: 0,
                              child: Container(
                                child: Center(
                                    child: ColoredText(
                                        (Duration(
                                                    milliseconds: controller
                                                        .playerDuration.value
                                                        .toInt())
                                                .inSeconds)
                                            .formatedTime(),
                                        textColor: Colors.white,
                                        textSize:
                                            ((constraints.maxWidth * 4) / 100) /
                                                (controller.isFullscreen.value
                                                    ? fullscreenPercentage
                                                    : 1))),
                              ),
                            ),
                            Flexible(
                              flex: 0,
                              child: Container(
                                height: double.infinity,
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      controller.toggleFullscreen();
                                    },
                                    child: Center(
                                      child: Container(
                                        height: double.infinity,
                                        margin: EdgeInsets.only(
                                            right: (constraints.maxWidth * 2) /
                                                100,
                                            left: (constraints.maxWidth * 3) /
                                                100),
                                        child: Center(
                                          child: Icon(
                                            Icons.fullscreen_rounded,
                                            color: Colors.white,
                                            size: ((constraints.maxWidth * 10) /
                                                    100) /
                                                (controller.isFullscreen.value
                                                    ? fullscreenPercentage
                                                    : 1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ));
  }
}
