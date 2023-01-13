import 'package:flutter/material.dart';
import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/controllers/subscribe_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/home_screen.dart';
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/views/screens/splash_screen.dart';
import 'package:zabaner/views/screens/web_view_screen.dart';
import 'package:zabaner/views/tabs/list_model.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';

class SubscribeScreen extends StatefulWidget {
  TabbarTypes typeForBuy;

  SubscribeScreen(this.typeForBuy);

  @override
  State<StatefulWidget> createState() {
    return _SubscribeScreen(typeForBuy);
  }
}

class _SubscribeScreen extends State<SubscribeScreen> {
  TabbarTypes typeForBuy;
  String typeOfBuyForShow = "";

  _SubscribeScreen(this.typeForBuy);

  @override
  Widget build(BuildContext context) {
    SubscribeController _controller = Get.put(SubscribeController(typeForBuy));
    final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
    final GetStorage _getStorage = GetStorage();

    String title = "";
    if (typeForBuy == TabbarTypes.CHILD) {
      typeOfBuyForShow = "کودکان";
    } else if (typeForBuy == TabbarTypes.ADULT) {
      typeOfBuyForShow = "بزرگسالان";
    } else if (typeForBuy == TabbarTypes.NATIONAL) {
      typeOfBuyForShow = "آزمون ها";
    }
    title = "اشتراک " + typeOfBuyForShow;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: AppBar(
              leadingWidth: Get.width,
              backgroundColor: const Color(0xffEBB632),
              elevation: 0,
              title: ColoredText(
                title.toString(),
                textColor: Colors.white,
              ),
              leading: Padding(
                padding: EdgeInsets.only(right: Get.width / 40),
                child: InkWell(
                  onTap: () => Get.back(),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        "بازگشت",
                        style:
                            TextStyle(fontFamily: "Yekan", color: Colors.white),
                      ),
                    ],
                  ),
                ),
              )),
          body: SafeArea(
            child: Obx(() => !_controller.isDataLoaded()
                ? Center(
                    child: Loading(),
                  )
                : Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                            child: Column(
                              children: [
                                InkWell(
                                    onTap: () {
                                      _controller.setCurrentPos(0);
                                    },
                                    child: SubscribeTypeItem(
                                        0,
                                        _controller.getCurrentPos() == 0,
                                        typeOfBuyForShow,
                                        _controller)),
                                InkWell(
                                    onTap: () {
                                      _controller.setCurrentPos(1);
                                    },
                                    child: SubscribeTypeItem(
                                        1,
                                        _controller.getCurrentPos() == 1,
                                        typeOfBuyForShow,
                                        _controller)),
                                InkWell(
                                    onTap: () {
                                      _controller.setCurrentPos(2);
                                    },
                                    child: SubscribeTypeItem(
                                        2,
                                        _controller.getCurrentPos() == 2,
                                        typeOfBuyForShow,
                                        _controller)),
                              ],
                            ),
                          )),
                      Expanded(
                          child: Column(
                        children: [
                          Container(
                            child: const Icon(
                              Icons.lock_open_rounded,
                              color: Color(0xffc2ddc0),
                              size: 150,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ColoredText(_controller.getDescription(title))
                        ],
                      )),
                      Expanded(
                          flex: 0,
                          child: InkWell(
                            onTap: () async {
                              if (BUILD_MODE == "BAZAAR") {
                                var bazaarRes = await _controller.bazaarPay(typeForBuy);
                                String status = "NOK";
                                if (bazaarRes != null) {
                                  status = "OK";
                                }
                                var bodyRequest = {};
                                loadingDialog("لطفا صبر کنید");
                                var result = await _getConnect
                                    .post(getUserId, bodyRequest, headers: {
                                  'accept': 'application/json',
                                  'Authorization':
                                      'Bearer ${_getStorage.read('token')}'
                                });
                                var res = await _getConnect.get(
                                    "$paymentResultSubmit?type=$typeOfBuyForShow&timeOfSub=${_controller.getCurrentSelectedMonthInt(_controller.getCurrentPos())}&cmFrom=flutter&amount=1&Status=$status&description=${_controller.getDescription(title)}&user_id=${result.bodyString.toString().replaceAll("\"", "")}");
                                String subscribe = "";
                                if (typeForBuy == TabbarTypes.CHILD) {
                                  subscribe = "hasChildSub";
                                } else if (typeForBuy == TabbarTypes.ADULT) {
                                  subscribe = "hasAdultSub";
                                } else if (typeForBuy == TabbarTypes.NATIONAL) {
                                  subscribe = "hasNationalSub";
                                }
                                var bodyRequest1 = {
                                  subscribe: "on",
                                  "lastSeenAt": "",
                                  "timeOfSub": _controller.getCurrentSelectedMonthInt(_controller.getCurrentPos()).toString(),
                                };
                                if(status == "OK"){
                                var _res = await _getConnect.post(
                                    updateSubscribeProfile, bodyRequest1,
                                    headers: {
                                      'accept': 'application/json',
                                      'Authorization':
                                      'Bearer ${_getStorage.read('token')}'
                                    });
                                }
                                Get.back();
                                if(status == "OK"){
                                  ColoredSnack(title: "پرداخت انجام شد!",type: SnackType.SUCCESS);
                                  Get.offAll(() => LoginScreen());
                                }else{
                                  ColoredSnack(title: "پرداخت انجام نشد!",type: SnackType.ERROR);
                                }
                              } else {
                                Get.to(() => WebViewScreen(
                                    paymentCheck,
                                    "",
                                    "",
                                    _controller.getDescription(title),
                                    _controller.getCurrentSelectedPrice(
                                        _controller.getCurrentPos(),
                                        isHezarToman: true),
                                    typeOfBuyForShow,
                                    _controller.getCurrentPos().toString()));
                              }

                              // _controller.setupSubscribe(typeForBuy);
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(8),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8)),
                                child: ColoredText(
                                  "خرید اشتراک",
                                  textColor: Colors.white,
                                ),
                              ),
                            ),
                          ))
                    ],
                  )),
          ),
        ));
  }
}

class SubscribeTypeItem extends StatelessWidget {
  int pos;
  bool isSelected;
  SubscribeController controller;
  String typeOfBuyForShow = "";

  SubscribeTypeItem(
      this.pos, this.isSelected, this.typeOfBuyForShow, this.controller);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isSelected ? Color(0xD2AFFFAB) : Color(0xffF9F9F9),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Container(
                    width: double.infinity,
                    child: ColoredText(controller.getCurrentSelectedMonth(pos)),
                  )),
              Flexible(
                  flex: 0,
                  child: Column(
                    children: [
                      ColoredText(
                        typeOfBuyForShow.toString(),
                        textSize: 10,
                        textColor: Colors.black54,
                      ),
                      ColoredText(
                        controller.getCurrentSelectedPrice(pos) +
                            " هزار تومان ",
                        textColor: orangeDark,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
