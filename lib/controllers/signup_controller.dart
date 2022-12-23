import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/main.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/screens/validate_reset_password_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class SignupController extends GetConnect {
  var error = false.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    allowAutoSignedCert = true;
  }

  Future<void> signup(
      String username, String password, String mobile, String? email) async {
    allowAutoSignedCert = true;
    // final fcmToken = await FirebaseMessaging.instance.getToken();
    // debugPrint(fcmToken);
    Get.defaultDialog(title: "لطفا صبر کنید",content: CircularProgressIndicator());
    String? token = fcmToken;
    var _response = email!.isNotEmpty
        ? await post(signupUrl, {
            "username": username,
            "password": password,
            "mobile": mobile,
            "googleAccessToken": token.toString(),
            "email": email
          })
        : await post(signupUrl, {
            "username": username,
            "password": password,
            "googleAccessToken": token.toString(),
            "mobile": mobile,
          });
    Get.back();
    if (_response.statusCode == 201) {
      Get.to(() =>
          ValidateResetPasswordCode(recovery: false, phoneNumber: mobile));
    } else {
      error.value = true;
      switch (_response.body["error"].toString()) {
        case "4001":
          ColoredSnack(title: "نام کاربری قبلا در سامانه ثبت شده است",type: SnackType.ERROR);
          break;
        case "4002":
          ColoredSnack(title: "شماره موبایل قبلا در سامانه ثبت شده است",type: SnackType.ERROR);
          break;
        case "4003":
          ColoredSnack(title: "ایمیل قبلا در سامانه ثبت شده است",type: SnackType.ERROR);
          break;
      }
    }
  }
}
