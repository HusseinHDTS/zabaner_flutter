import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:zabaner/controllers/create_class_controller.dart';
import 'package:zabaner/controllers/custom_date_picker_controller.dart';
import 'package:zabaner/models/money_input_formatter.dart';
import 'package:zabaner/models/price_seperator.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/custom_date_picker.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class CreateClassScreen extends StatefulWidget {
  CreateClassScreen();

  @override
  State<StatefulWidget> createState() {
    return _CreateClassScreen();
  }
}

class _CreateClassScreen extends State<CreateClassScreen> {
  CreateClassController controller = Get.put(CreateClassController());

  @override
  void initState() {
    super.initState();
    controller.initData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: ColoredAppBar(),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExpandableNotifier(
                      initialExpanded: controller.isFirstTime(makeFalse: true),
                      child: Column(
                        children: [
                          Expandable(
                            collapsed: Container(
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: ExpandableButton(
                                    child: infoBox(
                                        "نمایش جزئیات و کمیسیون کلاس ها")),
                              ),
                            ),
                            expanded: Column(
                              children: [
                                infoBox(
                                    "در این صفحه شما می توانید تعرفه برگزاری کلاس ها را به ازای هر ساعت تدریس مشخص نمایید. برای مدت زمان های 3 ساعت، 5 ساعت و 10 ساعت مدت زمان ها را به ازای هر 1 ساعت تعیین نمایید. به عنوان مثال اگر برای 3 ساعت تعرفه ای که تعیین می کنید 100,000 تومان باشد قیمت هر سه ساعت برابر با 300,000 تومان خواهد بود. ",
                                    textSize: 14),
                                SizedBox(
                                  height: 18,
                                ),
                                infoBox(
                                    "کلاس آزمایشی به منظور تعیین سطح و آشنایی شما با زبان آموز می باشد و مدت زمان آن 30 دقیقه است. در صورتی که تمایل داشته باشید کلاس آزمایشی را به صورت رایگان برگزار کنید کافی است عدد 0 (صفر) را در فیلد مربوطه وارد نمایید.",
                                    textSize: 14),
                                SizedBox(
                                  height: 18,
                                ),
                                infoBox(
                                    "کمیسیون زبانر بسته به مجموع مدت زمانی که اساتید تدریس داشته اند متفاوت است، بنابراین هر چه مجموع مدت زمانی که مدرس تدریس کرده است بالاتر باشد میزان کمیسیون کاهش پیدا می کند. کمیسیون زبانر مطابق میزان مدت زمان های زیراست:",
                                    textSize: 14),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 28),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      infoBox(
                                          "از 0 تا 20 ساعت تدریس – کمیسیون 27 درصد ",
                                          textSize: 11),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      infoBox(
                                          "از 21 تا 50 ساعت تدریس – کمیسیون 25 درصد ",
                                          textSize: 11),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      infoBox(
                                          "از 51 تا 100 ساعت تدریس – کمیسیون 23 درصد ",
                                          textSize: 11),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      infoBox(
                                          "از 101 تا 200 ساعت تدریس – کمیسیون 21 درصد ",
                                          textSize: 11),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      infoBox(
                                          "از 201 تا 400 ساعت تدریس – کمیسیون 19 درصد ",
                                          textSize: 11),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      infoBox(
                                          "از بیش از 400 ساعت تدریس – کمیسیون 17 درصد",
                                          textSize: 11),
                                      SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: ExpandableButton(
                                        child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 8),
                                            child: ColoredText(
                                              "بستن",
                                              textSize: 14,
                                              textColor: primaryDark,
                                            )),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      width: double.infinity,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: ColoredText("مجموع مدت زمان تدریس شما : "),
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
                      child: Align(
                        alignment: Alignment.topRight,
                        child: ColoredText(
                          "کمیسیون کلاس های شما : ${controller.getPercentage()} درصد ",
                          textSize: 12.5,
                          textColor: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  divider(),
                  Expanded(
                    flex: 0,
                    child: inputText(
                        "قیمت کلاس آزمایشی", controller.testClassPrice,
                        keyboardType: TextInputType.number, onChange: (value) {
                      controller.onTestPriceChange(value);
                    }, inputFormatters: [
                      CurrencyTextInputFormatter(decimalDigits: 0)
                    ], priceUnit: "تومان", textDirection: TextDirection.ltr),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      child: Obx(() => infoBox(
                          "جلسه آزمایشی   -   ${formatPrice(controller.testClassPriceString.value,count: 1)}")),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    flex: 0,
                    child: inputText(
                      "قیمت هر ساعت برای 1 جلسه",
                      controller.normal1ClassPrice,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(decimalDigits: 0)
                      ],
                      textDirection: TextDirection.ltr,
                      onChange: (value) {
                        controller.onNormalPriceChange(value,1);
                      },
                      priceUnit: "تومان",
                    ),
                  ),
                  Obx(() => Container(margin: EdgeInsets.symmetric(horizontal: 18),child: infoBox(
                      "1 جلسه یک ساعتی  -  ${formatPrice(controller.normal1ClassPriceString.value.replaceAll(",", ""),count: 1)}"),)),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    flex: 0,
                    child: inputText(
                      "قیمت هر ساعت برای 3 جلسه",
                      controller.normal3ClassPrice,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(decimalDigits: 0)
                      ],
                      textDirection: TextDirection.ltr,
                      onChange: (value) {
                        controller.onNormalPriceChange(value,3);
                      },
                      priceUnit: "تومان",
                    ),
                  ),
                  Obx(() => Container(margin: EdgeInsets.symmetric(horizontal: 18),child: infoBox(
                      "3 جلسه یک ساعتی  -  ${formatPrice(controller.normal3ClassPriceString.value.replaceAll(",", ""),count: 3)}"),)),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    flex: 0,
                    child: inputText(
                      "قیمت هر ساعت برای 5 جلسه",
                      controller.normal5ClassPrice,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(decimalDigits: 0)
                      ],
                      textDirection: TextDirection.ltr,
                      onChange: (value) {
                        controller.onNormalPriceChange(value,5);
                      },
                      priceUnit: "تومان",
                    ),
                  ),
                  Obx(() => Container(margin: EdgeInsets.symmetric(horizontal: 18),child: infoBox(
                      "5 جلسه یک ساعتی  -  ${formatPrice(controller.normal5ClassPriceString.value.replaceAll(",", ""),count: 5)}"),)),
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    flex: 0,
                    child: inputText(
                      "قیمت هر ساعت برای 10 جلسه",
                      controller.normal10ClassPrice,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        CurrencyTextInputFormatter(decimalDigits: 0)
                      ],
                      textDirection: TextDirection.ltr,
                      onChange: (value) {
                        controller.onNormalPriceChange(value,10);
                      },
                      priceUnit: "تومان",
                    ),
                  ),
                  Obx(() => Container(margin: EdgeInsets.symmetric(horizontal: 18),child: infoBox(
                      "10 جلسه یک ساعتی  -  ${formatPrice(controller.normal10ClassPriceString.value.replaceAll(",", "") , count: 10)}"),)),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
                      width: double.infinity,
                      child: Center(
                        child: ColoredButton(
                          "ثبت قیمت های کلاسی",
                          onTap: () {
                            controller.submitPrice();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class CreateClassTimingScreen extends StatelessWidget {
  CustomDatePickerController dateController = Get.put(CustomDatePickerController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ColoredAppBar(),
      body: Column(
        children: [
          Expanded(flex:1,child: CustomDatePicker(controller: dateController),),
        ],
      ),
    );
  }
}
