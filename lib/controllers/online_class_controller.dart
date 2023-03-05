import 'dart:convert';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';
import 'package:zabaner/controllers/custom_video_player_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/user_teachers.dart';
import 'package:zabaner/models/utils.dart';
import 'dart:io' as io;

import 'package:zabaner/widgets/custom_video_player.dart';

class OnlineClassController extends GetxController {
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  RefreshController refreshController = RefreshController();
  var teachersData = <UserTeachers>[];
  var data;
  RxBool isDataLoaded = false.obs;
  RxBool isNewUser = false.obs;
  RxBool isSubmitDone = false.obs;
  RxBool isAllowToCompleteSubmit = false.obs;
  RxBool errorData = false.obs;
  var videosList = [];

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  testFtp() async {
    FTPConnect ftpConnect = FTPConnect(FTP_ACCESS_HOST,
        user: FTP_ACCESS_USER, pass: FTP_ACCESS_PASSWORD);
    io.File fileToUpload = io.File('fileToUpload.txt');
    await ftpConnect.connect();
    // bool res = await ftpConnect.uploadFileWithRetry(fileToUpload, pRetryCount: 2);
    bool res = await ftpConnect.makeDirectory("testFromAndroid");
    await ftpConnect.disconnect();
  }

  getData() async {
    errorData.value = false;
    isDataLoaded.value = false;
    var bodyRequest = {
      "userId": userSavedId,
    };
    final _request = await _getConnect.post(getCurrentTeacherUser, bodyRequest);
    final _request1 = await _getConnect.get(getAllUserTeachers);
    isDataLoaded.value = true;
    data = jsonDecode(_request.bodyString ?? "");
    teachersData = userTeachersListModelFromJson(_request1.bodyString ?? "");
    debugPrint("askdjkjxzkjkwjaekjksjdksajdkj : " + _request.bodyString.toString());
    if (data.length == 0) {
      isNewUser.value = true;
      isSubmitDone.value = false;
    } else {
      data = data[0];
      isNewUser.value = false;
      if (data['profileStatus'] == "firstPending") {
        isSubmitDone.value = false;
        isAllowToCompleteSubmit.value = false;
      } else if (data['profileStatus'] == "firstPendingOk") {
        isSubmitDone.value = false;
        isAllowToCompleteSubmit.value = true;
      } else if (data['profileStatus'] == "waitingForBank") {
        isSubmitDone.value = false;
        isAllowToCompleteSubmit.value = false;
      } else if (data['profileStatus'] == "imageEdit") {
        isSubmitDone.value = true;
        isAllowToCompleteSubmit.value = false;
      } else if (data['profileStatus'] == "done") {
        isSubmitDone.value = true;
        isAllowToCompleteSubmit.value = false;
      } else if (data['profileStatus'] == "waitingForEdit") {
        isSubmitDone.value = false;
        isAllowToCompleteSubmit.value = false;
      }
    }
    if(videosList.isNotEmpty){
      videosList.clear();
    }
    for (var element in teachersData) {
      videosList.add(CustomVideoPlayerController(CachedVideoPlayerController.network(
          getUrl(element.videoPath),
          videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true,allowBackgroundPlayback: false))));
    }
    refreshController.refreshCompleted();
  }
}
