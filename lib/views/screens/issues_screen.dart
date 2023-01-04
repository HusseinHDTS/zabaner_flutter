import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/controllers/issue_controller.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_text.dart';

class IssuesScreen extends StatefulWidget {
  const IssuesScreen({Key? key}) : super(key: key);

  @override
  State<IssuesScreen> createState() => _IssuesScreen();
}

class _IssuesScreen extends State<IssuesScreen> {
  final IssueController _controller = Get.put(IssueController());

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
                    margin: EdgeInsets.symmetric(vertical: 12),
                    child: ColoredText(
                      "سوالات متداول",
                      textSize: 22,
                    )),
              ),
              Expanded(
                  flex: 1,
                  child: Obx(() => _controller.isDataLoaded.isTrue
                      ? ListView.builder(
                          itemCount: _controller.issues.length,
                          itemBuilder: (ctx, index) {
                            var item = _controller.issues[index];
                            var isShowingContent = false.obs;
                            return InkWell(
                              onTap: () {
                                isShowingContent.toggle();
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              overlayColor: null,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 45, vertical: 18),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: orangeMessage,
                                    ),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 12),
                                  child: Obx(() => Stack(
                                    children: [
                                      Row(
                                            children: [
                                              Flexible(
                                                flex:1,
                                                child: Container(
                                                  width: double.infinity,
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      ColoredText(
                                                        isShowingContent.isTrue
                                                            ? item.description
                                                            : item.title,
                                                        textAlign: TextAlign.right,
                                                      ),
                                                      isShowingContent.isTrue
                                                          ? Container()
                                                          : ColoredText(
                                                              item.description,
                                                              maxLines: 1,
                                                              textColor: Colors.grey,
                                                            ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(flex:0,child: Container(width: 20,child: Container(),))
                                            ],
                                          ),
                                      Align(alignment:Alignment.topLeft,child: Icon(isShowingContent.isTrue? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,color: orangeDark,),),
                                    ],
                                  )),
                                ),
                              ),
                            );
                          },
                        )
                      : const SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ))),
            ],
          ),
        ));
  }
}
