import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/main.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/screens/main_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class LoginController extends GetConnect {
  var error = false.obs;
  var errorMessage = "".obs;
  var loginCheck = false.obs;
  final GetStorage _getStorage = GetStorage();
  @override
  void onInit() async {
    super.onInit();
    allowAutoSignedCert = true;
  }

  void customInit() async {
    allowAutoSignedCert = true;
    await GetStorage.init();
    if (_getStorage.read('token') != null) {
      final _request = await get(profileInformationUrl, headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${_getStorage.read('token')}'
      });

      if (_request.statusCode == 200) {
        Get.offAll(() => MainScreen(
              isGuest: false,
            ));
      } else {
        loginCheck.value = true;
      }
    } else {
      loginCheck.value = true;
    }
  }

  Future<void> login(String username, String password, bool rememberMe) async {
    allowAutoSignedCert = true;
    String token = "NaN";
    Get.defaultDialog(title: "لطفا صبر کنید",content: CircularProgressIndicator());
    token = fcmToken;
    var _response =
        await post(signinUrl, {"username": username, "password": password,"googleAccessToken":token});
    if (_response.statusCode == 201) {
      if (rememberMe) {
        try{
          _getStorage.write('token', _response.body['accessToken'].toString());
        }catch(e){
          e.printError();
        }
        Get.offAll(() => MainScreen(
              isGuest: false,
            ));
      } else {
        Get.offAll(() => MainScreen(
          isGuest: false,
        ));
      }
    }
    if (_response.statusCode == 400) {
      Get.back();
      ColoredSnack(title: "نام کاربری یا رمز عبور صحیح نمی‌باشد",type: SnackType.ERROR);
    }
    if (_response.statusCode == 429) {
      Get.back();
      ColoredSnack(title: "شما بیش از اندازه تلاش کردید",type: SnackType.ERROR);
    }
  }
}
