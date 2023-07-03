import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/controllers/web_view_controller.dart';
import 'package:zabaner/models/price_seperator.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/models/wallet_info.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/views/screens/ticket_screen_user_teacher.dart';
import 'package:zabaner/views/screens/wallet_history_screen.dart';
import 'package:zabaner/views/screens/web_view_screen.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

import '../models/card_number_seperator.dart';

class WalletInfoWidget extends StatelessWidget {
  WalletInfo? _walletInfo;
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  final GetStorage _getStorage = GetStorage();
  TextEditingController priceController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController cardNameController = TextEditingController();

  WalletInfoWidget() {
    if (savedWalletInfo == null) {
      _walletInfo = WalletInfo(
          currentPrice: "0",
          blockPrice: "0",
          totalPrice: "0",
          lastMonthPrice: "0",
          pays: "");
    } else {
      _walletInfo = savedWalletInfo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.45),
                offset: Offset(1, 4),
                spreadRadius: 2,
                blurRadius: 28)
          ],
          gradient: LinearGradient(colors: [
            primaryLight,
            primaryLight,
            primary,
            primaryDark,
            primaryDark
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      // margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              flex: 0,
              child: ColoredAppBar(
                backgroundColor: Colors.transparent,
                actions: [
                  Container(
                      margin: EdgeInsets.only(left: 18),
                      child: ColoredButton(
                        "",
                        textSize: 12,
                        content: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ColoredText(
                              "پشتیبانی",
                              textColor: Colors.black,
                              textSize: 12,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Icon(
                              Icons.support_agent,
                              color: Colors.black,
                              size: 18,
                            ),
                          ],
                        ),
                        height: 25,
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white70,
                              Colors.white.withOpacity(0.9),
                              Colors.white
                            ]),
                        textColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        onTap: () {
                          Get.to(() => TicketScreenUserTeacher(
                                isFromTeacher: "user",
                              ));
                        },
                      ))
                ],
              )),
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: ColoredText(
                          "موجودی کل حساب شما : ",
                          textSize: 13,
                          textColor: Colors.white70,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: ColoredText(
                              formatPrice(
                                _walletInfo!.currentPrice,
                                unitText: "تومان",
                                showFreeText: false,
                              ),
                              minFontSize: 16,
                              maxFontSize: 28,
                              textSize: 28,
                              autoHeight: true,
                              textColor: Colors.white,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: SizedBox(
                        height: 22,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 100,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 8,
                              ),
                              Flexible(
                                  flex: 2,
                                  child: Container(
                                      width: double.infinity,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () {
                                              requestForWalletPay("add");
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Center(
                                                child: ColoredText(
                                                  "افزایش موجودی",
                                                  textColor: Colors.black,
                                                  textSize: 12,
                                                ),
                                              ),
                                            ),
                                          )))),
                              SizedBox(
                                width: 18,
                              ),
                              Flexible(
                                  flex: 3,
                                  child: Container(
                                      width: double.infinity,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Opacity(
                                            opacity: (int.tryParse(_walletInfo!
                                                            .currentPrice
                                                            .toString()) ??
                                                        0) >
                                                    100000
                                                ? 1
                                                : 0.4,
                                            child: GestureDetector(
                                              onTap: () {
                                                if ((int.tryParse(_walletInfo!
                                                            .currentPrice
                                                            .toString()) ??
                                                        0) >
                                                    100000) {
                                                  Get.dialog(AlertDialog(
                                                    title: ColoredText(
                                                        "درخواست دریافت وجه"),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          height: 18,
                                                        ),
                                                        inputText(
                                                            "مبلغ خود را به تومان وارد کنید",
                                                            priceController,
                                                            priceUnit: "تومان",
                                                            keyboardType: TextInputType.number,
                                                            inputFormatters: [
                                                              CurrencyTextInputFormatter(
                                                                  decimalDigits:
                                                                      0)
                                                            ]),
                                                        inputText("شماره کارت",
                                                            cardNumberController,
                                                            textDirection: TextDirection.ltr,
                                                            // error: false,
                                                            keyboardType: TextInputType.number,
                                                            textAlign: TextAlign.center,
                                                            maxLength: 16 + (CARD_NUMBER_SEPARATOR.length * 3),
                                                            inputFormatters: [
                                                              CardFormatter(
                                                                  separator:
                                                                      CARD_NUMBER_SEPARATOR)
                                                            ]),
                                                        inputText(
                                                          "نام صاحب کارت",
                                                          cardNameController,
                                                          keyboardType:
                                                              TextInputType
                                                                  .name,
                                                        ),
                                                        SizedBox(
                                                          height: 18,
                                                        ),
                                                        ColoredButton(
                                                          "پرداخت",
                                                          onTap: () {
                                                            if (priceController
                                                                    .text
                                                                    .toString()
                                                                    .trim()
                                                                    .isEmpty ||
                                                                cardNameController
                                                                    .text
                                                                    .toString()
                                                                    .trim()
                                                                    .isEmpty ||
                                                                cardNumberController
                                                                    .text
                                                                    .toString()
                                                                    .trim()
                                                                    .isEmpty) {
                                                              return;
                                                            }
                                                            if((int.tryParse(priceController.text.toString().replaceAll(",", "")) ?? 0) < 100000){
                                                              ColoredSnack(
                                                                  title:
                                                                  "حداقل موجودی برای دریافت وجه ${formatPrice("100000", unitText: "تومان")} می‌باشد ",
                                                                  type: SnackType.ERROR);
                                                              return;
                                                            // }else if((int.tryParse(priceController.text.toString().replaceAll(",", "")) ?? 0) < 100000){
                                                            //   ColoredSnack(
                                                            //       title:
                                                            //       "حداکثر موجودی برای دریافت وجه ${formatPrice("100000", unitText: "تومان")} می‌باشد ",
                                                            //       type: SnackType.ERROR);
                                                            //   return;
                                                            }
                                                            if(RegExp(r'^[a-z]+$').hasMatch(cardNameController.text)){
                                                              ColoredSnack(
                                                                  title:"لطفا نام خود را به فارسی وارد کنید",
                                                                  type: SnackType.ERROR);
                                                              return;
                                                            }
                                                            if(cardNameController.text.isNumeric){
                                                              ColoredSnack(
                                                                  title:"لطفا برای نام خود از اعداد استفاده نکنید",
                                                                  type: SnackType.ERROR);
                                                              return;
                                                            }
                                                            if(cardNumberController.text.toString().replaceAll(CARD_NUMBER_SEPARATOR, "").trim().length != 16){
                                                              ColoredSnack(
                                                                  title:"شماره کارت باید 16 رقم داشته باشد",
                                                                  type: SnackType.ERROR);
                                                              return;
                                                            }
                                                            requestForMoney();
                                                          },
                                                        ),
                                                        SizedBox(
                                                          height: 18,
                                                        ),
                                                      ],
                                                    ),
                                                  ));
                                                } else {
                                                  ColoredSnack(
                                                      title:
                                                          "حداقل موجودی برای دریافت وجه ${formatPrice("100000", unitText: "تومان")} می‌باشد ",
                                                      type: SnackType.ERROR);
                                                }
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                height: double.infinity,
                                                decoration: BoxDecoration(
                                                    color:
                                                        snackbarSuccessTransparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Center(
                                                  child: ColoredText(
                                                    "درخواست دریافت وجه",
                                                    textColor: Colors.white,
                                                    textSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )))),
                              SizedBox(
                                width: 18,
                              ),
                              Flexible(
                                  flex: 1,
                                  child: Container(
                                      width: double.infinity,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(() =>
                                                  const WalletHistoryScreen());
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                      colors: [
                                                        Colors.grey
                                                            .withOpacity(0.1),
                                                        Colors.grey
                                                            .withOpacity(0.2),
                                                        Colors.grey
                                                            .withOpacity(0.5),
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment
                                                          .bottomRight),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              child: Builder(
                                                  builder: (iconContext) {
                                                return Center(
                                                  child: SizedBox.fromSize(
                                                    child: FittedBox(
                                                      child: Icon(
                                                        Icons
                                                            .work_history_outlined,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          )))),
                              SizedBox(
                                width: 8,
                              ),
                            ],
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
            ),
          )
        ],
      ),
    );
  }

  Future<void> requestForMoney() async {
    Get.back();
    loadingDialog("لطفا صبر کنید...");
    var bodyRequest = {
      "title": getRandomString(50),
      "price": formatPrice(priceController.text.toString().replaceAll(".", "")),
      "cardNumber": cardNumberController.text,
      "cardName": cardNameController.text,
      "userId": userSavedId,
      "status": "none",
      "date": "",
    };
    var result = await _getConnect.post(addMoneyRequest, bodyRequest);
    Get.back();
    finalPay("customRemove",
        desc: "اعتبار از طریق دریافت وجه به شماره کارت : / " +
            cardNumberController.text +
            " / " +
            " به نام : / " +
            cardNameController.text +
            " / " +
            "  به مبلغ  " +
            formatPrice(priceController.text.toString().replaceAll(".", "")));
  }

  Future<void> requestForWalletPay(String type, {String desc = ""}) async {
    Get.dialog(AlertDialog(
      title:
          ColoredText(type == "add" ? "افزایش موجودی" : "درخواست دریافت وجه"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 18,
          ),
          inputText("مبلغ خود را به تومان وارد کنید", priceController,
              priceUnit: "تومان",
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyTextInputFormatter(decimalDigits: 0)]),
          SizedBox(
            height: 18,
          ),
          ColoredButton(
            "پرداخت",
            onTap: () {
              if (priceController.text.toString().trim().isEmpty) {
                return;
              }
              if (type == "remove") {
                if ((int.tryParse(priceController.text
                            .toString()
                            .replaceAll(",", "")) ??
                        0) <
                    100000) {
                  ColoredSnack(
                      title:
                          "مبلغ وارد شده باید بیشتر از ${formatPrice("100000")}باشد",
                      type: SnackType.ERROR);
                  return;
                }
              } else {
                if ((int.tryParse(priceController.text
                            .toString()
                            .replaceAll(",", "")) ??
                        0) <
                    1000) {
                  ColoredSnack(
                      title:
                          "مبلغ وارد شده باید بیشتر از ${formatPrice("1000")}باشد",
                      type: SnackType.ERROR);
                  return;
                }
              }
              finalPay(type, desc: desc);
            },
          ),
        ],
      ),
    ));
  }

  finalPay(String type, {String desc = ""}) {
    String descc = "";
    if (type == "remove") {
      descc = "اعتبار از طریق دریافت وجه";
    } else if (type == "add") {
      descc = "اعتبار از طریق درگاه پرداخت";
    } else if (type == "customRemove") {
      descc = desc;
      type = "remove";
    }
    if (type != "remove") {
      Get.back();
      Get.to(() => WebViewScreen(
            paymentCheck,
            bodyRequest: {
              "amount":
                  "${priceController.text.toString().replaceAll(",", "")}0",
              "description": "[ شارژ کیف پول ]",
              "phone": "0",
              "email": "husseindts@gmail.com",
              "type": "type",
              "timeOfSub": "timeOfSub",
            },
            onPaymentCallBack: (WebViewController _ctrl, url) async {
              _ctrl.setResultReceived(true);
              loadingDialog("درحال پرداخت");
              String pStat = url.queryParameters['status'].toString();
              String paymentState = "none";
              if (pStat.toLowerCase() == "OK".toLowerCase()) {
                paymentState = "success";

                var requestBody = {
                  "type": type,
                  "description": descc,
                  "price":
                      (priceController.text).toString().replaceAll(",", ""),
                };
                _getConnect.post(addRemoveWallet, requestBody, headers: {
                  'accept': 'application/json',
                  'Authorization': 'Bearer ${_getStorage.read('token')}'
                }).then((value) async {
                  Get.back();
                  reloadApp();
                });
              } else {
                paymentState = "failed";
                Get.back();
                ColoredSnack(title: "پرداخت انجام نشد!", type: SnackType.ERROR);
              }
            },
          ));
    } else {
      Get.back();
      loadingDialog("درحال ثبت ...");

      var requestBody = {
        "type": type,
        "description": descc,
        "price": (priceController.text).toString().replaceAll(",", ""),
      };
      _getConnect.post(addRemoveWallet, requestBody, headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${_getStorage.read('token')}'
      }).then((value) async {
        reloadApp();
      });
    }
  }
}
