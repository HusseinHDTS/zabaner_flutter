import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/controllers/custom_date_picker_controller.dart';
import 'package:zabaner/controllers/online_class_controller.dart';
import 'package:zabaner/controllers/submit_class_controller.dart';
import 'package:zabaner/models/custom_date.dart';
import 'package:zabaner/models/user_teachers.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/custom_date_picker.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class SubmitClass extends StatefulWidget {
  UserTeachers item;
  int selectedPos;

  SubmitClass(this.item, this.selectedPos, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubmitClass();
  }
}

class _SubmitClass extends State<SubmitClass> {
  SubmitClassController controller = Get.put(SubmitClassController());

  @override
  Widget build(BuildContext context) {
    List<CustomDate>? customDates;
    try{
      customDates = customDateListModelFromJson(widget.item.freeTimes);
      customDates.removeWhere((element){
        if(element.isFree.toString() == "true"){
          return true;
        }
        return false;
      });
    }catch(e){e.printError();}
    return Scaffold(
      appBar: ColoredAppBar(),
      body: Container(
        color: primaryDark.withOpacity(0.08),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 18),
          child: Column(
            children: [
              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     height: double.infinity,
              //     margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(18),
              //         color: Colors.white,
              //         border: Border.all(color: primaryDark, width: 2)),
              //     child: ClipRRect(
              //       borderRadius: BorderRadius.circular(15),
              //       child: SfDateRangePicker(
              //         view: DateRangePickerView.month,
              //         allowViewNavigation: false,
              //         controller: controller.dateController,
              //         onViewChanged: (item){
              //
              //         },
              //         selectionColor: primary,
              //         todayHighlightColor: Colors.blueAccent,
              //         monthViewSettings:  DateRangePickerMonthViewSettings(
              //           firstDayOfWeek: 6,
              //           specialDates: [],
              //           viewHeaderStyle: DateRangePickerViewHeaderStyle(backgroundColor: primary,textStyle: TextStyle(color: Colors.white)),
              //           dayFormat: "E",
              //         ),
              //         headerHeight: 50,
              //         enableMultiView: false,
              //         monthFormat: "MM /",
              //         selectionMode: DateRangePickerSelectionMode.multiple,
              //         onSelectionChanged: (args){
              //           // DateRangePickerCellDetails item = args.value;
              //           // var items = controller.dateController.selectedDates!;
              //           if(args.value.length > widget.selectedPos){
              //             controller.dateController.selectedDates!.clear();
              //             controller.dateController.selectedDates!.addAll(controller.selectedDates);
              //             controller.dateController.notifyPropertyChangedListeners("selectedDates");
              //             ColoredSnack(title: "نمیتوانید بیشتر از ${widget.selectedPos} روز رزرو کنید! ",type: SnackType.ERROR);
              //             // debugPrint("asdkjkawjdkjskjckxjzkcjkjxz : " + controller.selectedDates.toString());
              //             return;
              //           }
              //           controller.selectedDates = args.value;
              //           // debugPrint("daskdjkjsakdjksjakjdkjkjwww : " + controller.dateController.selectedDates!.toList().toString());
              //           // debugPrint("daskdjkjsakdjksjakjdkjkjwww : " + args.value.toString());
              //         },
              //         selectableDayPredicate: (dateTime){
              //           return true;
              //         },
              //         headerStyle: const DateRangePickerHeaderStyle(
              //           backgroundColor: primaryDark,
              //           textAlign: TextAlign.center,
              //           textStyle: TextStyle(color: Colors.white),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: primaryDark.withOpacity(0.22),
                          spreadRadius: 2,
                          blurRadius: 17,
                          offset: Offset(0, 5),
                        )
                      ],
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                      border: Border.all(color: primary, width: 2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CustomDatePicker(
                      controller: Get.find(),
                      autoSelectNext: widget.selectedPos != 0,
                      deActiveDates: customDates,
                      maxTimes:
                          widget.selectedPos == 0 ? 1 : widget.selectedPos,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Expanded(
                flex: 0,
                child: Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ColoredButton(
                      "رزرو زمانبندی ها",
                      onTap: () {
                        if (userSavedName.toString().trim().isEmpty) {
                          OnlineClassController ocController = Get.find();
                          if(!ocController.isNewUser.value){
                            controller.submitUserData(widget.item, widget.selectedPos,useInputText: false,uName: ocController.data['name'],uFamily:ocController.data['family']);
                            return;
                          }
                          customDialog(
                              borderRadius: 18,
                              child: Container(
                                color: Colors.white,
                                width: 300,
                                child: Directionality(textDirection: TextDirection.rtl,child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    topRoundedMiniBar(title: "لطفا اطلاعات خود را تکمیل کنید"),
                                    SizedBox(
                                      height: 18,
                                    ),
                                    inputText("نام", controller.nameController),
                                    inputText("نام خانوادگی", controller.familyController),
                                    inputText("شماره تلفن", controller.phoneController,enabled: false),
                                    SizedBox(height: 18,),
                                    ColoredButton("ثبت اطلاعات",gradient: LinearGradient(colors: [primary,primaryDark]),onTap: (){
                                      controller.submitUserData(widget.item, widget.selectedPos);
                                    },),
                                    SizedBox(height: 28,),
                                  ],
                                ),),
                              ));

                        } else {
                          controller.submitData(
                              widget.item, widget.selectedPos);
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
