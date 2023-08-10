import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:zabaner/controllers/recovery_password_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/validate_reset_password_screen.dart';
import 'package:zabaner/views/widgets/custom_text_input.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/icon_widget.dart';

import '../colors.dart';

class RecoveryPasswordScreen extends StatelessWidget {
  const RecoveryPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String phoneMail = "";
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

              AppLogo(axis: Axis.horizontal,),
              // Signup Paramerts
              Container(
                  width: Get.width / 1.25,
                  height: Get.height / 3.4,
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
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(bottom: 6),
                                child: Text(
                                  "فراموشی رمز عبور",
                                  style: TextStyle(
                                      fontSize: 13, fontFamily: "Yekan"),
                                ),
                              ),
                              Text(
                                "شماره همراه را وارد کنید",
                                style: TextStyle(
                                    fontSize: 8,
                                    fontFamily: "Yekan",
                                    color: Color(0xff9F9F9F)),
                              ),
                            ],
                          ),
                        ),

                        // Email or phone number text input
                        SizedBox(
                          height: Get.height / 23,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: CustomTextInput(
                                  hintText: "9xxxxxxxxx",
                                  iconPath: "key.png",
                                  error: false,
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) => phoneMail = "0"+value,
                                ),
                              ),
                              SizedBox(width: 5,),
                              Expanded(
                                  flex: 0,
                                  child: SizedBox(
                                    width: 30,
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: Center(child: ColoredText("+ 98",textColor: Colors.black45,textSize: 10,textDirection: TextDirection.ltr,)),
                                      decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(8),border: Border.all(color: primary,width: 1)),
                                    ),
                                  )),
                            ],
                          ),
                        ),

                        //login button
                        Container(
                            width: Get.width,
                            height: Get.height / 13,
                            padding:
                                EdgeInsets.symmetric(vertical: Get.height / 45),
                            child: ElevatedButton(
                              onPressed: () {
                                loadingDialog("درحال ارسال کد");
                                RecoveryPasswordController().SendCode(phoneMail);
                              },
                              child: const Text(
                                "بازیابی",
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

                        // Connect to support
                        // Padding(
                        //   padding: EdgeInsets.only(top: Get.height / 60),
                        //   child: SizedBox(
                        //     height: Get.height / 28,
                        //     width: Get.width,
                        //     child: Column(
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: const [
                        //         Text("اطلاعات ورود خود را فراموش کرده اید؟",
                        //             style: TextStyle(
                        //               fontSize: 9,
                        //               color: Color(0xff9F9F9F),
                        //               fontFamily: "Yekan",
                        //             )),
                        //         InkWell(
                        //           child: Text("ارتباط با پشتیبانی",
                        //               style: TextStyle(
                        //                 fontSize: 9,
                        //                 color: orange,
                        //                 fontFamily: "Yekan",
                        //               )),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  )),

              // Image in bottom Center
              SizedBox(
                height: Get.height / 3,
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
