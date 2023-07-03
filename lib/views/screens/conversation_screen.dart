import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_3.dart';
import 'package:get/get.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';
import 'package:lottie/lottie.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:zabaner/controllers/conversation_controller.dart';
import 'package:zabaner/controllers/support_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/full_screen_image.dart';
import 'package:zabaner/views/widgets/serach_text_input.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'dart:math' as math;

import 'package:zabaner/widgets/my_app_bar.dart';

class ConversationScreen extends StatefulWidget {
  String id, title;

  ConversationScreen({Key? key, required this.title, required this.id})
      : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen>
    with TickerProviderStateMixin {
  final ConversationController _controller = Get.put(ConversationController());
  final SupportController _sController = Get.find();
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _controller.dispose();
    _sController.getTickets();
    super.dispose();
  }

  //@keyframes rotating { from { transform: rotate(0deg); } to { transform: rotate(360deg); }} .cover-art { animation: rotating 2s linear infinite; clip-path: circle(50% at 50% 50%);}

  @override
  Widget build(BuildContext context) {
    _controller.getData(widget.title);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white.withOpacity(0.75),
        appBar: ColoredAppBar(),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Stack(children: [
            ShakeWidget(
              duration: Duration(milliseconds: 20000),
              deltaX: 0.5,
              curve: Curves.linear,
              child: SizedBox(width: Get.width,height: Get.height,child: Image.asset(
                "assets/images/user_teacher_pattern.png",
                repeat: ImageRepeat.repeatX,
                color: Colors.white.withOpacity(0.8),
              ),),
            ),
            FooterLayout(
              footer: KeyboardAttachable(
                child: Container(
                  height: 50,
                  color: Colors.transparent,
                  margin: EdgeInsets.only(
                      right: 10, left: 10, bottom: 14, top: 8),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Flexible(
                              flex: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: primaryDark),
                                width: 50,
                                height: double.infinity,
                                child: Material(
                                  color: primaryDark,
                                  shape: const CircleBorder(),
                                  child: InkWell(
                                    customBorder: const CircleBorder(),
                                    onTap: () {
                                      _controller.sendMessage(
                                          widget.title, widget.id);
                                      _animationController.forward();
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(4),
                                      child: Transform.rotate(
                                        angle: math.pi / 4,
                                        child: Lottie.asset(
                                          'assets/animations/send_message2.json',
                                          width: double.infinity,
                                          height: double.infinity,
                                          repeat: false,
                                          controller: _animationController,
                                          onLoaded: (composition) {
                                            _animationController.duration =
                                                composition.duration;
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
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                    decoration: BoxDecoration(
                                        color: Color(0xffe6e6e9),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Container(
                                      margin: EdgeInsets.only(left: 50),
                                      child: MessageTextInput(
                                        textController:
                                        _controller.textController,
                                        focus: _controller.focus,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                        onTap: () {
                                          _controller.getImage(
                                              widget.title, widget.id);
                                        },
                                        child: const SizedBox(
                                          height: double.infinity,
                                          width: 50,
                                          child: Icon(
                                            Icons.attach_file_outlined,
                                            color: Colors.black,
                                          ),
                                        )),
                                  ),
                                ],
                              )),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              child: Obx(() => _controller.isDataLoaded.isTrue
                  ? ListView.builder(
                  itemCount: _controller.conversations.length + 1,
                  shrinkWrap: true,
                  controller: _controller.scrollController,
                  itemBuilder: (context, index) {
                    var colorReceive = supportMessageColor;
                    var colorSend = Color(0xffe6e6e9);
                    int indexForPosh = 1;
                    if (_controller.conversations.length > 1) {
                      if (_controller.conversations[1].description
                          .toString()
                          .trim()
                          .isEmpty) {
                        indexForPosh = 2;
                      } else {
                        indexForPosh = 1;
                      }
                    }

                    if (indexForPosh == index) {
                      String poshtibani =
                          "با سلام \nپیام شما دریافت شد. در کمتر از 24 ساعت پاسخ شما از طرف پشتیبان ارسال خواهد شد.";
                      return AutoScrollTag(
                        key: ValueKey(index),
                        controller: _controller.scrollController,
                        index: index,
                        child: chatText(
                            poshtibani,
                            "",
                            index,
                            _controller.conversations[0].createAt,
                            BubbleType.receiverBubble,
                            colorReceive,
                            Colors.white,
                            "answer"),
                      );
                    }

                    var ind;
                    if (indexForPosh == 1) {
                      if (index == 0) {
                        ind = 0;
                      } else {
                        ind = index - 1;
                      }
                    } else if (indexForPosh == 2) {
                      if (index == 0) {
                        ind = 0;
                      } else if (index == 1) {
                        ind = 1;
                      } else {
                        ind = index - 1;
                      }
                    }

                    var item = _controller.conversations[ind];
                    var widg = chatText(
                      item.description,
                      item.image,
                      ind,
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
                      item.type,
                    );
                    if (ind == _controller.conversations.length - 1) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widg,
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    }
                    return widg;
                  })
                  : Center(
                child: Loading(),
              )),
            ),

          ],),
        ),
      ),
    );
  }

  chatText(text, image, index, createAt, type, backC, textC, iType) {
    var align, smallColor, fromStr = "";

    if (type == BubbleType.sendBubble) {
      align = Alignment.topRight;
      smallColor = primary;
      fromStr = "ارسال شده";
    } else {
      smallColor = Colors.white;
      fromStr = "پشتیبان";
    }
    return AutoScrollTag(
      key: ValueKey(index),
      controller: _controller.scrollController,
      index: index,
      child: Container(
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
                    text.toString().trim().isNotEmpty
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: ColoredText(
                              text.toString().replaceAll("<br/>", "\n"),
                              textColor: textC,
                              textAlign: TextAlign.right,
                            ),
                          )
                        : Center(
                            child: InkWell(
                              onTap: () {
                                Get.to(() =>
                                    FullScreenImage(image: image.toString()));
                              },
                              child: Image.network(
                                image.toString(),
                                height: 80,
                                // loadingBuilder: (_context, widget, event) {
                                //   if(event.)
                                // },
                              ),
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
                                  textDirection: TextDirection.ltr,
                                  textColor: smallColor,
                                  textAlign: TextAlign.right,
                                ))),
                        Flexible(
                            flex: 1,
                            child: Container(
                                width: double.infinity,
                                child: iType == "loading"
                                    ? Align(
                                        alignment: Alignment.centerLeft,
                                        child: Lottie.asset(
                                            'assets/animations/loading.json',
                                            height: 30))
                                    : ColoredText(fromStr,
                                        textSize: 10,
                                        textColor: smallColor,
                                        textAlign: TextAlign.left))),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
