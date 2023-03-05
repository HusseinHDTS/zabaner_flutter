import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:zabaner/models/custom_date.dart';

class CustomDatePickerController extends GetxController {
  PageController pageController =
      PageController(keepPage: true, viewportFraction: 1,initialPage: 0);
  RxInt currentPage = 0.obs;
  RxList<CustomDate> currentSelectedDates = <CustomDate>[].obs;

  var jDate = Jalali.fromDateTime(DateTime.now());

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
        hour: result);

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
