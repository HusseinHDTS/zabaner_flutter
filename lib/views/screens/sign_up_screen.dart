import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/controllers/signup_controller.dart';
import 'package:zabaner/views/widgets/custom_check_box.dart';
import 'package:zabaner/views/widgets/custom_text_input.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';

import '../colors.dart';

class SignupScreen extends StatelessWidget {
  static const textInputDetail = [
    ["نام کاربری", "رمز عبور", "تکرار رمز عبور", "شماره موبایل", "ایمیل"],
    ["username.png", "lock.png", "repassword.png", "mobile.png", "email2.png"]
  ];

  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignupController _controller = Get.put(SignupController());
    List signupParamerts = ["", " ", "", "", ""];
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
                padding: EdgeInsets.only(
                    right: Get.width / 20, top: Get.height / 35),
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
                  height: Get.height / 1.8,
                  decoration: BoxDecoration(
                      color: const Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(36)),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Get.width / 10, vertical: Get.height / 45),
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
                                  "ثبت نام کنید",
                                  style: TextStyle(
                                      fontSize: 13, fontFamily: "Yekan"),
                                ),
                              ),
                              Text(
                                "جهت دسترسی به برنامه نیاز به  ورود اطلاعات است",
                                style: TextStyle(
                                    fontSize: 8,
                                    fontFamily: "Yekan",
                                    color: Color(0xff9F9F9F)),
                              ),
                            ],
                          ),
                        ),

                        //login text input and remember me custom check box
                        SizedBox(
                            height: Get.height / 3.5,
                            // color: Colors.red,
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                    6,
                                    (index) => index == 5
                                        ? customCheckBox(
                                            Get.width / 20,
                                            Get.height / 40,
                                            "   استفاده از زبانر به معنی موافقت با قوانین می باشد",
                                            (value) {
                                              _controller.setAgreed(value);
                                            },
                                            false,
                                            content:  Text.rich(
                                                TextSpan(style:TextStyle(fontSize: 10,color: Color(0xff9F9F9F), fontFamily: "Yekan"),children: <InlineSpan>[
                                              TextSpan(
                                                  text:"استفاده از زبانر به معنی موافقت با"),
                                              TextSpan(
                                                style: TextStyle(color: Colors.blueAccent,decoration: TextDecoration.underline),
                                                  recognizer: TapGestureRecognizer()..onTap = (){
                                                    Get.defaultDialog(title: "قوانین",content: Container(
                                                      height: 350,
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          mainAxisSize: MainAxisSize.min,children: [
                                                          middleText("کاربر گرامی ضمن سپاس از انتخاب اپلیکیشن زبانر لازم است پیش از ثبت نام و خرید، توافقنامه و قوانین ذیل را مشاهده کنید.",),
                                                          const SizedBox(height: 10,),
                                                          Container(width: double.infinity,height: 1,decoration: BoxDecoration(color: Colors.black12),),
                                                          const SizedBox(height: 10,),
                                                          descriptionText("تمامی منابع استفاده شده در نرم افزار برای \"زبانر\" است و هرگونه استفاده از محتوای این نرم افزار پیگرد قانونی دارد.",),
                                                          const SizedBox(height: 10,),
                                                          descriptionText("هرگونه کپی برداری از لوگوی <زبانر> ممنوع است",),
                                                          const SizedBox(height: 10,),
                                                          descriptionText("زبانر درصورت مشاهده هرگونه اقدام غیر متعارف برای دسترسی به اشتراک، خرید و ورود، این حق را دارد که این اقدامات غیرمجاز را متوقف کرده و در ادامه اشتراک کاربر را لغو کند",),
                                                          const SizedBox(height: 10,),
                                                          titleText("سیاست های حریم شخصی"),
                                                          middleText("اطلاعات دریافتی"),
                                                          const SizedBox(height: 10,),
                                                          descriptionText("زبانر اطلاعات کاربران خود را در سرور های داخلی در ایران نگهداری می‌کند و از این رو، هیچگونه نگرانی برای خروج اطلاعات از مرز های کشور برای کاربران وجود نخواهد داشت. کاربان ربانر مستقیما اطلاعات زیر را در اختیار زبانر می‌گذارند: "),
                                                          descriptionText("آدرس پست الکترونیکی یا شماره تلفن"),
                                                          descriptionText("نام کاربری و گذرواژه"),
                                                          descriptionText("تصویر ارسال شده توسط کاربر (شامل عکس پروفایل ، منظره و غیره)"),
                                                          const SizedBox(height: 10,),
                                                          descriptionText("همچنین زبانر با استفاده از کوکی‌ها و فناوری‌های مشابه آن ، اطلاعات مربوط به فرایند استفاده شما از زبانر و همچنین، روند خدمت‌رسانی خود به شما را جمع‌آوری می‌کند"),
                                                          const SizedBox(height: 10,),
                                                          middleText("اشتراک گذاری اطلاعات شما"),
                                                          descriptionText("زبانر ، حق افشای اطلاعات شخص شما را تنها به منظور پاسخگویی به درخواست‌ها و درصورت نیاز، ارائه گزارش به مراجع قانونی برای خود محفوظ می‌دارد. اطلاعات تماس شما - مانند شماره تلفن یا آدرس ایمل - در هیچ بخشی از زبانر برای سایر کاربران زبانر به نمایش گذاشته نمی‌شوند."),
                                                          const SizedBox(height: 10,),
                                                          titleText("حریم خصوصی کاربران در زبانر:"),
                                                          descriptionText("زبانر جهت ارائه بهتر سرویس خود و اطلاع رسانی در خصوص طرح‌های ویژه و پیشنهاد محتواهای جدید و ...، ممکن است از طریق ایمیل یا شماره تلفن همراه ثبت شده، اقدام به ارسال اطلاعاتی برای کاربران نماید. شما همواره میتوانید با کلیک کردن بر روی دکمه لغو در انتهای ایمیل های‌اطلاع رسانی ، آنها را غیرفعال کنید."),
                                                        ],),
                                                      ),
                                                    ));
                                                  },
                                                  text:
                                                      " قوانین "),
                                              TextSpan(
                                                  text:
                                                      "می باشد"),
                                            ])))
                                        : SizedBox(
                                            width: Get.width,
                                            height: Get.height / 23,
                                            child: Row(
                                              children: [
                                                Obx(() => Expanded(
                                                      flex: 1,
                                                      child: CustomTextInput(
                                                        hintText:
                                                            textInputDetail[0]
                                                                [index],
                                                        iconPath:
                                                            textInputDetail[1]
                                                                [index],
                                                        error: _controller
                                                            .error.value,
                                                        maxLength: index == 3
                                                            ? 11
                                                            : null,
                                                        keyboardType: index == 3
                                                            ? TextInputType
                                                                .phone
                                                            : TextInputType
                                                                .emailAddress,
                                                        onChanged: (text) {
                                                          if (index == 3) {
                                                            if(text.toString().length > 0){
                                                              if(text.toString().characters.characterAt(0).toString() == "0"){
                                                                text = text.substring(1);
                                                              }
                                                            }
                                                            signupParamerts[
                                                                    index] =
                                                                "0" + text;
                                                            debugPrint("qwtytncxmnkjsadkwqd : " + signupParamerts[index].toString());
                                                          } else {
                                                            signupParamerts[
                                                                index] = text;
                                                          }
                                                        },
                                                        password: index == 1 ||
                                                            index == 2,
                                                      ),
                                                    )),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                index == 3
                                                    ? Expanded(
                                                        flex: 0,
                                                        child: SizedBox(
                                                          width: 30,
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            child: Center(
                                                                child:
                                                                    ColoredText(
                                                              "+ 98",
                                                              textColor: Colors
                                                                  .black45,
                                                              textSize: 10,
                                                              textDirection:
                                                                  TextDirection
                                                                      .ltr,
                                                            )),
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                border: Border.all(
                                                                    color:
                                                                        primary,
                                                                    width: 1)),
                                                          ),
                                                        ))
                                                    : Container(),
                                              ],
                                            ),
                                          )))),

                        //login button
                        const SizedBox(height: 10,),
                        InkWell(
                          onTap: () {
                            if(!_controller.isAgreed()){
                              return;
                            }
                            if (signupParamerts[1] == signupParamerts[2] &&
                                signupParamerts[0].toString().isNotEmpty &&
                                signupParamerts[3].toString().isNotEmpty) {
                              _controller.signup(
                                  signupParamerts[0],
                                  signupParamerts[1],
                                  signupParamerts[3],
                                  signupParamerts[4]);
                            } else {
                              if (signupParamerts[1] != signupParamerts[2]) {
                                ColoredSnack(
                                    title:
                                        "رمز عبور با تکرار رمز عبور یکسان نیست",
                                    type: SnackType.ERROR);
                              } else {
                                ColoredSnack(
                                    title: "لطفا تمام فیلد ها را پر کنید",
                                    type: SnackType.WARNING);
                              }
                            }
                          },
                          child: Obx(()=> Container(
                            width: Get.width,
                            height: Get.height / 26,
                            margin:
                            EdgeInsets.symmetric(vertical: Get.height / 60),
                            decoration: BoxDecoration(
                                color: _controller.isAgreed() ? primary : Colors.grey,
                                borderRadius: BorderRadius.circular(11)),
                            child: const Center(
                              child: Text(
                                "ثبت نام",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "Yekan",
                                    color: Color(0xffffffff)),
                              ),
                            ),
                          )),
                        ),

                        // login with gmail button
                        // Container(
                        //   height: Get.height / 23,
                        //   margin: EdgeInsets.symmetric(
                        //       horizontal: Get.width / 10,
                        //       vertical: Get.height / 50),
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(8),
                        //       border: Border.all(color: orange, width: 0.8)),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       const Text("ثبت نام با حساب کاربری گوگل",
                        //           style: TextStyle(
                        //               color: Color(0xff616161),
                        //               fontFamily: "Yekan",
                        //               fontSize: 9)),
                        //       Image.asset(
                        //         "assets/images/gmail.png",
                        //         width: Get.width / 12,
                        //         height: Get.height / 45,
                        //       )
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  )),

              // Image in bottom Center
              SizedBox(
                height: Get.height / 5.5,
                width: Get.width,
                // color: Colors.red,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      "assets/images/signup_image.png",
                      width: Get.width / 3.2,
                      // height: Get.height / 8,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  titleText(text){
    return ColoredText(text,textSize: 18,textAlign: TextAlign.right,textDirection: TextDirection.rtl);
  }

  middleText(text){
    return ColoredText(text,textColor: Colors.black87,textSize: 14,textAlign: TextAlign.right,textDirection: TextDirection.rtl);
  }

  descriptionText(text){
    return ColoredText(text,textSize: 12,textColor: Colors.black54,textAlign: TextAlign.right,textDirection: TextDirection.rtl,);
  }

}
