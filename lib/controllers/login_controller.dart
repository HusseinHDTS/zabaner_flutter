import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/main.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/main_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class LoginController extends GetConnect {
  var error = false.obs;
  var errorMessage = "".obs;
  var loginCheck = false.obs;
  var errorData = false.obs;
  int _connectionTry = 0;
  int _maxTry = 2;
  final GetStorage _getStorage = GetStorage();
  @override
  void onInit() async {
    super.onInit();
    allowAutoSignedCert = true;
    customInit();
  }

  void customInit() async {
    errorData.value = false;
    loginCheck.value = false;
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
        if(_connectionTry == _maxTry){
          ColoredSnack(title: "خطا هنگام دریافت اطلاعات کاربری!",type: SnackType.ERROR);
          errorData.value = true;
          _connectionTry = 0;
        }else{
          _connectionTry ++;
        }
      }
    } else {
      if(_connectionTry == _maxTry){
        loginCheck.value = true;
        _connectionTry = 0;
      }else{
        customInit();
        _connectionTry ++;
      }
    }
  }

  Future<void> login(String username, String password, bool rememberMe) async {
    allowAutoSignedCert = true;
    String token = "NaN";
    loadingDialog("لطفا صبر کنید");
    token = fcmToken;
    var _response = await post(signinUrl, {"username": username, "password": password,"googleAccessToken":token});
    var getConnect = GetConnect(allowAutoSignedCert: true);
    if (_response.statusCode == 201) {
        try{
          await _getStorage.write('token', _response.body['accessToken'].toString());
        }catch(e){
          e.printError();
        }
        Get.offAll(() => MainScreen(
              isGuest: false,
            ));
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
