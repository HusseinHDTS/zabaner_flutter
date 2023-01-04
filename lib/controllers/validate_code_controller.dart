import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/main_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class ValidateController extends GetConnect {
  final GetStorage _getStorage = GetStorage();
  CountdownController countController = CountdownController(autoStart: true);
  var isSmsTimerSend = false.obs;
  @override
  void onInit() {
    super.onInit();
    GetStorage.init();
    allowAutoSignedCert = true;
  }

  bool isTimerEnded(){
    return isSmsTimerSend.value;
  }

  void setTimerEnded(_ended){
    isSmsTimerSend.value = _ended;
  }


  Future<void> validateSignup(String phoneNumber, String code) async {
    loadingDialog("لطفا صبر کنید");
    var _request =
        await post(validateCodeUrl, {"mobile": phoneNumber, "code": code});
    Get.back();
    if (_request.statusCode == 201) {
      print(_request.body['accessToken'].toString());
      Get.offAll(() => MainScreen(
            isGuest: false,
            firstTime: true,
          ));
      try{
      _getStorage.write('token', _request.body['accessToken'].toString());
      }catch(e){e.printError();}
    }else{
      ColoredSnack(title: "کد وارد شده صحیح نمی‌باشد",type: SnackType.ERROR);
    }

  }
}
