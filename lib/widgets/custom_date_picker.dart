import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  List<CustomDate>? activeDates;
  EdgeInsets? headerPadding;
  double? headerTextSize;
  Color? headerColor;
  Color? headerTextColor;

  CustomDatePicker(
      {required this.controller,
      this.weeks,
      this.maxTimes,
      this.headerColor,
      this.isTeacher,
      this.autoSelectNext,
      this.viewMode,
      this.deActiveDates,
      this.activeDates,
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
    activeDates ??= [];
    maxTimes ??= 999999999999999999;
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

  var modifyCurrentDate;

  @override
  Widget build(BuildContext context) {
    Jalali currentSelectedDate = Jalali.now();
    final pages = List.generate(weeks!, (weekIndex) {
      RxInt selectedDay = 0.obs;
      return Column(
        children: [
          Expanded(
            flex: 0,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(7, (dayIndex) {
                  int currentFullDayNumber = (weekIndex * 7) + (dayIndex);
                  Jalali currentDate =
                      controller.getDateFromNumber(currentFullDayNumber);
                  bool isDayActive = true;
                  if (weekIndex == 0) {
                    if (Jalali.now().weekDay == currentDate.weekDay) {
                      selectedDay.value = dayIndex;
                      currentSelectedDate = currentDate;
                    }
                    if (Jalali.now().weekDay > currentDate.weekDay) {
                      isDayActive = false;
                    }
                  }

                  return Obx(() {
                    if (controller.currentPage.value == weekIndex) {
                      if (selectedDay.value == dayIndex) {
                        currentSelectedDate = currentDate;
                      }
                    }
                    return Flexible(
                        flex: controller.isDaySelected(
                                dayIndex, selectedDay.value)
                            ? 3
                            : 1,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 1),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () {
                                if (!isDayActive) return;
                                if (selectedDay.value != dayIndex) {
                                  selectedDay.value = dayIndex;
                                  currentSelectedDate =
                                      controller.getDateFromNumber(
                                          (weekIndex * 7) + (dayIndex));
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    top: controller.isDaySelected(
                                            dayIndex, selectedDay.value)
                                        ? 0
                                        : 4),
                                height: controller.isDaySelected(
                                        dayIndex, selectedDay.value)
                                    ? 55
                                    : 38,
                                decoration: BoxDecoration(
                                    color: !isDayActive
                                        ? Colors.black38
                                        : controller.isDaySelected(
                                                dayIndex, selectedDay.value)
                                            ? Colors.white
                                            : primaryDark,
                                    shape: !isDayActive
                                        ? BoxShape.circle
                                        : BoxShape.rectangle,
                                    borderRadius: controller.isDaySelected(
                                            dayIndex, selectedDay.value)
                                        ? (isTeacher ?? false)
                                            ? null
                                            : BorderRadius.only(
                                                topRight: Radius.circular(8),
                                                topLeft: Radius.circular(8))
                                        : !isDayActive
                                            ? null
                                            : BorderRadius.circular(6)),
                                child: Center(
                                    child: ColoredText(
                                  controller.isDaySelected(
                                          dayIndex, selectedDay.value)
                                      ? controller.getDay(dayIndex) +
                                          " " +
                                          currentDate.formatter.dd +
                                          " " +
                                          currentDate.formatter.mN
                                      : currentDate.formatter.dd + " ام",
                                  textSize: 12,
                                  textColor: controller.isDaySelected(
                                          dayIndex, selectedDay.value)
                                      ? Colors.black
                                      : Colors.white,
                                  maxLines: 1,
                                )),
                              ),
                            ),
                          ),
                        ));
                  });
                })),
          ),
          Expanded(
            flex: 1,
            child: Obx(() => Container(
                  height: double.infinity,
                  margin: const EdgeInsets.only(bottom: 8, right: 1, left: 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      topLeft: selectedDay.value == 6
                          ? Radius.zero
                          : Radius.circular(8),
                      topRight: selectedDay.value == 0
                          ? Radius.zero
                          : Radius.circular(8),
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(5, (timeIndex) {
                        return Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(6, (minTimeIndex) {
                                int currentMinTime =
                                    (timeIndex * 5) + (minTimeIndex);
                                if (timeIndex != 0) {
                                  currentMinTime += timeIndex;
                                }
                                if (controller.currentPage.value == 0) {}
                                CustomDate ccD = CustomDate(
                                    day: currentSelectedDate.formatter.dd,
                                    month: currentSelectedDate.month.toString(),
                                    year: currentSelectedDate.year,
                                    hour: controller
                                        .getCurrentMinTimeText(currentMinTime),
                                    isFree: "true");
                                deActiveDates ??= [];
                                if (!isTeacher!) {
                                  if (!activeDates!.any((element) =>
                                      element
                                          .toJson(
                                              removeFree: (isTeacher ?? false))
                                          .toString() ==
                                      ccD
                                          .toJson(
                                              removeFree: (isTeacher ?? false))
                                          .toString())) {
                                    deActiveDates!.add(ccD);
                                  }
                                }
                                bool isActive = (!deActiveDates!.any(
                                    (element) =>
                                        element
                                            .toJson(
                                                removeFree:
                                                    (isTeacher ?? false))
                                            .toString() ==
                                        ccD
                                            .toJson(
                                                removeFree:
                                                    (isTeacher ?? false))
                                            .toString()));
                                RxBool isSelected = (controller
                                    .getSelectedDates()
                                    .any((element) {
                                  bool has = element
                                          .toJson(
                                              removeFree: (isTeacher ?? false))
                                          .toString() ==
                                      ccD
                                          .toJson(
                                              removeFree: (isTeacher ?? false))
                                          .toString();
                                  if ((isTeacher ?? false)) {
                                    if (has) {
                                      ccD = element;
                                    }
                                  }
                                  return has;
                                })).obs;
                                return GestureDetector(
                                  onTap: () {
                                    if (!isActive || viewMode!) return;
                                    if ((isTeacher ?? false)) {
                                      ccD.isFree = controller
                                          .isAddTimeEnable.value
                                          .toString();
                                    }
                                    isSelected.toggle();
                                    if (isSelected.value) {
                                      if(controller.getSelectedDates().length == maxTimes!){
                                        ColoredSnack(title:"تعداد جلسات انتخاب شده تکمیل شده است.",type: SnackType.ERROR);
                                        return;
                                      }
                                      controller.getSelectedDates().add(ccD);
                                      if ((autoSelectNext ?? false)) {
                                        if(controller.getSelectedDates().length == maxTimes!){
                                          return;
                                        }
                                        if ((currentMinTime + 1) <= 30) {
                                          controller.getSelectedDates().add(
                                              CustomDate(
                                                  day: currentSelectedDate
                                                      .formatter.dd,
                                                  month: currentSelectedDate
                                                      .month.toString(),
                                                  year:
                                                      currentSelectedDate.year,
                                                  hour: controller
                                                      .getCurrentMinTimeText(
                                                          currentMinTime + 1),
                                                  isFree: "true"));
                                        }
                                      }
                                    } else {
                                      controller.getSelectedDates().removeWhere(
                                          (element) =>
                                              element
                                                  .toJson(
                                                      removeFree:
                                                          (isTeacher ?? false))
                                                  .toString() ==
                                              ccD
                                                  .toJson(
                                                      removeFree:
                                                          (isTeacher ?? false))
                                                  .toString());
                                      if ((autoSelectNext ?? false)) {
                                        CustomDate ccDN;
                                        if(controller.getCurrentMinTimeText(currentMinTime).toString().split(":")[1] == "00"){
                                          ccDN = CustomDate(
                                              day: currentSelectedDate
                                                  .formatter.dd,
                                              month: currentSelectedDate
                                                  .month.toString(),
                                              year:
                                              currentSelectedDate.year,
                                              hour: controller
                                                  .getCurrentMinTimeText(
                                                  currentMinTime + 1),
                                              isFree: "true");
                                        }else{
                                          ccDN = CustomDate(
                                              day: currentSelectedDate
                                                  .formatter.dd,
                                              month: currentSelectedDate
                                                  .month.toString(),
                                              year:
                                              currentSelectedDate.year,
                                              hour: controller
                                                  .getCurrentMinTimeText(
                                                  currentMinTime - 1),
                                              isFree: "true");
                                        }
                                        controller.getSelectedDates().removeWhere(
                                                (element) => element.toJson(
                                                removeFree: (isTeacher ??
                                                    false))
                                                .toString() ==
                                                ccDN.toJson(
                                                    removeFree:(isTeacher ??false)).toString());
                                      }
                                    }
                                  },
                                  child: Container(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 4),
                                      child: ColoredText(
                                        controller.getCurrentMinTimeText(
                                            currentMinTime),
                                        textColor: !isActive
                                            ? Colors.white
                                            : isSelected.value
                                                ? Colors.white
                                                : null,
                                      ),
                                    ),
                                    decoration: (isSelected.value || !isActive)
                                        ? BoxDecoration(
                                            color: !isActive
                                                ? Colors.black38
                                                : (isTeacher ?? false)
                                                    ? ccD.isFree.toString() ==
                                                            "true"
                                                        ? Colors.green
                                                        : Colors.red
                                                    : primary,
                                            borderRadius:
                                                BorderRadius.circular(6))
                                        : BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                            color: (timeIndex % 2 == 0)
                                                ? primaryDark.withOpacity(0.14)
                                                : Colors.grey.withOpacity(0.09)),
                                  ),
                                );
                              }),
                            ));
                      }),
                    ),
                  ),
                )),
          ),
        ],
      );
    });
    return Container(
      color: primaryDark.withOpacity(0.2),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          child: Stack(
            children: [
              Column(
                children: [
                  !viewMode! && (isTeacher ?? false)
                      ? Expanded(
                          flex: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: Colors.white),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: double.infinity,
                                    child: Center(
                                      child: Obx(() => checkBox("افزودن",
                                              controller.isAddTimeEnable,
                                              (value) {
                                            if (controller
                                                .isAddTimeEnable.isFalse) {
                                              controller.toggleAddRemoveTime();
                                            }
                                          },
                                              textColor: Colors.green,
                                              boxColor: Colors.green,
                                              activeColor: Colors.green,
                                              checkColor: Colors.white)),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: double.infinity,
                                    child: Center(
                                      child: Obx(() => checkBox("حذف",
                                              controller.isRemoveTimeEnable,
                                              (value) {
                                            if (controller
                                                .isRemoveTimeEnable.isFalse) {
                                              controller.toggleAddRemoveTime();
                                            }
                                          },
                                              textColor: Colors.red,
                                              boxColor: Colors.red,
                                              activeColor: Colors.red,
                                              checkColor: Colors.white)),
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
                    child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: PageView.builder(
                          controller: controller.pageController,
                          itemCount: weeks!,
                          onPageChanged: (cp) {
                            controller.setCurrentPage(cp);
                          },
                          itemBuilder: (context, index) {
                            return pages[index % pages.length];
                          }),
                    ),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 4),
                    child: SmoothPageIndicator(
                      controller: controller.pageController,
                      count: pages.length,
                      effect: WormEffect(
                        dotHeight: 7,
                        dotWidth: 13,
                        spacing: 9,
                        type: WormType.thin,
                        dotColor: Colors.black12,
                        activeDotColor: primaryDark,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

// class CustomDatePicker2 extends StatelessWidget {
//   CustomDatePickerController controller;
//   int? weeks;
//   int? maxTimes;
//   bool? isTeacher;
//   bool? autoSelectNext;
//   bool? viewMode;
//   List<CustomDate>? deActiveDates;
//   List<CustomDate>? activeDates;
//   EdgeInsets? headerPadding;
//   double? headerTextSize;
//   Color? headerColor;
//   Color? headerTextColor;
//
//   CustomDatePicker2(
//       {required this.controller,
//       this.weeks,
//       this.maxTimes,
//       this.headerColor,
//       this.isTeacher,
//       this.autoSelectNext,
//       this.viewMode,
//       this.deActiveDates,
//       this.activeDates,
//       this.headerPadding,
//       this.headerTextSize,
//       this.headerTextColor,
//       Key? key})
//       : super(key: key) {
//     controller.currentPage = 0.obs;
//     weeks ??= 4;
//     isTeacher ??= false;
//     viewMode ??= false;
//     headerPadding ??= EdgeInsets.zero;
//     deActiveDates ??= [];
//     activeDates ??= [];
//     maxTimes ??= 999999999999999;
//     autoSelectNext ??= false;
//     headerTextSize ??= 12;
//     headerColor ??= primary;
//     headerTextColor ??= Colors.white;
//     if (autoSelectNext!) {
//       maxTimes = maxTimes! * 2;
//     }
//     // if(Get.isRegistered<CustomDatePickerController>()){
//     //   controller = Get.find();
//     // }else{
//     //   controller = Get.put(CustomDatePickerController());
//     // }
//   }
//
//   Future<dynamic> calculateAsIndex(
//     CustomDate customDate,
//   ) async {
//     if (!isTeacher!) {
//       if (activeDates!.firstWhereOrNull((element) =>
//               element.toJson(removeFree: true).toString() ==
//               customDate.toJson(removeFree: true).toString()) ==
//           null) {
//         deActiveDates!.add(customDate);
//       }
//     }
//     // bool isActive = deActiveDates!.firstWhereOrNull((element) => element
//     //     .toJson(removeFree: true)
//     //     .toString() ==
//     //     customDate
//     //         .toJson(removeFree: true)
//     //         .toString()) == null;
//
//     bool isActive = true;
//
//     bool isSelected = (controller.getSelectedDates().firstWhereOrNull(
//             (element) =>
//                 element.toJson(removeFree: true).toString() ==
//                 customDate.toJson(removeFree: true).toString()) !=
//         null);
//
//     return {
//       "isActive": isActive.toString(),
//       "isSelected": isSelected.toString()
//     };
//   }
//
//   Future<List<Widget>> getPages(
//     weekDay,
//     cDay,
//   ) async {
//     return List.generate(
//         weeks!,
//         (pageIndex) => Padding(
//             padding: const EdgeInsets.only(
//               bottom: 18,
//             ),
//             child: Directionality(
//               textDirection: TextDirection.rtl,
//               child: Container(
//                 child: Column(
//                   children: [
//                     Expanded(
//                       flex: 0,
//                       child: Container(
//                         height: 45,
//                         padding: headerPadding,
//                         decoration: BoxDecoration(color: headerColor),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: List.generate(7, (weekIndex) {
//                             return Flexible(
//                                 child: Center(
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Container(
//                                     padding:
//                                         EdgeInsets.symmetric(horizontal: 0.5),
//                                     child: Obx(() => controller
//                                                 .currentPage.value ==
//                                             0
//                                         ? ColoredText(
//                                             controller.getCurrentPageToShow(
//                                                 index: weekIndex,
//                                                 weekDay: weekDay,
//                                                 currentDay: cDay,
//                                                 currentPage: pageIndex,
//                                                 showMonth: true)[0],
//                                             textColor: weekDay ==
//                                                         weekIndex + 1 &&
//                                                     controller.getCurrentPageToShow(
//                                                             index: weekIndex,
//                                                             weekDay: weekDay,
//                                                             currentDay: cDay,
//                                                             currentPage:
//                                                                 pageIndex)[0] ==
//                                                         cDay.toString()
//                                                 ? primaryDate
//                                                 : headerTextColor,
//                                             textSize: headerTextSize! - 1.8,
//                                           )
//                                         : ColoredText(
//                                             controller.getCurrentPageToShow(
//                                                 index: weekIndex,
//                                                 weekDay: weekDay,
//                                                 currentDay: cDay,
//                                                 currentPage: pageIndex,
//                                                 showMonth: true)[0],
//                                             textColor: weekDay ==
//                                                         weekIndex + 1 &&
//                                                     controller.getCurrentPageToShow(
//                                                             index: weekIndex,
//                                                             weekDay: weekDay,
//                                                             currentDay: cDay,
//                                                             currentPage:
//                                                                 pageIndex)[0] ==
//                                                         cDay.toString()
//                                                 ? primaryDate
//                                                 : headerTextColor,
//                                             textSize: headerTextSize! - 1.8,
//                                           )),
//                                   ),
//                                   Container(
//                                     padding:
//                                         EdgeInsets.symmetric(horizontal: 0.5),
//                                     child: Obx(() => controller
//                                                 .currentPage.value ==
//                                             0
//                                         ? ColoredText(
//                                             getCurrentDayDatePicker(weekIndex),
//                                             textColor: weekDay ==
//                                                         weekIndex + 1 &&
//                                                     controller.getCurrentPageToShow(
//                                                             index: weekIndex,
//                                                             weekDay: weekDay,
//                                                             currentDay: cDay,
//                                                             currentPage:
//                                                                 pageIndex)[0] ==
//                                                         cDay.toString()
//                                                 ? primaryDate
//                                                 : headerTextColor,
//                                             textSize: headerTextSize! - 3,
//                                           )
//                                         : ColoredText(
//                                             getCurrentDayDatePicker(weekIndex),
//                                             textColor: weekDay ==
//                                                         weekIndex + 1 &&
//                                                     controller.getCurrentPageToShow(
//                                                             index: weekIndex,
//                                                             weekDay: weekDay,
//                                                             currentDay: cDay,
//                                                             currentPage:
//                                                                 pageIndex)[0] ==
//                                                         cDay.toString()
//                                                 ? primaryDate
//                                                 : headerTextColor,
//                                             textSize: headerTextSize! - 3,
//                                           )),
//                                   ),
//                                 ],
//                               ),
//                             ));
//                           }),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Expanded(
//                       flex: 1,
//                       child: Container(
//                         height: double.infinity,
//                         margin: EdgeInsets.symmetric(horizontal: 4),
//                         child: SingleChildScrollView(
//                           child: Row(
//                             children: List.generate(7, (weekIndex) {
//                               return Flexible(
//                                   child: Center(
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(horizontal: 4),
//                                   decoration: BoxDecoration(
//                                       border:
//                                           Border.all(color: primary, width: 1)),
//                                   child: Column(
//                                     children: List.generate(31, (timeIndex) {
//                                       CustomDate customDate =
//                                           controller.getCurrentPageToShow(
//                                         index: weekIndex,
//                                         weekDay: weekDay,
//                                         currentDay: cDay,
//                                         currentPage: pageIndex,
//                                       )[1];
//                                       customDate.hour =
//                                           getCurrentHourMinDatePicker(timeIndex)
//                                               .toString();
//                                       CustomDate? nextCustomDate;
//                                       CustomDate? preCustomDate;
//                                       if (timeIndex + 1 < 31) {
//                                         nextCustomDate =
//                                             controller.getCurrentPageToShow(
//                                           index: weekIndex,
//                                           weekDay: weekDay,
//                                           currentDay: cDay,
//                                           currentPage: pageIndex,
//                                         )[1];
//                                         nextCustomDate!.hour =
//                                             getCurrentHourMinDatePicker(
//                                                     timeIndex + 1)
//                                                 .toString();
//                                       }
//                                       if (timeIndex - 1 >= 0) {
//                                         preCustomDate =
//                                             controller.getCurrentPageToShow(
//                                           index: weekIndex,
//                                           weekDay: weekDay,
//                                           currentDay: cDay,
//                                           currentPage: pageIndex,
//                                         )[1];
//                                         preCustomDate!.hour =
//                                             getCurrentHourMinDatePicker(
//                                                     timeIndex - 1)
//                                                 .toString();
//                                       }
//                                       if (weekIndex + 1 < weekDay &&
//                                           pageIndex == 0) {
//                                         deActiveDates!.add(customDate);
//                                       }
//                                       return FutureBuilder<dynamic>(
//                                         future: calculateAsIndex(
//                                           customDate,
//                                         ),
//                                         builder: (context, snapshot) {
//                                           if (!snapshot.hasData) {
//                                             return Center(
//                                               child: Container(),
//                                             );
//                                           }
//
//                                           bool isActive =
//                                               (snapshot.data['isActive'] ==
//                                                   "true");
//
//                                           if (controller
//                                               .getSelectedDates()
//                                               .isNotEmpty) {
//                                             if (controller
//                                                     .getSelectedDates()
//                                                     .length >
//                                                 maxTimes!) {
//                                               controller
//                                                   .getSelectedDates()
//                                                   .clear();
//                                             }
//                                           }
//                                           RxBool isSelected =
//                                               (snapshot.data['isSelected'] ==
//                                                       "true")
//                                                   .obs;
//                                           return Obx(() {
//                                             RxBool isFree = (controller
//                                                     .isAddTimeEnable.value)
//                                                 .obs;
//                                             if (isSelected.value == true) {
//                                               isFree.value =
//                                                   (customDate.isFree ?? true);
//                                             }
//                                             var selectedColors;
//                                             if (isTeacher ?? false) {
//                                               if (isFree.value) {
//                                                 selectedColors = [
//                                                   Colors.green.shade400,
//                                                   Colors.green.shade600,
//                                                 ];
//                                               } else {
//                                                 selectedColors = [
//                                                   Colors.red.shade400,
//                                                   Colors.red.shade600,
//                                                 ];
//                                               }
//                                             } else {
//                                               selectedColors = [
//                                                 primary,
//                                                 primaryDark,
//                                               ];
//                                             }
//                                             return InkWell(
//                                               onTap: !isActive
//                                                   ? null
//                                                   : () {
//                                                       if (viewMode!) {
//                                                         return;
//                                                       }
//                                                       customDate.isFree =
//                                                           controller
//                                                               .isAddTimeEnable
//                                                               .value;
//
//                                                       if (isTeacher!) {
//                                                         controller
//                                                             .onTeacherClick(
//                                                                 customDate:
//                                                                     customDate,
//                                                                 timeIndex:
//                                                                     timeIndex,
//                                                                 isSelected:
//                                                                     isSelected);
//                                                       } else {
//                                                         controller.onUserClick(
//                                                             customDate:
//                                                                 customDate,
//                                                             isSelected:
//                                                                 isSelected,
//                                                             maxTimes: maxTimes,
//                                                             nextCustomDate:
//                                                                 nextCustomDate,
//                                                             preCustomDate:
//                                                                 preCustomDate,
//                                                             timeIndex:
//                                                                 timeIndex);
//                                                       }
//                                                     },
//                                               child: Container(
//                                                 decoration: isSelected.value
//                                                     ? BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(5),
//                                                         gradient: LinearGradient(
//                                                             colors:
//                                                                 selectedColors))
//                                                     : BoxDecoration(
//                                                         color: !isActive
//                                                             ? Colors.grey
//                                                                 .withOpacity(
//                                                                     0.2)
//                                                             : timeIndex % 2 == 0
//                                                                 ? null
//                                                                 : primaryDark
//                                                                     .withOpacity(
//                                                                         0.2),
//                                                         border: Border(
//                                                             bottom: BorderSide(
//                                                                 color: primary
//                                                                     .withOpacity(
//                                                                         0.4),
//                                                                 width: 1))),
//                                                 margin: EdgeInsets.symmetric(
//                                                     vertical: 4),
//                                                 padding: EdgeInsets.symmetric(
//                                                     vertical: 3, horizontal: 3),
//                                                 child: ColoredText(
//                                                   getCurrentHourMinDatePicker(
//                                                       timeIndex),
//                                                   textSize: 12,
//                                                   textColor: isSelected.value
//                                                       ? Colors.white
//                                                       : isActive
//                                                           ? null
//                                                           : Colors.black38,
//                                                 ),
//                                               ),
//                                             );
//                                           });
//                                         },
//                                       );
//                                     }),
//                                   ),
//                                 ),
//                               ));
//                             }),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Expanded(
//                       flex: 0,
//                       child: Container(
//                         width: double.infinity,
//                         margin: EdgeInsets.symmetric(horizontal: 16),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.max,
//                           children: [
//                             Flexible(
//                               child: Align(
//                                 alignment: Alignment.centerRight,
//                                 child: pageIndex == 0
//                                     ? Container()
//                                     : InkWell(
//                                         onTap: () {
//                                           controller.pageController
//                                               .previousPage(
//                                                   duration: Duration(
//                                                       milliseconds: 650),
//                                                   curve: Curves.linear);
//                                         },
//                                         child: Container(
//                                           child: ColoredText(
//                                             "هفته قبل",
//                                             textDirection: TextDirection.rtl,
//                                             textColor: Colors.redAccent,
//                                           ),
//                                         ),
//                                       ),
//                               ),
//                             ),
//                             Flexible(
//                               child: Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: pageIndex == weeks! - 1
//                                     ? Container()
//                                     : InkWell(
//                                         onTap: () {
//                                           controller.pageController.nextPage(
//                                               duration:
//                                                   Duration(milliseconds: 650),
//                                               curve: Curves.linear);
//                                         },
//                                         child: Container(
//                                           child: ColoredText(
//                                             "هفته بعد",
//                                             textColor: Colors.green,
//                                           ),
//                                         ),
//                                       ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int weekDay = controller.jDate.weekDay;
//     int cDay = controller.jDate.day;
//     return FutureBuilder<List<Widget>>(
//         future: getPages(weekDay, cDay),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           List<Widget> pages = snapshot.data!;
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             child: Directionality(
//               textDirection: TextDirection.rtl,
//               child: Stack(
//                 children: [
//                   Column(
//                     children: [
//                       !viewMode! && isTeacher!
//                           ? Expanded(
//                               flex: 0,
//                               child: Container(
//                                 height: 40,
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 8),
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(color: primary),
//                                 child: Row(
//                                   children: [
//                                     Flexible(
//                                       flex: 0,
//                                       child: Container(
//                                         child: Align(
//                                           alignment: Alignment.centerRight,
//                                           child: Obx(() => checkBox("افزودن",
//                                                   controller.isAddTimeEnable,
//                                                   (value) {
//                                                 if (controller
//                                                     .isAddTimeEnable.isFalse) {
//                                                   controller
//                                                       .toggleAddRemoveTime();
//                                                 }
//                                               },
//                                                   textColor: Colors.white,
//                                                   boxColor: Colors.white,
//                                                   activeColor: Colors.white,
//                                                   checkColor: Colors.green)),
//                                         ),
//                                       ),
//                                     ),
//                                     Flexible(
//                                       flex: 0,
//                                       child: Container(
//                                         child: Align(
//                                           alignment: Alignment.centerRight,
//                                           child: Obx(() => checkBox("حذف",
//                                                   controller.isRemoveTimeEnable,
//                                                   (value) {
//                                                 if (controller
//                                                     .isRemoveTimeEnable
//                                                     .isFalse) {
//                                                   controller
//                                                       .toggleAddRemoveTime();
//                                                 }
//                                               },
//                                                   textColor: Colors.white,
//                                                   boxColor: Colors.white,
//                                                   activeColor: Colors.white,
//                                                   checkColor: Colors.red)),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           : Container(),
//                       Expanded(
//                           flex: 1,
//                           child: PageView.builder(
//                               controller: controller.pageController,
//                               itemCount: weeks!,
//                               onPageChanged: (cp) {
//                                 controller.setCurrentPage(cp);
//                               },
//                               itemBuilder: (context, index) {
//                                 return pages[index % pages.length];
//                               }))
//                     ],
//                   ),
//                   Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: 4),
//                         child: SmoothPageIndicator(
//                           controller: controller.pageController,
//                           count: pages.length,
//                           effect: const WormEffect(
//                             dotHeight: 7,
//                             dotWidth: 13,
//                             spacing: 9,
//                             type: WormType.thin,
//                             dotColor: Colors.black12,
//                             activeDotColor: primaryDark,
//                           ),
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }
