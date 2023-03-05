import 'dart:async';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:zabaner/controllers/custom_video_player_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/widgets/custom_video_player.dart';

class FullScreenPage extends StatefulWidget {
  FullScreenPage({
    Key? key,
    required this.fixedLandscape,
  }) : super(key: key);

  final bool fixedLandscape;

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  Timer? _systemResetTimer;

  @override
  void initState() {
    if (widget.fixedLandscape) _setLandscapeFixed();
    super.initState();
  }

  @override
  void dispose() {
    // _systemResetTimer == null ? {}: _systemResetTimer!.cancel();
    super.dispose();
  }

  Future<void> _setLandscapeFixed() async {
    _hideSystemOverlay();
  }

  void _hideSystemOverlay({bool? withTimer, int? milliseconds}) {
    withTimer ??= true;
    milliseconds ??= 3000;
    if (withTimer) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        SystemChrome.setEnabledSystemUIOverlays([]);
      });
    } else {
      SystemChrome.setEnabledSystemUIOverlays([]);
    }
  }

  void _restoreSystemOverlay() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          customVideoPlayerController!.toggleFullscreen();
          return false;
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Obx(()=>customVideoPlayerController!.isFullscreen.value ? Center(child: CustomVideoPlayer(null,null,initializedVideoPlayerController:customVideoPlayerController,isInitialized: true,showThumbnail: false, )) : Center(child: Loading(),)),
        ),
      ),
    );
  }
}
