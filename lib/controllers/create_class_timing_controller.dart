import 'dart:convert';
import 'dart:typed_data';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:zabaner/controllers/online_class_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class CreateClassTimingController extends GetxController {
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);

  sendData(String selectedDates) async {
    debugPrint("daskjdksajdkjaskdjkasjd : " + selectedDates);
    // return;
    loadingDialog("لطفا صبر کنید");
    var bodyRequest = {"id": userSavedId, "freeTimes": selectedDates};
    var result = await _getConnect.post(updateTeacherFreeTimes, bodyRequest);
    Get.back();
    if(result.bodyString.toString() != "null" || result.bodyString.toString() != ""){
      if(!jsonEncode(result.bodyString ?? "").contains("statusCode")) {
        Get.back();
        ColoredSnack(title: "اطلاعات ثبت شد",type: SnackType.SUCCESS);
      }else{
        ColoredSnack(title: "اطلاعات ثبت نشد",type: SnackType.ERROR);
      }
    }
  }
}
