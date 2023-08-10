import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:zabaner/controllers/support_controller.dart';
import 'package:zabaner/models/support_tickets.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/conversation_screen.dart';
import 'package:zabaner/views/screens/create_ticket_screen.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class TicketScreenUserTeacher extends StatefulWidget {
  String isFromTeacher;
  final SupportController _controller = Get.put(SupportController());

  TicketScreenUserTeacher({required this.isFromTeacher,Key? key}) : super(key: key);

  @override
  _TicketScreenUserTeacherState createState() =>
      _TicketScreenUserTeacherState();
}

class _TicketScreenUserTeacherState extends State<TicketScreenUserTeacher> {
  final GetConnect _getConnect = GetConnect();
  final GetStorage _getStorage = GetStorage();
  List<SupportTickets> tickets = [];
  RxBool isDataLoaded = false.obs;
  void getInfo() async{
    isDataLoaded.value = false;
    var bodyRequest1 = {
      "mobile": userPhoneNumber,
      "type": widget.isFromTeacher,
    };
    var request = await _getConnect.post(getTicketsList,bodyRequest1);
    tickets = ticketsListModelFromJson(request.bodyString ?? "").reversed.toList();
    isDataLoaded.value = true;
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ColoredAppBar(),
      body: Column(children: [
        SizedBox(
          height: 18,
        ),
        Expanded(flex: 1,child: Container(height: double.infinity,child: Obx(()=>isDataLoaded.value ? tickets.isEmpty ? NoData() : ListView.builder(itemCount:tickets.length,shrinkWrap: true,itemBuilder: (context, index) {
          var item = tickets[index];
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
                                          maxLines: 1,
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
        }) : Center(child: CircularProgressIndicator(),) ),),),
        Expanded(
          flex: 0,
          child: InkWell(
            onTap: () {
              Get.to(() => CreateTicketScreen(type: widget.isFromTeacher,onDone: (){
                getInfo();
              },));
            },
            child: Container(
              width: double.infinity,
              height: 50,
              margin: const EdgeInsets.only(right: 18, left: 18, top: 18),
              decoration: BoxDecoration(
                  color: primaryDark, borderRadius: BorderRadius.circular(8)),
              child: Center(
                child: ColoredText(
                  "ارسال پیام جدید",
                  textSize: 17,
                  textColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 18,),
      ]),
    );
  }
}
