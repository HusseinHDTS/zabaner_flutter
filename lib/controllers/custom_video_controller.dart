import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:zabaner/controllers/custom_video_player_controller.dart';
import 'package:zabaner/widgets/custom_video_player.dart';

class CustomVideoController extends GetxController {
  CustomVideoPlayerController? videoPlayerController;
  String? tag;
  RxBool isVideoControllerValid = false.obs;


  bool isCurrentPlayer(String cTag){
    if(tag == null || cTag.toString().trim() == "" || cTag.toString().trim() == "null"){
      return false;
    }
    debugPrint("sadkjaskjdksajkdjsakjdkasjkdjaskj : tag : " + tag.toString() + "   cTag : " + cTag.toString());
    return tag.toString().trim() == cTag.toString().trim();
  }

  Future<void> initPlayer(String cTag,{bool? autoPlay})async{
    tag = cTag;
    await videoPlayerController!.init(autoPlay:autoPlay);
    videoPlayerController!.isInitialize.value = true;
  }

  initVideoPlayer(var path, CustomVideoType videoType,{String? tag,bool? autoInit}) {
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
    }
    if (videoType == CustomVideoType.NETWORK) {
      videoPlayerController = CustomVideoPlayerController(
          CachedVideoPlayerController.network(path,
              httpHeaders: {"Keep-Alive":"timeout=1000 , max=100000"},
              videoPlayerOptions: VideoPlayerOptions(
                  mixWithOthers: true, allowBackgroundPlayback: false)),autoInit: autoInit);
    } else if (videoType == CustomVideoType.STORAGE) {
      videoPlayerController = CustomVideoPlayerController(
          CachedVideoPlayerController.file(path,
              videoPlayerOptions: VideoPlayerOptions(
                  mixWithOthers: true, allowBackgroundPlayback: false)),autoInit: autoInit);
    }
  }


}
