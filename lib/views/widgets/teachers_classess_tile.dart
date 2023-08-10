import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:zabaner/models/custom_date.dart';
import 'package:zabaner/models/online_class.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';

class TeachersClassTile extends StatelessWidget {
  OnlineClass item;

  TeachersClassTile(this.item);

  @override
  Widget build(BuildContext context) {
    String classCounts = item.classCount;
    String classStatus = item.classStatus;
    if (classCounts == "0") {
      classCounts = "جلسه آزمایشی";
    } else {
      classCounts = "$classCounts جلسه یک ساعتی ";
    }
    if (classStatus == "done") {
      classStatus = "کلاس ها برگذار شده اند";
    } else if (classStatus == "linkUpdate") {
      classStatus = "لینک کلاسی قرار داده شده است";
    } else {
      classStatus = "در انتظار تایید";
    }
    List<CustomDate> customDates = customDateListModelFromJson(item.classTimes);
    Color backColor = Colors.lightGreen;
    if (item.classStatus != "done") {
      backColor = Colors.white;
    }
    if (item.classStatus == "linkUpdate") {
      backColor = Colors.orange;
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3)),
          ]),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  backColor.withOpacity(0.3),
                  backColor.withOpacity(0.2),
                  backColor.withOpacity(0.1),
                  backColor.withOpacity(0.0),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent
                ])),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topRoundedMiniBar(
                title: "نام زبان‌آموز : ${item.userName}", height: 60),
            SizedBox(
              height: 18,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              child: ColoredText(
                "تعداد جلسات رزرو شده : $classCounts",
                textDirection: TextDirection.rtl,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 18),
              child: Scrollbar(
                thumbVisibility: true,
                radius: Radius.circular(8),
                thickness: 1.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(customDates.length, (index) {
                      CustomDate cDate = customDates[index];
                      Jalali jalali = Jalali.now();
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ColoredText(
                          "(${index + 1}) ${cDate.day} / ${cDate.month} / ${cDate.year} : ${cDate.hour}",
                          textDirection: TextDirection.rtl,
                          textColor: Colors.black54,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            divider(),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ColoredText(
                            classStatus,
                            textDirection: TextDirection.rtl,
                            textSize: 12,
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ColoredText(
                            " قیمت کلاس : ${item.classPrice} تومان ",
                            textDirection: TextDirection.rtl,
                            textSize: 12.5,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Container(
              width: double.infinity,
              child: Center(
                child: InkWell(
                  onTap: () {
                    if (item.classStatus == "linkUpdate") {
                      copyToClipboard(item.classLink,
                          showAlert: true, title: "لینک کپی شد!");
                    }
                  },
                  child: ColoredText(
                    item.classStatus == "linkUpdate"
                        ? "کپی کردن لینک ورود به کلاس"
                        : (item.classStatus == "" || item.classStatus == "none") ? "کلاس برگزار نشده است" : item.classStatus == "done" ? "کلاس برگزار شده است" : "Out Of State Exception" ,
                    textColor: item.classStatus == "linkUpdate"
                        ? primary
                        : Colors.black45,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class UsersClassTile extends StatelessWidget {
  OnlineClass item;
  var onPayClick;

  UsersClassTile(this.item, {this.onPayClick});

  @override
  Widget build(BuildContext context) {
    String classCounts = item.classCount;
    String classStatus = item.classStatus;
    if (classCounts == "0") {
      classCounts = "جلسه آزمایشی";
    } else {
      classCounts = "$classCounts جلسه یک ساعتی ";
    }
    if (classStatus == "done") {
      classStatus = "کلاس ها برگذار شده اند";
    } else if (classStatus == "linkUpdate") {
      classStatus = "لینک کلاسی قرار داده شده است";
    } else {
      classStatus = "در انتظار تایید";
    }
    List<CustomDate> customDates = customDateListModelFromJson(item.classTimes);
    Color backColor = Colors.lightGreen;
    if (item.classStatus != "done") {
      backColor = Colors.white;
    }
    if (item.classStatus == "linkUpdate") {
      backColor = Colors.orange;
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3)),
          ]),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  backColor.withOpacity(0.3),
                  backColor.withOpacity(0.2),
                  backColor.withOpacity(0.1),
                  backColor.withOpacity(0.0),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.transparent,
                ])),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topRoundedMiniBar(
                title: "نام استاد : ${item.teacherName}", height: 60),
            SizedBox(
              height: 18,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              child: ColoredText(
                "تعداد جلسات رزرو شده : $classCounts",
                textDirection: TextDirection.rtl,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 18),
              child: Scrollbar(
                thumbVisibility: true,
                radius: Radius.circular(8),
                thickness: 1.8,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(customDates.length, (index) {
                      CustomDate cDate = customDates[index];
                      Jalali jalali = Jalali.now();
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4),
                        child: ColoredText(
                          "(${index + 1}) ${cDate.day} / ${cDate.month} / ${cDate.year} : ${cDate.hour}",
                          textDirection: TextDirection.rtl,
                          textColor: Colors.black54,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Center(
              child: ColoredText("امتیاز دهی به استاد"),
            ),
            Center(
              child: Builder(builder: (context) {
                RxInt currentRatingToChange =
                    (int.tryParse(item.rating.toString()) ?? 0).obs;
                RxBool shouldRate =
                    currentRatingToChange.value > 0.0 ? false.obs : true.obs;
                return Obx(() => customRating(
                    startSize: 22.0,
                    preview: true,
                    current: currentRatingToChange.value,
                    count: 1,
                    onPreviewClick: () {
                      if (!shouldRate.value) {
                        return;
                      }
                      if(item.classStatus != "done"){
                        ColoredSnack(title: "بعد از برگزاری کلاس می‌توانید به استاد امتیاز دهید.",type: SnackType.ERROR);
                        return;
                      }
                      double currentVal = 0.0;
                      customDialog(
                          borderRadius: 18,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                topRoundedMiniBar(
                                    height: 30,
                                    title:
                                        "امتیاز دهی به استاد ${item.teacherName}"),
                                SizedBox(
                                  height: 18,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(width: 28,),
                                    customRating(
                                        startSize: 22.0,
                                        changeOnClick: true,
                                        current: currentRatingToChange.value,
                                        count: 1,
                                        onStarChanged: (value) {
                                          currentVal = value;
                                        }),
                                    SizedBox(width: 18,),
                                    Center(
                                        child: InkWell(
                                            onTap: () {
                                              if(currentVal.toInt() == 0){
                                                return;
                                              }
                                              Get.back();
                                              currentRatingToChange.value =
                                                  currentVal.toInt();
                                              ColoredSnack(title: "امتیاز شما ثبت شد",type: SnackType.SUCCESS);
                                              GetConnect _getConnect = GetConnect(
                                                  allowAutoSignedCert: true);
                                              _getConnect.post(
                                                  updateUserTeacherRating, {
                                                "id": item.teacherId,
                                                "rate": currentRatingToChange.value
                                                    .toString()
                                              });
                                              _getConnect.post(updateRateForClass, {
                                                "id": item.id,
                                                "rate": currentRatingToChange.value
                                                    .toString()
                                              });
                                            },
                                            child: Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                child: Padding(
                                                    padding: EdgeInsets.all(6),
                                                    child: Image.asset(
                                                      "assets/images/icon_like.png",
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ))),
                                  ],
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                              ],
                            ),
                          ));
                    },
                    onStarChanged: (rate) async {}));
              }),
            ),
            SizedBox(
              height: 4,
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              width: double.infinity,
              child: Row(
                children: [
                  SizedBox(
                    width: 4,
                  ),
                  Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ColoredText(
                            classStatus,
                            textDirection: TextDirection.rtl,
                            textSize: 12,
                          ),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ColoredText(
                            " قیمت کلاس : ${item.classPrice} تومان ",
                            textDirection: TextDirection.rtl,
                            textSize: 12.5,
                          ),
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Container(
              width: double.infinity,
              child: Center(
                child: InkWell(
                  onTap: () {
                    if (item.classStatus == "linkUpdate") {
                      copyToClipboard(item.classLink,
                          showAlert: true, title: "لینک کپی شد!");
                    }
                  },
                  child: (item.classStatus == "done") ? Container(): ColoredText(
                    item.classStatus == "linkUpdate"
                        ? "کپی کردن لینک ورود به کلاس"
                        : (item.classStatus == "" || item.classStatus == "none") ? "کلاس برگزار نشده است" : item.classStatus == "done" ? "کلاس برگزار شده است" : "Out Of State Exception" ,
                    textColor: item.classStatus == "linkUpdate"
                        ? primary
                        : Colors.black45,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Container(
              width: double.infinity,
              child: Center(
                child: Builder(builder: (context) {
                  Color color = Colors.green;
                  String title = "پرداخت";
                  var onClick = onPayClick;
                  bool isVisible = true;
                  if (item.paymentState.toLowerCase() == "none".toLowerCase()) {
                    title = "پرداخت";
                    color = Colors.green;
                  } else if (item.paymentState.toLowerCase() ==
                      "success".toLowerCase()) {
                    title = "پرداخت شده";
                    color = Colors.orange;
                    if (item.classStatus == "done") {
                      title = "کلاس تمام شده است";
                      color = Colors.teal;
                    }
                    onClick = () {};
                  } else if (item.paymentState.toLowerCase() ==
                      "failed".toLowerCase()) {
                    title = "پرداخت مجدد";
                    color = Colors.red;
                  }
                  return isVisible
                      ? ColoredButton(
                          title,
                          onTap: onClick,
                          gradientBorder: true,
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                color.withOpacity(0.3),
                                color.withOpacity(0.5),
                                color,
                              ]),
                          textColor: color,
                        )
                      : Container();
                }),
              ),
            ),
            SizedBox(
              height: 18,
            ),
          ],
        ),
      ),
    );
  }
}
