import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/support_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/conversation_screen.dart';
import 'package:zabaner/views/screens/create_ticket_screen.dart';
import 'package:zabaner/views/screens/issues_screen.dart';
import 'package:zabaner/views/widgets/message_text_widget.dart';
import 'package:zabaner/widgets/colored_text.dart';

class ProfileSupport extends StatelessWidget {
  ProfileSupport({
    Key? key,
  }) : super(key: key);
  final SupportController _controller = Get.put(SupportController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
                height: double.infinity,
                child: Obx(() => _controller.isDataLoaded.isTrue
                    ? SmartRefresher(
                        controller: _controller.refreshController1,
                        onRefresh: () {
                          _controller.getTickets();
                        },
                        header: const MaterialClassicHeader(),
                        child: Container(
                          child: _controller.tickets.length == 0
                              ? NoData(
                                  message:
                                      "شما هنوز پیامی برای پشتیبان ارسال نکرده اید!")
                              : Container(
                                  padding: EdgeInsets.only(top: 18),
                                  child: ListView.builder(
                                    shrinkWrap:false,
                                    itemCount: _controller.tickets.length,
                                    itemBuilder: (context, index) {
                                      var item = _controller.tickets[index];
                                      return InkWell(
                                        onTap: () {
                                          Get.to(() => ConversationScreen(
                                                id: item.id,
                                                title: item.title,
                                              ));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          height: 80,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 18, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.4),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 6),
                                              child: Row(
                                                children: [
                                                  Flexible(
                                                      flex: 0,
                                                      child: Container(
                                                        width: 60,
                                                        height: double.infinity,
                                                        child: Center(
                                                            child: Lottie.asset(
                                                                'assets/animations/support.json',
                                                                height: 40,
                                                                repeat: false)),
                                                      )),
                                                  Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        width: double.infinity,
                                                        height: double.infinity,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 9,
                                                                vertical: 3),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: 4,
                                                            ),
                                                            Expanded(
                                                                flex: 0,
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child:
                                                                        ColoredText(
                                                                      item.mTitle,
                                                                      textSize:
                                                                          18,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ))),
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  height: double
                                                                      .infinity,
                                                                )),
                                                            Expanded(
                                                                flex: 0,
                                                                child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child:
                                                                        ColoredText(
                                                                      item.lastUpdate,
                                                                      textDirection:
                                                                          TextDirection
                                                                              .ltr,
                                                                      textSize:
                                                                          8,
                                                                    ))),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  Flexible(
                                                      flex: 0,
                                                      child: Container(
                                                        width: 80,
                                                        height: double.infinity,
                                                        child: Center(
                                                          child: ColoredText(
                                                            item.status ==
                                                                    "waiting"
                                                                ? "در انتظار پاسخ"
                                                                : "پاسخ داده شده",
                                                            textColor: item
                                                                        .status ==
                                                                    "waiting"
                                                                ? Colors
                                                                    .deepOrangeAccent
                                                                : Colors.green,
                                                            textSize: 11,
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                        ),
                      )
                    : Center(
                        child: Loading(),
                      )))),
        Expanded(
          flex: 0,
          child: InkWell(
            onTap: () {
              Get.to(() => const CreateTicketScreen());
            },
            child: Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(right: 18, left: 18, top: 18),
              decoration: BoxDecoration(
                  color: primaryDark, borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: ColoredText(
                  "ارسال پیام",
                  textSize: 17,
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: InkWell(
            onTap: () {
              Get.to(() => const IssuesScreen());
            },
            child: Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(right: 18, left: 18, top: 8),
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: ColoredText("سوال های متداول",
                    textSize: 17, textColor: Colors.white),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 20,
        ),
        // SizedBox(
        //     height: Get.height / 3,
        //     width: Get.width,
        //     child: Obx(() => ListView.builder(
        //         itemCount: _controller.messagesList.length,
        //         itemBuilder: (context, index) => MessageWidget(
        //             text: _controller.messagesList[index].message,
        //             time:
        //                 "${_controller.messagesList[index].createdAt.hour}:${_controller.messagesList[index].createdAt.minute}",
        //             type: _controller.messagesList[index].type))))
      ],
    );
  }
}
