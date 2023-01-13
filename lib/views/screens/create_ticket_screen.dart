import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/controllers/create_ticket_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/widgets/serach_text_input.dart';
import 'package:zabaner/widgets/colored_text.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({Key? key}) : super(key: key);

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreen();
}

class _CreateTicketScreen extends State<CreateTicketScreen> {
  final CreateTicketController _controller = Get.put(CreateTicketController());

  @override
  Widget build(BuildContext context) {
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
          body: Column(
            children: [
              Center(
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ColoredText(
                      "ارسال پیام",
                      textSize: 22,
                    )),
              ),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8)),
                  child: TicketTextInput(
                    textController: _controller.titleController,
                    lines: 1,
                    hint: "عنوان پیام خود را وارد کنید ...",
                  )),
              const SizedBox(
                height: 12,
              ),
              Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(8)),
                  child: TicketTextInput(
                    textController: _controller.descriptionController,
                    lines: 12,
                    hint: "توضیحات پیام خود را وارد کنید ...",
                  )),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 0,
                child: SizedBox(
                  height: 150,
                  child: InkWell(
                    onTap: () {
                      _controller.getImage();
                    },
                    child: Obx(()=>_controller.hasError.isTrue ? Container(): _controller.image == null
                        ? Column(
                            children: [
                              const Icon(
                                Icons.cloud_upload_outlined,
                                size: 80,
                                color: orangeDark,
                              ),
                              ColoredText(
                                "برای اپلود عکس کلیک کنید",
                                textColor: orangeDark,
                              ),
                              ColoredText(
                                "محدودیت حجم : 4 مگابایت",
                                textColor: Colors.deepOrange,
                                textSize: 10,
                                textDirection: TextDirection.ltr,
                              )
                            ],
                          )
                        : _controller.imageChanged.isTrue ? FutureBuilder<ImageProvider>(
                        future:
                        _controller.xFileToImage(_controller.image!),
                        builder: (ctx, item) {
                          return Image(
                            image: item.data!,
                          );
                        }) : Container(child: Center(child: Loading(),),)),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    height: double.infinity,
                  )),
              Expanded(
                  flex: 0,
                  child: InkWell(
                    onTap: () {
                      _controller.submitTicket();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                          color: orangeDark,
                          borderRadius: BorderRadius.circular(8)),
                      child: Center(
                        child: ColoredText(
                          "ثبت پیام",
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
