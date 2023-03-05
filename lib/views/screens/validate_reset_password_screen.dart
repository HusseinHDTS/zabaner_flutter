import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:zabaner/controllers/recovery_password_controller.dart';
import 'package:zabaner/controllers/validate_code_controller.dart';
import 'package:zabaner/views/screens/set_new_password.dart';
import 'package:zabaner/views/widgets/reset_password_code.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';

import '../colors.dart';

class ValidateResetPasswordCode extends StatelessWidget {
  const ValidateResetPasswordCode(
      {Key? key, required this.recovery, required this.phoneNumber})
      : super(key: key);
  final bool recovery;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    final ValidateController _controller = Get.put(ValidateController());
    List code = ["", "", "", ""];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffffffff),
        body: SafeArea(
          child: Column(
            children: [
              // Back Button
              Padding(
                padding:
                    EdgeInsets.only(right: Get.width / 20, top: Get.height / 35),
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_back,
                        size: 18,
                      ),
                      Text("بازگشت",
                          style: TextStyle(fontFamily: "Yekan", fontSize: 12)),
                    ],
                  ),
                ),
              ),

              //Logo in top of page
              Padding(
                padding: EdgeInsets.only(bottom: Get.height / 39),
                child: SizedBox(
                  height: Get.height / 8,
                  width: Get.width / 2,
                  child: Image.asset(
                    "assets/images/zabaner_logo.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),

              // Signup Paramerts
              Container(
                  width: Get.width / 1.25,
                  height: Get.height / 3.0,
                  decoration: BoxDecoration(
                      color: const Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(36)),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Get.width / 10, vertical: Get.height / 35),
                    child: Column(
                      children: [
                        // top widget texts
                        SizedBox(
                          width: Get.width,
                          height: Get.height / 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  recovery ? "بازیابی" : "اعتبار سنجی",
                                  style: const TextStyle(
                                      fontSize: 13, fontFamily: "Yekan"),
                                ),
                              ),
                              Text(
                                "کد ارسال شده برای شماره همراه $phoneNumber را وارد کنید",
                                style: const TextStyle(
                                    fontSize: 9,
                                    fontFamily: "Yekan",
                                    color: Color(0xff9F9F9F)),
                              ),
                            ],
                          ),
                        ),

                        // Code text input
                        SizedBox(
                            height: Get.height / 19,
                            child: Directionality(
                              textDirection: TextDirection.ltr,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                    4,
                                    (index) => ResetPasswordCode(
                                          index: index,
                                          onChanged: (value) =>
                                              code[index] = value,
                                        )),
                              ),
                            )),

                        SizedBox(
                          height: 10,
                        ),
                        // Timer text
                        SizedBox(
                            width: Get.width,
                            height: 20,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Countdown(
                                  seconds: 90,
                                  controller: _controller.countController,
                                  build: (BuildContext context, double time) {
                                    int currentTime =
                                        int.parse(time.toString().split(".")[0]);
                                    int minutes = currentTime ~/ 60;
                                    int seconds = (minutes * 60) - currentTime;
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ColoredText("دقیقه",
                                            textSize: 11,
                                            textColor: Color(0xff9F9F9F)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ColoredText(
                                            minutes.toString() +
                                                " : " +
                                                seconds
                                                    .toString()
                                                    .replaceAll("-", ""),
                                            textSize: 11,
                                            textColor: Color(0xff9F9F9F)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ColoredText("ارسال مجدد کد بعد از  ",
                                            textSize: 11,
                                            textColor: Color(0xff9F9F9F)),
                                      ],
                                    );
                                  },
                                  interval: Duration(milliseconds: 100),
                                  onFinished: () {
                                    _controller.setTimerEnded(true);
                                  },
                                ),
                              ),
                            )),

                        //Validate button
                        Container(
                            width: Get.width,
                            height: Get.height / 13,
                            padding:
                                EdgeInsets.symmetric(vertical: Get.height / 45),
                            child: ElevatedButton(
                              onPressed: () {
                                if ((code[0] + code[1] + code[2] + code[3]).toString().trim().isEmpty) {
                                  ColoredSnack(title: "لطفا کد ارسال شده را وارد کنید.",type: SnackType.WARNING);
                                  return;
                                }
                                if(code[0].toString().trim() == "" || code[1].toString().trim() == ""  || code[2].toString().trim() == ""  || code[3].toString().trim() == "" ){
                                  ColoredSnack(title: "لطفا کد ارسال شده را درست وارد کنید.",type: SnackType.WARNING);
                                  return;
                                }
                                recovery
                                    ? {
                                        Get.to(
                                          () => SetNewPasswordScreen(
                                            code: code[0] +
                                                code[1] +
                                                code[2] +
                                                code[3],
                                            mobail: phoneNumber,
                                          ),
                                        )
                                      }
                                    : {
                                        _controller.validateSignup(phoneNumber,
                                            code[0] + code[1] + code[2] + code[3])
                                      };
                              },
                              child: const Text(
                                "اعتبار سنجی",
                                style:
                                    TextStyle(fontSize: 12, fontFamily: "Yekan"),
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(primary),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)))),
                            )),

                        // Resend Reset Password Code
                        SizedBox(
                          height: Get.height / 35,
                          width: Get.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("کد برای شما ارسال نشده است؟",
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: Color(0xff9F9F9F),
                                    fontFamily: "Yekan",
                                  )),
                              Obx(() => _controller.isTimerEnded()
                                  ? GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        RecoveryPasswordController()
                                            .SendCode(phoneNumber);
                                        _controller.countController.restart();
                                        _controller.setTimerEnded(false);
                                      },
                                      child: Text(
                                        "ارسال مجدد کد",
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: primary,
                                          fontFamily: "Yekan",
                                        ),
                                      ))
                                  : Container())
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),

              // Image in bottom Center
              SizedBox(
                height: Get.height / 3.2,
                width: Get.width,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      "assets/images/signup_image.png",
                      width: Get.width / 1.5,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
