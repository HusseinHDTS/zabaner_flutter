import 'dart:async';
import 'dart:typed_data';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:zabaner/controllers/custom_video_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/video_fullscreen.dart';

class CustomVideoPlayerController {
  CachedVideoPlayerController videoPlayerController;
  late Duration overlayDuration;
  bool? fullscreenOnStart;

  RxDouble playerValue = 0.0.obs;

  RxDouble playerPosition = 0.0.obs;
  RxDouble playerDuration = 0.0.obs;
  RxBool isPlaying = false.obs;
  bool _savedIsPlaying = false;
  RxBool isInitialize = false.obs;
  RxBool isInitializeError = false.obs;
  RxBool isFullscreen = false.obs;
  RxBool isOverlay = true.obs;

  Timer? _timer;
  CustomVideoPlayerController(this.videoPlayerController,{Duration? overlayDuration,bool? autoInit,this.fullscreenOnStart}){
    playerPosition = 0.0.obs;
    playerDuration = 0.0.obs;
    autoInit??=true;
    fullscreenOnStart??=false;
    this.overlayDuration = overlayDuration??const Duration(seconds: 3);
    if(autoInit){
      init();
    }
  }

  Future<Uint8List?> getVideoThumbnail(String videoPath)async{
    return await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      quality: 50,
    );
  }

  void seekTo(double value){
    pause(save: false);
    playerValue.value = value;
    videoPlayerController.seekTo(Duration(milliseconds: value.toInt()));
    if(_savedIsPlaying == true){
      play(save: false);
    }
  }

  Future<void> init({bool? autoPlay})async{
    autoPlay??=false;
    try{
      isInitialize.value = false;
      isInitializeError.value = false;
      await videoPlayerController.initialize();
      playerDuration.value = videoPlayerController.value.duration.inMilliseconds.toDouble();
      videoPlayerController.addListener((){
        if(isPlaying.value){
          playerPosition.value = videoPlayerController.value.position.inMilliseconds.toDouble();
          playerValue.value = playerPosition.value;
          if(videoPlayerController.value.position.inMilliseconds == videoPlayerController.value.duration.inMilliseconds){
            pause();
            isFullscreen.value ? fullscreenModeOff() : {};
          }
        }
      });
      if(autoPlay){
        play();
      }
      isInitialize.value = true;
    }catch(e){
      isInitializeError.value = true;
    }
  }

  void retryInitialize(CachedVideoPlayerController controller){
    dispose();
    videoPlayerController = controller;
    init();
  }

  void fullscreenModeOn(){
    enterFullScreenMode();
    isFullscreen.value = true;
    Get.to(()=> FullScreenPage(fixedLandscape: true,),fullscreenDialog: true,);
  }

  void fullscreenModeOff(){
    isFullscreen.value = false;
    Get.back();
    exitFullScreenMode();
  }

  void toggleFullscreen(){
    isFullscreen.value ? fullscreenModeOff() : fullscreenModeOn();
  }

  void play({bool? save}){
    save ??= true;
    isPlaying.value = true;
    save ? _savedIsPlaying = isPlaying.value : {};
    if(fullscreenOnStart!){
      if(playerPosition.value.toInt() == 0){
        fullscreenModeOn();
      }
    }
    videoPlayerController.play();
    if(_timer != null){
      _timer!.cancel();
    }
    _timer = null;
    _timer = Timer.periodic(overlayDuration, (timer) {
      isOverlay.value = false;
      timer.cancel();
    });
  }

  void pause({bool? save}){
    save??=true;
    isPlaying.value = false;
    save ? _savedIsPlaying = isPlaying.value : {};
    videoPlayerController.pause();
    isOverlay.value = true;
  }

  void togglePlay(){
    isPlaying.value ? pause() : play();
  }

  void togglePause(){
    isPlaying.value ? pause() : play();
  }


  void dispose(){
    if(isInitialize.isTrue) {
      pause();
    }
    customVideoPlayerTag.value = "null";
    videoPlayerController.dispose();
  }


}