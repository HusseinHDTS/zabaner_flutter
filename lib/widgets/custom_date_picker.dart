import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zabaner/controllers/custom_date_picker_controller.dart';
import 'package:zabaner/models/custom_date.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';

class CustomDatePicker extends StatelessWidget {
  CustomDatePickerController controller;
  int? weeks;
  int? maxTimes;
  bool? isTeacher;
  bool? autoSelectNext;
  bool? viewMode;
  List<CustomDate>? deActiveDates;
  EdgeInsets? headerPadding;
  double? headerTextSize;
  Color? headerColor;
  Color? headerTextColor;

  CustomDatePicker({required this.controller,
    this.weeks,
    this.maxTimes,
    this.headerColor,
    this.isTeacher,
    this.autoSelectNext,
    this.viewMode,
    this.deActiveDates,
    this.headerPadding,
    this.headerTextSize,
    this.headerTextColor,
    Key? key})
      : super(key: key) {
    controller.currentPage = 0.obs;
    weeks ??= 4;
    isTeacher ??= false;
    viewMode ??= false;
    headerPadding ??= EdgeInsets.zero;
    deActiveDates ??= [];
    maxTimes ??= 999999999999999;
    autoSelectNext ??= false;
    headerTextSize ??= 12;
    headerColor ??= primary;
    headerTextColor ??= Colors.white;
    if (autoSelectNext!) {
      maxTimes = maxTimes! * 2;
    }
    // if(Get.isRegistered<CustomDatePickerController>()){
    //   controller = Get.find();
    // }else{
    //   controller = Get.put(CustomDatePickerController());
    // }
  }

