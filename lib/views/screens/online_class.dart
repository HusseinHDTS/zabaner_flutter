import 'package:another_xlider/another_xlider.dart';
import 'package:another_xlider/models/handler.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';
import 'package:zabaner/controllers/online_class_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/create_teacher_screen.dart';
import 'package:zabaner/views/screens/profile_screen.dart';
import 'package:zabaner/views/screens/submit_bank_screen.dart';
import 'package:zabaner/views/screens/user_dashboard_screen.dart';
import 'package:zabaner/views/screens/user_information_screen.dart';
import 'package:zabaner/views/widgets/user_teachers_tile.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class OnlineClass extends StatefulWidget {
  OnlineClass({Key? key}) : super(key: key);

  @override
  State<OnlineClass> createState() => _OnlineClassState();
}

class _OnlineClassState extends State<OnlineClass>
    with TickerProviderStateMixin {
  final pageController = PageController(viewportFraction: 1, keepPage: true);
  final DecorationTween decorationTween = DecorationTween(
    begin: BoxDecoration(shape: BoxShape.circle),
    end: BoxDecoration(borderRadius: BorderRadius.circular(8)),
  );
  late final AnimationController _decoratedController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  OnlineClassController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
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
                        padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        width: double.infinity,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Opacity(
                              opacity: 1.0,
                              child: InkWell(
                                onTap: () {
                                  if (userSavedFirstName.toString().trim() ==
                                      "" ||
                                      userSavedLastName.toString().trim() == "") {
                                    Get.to(() => UserInformationScreen());
                                  } else {
                                    Get.to(() => UserDashboardScreen());
                                  }
                                },
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
                        height: ColoredAppBar().preferredSize.height,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              customDialog(child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(18))),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        topRoundedMiniBar(
                                            title: "فیلتر ها", height: 45),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 8),
                                          child: Obx(()=>Column(
                                            children: [
                                              Align(
                                                alignment:
                                                Alignment.centerRight,
                                                child: ColoredText("قیمت : "),
                                              ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        width:
                                                        double.infinity,
                                                        child: checkBox(
                                                            "گران ترین",
                                                            controller
                                                                .isHighPriceEnable,
                                                                (value) {
                                                              controller
                                                                  .isHighPriceEnable
                                                                  .value = value;
                                                              controller
                                                                  .isLowPriceEnable
                                                                  .value = !value;
                                                            },boxColor: primary
                                                        ),
                                                      )),
                                                  Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        width:
                                                        double.infinity,
                                                        child: checkBox(
                                                            "ارزان ترین",
                                                            controller
                                                                .isLowPriceEnable,
                                                                (value) {
                                                              controller
                                                                  .isLowPriceEnable
                                                                  .value = value;
                                                              controller
                                                                  .isHighPriceEnable
                                                                  .value = !value;
                                                            },boxColor: primary
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 18,
                                              ),
                                              Align(
                                                alignment:
                                                Alignment.centerRight,
                                                child:
                                                ColoredText("جنسیت : "),
                                              ),
                                              Row(
                                                children: [
                                                  Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        width:
                                                        double.infinity,
                                                        child: checkBox(
                                                            "آقا",
                                                            controller
                                                                .isMenEnable,
                                                                (value) {
                                                              controller
                                                                  .isMenEnable
                                                                  .value = value;
                                                              controller
                                                                  .isWomenEnable
                                                                  .value = !value;
                                                            },boxColor: primary
                                                        ),
                                                      )),
                                                  Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        width:
                                                        double.infinity,
                                                        child: checkBox(
                                                            "خانم",
                                                            controller
                                                                .isWomenEnable,
                                                                (value) {
                                                              controller
                                                                  .isWomenEnable
                                                                  .value = value;
                                                              controller
                                                                  .isMenEnable
                                                                  .value = !value;
                                                            },boxColor: primary
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 18,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        width:
                                                        double.infinity,
                                                        child: Center(
                                                          child: ColoredButton(
                                                            "اعمال فیلتر",
                                                            gradient: LinearGradient(colors: [primary,primaryDark]),
                                                            textSize: 13,
                                                            onTap: () {
                                                              Get.back();
                                                              controller.applyFilters();
                                                            },
                                                          ),
                                                        ),
                                                      )),
                                                  Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        width:
                                                        double.infinity,
                                                        child: Center(
                                                          child: ColoredButton(
                                                            "حذف فیلتر ها",
                                                            gradientBorder: true,
                                                            gradient: LinearGradient(colors: [Colors.red.shade300,Colors.red.shade500]),
                                                            textColor: Colors.red,
                                                            textSize: 13,
                                                            onTap: () {
                                                              Get.back();
                                                              controller.resetFilters();
                                                            },
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 18,
                                              ),
                                            ],
                                          )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                            },
                            child: Row(
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: ColoredText(
                                      "کلاس آنلاین",
                                      textColor: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      textSize: 17,
                                    )),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    child: RotationTransition(
                                      turns: AlwaysStoppedAnimation(0 / 360),
                                      child: Center(
                                          child: ColorFiltered(
                                              colorFilter: ColorFilter.mode(
                                                  Colors.white,
                                                  BlendMode.srcIn),
                                              child: Lottie.asset(
                                                  'assets/animations/sort.json',
                                                  // width: 40,
                                                  height: 40))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                Flexible(
                    child: Opacity(
                      opacity: 0.88,
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        width: double.infinity,
                        child: Obx(() => Opacity(
                          opacity: controller.isNewUser.isTrue
                              ? 1
                              : controller.isSubmitDone.isTrue
                              ? 1
                              : controller.isAllowToCompleteSubmit.isTrue
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
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Align(
                                                alignment: Alignment.topRight,
                                                child: ColoredText(
                                                  "استاد گرامی، ",
                                                  textDirection:
                                                  TextDirection.rtl,
                                                  textAlign: TextAlign.right,
                                                )),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: ColoredText(
                                                "برای ثبت نام، فرم ثبت نام نیاز است تکمیل شود که شامل اطلاعات فردی، تحصیلی و یک ویدئوی معرفی از خودتان است. ویدئوی معرفی را می توانید در اپلیکیشن بارگذاری نمایید.",
                                                textDirection:
                                                TextDirection.rtl,
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Align(
                                                alignment: Alignment.center,
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                    Get.to(() =>
                                                    const CreateTeacherScreen());
                                                  },
                                                  child: Container(
                                                    margin:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 24,
                                                        vertical: 8),
                                                    padding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 6),
                                                    decoration: BoxDecoration(
                                                        color: primaryDark,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(8)),
                                                    child: Center(
                                                      child: ColoredText(
                                                        "تکمیل فرم ثبت نام",
                                                        textColor:
                                                        Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ],
                                        ));
                                  } else if (controller.isSubmitDone.isTrue) {
                                    Get.to(() => SubmitBankScreen(
                                        controller.isSubmitDone.value,
                                        controller
                                            .isAllowToCompleteSubmit.value,
                                        controller.data));
                                  } else if (controller
                                      .isAllowToCompleteSubmit.isTrue) {
                                    Get.to(() => SubmitBankScreen(
                                        controller.isSubmitDone.value,
                                        controller
                                            .isAllowToCompleteSubmit.value,
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
        Obx(() => controller.isDataLoaded.value
            ? Expanded(
          flex: 1,
          child: controller.teachersData.isEmpty
              ? NoData()
              : SmartRefresher(
            onRefresh: () {
              controller.getData(resetFilters: true);
            },
            header: const MaterialClassicHeader(),
            controller: controller.refreshController,
            child: ListView.builder(
                itemCount: controller.teachersData.length + 2,
                shrinkWrap: false,
                itemBuilder: (context, index) {
                  if(index == 0){
                    return SizedBox(height: 18,);
                  }
                  if(index == controller.teachersData.length+1){
                    return SizedBox(height: 80,);
                  }
                  return UserTeachersTile(
                      controller.teachersData[index-1],
                      controller.videosList[index-1]);
                }),
          ),
        )
            : Loading()),
      ]),
    );
  }
}
