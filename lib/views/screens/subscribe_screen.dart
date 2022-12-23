import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/controllers/subscribe_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/web_view_screen.dart';
import 'package:zabaner/views/tabs/list_model.dart';
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
    SubscribeController _controller =  Get.put(SubscribeController(typeForBuy));
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
            child: Obx(() => !_controller.isDataLoaded() ? const Center(child: CircularProgressIndicator(),): Column(
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
                                      typeOfBuyForShow, _controller)),
                              InkWell(
                                  onTap: () {
                                    _controller.setCurrentPos(1);
                                  },
                                  child: SubscribeTypeItem(
                                      1,
                                      _controller.getCurrentPos() == 1,
                                      typeOfBuyForShow, _controller)),
                              InkWell(
                                  onTap: () {
                                    _controller.setCurrentPos(2);
                                  },
                                  child: SubscribeTypeItem(
                                      2,
                                      _controller.getCurrentPos() == 2,
                                      typeOfBuyForShow , _controller)),
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
                        SizedBox(height: 10,),
                        ColoredText(_controller.getDescription(title))
                      ],
                    )),
                    Expanded(
                        flex: 0,
                        child: InkWell(
                          onTap: () {
                            Get.to(()=>WebViewScreen(paymentCheck, "", "", _controller.getDescription(title), _controller.getCurrentSelectedPrice(_controller.getCurrentPos(),isHezarToman: true),
                                typeOfBuyForShow, _controller.getCurrentPos().toString()));
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

  SubscribeTypeItem(this.pos, this.isSelected, this.typeOfBuyForShow,this.controller) ;

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
                        controller.getCurrentSelectedPrice(pos) + " هزار تومان ",
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
