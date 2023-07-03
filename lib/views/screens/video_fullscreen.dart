import 'dart:async';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullscreen/fullscreen.dart';
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
    super.initState();
    if (widget.fixedLandscape) _setLandscapeFixed();
  }

  @override
  void dispose() {
    super.dispose();
    _systemResetTimer == null ? {}: _systemResetTimer!.cancel();
  }

  Future<void> _setLandscapeFixed() async {
    try{_hideSystemOverlay();}catch(e){e.printError();}
  }


  void _hideSystemOverlay({bool? withTimer, int? milliseconds}) {
    withTimer ??= true;
    milliseconds ??= 3000;
    if (withTimer) {
      if(_systemResetTimer != null){
        _systemResetTimer!.cancel();
      }
      _systemResetTimer = Timer.periodic(const Duration(milliseconds: 3000), (timer) {
        // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        //     statusBarColor: Colors.transparent
        // ));
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
    // return Container(width: double.infinity,height: double.infinity,color: Colors.blue,);
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          customVideoPlayerController!.toggleFullscreen();
          _systemResetTimer == null ? {}: _systemResetTimer!.cancel();
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
