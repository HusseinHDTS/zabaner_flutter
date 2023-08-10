import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/controllers/custom_date_picker_controller.dart';
import 'package:zabaner/controllers/web_view_controller.dart';
import 'package:zabaner/models/profile_information_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/user_teachers.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/colored_snack.dart';

import '../views/screens/web_view_screen.dart';

class SubmitClassController extends GetxController {
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  final GetStorage _getStorage = GetStorage();
  List<DateTime> selectedDates = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    phoneController.text = userPhoneNumber;
    nameController.text = userSavedFirstName;
    familyController.text = userSavedLastName;
  }

  submitUserData(item, count,
      {bool? useInputText, String? uName, String? uFamily}) async {
    useInputText ??= true;
    String name, family;
    if (useInputText) {
      name = nameController.text;
      family = familyController.text;
    } else {
      name = uName.toString();
      family = uFamily.toString();
    }
    loadingDialog("لطفا صبر کنید");
    var _request = await _getConnect.patch(updateProfileUrl, {
      'firstName': name,
      'lastName': family,
    }, headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer ${_getStorage.read('token')}'
    });
    Get.back();
    if (_request.statusCode == 200) {
      userSavedName = "${nameController.text} ${familyController.text}";
      Get.back();
      submitData(item, count);
    } else {
      ColoredSnack(
          title: "لطفا تمامی فیلد ها را پر کنید", type: SnackType.ERROR);
    }
  }

  submitData(UserTeachers item, int count) async {
    int cpc = count;
    var generatedItemTitle = getRandomString(30);
    cpc = cpc * 2;
    if (cpc == 0) {
      cpc = 1;
    }
    CustomDatePickerController cppController = Get.find();
    if (cppController.getSelectedDates().length != cpc) {
      ColoredSnack(
          title:
              "تعداد جلسات انتخاب شده کم تر از جلسات رزرو شده است  ",
          type: SnackType.ERROR);
      return;
    }
    int price;
    if (count == 0) {
      price = int.parse(item.testClassPrice.toString().replaceAll(",", ""));
    } else if (count == 1) {
      price =
          int.parse(item.normal1ClassPrice.toString().replaceAll(",", "")) * 1;
    } else if (count == 3) {
      price =
          int.parse(item.normal3ClassPrice.toString().replaceAll(",", "")) * 3;
    } else if (count == 5) {
      price =
          int.parse(item.normal5ClassPrice.toString().replaceAll(",", "")) * 5;
    } else if (count == 10) {
      price =
          int.parse(item.normal10ClassPrice.toString().replaceAll(",", "")) *
              10;
    } else {
      price = int.parse(item.normal1ClassPrice.toString().replaceAll(",", ""));
    }
    customDialog(
        child: Column(
      children: [
        topRoundedMiniBar(title: "پرداخت", height: 50),
        Container(
          width: 180,
        ),
        SizedBox(
          height: 18,
        ),
        selectableItem(
            price: price.toString(),
            description: count == 0
                ? "جلسه آزمایشی"
                : (count.toString() + " جلسه یک ساعتی"),
            selected: true),
        SizedBox(
          height: 18,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                flex: 1,
                child: ColoredButton(
                  "بعدا پرداخت میکنم",
                  gradientBorder: true,
                  onTap: () {
                    Get.back();
                    continuePayment(
                        count: count,
                        cppController: cppController,
                        generatedItemTitle: generatedItemTitle,
                        item: item,
                        paymentStatus: "none",
                        price: price);
                  },
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  textSize: 15,
                  textColor: Colors.blue,
                  gradient: LinearGradient(colors: [
                    Colors.blue,
                    Colors.lightBlue,
                  ]),
                )),
            SizedBox(
              width: 18,
            ),
            Flexible(
                flex: 1,
                child: ColoredButton(
                  "پرداخت",
                  gradientBorder: true,
                  onTap: () {
                    if (int.parse(savedWalletInfo!.currentPrice.toString()) >
                        int.parse(
                            price.toString().replaceAll(",", ""))) {
                      loadingDialog("درحال پرداخت ...");
                      var requestBody = {
                        "type": "remove",
                        "toUserId": item.teacherId,
                        "description": " حساب برای کلاس ${item.name}  ${item.family}  / " + (count == 0
                            ? "جلسه آزمایشی"
                            : (count.toString() + " جلسه یک ساعتی")),
                        "price": "${price.toString().replaceAll(",", "")}",
                      };
                      _getConnect.post(addRemoveWallet, requestBody, headers: {
                        'accept': 'application/json',
                        'Authorization': 'Bearer ${_getStorage.read('token')}'
                      }).then((value) {
                        Get.back();
                        continuePayment(price: price,paymentStatus: "success",item:item ,generatedItemTitle: generatedItemTitle,cppController: cppController,count: count).then((value){
                          reloadApp();
                        });
                      });
                    }else{
                      Get.to(() => WebViewScreen(
                        paymentCheck,
                        bodyRequest: {
                          "amount": "${price.toString().replaceAll(",", "")}0",
                          "description": "[" +
                              " کلاس ${item.name} ${item.family} ${count == 0 ? "1" : count.toString()}   جلسه ای " +
                              "]",
                          "phone": "0",
                          "email": "husseindts@gmail.com",
                          "type": "type",
                          "timeOfSub": "timeOfSub",
                        },
                        onPaymentCallBack: (WebViewController _ctrl, url) async {
                          _ctrl.setResultReceived(true);
                          loadingDialog("درحال ثبت پرداخت ...");
                          String pStat = url.queryParameters['status'].toString();
                          String paymentState = "none";
                          if (pStat.toLowerCase() == "OK".toLowerCase()) {
                            paymentState = "success";
                          } else {
                            paymentState = "failed";
                          }
                          Get.back();
                          Get.back();
                          continuePayment(
                              count: count,
                              cppController: cppController,
                              generatedItemTitle: generatedItemTitle,
                              item: item,
                              paymentStatus: paymentState,
                              price: price).then((value){
                                reloadApp();
                          });
                        },
                      ));
                    }
                  },
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  textSize: 15,
                  textColor: Colors.green,
                  gradient: LinearGradient(colors: [
                    Colors.green,
                    Colors.lightGreen,
                  ]),
                )),
          ],
        ),
        SizedBox(
          height: 18,
        ),
      ],
    ));
  }

  Future<void> continuePayment({
    paymentStatus,
    generatedItemTitle,
    count,
    item,
    price,
    cppController,
  }) async {
    loadingDialog("لطفا صبر کنید");
    var body = {
      "title": generatedItemTitle,
      "classCount": "$count",
      "teacherId": item.userId,
      "userId": userSavedId,
      "language": "انگلیسی",
      "classPrice": formatPrice(price.toString(), showUnit: false),
      "classTimes": jsonEncode(cppController.getSelectedDates().toList()),
      "paymentState": paymentStatus,
      "classStatus": "",
      "lastUpdate": "",
      "classLink": "",
    };
    var result = await _getConnect.post(createOnlineClass, body);
    if (jsonDecode(result.bodyString ?? "")['statusCode'] != null) {
      Get.back();
      ColoredSnack(title: "خطا در ثبت اطلاعات", type: SnackType.ERROR);
    } else {
      Get.back();
      Get.back();
      ColoredSnack(title: "ثبت شد", type: SnackType.SUCCESS);
    }
  }
}
