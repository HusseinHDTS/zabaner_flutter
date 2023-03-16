import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:zabaner/models/custom_date.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class CustomDatePickerController extends GetxController {
  PageController pageController =
      PageController(keepPage: true, viewportFraction: 1,initialPage: 0);
  RxInt currentPage = 0.obs;
  RxBool isAddTimeEnable = true.obs;
  RxBool isRemoveTimeEnable = false.obs;
  RxList<CustomDate> currentSelectedDates = <CustomDate>[].obs;

  var jDate = Jalali.fromDateTime(DateTime.now());

  void onTeacherClick({required CustomDate customDate,timeIndex,RxBool? isSelected}) {
    isSelected ??=false.obs;
    // customDate.hour =
    //     getCurrentHourMinDatePicker(
    //         timeIndex)
    //         .toString();
    //   if(isAddTimeEnable.value){
    //     customDate.isFree = true;
    //   }else{
    //     customDate.isFree = false;
    //   }
      if(!isSelected.value){
        getSelectedDates().add(customDate);
      }else{
        getSelectedDates()
            .removeWhere(
                (element) {
                if(element.toJson(removeFree: true).toString() == customDate.toJson(removeFree: true).toString()) {
                  return true;
                }
              return false;
            });
      }
    isSelected.toggle();
  }

  void toggleAddRemoveTime() {
    isAddTimeEnable.toggle();
    isRemoveTimeEnable.toggle();
  }

  void onUserClick({customDate,timeIndex,RxBool? isSelected,maxTimes,nextCustomDate,preCustomDate}){
    isSelected ??=false.obs;

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
          if(getSelectedDates().contains(nextCustomDate)){
            removeNext = true;
          }else{
            if(preCustomDate != null){
              if(getSelectedDates().contains(preCustomDate)){
                removeNext = false;
              }
            }
          }
        }else{
          removeNext = false;
        }
      }else{
        if(preCustomDate != null){
          if(getSelectedDates().contains(preCustomDate)){
            removeNext = false;
          }else{
            if(nextCustomDate != null){
              if(getSelectedDates().contains(nextCustomDate)) {
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
    if (getSelectedDates()
        .length + 1 <
        maxTimes! &&
        nextCustomDate !=
            null &&
        isSelected
            .value ==
            false) {
      getSelectedDates()
          .add(
          nextCustomDate);
      currentSelectedDates
          .refresh();
    }
    if (getSelectedDates()
        .length ==
        maxTimes!) {
      isSelected.value =
      false;
    } else {
      isSelected.toggle();
    }
    if (isSelected
        .value) {
      getSelectedDates()
          .add(
          customDate);
    } else {
      getSelectedDates()
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
      if (getSelectedDates()
          .length ==
          maxTimes!) {
        ColoredSnack(
            title:
            "تعداد جلسات انتخاب شده تکمیل شده است.",
            type: SnackType
                .ERROR);
      }
    }
  }

  bool removeNextCustomDate(CustomDate? nextCustomDate) {
    if(nextCustomDate == null){
      return false;
    }
    bool isRemoved = false;
    // if(nextCustomDate.hour.toString().split(":")[1] != "00"){
    getSelectedDates().removeWhere((element) {
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
    currentSelectedDates.refresh();
    return isRemoved;
    // }
  }

  bool removePreCustomDate(CustomDate? preCustomDate) {
    if(preCustomDate == null){
      return false;
    }
    bool isRemoved = false;
    // if(preCustomDate.hour.toString().split(":")[1] == "00"){
    getSelectedDates().removeWhere((element) {
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
    currentSelectedDates.refresh();
    return isRemoved;
    // }
  }

  void setCurrentPage(int page) {
    currentPage.value = page;
  }

  List<CustomDate> getSelectedDates(){
    return currentSelectedDates.cast();
  }

  int getCurrentPage() {
    return currentPage.value;
  }

  void addOrRemoveTime(
      {required int weekDay, required int day, required String time}) {}

  List getTrueDay(String day,{bool? showMonth}) {
    showMonth??=false;
    int currentYear = jDate.year;
    int currentMonth = jDate.month;
    int monthLength = jDate.monthLength;
    int cDay = int.parse(day);
    String showingMonth = "";
    String result = "";
    if (cDay < 0) {
      if (currentMonth == 1) {
        currentYear--;
        currentMonth = 12;
      } else {
        currentMonth--;
      }
      result = (monthLength + cDay).toString();
    } else {
      if (cDay > monthLength) {
        result = (cDay - monthLength).toString();
        int ccDay = cDay;
        while(ccDay > monthLength){
          ccDay = ccDay - monthLength;
          if (currentMonth == 12) {
            currentMonth = 1;
            currentYear++;
          } else {
            currentMonth++;
          }
        }
        result = ccDay.toString();
      } else {
        result = cDay.toString();
      }
    }
    showingMonth = showMonth ? " ${jDate.copy(month: currentMonth,year: currentYear,day: 1).formatter.mN}" : "";
    CustomDate date = CustomDate(
        year: currentYear,
        month: currentMonth,
        day: cDay.toString(),
        hour: result,isFree: true);

    return [result+showingMonth, date];
  }

  List getCurrentPageToShow(
      {required int index,
      required int weekDay,
      required int currentPage,
      required int currentDay,bool?showMonth}) {
    showMonth??=false;
    //currentDay 2
    // currentPage 0
    //currentIndex 0
    if (currentPage == 0) {
      if (index + 1 < weekDay) {
        var a = weekDay - index;
        return getTrueDay((currentDay + 1 - a).toString(),showMonth: showMonth);
      }
      if (index == 0) {
        return getTrueDay((currentDay + 1 - weekDay).toString(),showMonth: showMonth);
      } else {
        return getTrueDay(((currentDay + 1 - weekDay) + index).toString(),showMonth: showMonth);
      }
    } else {
      int dayPast = 7 * currentPage;
      if (index == 0) {
        return getTrueDay(((currentDay + 1 - weekDay) + dayPast).toString(),showMonth: showMonth);
      } else {
        return getTrueDay(
            ((currentDay + 1 - weekDay) + dayPast + index).toString(),showMonth: showMonth);
      }
    }
  }


}
