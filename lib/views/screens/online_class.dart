import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';
import 'package:zabaner/controllers/online_class_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/create_teacher_screen.dart';
import 'package:zabaner/views/screens/submit_bank_screen.dart';
import 'package:zabaner/views/widgets/user_teachers_tile.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';

class OnlineClass extends StatelessWidget {
  final pageController = PageController(viewportFraction: 1, keepPage: true);

  OnlineClass({Key? key}) : super(key: key);

  OnlineClassController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => controller.isDataLoaded.value
          ? SmartRefresher(
              onRefresh: () {
                controller.getData();
              },
              header: const MaterialClassicHeader(),
              controller: controller.refreshController,
              child: Column(children: [
                Container(
                  color: primary,
                  padding: EdgeInsets.only(top: 4, bottom: 4),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Flexible(
                            child: Opacity(
                          opacity: 0.88,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            width: double.infinity,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Opacity(
                                  opacity: 0.6,
                                  child: InkWell(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.person_pin_outlined,
                                            color: Colors.grey.shade100,
                                            size: 25,
                                          ),
                                        ),
                                        Container(
                                          child: ColoredText(
                                            "داشبورد",
                                            textColor: Colors.grey.shade50,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        )),
                        Flexible(
                            flex: 1,
                            child: Opacity(
                              opacity: 0.8,
                              child: SizedBox(
                                width: double.infinity,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: ColoredText(
                                      "کلاس آنلاین",
                                      textColor: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      textSize: 19,
                                    )),
                              ),
                            )),
                        Flexible(
                            child: Opacity(
                          opacity: 0.88,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            width: double.infinity,
                            child: Obx(() => Opacity(
                                  opacity: controller.isNewUser.isTrue
                                      ? 1
                                      : controller.isSubmitDone.isTrue
                                          ? 1
                                          : controller.isAllowToCompleteSubmit
                                                  .isTrue
                                              ? 1
                                              : 0.6,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                        onTap: () {
                                          if (controller.isNewUser.isTrue) {
                                            Get.defaultDialog(
                                                title: "ثبت نام استاد",
                                                content: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: ColoredText(
                                                          "استاد گرامی، ",
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          textAlign:
                                                              TextAlign.right,
                                                        )),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8),
                                                      child: ColoredText(
                                                        "برای ثبت نام، فرم ثبت نام نیاز است تکمیل شود که شامل اطلاعات فردی، تحصیلی و یک ویدئوی معرفی از خودتان است. ویدئوی معرفی را می توانید در اپلیکیشن بارگذاری نمایید.",
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 12,
                                                    ),
                                                    Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Get.back();
                                                            Get.to(() =>
                                                                const CreateTeacherScreen());
                                                          },
                                                          child: Container(
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        24,
                                                                    vertical:
                                                                        8),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        8,
                                                                    vertical:
                                                                        6),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    primaryDark,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: Center(
                                                              child:
                                                                  ColoredText(
                                                                "تکمیل فرم ثبت نام",
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ));
                                          } else if (controller
                                              .isSubmitDone.isTrue) {
                                            Get.to(() => SubmitBankScreen(
                                                controller.isSubmitDone.value,
                                                controller
                                                    .isAllowToCompleteSubmit
                                                    .value,
                                                controller.data));
                                          } else if (controller
                                              .isAllowToCompleteSubmit.isTrue) {
                                            Get.to(() => SubmitBankScreen(
                                                controller.isSubmitDone.value,
                                                controller
                                                    .isAllowToCompleteSubmit
                                                    .value,
                                                controller.data));
                                          } else {
                                            ColoredSnack(
                                                title:
                                                    "لطفا تا زمان تایید شدن صبر کنید ...",
                                                type: SnackType.WARNING);
                                          }
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              child: Icon(
                                                Icons.assignment_outlined,
                                                color: Colors.grey.shade100,
                                                size: 25,
                                              ),
                                            ),
                                            Container(
                                              child: ColoredText(
                                                controller.isNewUser.isTrue
                                                    ? "ثبت نام استاد"
                                                    : "حساب کاربری",
                                                textColor: Colors.grey.shade50,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                )),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: controller.teachersData.isEmpty ? NoData() : ListView.builder(
                      itemCount: controller.teachersData.length,
                      shrinkWrap: false,
                      itemBuilder: (context, index) {
                        return UserTeachersTile(controller.teachersData[index],controller.videosList[index]);
                      }),
                ),
              ]),
            )
          : Loading()),
    );
  }
}
