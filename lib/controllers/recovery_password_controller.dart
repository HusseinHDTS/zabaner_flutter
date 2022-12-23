import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/screens/validate_reset_password_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class RecoveryPasswordController extends GetConnect {
  
  Future<void> SendCode(String mobail) async {
    allowAutoSignedCert = true;
    var _request = mobail.isPhoneNumber
        ? await post(forgotPasswordUrl, {'mobile': mobail})
        : await post(forgotPasswordUrl, {'email': mobail});
    if (_request.statusCode == 201) {
      Get.back();
      Get.to(() => ValidateResetPasswordCode(
            recovery: true,
            phoneNumber: mobail,
          ));
    } else {
      if(_request.body == null ){
        Get.back();
        ColoredSnack(title: "خطا هنگام ارسال کد",type: SnackType.ERROR);
        return;
      }
      if (_request.body['error'].toString().trim() == "4006") {
        ColoredSnack(title: "ایمیل در سامانه یافت نشد",type: SnackType.WARNING);
        return;
      }
      if (_request.body['error'] == 4005) {
        ColoredSnack(title: "شماره موبایل در سامانه یافت نشد",type: SnackType.WARNING);
        return;
      }
      ColoredSnack(title: "خطا هنگام ارسال کد . لطفا بعدا سعی کنید",type: SnackType.ERROR);
    }
  }
}
