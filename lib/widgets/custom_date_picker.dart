import 'dart:convert';

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
  List<CustomDate>? deActiveDates;
  double? headerTextSize;
  Color? headerColor;
  Color? headerTextColor;

  CustomDatePicker({required this.controller,
    this.weeks,
    this.maxTimes,
    this.headerColor,
    this.isTeacher,
    this.autoSelectNext,
    this.deActiveDates,
    this.headerTextSize,
    this.headerTextColor,
    Key? key})
      : super(key: key) {
    controller.currentPage = 0.obs;
    weeks ??= 4;
    deActiveDates ??= [];
    maxTimes ??= 9999999999999;
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
                                            child: Obx(() =>
                                                ColoredText(
                                                  "${controller
                                                      .getCurrentPageToShow(
                                                      index: weekIndex,
                                                      weekDay: weekDay,
                                                      currentDay: cDay,
                                                      currentPage: controller
                                                          .currentPage.value,
                                                      showMonth: true)[0]}",
                                                  overflow: TextOverflow
                                                      .ellipsis,
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
                                                  textSize: headerTextSize! -
                                                      1.8,
                                                )),
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
                                                  CustomDate customDate =
                                                  controller
                                                      .getCurrentPageToShow(
                                                      index: weekIndex,
                                                      weekDay: weekDay,
                                                      currentDay: cDay,
                                                      currentPage: controller
                                                          .currentPage
                                                          .value)[1];
                                                  customDate.hour =
                                                      getCurrentHourMinDatePicker(
                                                          timeIndex)
                                                          .toString();
                                                  CustomDate? nextCustomDate;
                                                  CustomDate? preCustomDate;
                                                  if (timeIndex + 1 < 31) {
                                                    nextCustomDate = controller
                                                        .getCurrentPageToShow(
                                                        index: weekIndex,
                                                        weekDay: weekDay,
                                                        currentDay: cDay,
                                                        currentPage: controller
                                                            .currentPage
                                                            .value)[1];
                                                    nextCustomDate!.hour =
                                                        getCurrentHourMinDatePicker(
                                                            timeIndex + 1)
                                                            .toString();
                                                  }
                                                  if (timeIndex - 1 >= 0) {
                                                    preCustomDate = controller
                                                        .getCurrentPageToShow(
                                                        index: weekIndex,
                                                        weekDay: weekDay,
                                                        currentDay: cDay,
                                                        currentPage: controller
                                                            .currentPage
                                                            .value)[1];
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
                                                  bool isActive = !deActiveDates!
                                                      .contains(customDate);

                                                  RxBool isSelected;
                                                  if (controller
                                                      .getSelectedDates()
                                                      .isNotEmpty) {
                                                    if (controller
                                                        .getSelectedDates()
                                                        .length > maxTimes!) {
                                                      controller
                                                          .getSelectedDates()
                                                          .clear();
                                                      isSelected = false.obs;
                                                    } else {
                                                      isSelected = (controller
                                                          .getSelectedDates()
                                                          .firstWhereOrNull((
                                                          element) {
                                                        if (element.toJson()
                                                            .toString() ==
                                                            customDate.toJson()
                                                                .toString()) {
                                                          return true;
                                                        } else {
                                                          return false;
                                                        }
                                                      }) != null).obs;
                                                    }
                                                  } else {
                                                    isSelected = false.obs;
                                                  }
                                                  return Obx(() =>
                                                      InkWell(
                                                        onTap: !isActive
                                                            ? null
                                                            : () {
                                                          customDate.hour =
                                                              getCurrentHourMinDatePicker(
                                                                  timeIndex)
                                                                  .toString();
                                                          if (isSelected
                                                              .value == true) {
                                                            bool removeNext = customDate
                                                                .hour.toString()
                                                                .split(
                                                                ":")[1] == "00";

                                                            if(removeNext){
                                                              if(nextCustomDate != null){
                                                                if(controller.getSelectedDates().contains(nextCustomDate)){
                                                                  removeNext = true;
                                                                }else{
                                                                  if(preCustomDate != null){
                                                                    if(controller.getSelectedDates().contains(preCustomDate)){
                                                                      removeNext = false;
                                                                    }
                                                                  }
                                                                }
                                                              }else{
                                                                removeNext = false;
                                                              }
                                                            }else{
                                                              if(preCustomDate != null){
                                                                if(controller.getSelectedDates().contains(preCustomDate)){
                                                                  removeNext = false;
                                                                }else{
                                                                  if(nextCustomDate != null){
                                                                      if(controller.getSelectedDates().contains(nextCustomDate)) {
                                                                        removeNext = true;
                                                                      }
                                                                  }
                                                                }
                                                              }else{
                                                                removeNext = true;
                                                              }
                                                            }
                                                            if(!removeNextCustomDate(nextCustomDate)){
                                                              removePreCustomDate(preCustomDate);
                                                            }
                                                          }
                                                          if (controller
                                                              .getSelectedDates()
                                                              .length + 1 <
                                                              maxTimes! &&
                                                              nextCustomDate !=
                                                                  null &&
                                                              isSelected
                                                                  .value ==
                                                                  false) {
                                                            controller
                                                                .getSelectedDates()
                                                                .add(
                                                                nextCustomDate);
                                                            controller
                                                                .currentSelectedDates
                                                                .refresh();
                                                          }
                                                          if (controller
                                                              .getSelectedDates()
                                                              .length ==
                                                              maxTimes!) {
                                                            isSelected.value =
                                                            false;
                                                          } else {
                                                            isSelected.toggle();
                                                          }
                                                          if (isSelected
                                                              .value) {
                                                            controller
                                                                .getSelectedDates()
                                                                .add(
                                                                customDate);
                                                          } else {
                                                            controller
                                                                .getSelectedDates()
                                                                .removeWhere(
                                                                    (element) {
                                                                  if (element
                                                                      .year ==
                                                                      customDate
                                                                          .year &&
                                                                      element
                                                                          .month ==
                                                                          customDate
                                                                              .month &&
                                                                      element
                                                                          .day ==
                                                                          customDate
                                                                              .day &&
                                                                      element
                                                                          .hour ==
                                                                          customDate
                                                                              .hour) {
                                                                    return true;
                                                                  }
                                                                  return false;
                                                                });
                                                            if (controller
                                                                .getSelectedDates()
                                                                .length ==
                                                                maxTimes!) {
                                                              ColoredSnack(
                                                                  title:
                                                                  "تعداد جلسات انتخاب شده تکمیل شده است.",
                                                                  type: SnackType
                                                                      .ERROR);
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration: isSelected
                                                              .value
                                                              ? BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                              gradient:
                                                              LinearGradient(
                                                                  colors: [
                                                                    primary,
                                                                    primaryDark,
                                                                  ]))
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
            PageView.builder(
                controller: controller.pageController,
                itemCount: weeks!,
                onPageChanged: (cp) {
                  controller.setCurrentPage(cp);
                },
                itemBuilder: (context, index) {
                  return pages[index % pages.length];
                }),
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

  bool removeNextCustomDate(CustomDate? nextCustomDate) {
    if(nextCustomDate == null){
      return false;
    }
    bool isRemoved = false;
    // if(nextCustomDate.hour.toString().split(":")[1] != "00"){
    controller.getSelectedDates().removeWhere((element) {
      if (element.year ==
          nextCustomDate
              .year &&
          element.month ==
              nextCustomDate
                  .month &&
          element.day ==
              nextCustomDate
                  .day &&
          element.hour ==
              nextCustomDate
                  .hour) {
        isRemoved = true;
        return true;
      } else {
        return false;
      }
    });
    controller.currentSelectedDates.refresh();
    return isRemoved;
    // }
  }

  bool removePreCustomDate(CustomDate? preCustomDate) {
    if(preCustomDate == null){
      return false;
    }
    bool isRemoved = false;
    // if(preCustomDate.hour.toString().split(":")[1] == "00"){
    controller.getSelectedDates().removeWhere((element) {
      if (element.year ==
          preCustomDate
              .year &&
          element.month ==
              preCustomDate
                  .month &&
          element.day ==
              preCustomDate
                  .day &&
          element.hour ==
              preCustomDate
                  .hour) {
        isRemoved = true;
        return true;
      } else {
        return false;
      }
    });
    controller.currentSelectedDates.refresh();
    return isRemoved;
    // }
  }
}