  @override
  Widget build(BuildContext context) {
    int weekDay = controller.jDate.weekDay;
    int cDay = controller.jDate.day;
    var titles = List.generate(7, (i) {
      return controller.getCurrentPageToShow(
          index: i,
          weekDay: weekDay,
          currentDay: cDay,
          currentPage: controller.currentPage.value,
          showMonth: true)[0];
    });
    var mainTimes = List.generate(7, (i) {
      return controller.getCurrentPageToShow(
        index: i,
        weekDay: weekDay,
        currentDay: cDay,
        currentPage: controller.currentPage.value,
      )[1];
    });
    final pages = List.generate(
        weeks!,
            (pageIndex) =>
            Padding(
                padding: const EdgeInsets.only(
                  bottom: 18,
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 0,
                          child: Container(
                            height: 45,
                            padding: headerPadding,
                            decoration: BoxDecoration(color: headerColor),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: List.generate(7, (weekIndex) {
                                return Flexible(
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal: 1.5),
                                            child: ColoredText(
                                              titles[weekIndex],
                                              overflow: TextOverflow.ellipsis,
                                              textColor: weekDay ==
                                                  weekIndex + 1 &&
                                                  controller
                                                      .getCurrentPageToShow(
                                                      index: weekIndex,
                                                      weekDay: weekDay,
                                                      currentDay: cDay,
                                                      currentPage: controller
                                                          .currentPage
                                                          .value)[0] ==
                                                      cDay.toString()
                                                  ? primaryDate
                                                  : headerTextColor,
                                              textSize: headerTextSize! - 1.8,
                                            ),
                                          ),
                                          Container(
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal: 1.5),
                                            child: Obx(() =>
                                            controller
                                                .currentPage.value ==
                                                0
                                                ? ColoredText(
                                              getCurrentDayDatePicker(
                                                  weekIndex),
                                              overflow: TextOverflow.ellipsis,
                                              textColor: weekDay ==
                                                  weekIndex + 1 &&
                                                  controller
                                                      .getCurrentPageToShow(
                                                      index: weekIndex,
                                                      weekDay: weekDay,
                                                      currentDay: cDay,
                                                      currentPage:
                                                      controller
                                                          .currentPage
                                                          .value)[0] ==
                                                      cDay.toString()
                                                  ? primaryDate
                                                  : headerTextColor,
                                              textSize: headerTextSize! - 3,
                                            )
                                                : ColoredText(
                                              getCurrentDayDatePicker(
                                                  weekIndex),
                                              overflow: TextOverflow.ellipsis,
                                              textColor: weekDay ==
                                                  weekIndex + 1 &&
                                                  controller
                                                      .getCurrentPageToShow(
                                                      index: weekIndex,
                                                      weekDay: weekDay,
                                                      currentDay: cDay,
                                                      currentPage:
                                                      controller
                                                          .currentPage
                                                          .value)[0] ==
                                                      cDay.toString()
                                                  ? primaryDate
                                                  : headerTextColor,
                                              textSize: headerTextSize! - 3,
                                            )),
                                          ),
                                        ],
                                      ),
                                    ));
                              }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                            child: SingleChildScrollView(
                              child: Row(
                                children: List.generate(7, (weekIndex) {
                                  return Flexible(
                                      child: Center(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2),
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      color: primary, width: 1),
                                                  bottom: BorderSide(
                                                      color: primary, width: 1),
                                                  left: BorderSide(
                                                      color: primary, width: 1),
                                                  right: BorderSide(
                                                      color: primary,
                                                      width: 1))),
                                          child: Obx(() =>
                                              Column(
                                                children:
                                                List.generate(31, (timeIndex) {
                                                  CustomDate mainDate =controller.getCurrentPageToShow(
                                                    index: weekIndex,
                                                    weekDay: weekDay,
                                                    currentDay: cDay,
                                                    currentPage: controller.currentPage.value,
                                                  )[1];
                                                  CustomDate customDate = mainDate;
                                                  customDate.hour =
                                                      getCurrentHourMinDatePicker(
                                                          timeIndex)
                                                          .toString();
                                                  CustomDate? nextCustomDate;
                                                  CustomDate? preCustomDate;
                                                  if (timeIndex + 1 < 31) {
                                                    nextCustomDate = mainDate;
                                                    nextCustomDate!.hour =
                                                        getCurrentHourMinDatePicker(
                                                            timeIndex + 1)
                                                            .toString();
                                                  }
                                                  if (timeIndex - 1 >= 0) {
                                                    preCustomDate = mainDate;
                                                    preCustomDate!.hour =
                                                        getCurrentHourMinDatePicker(
                                                            timeIndex - 1)
                                                            .toString();
                                                  }
                                                  if (weekIndex + 1 < weekDay &&
                                                      controller.currentPage
                                                          .value ==
                                                          0) {
                                                    deActiveDates!.add(
                                                        customDate);
                                                  }

                                                  var hasD = deActiveDates!
                                                      .firstWhereOrNull((
                                                      element) {
                                                    if (element
                                                        .toJson(
                                                        removeFree: true)
                                                        .toString() ==
                                                        customDate
                                                            .toJson(
                                                            removeFree: true)
                                                            .toString()) {
                                                      return true;
                                                    }
                                                    return false;
                                                  });

                                                  bool isActive = hasD == null;

                                                  RxBool isSelected;
                                                  RxBool isFree = controller
                                                      .isAddTimeEnable.value
                                                      .obs;
                                                  if (controller
                                                      .getSelectedDates()
                                                      .isNotEmpty) {
                                                    if (controller
                                                        .getSelectedDates()
                                                        .length >
                                                        maxTimes!) {
                                                      controller
                                                          .getSelectedDates()
                                                          .clear();
                                                      isSelected = false.obs;
                                                    } else {
                                                      CustomDate? itemContains =
                                                      controller
                                                          .getSelectedDates()
                                                          .firstWhereOrNull(
                                                              (element) {
                                                            if (element
                                                                .toJson(
                                                                removeFree: true)
                                                                .toString() ==
                                                                customDate
                                                                    .toJson(
                                                                    removeFree: true)
                                                                    .toString()) {
                                                              return true;
                                                            } else {
                                                              return false;
                                                            }
                                                          });
                                                      isSelected =
                                                          (itemContains != null)
                                                              .obs;
                                                      if (itemContains !=
                                                          null) {
                                                        isFree.value =
                                                        (itemContains.isFree ??
                                                            true);
                                                      }
                                                    }
                                                  } else {
                                                    isSelected = false.obs;
                                                  }
                                                  var selectedColors;
                                                  if (isTeacher ?? false) {
                                                    if (isFree.value) {
                                                      selectedColors = [
                                                        Colors.green.shade400,
                                                        Colors.green.shade600,
                                                      ];
                                                    } else {
                                                      selectedColors = [
                                                        Colors.red.shade400,
                                                        Colors.red.shade600,
                                                      ];
                                                    }
                                                  } else {
                                                    selectedColors = [
                                                      primary,
                                                      primaryDark,
                                                    ];
                                                  }
                                                  return Obx(() =>
                                                      InkWell(
                                                        onTap: !isActive
                                                            ? null
                                                            : () {
                                                          if (viewMode!) {
                                                            return;
                                                          }
                                                          customDate.isFree =
                                                              controller
                                                                  .isAddTimeEnable
                                                                  .value;

                                                          if (isTeacher!) {
                                                            controller
                                                                .onTeacherClick(
                                                                customDate:
                                                                customDate,
                                                                timeIndex:
                                                                timeIndex,
                                                                isSelected:
                                                                isSelected);
                                                          } else {
                                                            controller
                                                                .onUserClick(
                                                                customDate:
                                                                customDate,
                                                                isSelected:
                                                                isSelected,
                                                                maxTimes:
                                                                maxTimes,
                                                                nextCustomDate:
                                                                nextCustomDate,
                                                                preCustomDate:
                                                                preCustomDate,
                                                                timeIndex:
                                                                timeIndex);
                                                          }
                                                          // if (controller
                                                          //     .isAddTimeEnable
                                                          //     .isFalse) {
                                                          //   isFree.value = false;
                                                          // } else {
                                                          //   isFree.value = true;
                                                          // }
                                                        },
                                                        child: Container(
                                                          decoration: isSelected
                                                              .value
                                                              ? BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                              gradient: LinearGradient(
                                                                  colors:
                                                                  selectedColors))
                                                              : BoxDecoration(
                                                              color: !isActive
                                                                  ? Colors.grey
                                                                  .withOpacity(
                                                                  0.2)
                                                                  : timeIndex %
                                                                  2 ==
                                                                  0
                                                                  ? null
                                                                  : primaryDark
                                                                  .withOpacity(
                                                                  0.2),
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      color: primary
                                                                          .withOpacity(
                                                                          0.4),
                                                                      width: 1))),
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                              vertical: 4),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                              vertical: 4,
                                                              horizontal: 4),
                                                          child: ColoredText(
                                                            getCurrentHourMinDatePicker(
                                                                timeIndex),
                                                            textSize: 12,
                                                            textColor: isSelected
                                                                .value
                                                                ? Colors.white
                                                                : isActive
                                                                ? null
                                                                : Colors
                                                                .black38,
                                                          ),
                                                        ),
                                                      ));
                                                }),
                                              )),
                                        ),
                                      ));
                                }),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Expanded(
                          flex: 0,
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: pageIndex == 0
                                        ? Container()
                                        : InkWell(
                                      onTap: () {
                                        controller.pageController
                                            .previousPage(
                                            duration: Duration(
                                                milliseconds: 650),
                                            curve: Curves.linear);
                                      },
                                      child: Container(
                                        child: ColoredText(
                                          "هفته قبل",
                                          textDirection: TextDirection.rtl,
                                          textColor: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: pageIndex == weeks! - 1
                                        ? Container()
                                        : InkWell(
                                      onTap: () {
                                        controller.pageController.nextPage(
                                            duration:
                                            Duration(milliseconds: 650),
                                            curve: Curves.linear);
                                      },
                                      child: Container(
                                        child: ColoredText(
                                          "هفته بعد",
                                          textColor: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )));

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Column(
              children: [
                !viewMode! && isTeacher!
                    ? Expanded(
                  flex: 0,
                  child: Container(
                    height: 40,
                    padding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    width: double.infinity,
                    decoration: BoxDecoration(color: primary),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 0,
                          child: Container(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Obx(() =>
                                  checkBox("افزودن",
                                      controller.isAddTimeEnable,
                                          (value) {
                                        if (controller
                                            .isAddTimeEnable.isFalse) {
                                          controller.toggleAddRemoveTime();
                                        }
                                      },
                                      textColor: Colors.white,
                                      boxColor: Colors.white,
                                      activeColor: Colors.white,
                                      checkColor: Colors.green)),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 0,
                          child: Container(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Obx(() =>
                                  checkBox("حذف",
                                      controller.isRemoveTimeEnable,
                                          (value) {
                                        if (controller
                                            .isRemoveTimeEnable.isFalse) {
                                          controller.toggleAddRemoveTime();
                                        }
                                      },
                                      textColor: Colors.white,
                                      boxColor: Colors.white,
                                      activeColor: Colors.white,
                                      checkColor: Colors.red)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : Container(),
                Expanded(
                    flex: 1,
                    child: PageView.builder(
                        controller: controller.pageController,
                        itemCount: weeks!,
                        onPageChanged: (cp) {
                          controller.setCurrentPage(cp);
                        },
                        itemBuilder: (context, index) {
                          return pages[index % pages.length];
                        }))
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(bottom: 4),
                  child: SmoothPageIndicator(
                    controller: controller.pageController,
                    count: pages.length,
                    effect: const WormEffect(
                      dotHeight: 7,
                      dotWidth: 13,
                      spacing: 9,
                      type: WormType.thin,
                      dotColor: Colors.black12,
                      activeDotColor: primaryDark,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
