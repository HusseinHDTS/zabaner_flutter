import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:zabaner/models/custom_date.dart';
import 'package:zabaner/models/online_class.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
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
    if(classStatus == "done"){
      classStatus = "کلاس ها برگذار شده اند";
    }else if(classStatus == "linkUpdate"){
      classStatus = "لینک کلاسی قرار داده نشد";
    }else{
      classStatus = "در انتظار تایید";
    }
    List<CustomDate> customDates = customDateListModelFromJson(item.classTimes);
    Color backColor = Colors.lightGreen;
    if (item.classStatus != "done") {
      backColor = Colors.white;
    }
    if(item.classStatus == "linkUpdate"){
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
            topRoundedMiniBar(title: item.userName),
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
                      // debugPrint("wvmnndmasnmdnsadw : " + cDate.month.toString());
                      // jalali =
                      //     jalali.copy(month: int.parse(cDate.month.toString()),year: int.parse(cDate.year.toString()),day: 1);
                      return Container(margin: EdgeInsets.symmetric(vertical: 4),child: ColoredText(
                        "(${index + 1}) ${cDate.day} / ${cDate.month} / ${cDate.year} : ${cDate.hour}",
                        textDirection: TextDirection.rtl,
                        textColor: Colors.black54,
                      ),);
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
                            "قیمت کلاس : ${item.classPrice}",
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
                  onTap: (){
                    if(item.classStatus == "linkUpdate"){
                      copyToClipboard(item.classLink,showAlert: true,title: "لینک کپی شد!");
                    }
                  },
                  child: ColoredText( item.classStatus == "linkUpdate" ?
                    "کپی کردن لینک ورود به کلاس" : "کلاس ساخته نشده است",
                    textColor: item.classStatus == "linkUpdate" ? primary : Colors.black45,
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
