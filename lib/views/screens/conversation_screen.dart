import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:zabaner/controllers/conversation_controller.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'dart:math' as math;

class ConversationScreen extends StatefulWidget {
  String id, title;

  ConversationScreen({Key? key, required this.title, required this.id})
      : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> with TickerProviderStateMixin  {
  final ConversationController _controller = Get.put(ConversationController());
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.getData(widget.title);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            leadingWidth: Get.width,
            backgroundColor: orange,
            elevation: 0,
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
        backgroundColor: const Color(0xffffffff),
        // resizeToAvoidBottomInset: false,
        body: Container(
          child: Container(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: double.infinity,
                    child: Obx(() => _controller.isDataLoaded.isTrue
                        ? ListView.builder(
                            itemCount: _controller.conversations.length + 1,
                            itemBuilder: (context, index) {
                              var colorReceive = orangeMessage;
                              var colorSend = Color(0xffE7E7ED);

                              if (index == 1) {
                                return chatText(
                                    "با سلام. پیام شما دریافت شد و ظرف 24 ساعت آینده پاسخگو خواهیم بود.",
                                    _controller.conversations[0].createAt,
                                    BubbleType.receiverBubble,
                                    colorReceive,
                                    Colors.white);
                              }
                              var ind;
                              if (index == 0) {
                                ind = 0;
                              } else {
                                ind = index - 1;
                              }

                              var item = _controller.conversations[ind];

                              return chatText(
                                item.description,
                                item.createAt,
                                item.type == "answer"
                                    ? BubbleType.receiverBubble
                                    : BubbleType.sendBubble,
                                item.type == "answer"
                                    ? colorReceive
                                    : colorSend,
                                item.type == "answer"
                                    ? Colors.white
                                    : Colors.black,
                              );
                            })
                        : const Center(
                            child: CircularProgressIndicator(),
                          )),
                  ),
                ),
                // Opacity(opacity:0.5,child: Container(width: double.infinity,height: 1,decoration: BoxDecoration(color: Colors.black12),)),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 0,
                            child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle,color: orangeDark),
                              width: 50,
                              height: double.infinity,
                              child: Material(
                                color: orangeDark,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: (){
                                    _animationController.forward();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(4),
                                    child: Transform.rotate(
                                      angle: math.pi / 4,
                                      child: Lottie.asset('assets/animations/send_message2.json',width: double.infinity,height: double.infinity,repeat: false,controller: _animationController,onLoaded: (composition){
                                        _animationController.duration = composition.duration;
                                      },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            flex: 1,
                            child: Container(
                                width: double.infinity,
                                height: double.infinity,
                                decoration: BoxDecoration(color: Colors.grey))),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  chatText(text, createAt, type, backC, textC) {
    var align, smallColor, fromStr = "";

    if (type == BubbleType.sendBubble) {
      align = Alignment.topRight;
      smallColor = orange;
    } else {
      smallColor = Colors.white;
      fromStr = "پشتیبان";
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 14),
      child: ChatBubble(
        backGroundColor: backC,
        alignment: align,
        margin: EdgeInsets.only(top: 20),
        clipper: ChatBubbleClipper3(type: type),
        child: Container(
            constraints: BoxConstraints(maxWidth: Get.width * 0.7),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: ColoredText(
                      text,
                      textColor: textC,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Container(
                              width: double.infinity,
                              child: ColoredText(
                                createAt,
                                textSize: 10,
                                textColor: smallColor,
                                textAlign: TextAlign.right,
                              ))),
                      Flexible(
                          flex: 1,
                          child: Container(
                              width: double.infinity,
                              child: ColoredText(fromStr,
                                  textSize: 10,
                                  textColor: smallColor,
                                  textAlign: TextAlign.left))),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
