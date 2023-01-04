import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:zabaner/controllers/book_detail_controller.dart';
import 'package:zabaner/models/level.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/widgets/text_highlight.dart';

class BookScreen extends StatefulWidget {
  BookScreen(
      {Key? key,
      required this.isGuest,
      required this.bookId,
      required this.chapterTitle,
      required this.imageLink,
      required this.itemId})
      : super(key: key);
  final String bookId, itemId, imageLink, chapterTitle;
  final bool isGuest;

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  String? _imageLink, _chapterTitle;
  final BookController controller = Get.put(BookController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageLink = widget.imageLink;
    _chapterTitle = widget.chapterTitle;
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final GetStorage _getStotage = GetStorage();
    var screenSize = MediaQuery.of(context).size;

    GetStorage.init();
    controller.customeInit(widget.bookId,widget.itemId,widget.isGuest);
    return controller.obx(
      (status) => Obx(()=> controller.errorData.isTrue ? ErrorLoading() : Directionality(
        textDirection: TextDirection.rtl,
        child: WillPopScope(
          onWillPop: () async {
            controller.onClose();
            return true;
          },
          child: Scaffold(
              appBar: AppBar(
                  leading: InkWell(
                      onTap: () {
                        controller.onClose();
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back)),
                  backgroundColor: orange,
                  actions: [
                    // Obx(() => controller.downloadingState.value == "downloading"
                    //     ? CircleAvatar(
                    //         backgroundColor: Colors.transparent,
                    //         child: CircularProgressIndicator(
                    //           value: controller.downloadingPercent.value,
                    //           strokeWidth: 2,
                    //         ),
                    //       )
                    //     : SizedBox()),
                    InkWell(
                      onTap: () => controller.autoScroll.toggle(),
                      child: Obx(() => Container(
                        margin:
                        EdgeInsets.symmetric(vertical: Get.height / 60),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: controller.autoScroll.value
                                ? Colors.blue
                                : Colors.red
                          // border: Border.all(
                          // color: controller.autoScroll.value
                          //     ? Colors.black
                          //     : Colors.grey,
                          // width: 0.6)
                        ),
                        child: Row(children: const [
                          Icon(Icons.arrow_drop_down_sharp,
                              color: Colors.black),
                          Icon(Icons.arrow_drop_up_sharp,
                              color: Colors.black),
                        ]),
                      )),
                    ),
                    Row(
                      children: [
                        const Text("   انگلیسی:",
                            style:
                            TextStyle(fontFamily: "Yekan", fontSize: 16)),
                        Obx(() => Switch(
                          value: controller.en.value,
                          onChanged: (value) {
                            controller.en.value = value;
                          },
                        ))
                      ],
                    ),
                    Row(
                      children: [
                        const Text(" فارسی:",
                            style:
                            TextStyle(fontFamily: "Yekan", fontSize: 16)),
                        Obx(() => Switch(
                          value: controller.fa.value,
                          onChanged: (value) {
                            controller.fa.value = value;
                          },
                        ))
                      ],
                    )
                  ]),
              body: Stack(
                children: [
                  Column(children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                        child: SingleChildScrollView(
                          controller: controller.scrollController,
                          child: Obx(()=> controller.isSubtitleLoaded.isFalse ? Center(child: Container(margin:EdgeInsets.only(top: 20),child: CircularProgressIndicator()),) : Column(children: List.generate(controller.getParAsLang(null).length+1, (index){
                            Widget returnWidget = index == 0
                                ? Column(
                              children: [
                                SizedBox(
                                  child: Text("\n"),
                                ),
                                Container(
                                    width: 300,
                                    height: 250,
                                    child: Image.network(
                                      _imageLink.toString(),
                                    )),
                                SizedBox(
                                    width: Get.width,
                                    child: Text(
                                      "\n" +
                                          _chapterTitle
                                              .toString(),
                                      style: const TextStyle(
                                          fontFamily: "Yekan",
                                          fontSize: 22),
                                      textAlign:
                                      TextAlign.center,
                                    )),
                              ],
                            )
                                : Container(
                              child: Obx(() =>
                              controller.fa.value == true ||
                                  controller.en.value == true
                                  ? Column(
                                children: [
                                  controller.en.value == true
                                      ? Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: FutureBuilder<List<InlineSpan>>(
                                      future: controller.getCurrentText(index -1, false),
                                      builder: (_context , item){
                                        return Container(
                                            child: RichText(
                                              text: TextSpan(
                                                style: getSubDefault(false),
                                                children:item.data,
                                              ),
                                            ));
                                      },),
                                  )
                                      : Container(),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  controller.fa.value == true
                                      ? Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: FutureBuilder<List<InlineSpan>>(
                                      future: controller.getCurrentText(index -1, true),
                                      builder: (_context , item){
                                        return Container(
                                            child: RichText(
                                              text: TextSpan(
                                                style: getSubDefault(true),
                                                children:item.data,
                                              ),
                                            ));
                                      },),
                                  )
                                      : Container(),
                                  SizedBox(
                                    height: 24,
                                  ),
                                ],
                              )
                                  : Container()),
                            );
                            return returnWidget;
                          }) ) ),
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 0,
                      child: Obx(() => AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: controller.isHide.value
                              ? Get.height / 9 / 1.5
                              : Get.height / 9,
                          child: Column(children: [
                            // hide or show icon
                            SizedBox(
                              height: Get.height / 30,
                              child: InkWell(
                                onTap: () => controller.isHide.toggle(),
                                child: Image.asset(
                                  controller.isHide.value
                                      ? "assets/images/upward2.png"
                                      : "assets/images/downward2.png",
                                  height: double.infinity,
                                ),
                              ),
                            ),

                            // seekbar
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Expanded(
                                  flex: controller.isHide.value ? 1 : 1,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Obx(() => Text(
                                          (controller.duration.value.inSeconds -
                                              controller.playerPosition.value
                                                  .inSeconds)
                                              .formatTimer())),
                                      SizedBox(
                                          width: Get.width / 1.3,
                                          child: Obx(() => Slider(
                                            value: controller.playerPosition
                                                .value.inMilliseconds
                                                .toDouble(),
                                            min: 0,
                                            max: controller
                                                .duration.value.inMilliseconds
                                                .toDouble(),
                                            onChanged: (value) {
                                              controller
                                                  .playerPosition.value =
                                                  Duration(
                                                      milliseconds:
                                                      value.toInt());
                                            },
                                            onChangeEnd: (value) {
                                              controller.player.seekToPlayer(
                                                  Duration(
                                                      milliseconds:
                                                      value.toInt()));
                                            },
                                          ))),
                                      Text(controller.duration.value.inSeconds
                                          .formatTimer())
                                    ],
                                  )),
                            ),

                            // controll option buttons
                            controller.isHide.value
                                ? const SizedBox()
                                : Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: [
                                  // play speed
                                  InkWell(
                                      onTap: () {
                                        if (controller.isPlaying.value) {
                                          if (controller.playSpeed.value ==
                                              0.5) {
                                            controller.playSpeed.value = 1;
                                            controller.player.setSpeed(1);
                                          } else if (controller
                                              .playSpeed.value ==
                                              1) {
                                            controller.playSpeed.value = 2;
                                            controller.player.setSpeed(2);
                                          } else if (controller
                                              .playSpeed.value ==
                                              2) {
                                            controller.playSpeed.value =
                                            0.5;
                                            controller.player.setSpeed(0.5);
                                          }
                                        }
                                      },
                                      child: Obx(() => Text(
                                        controller.playSpeed.value
                                            .toString() +
                                            "x",
                                        style: const TextStyle(
                                            fontSize: 18),
                                      ))),

                                  // forward
                                  InkWell(
                                      onTap: () {
                                        if (controller.ind !=
                                            controller.bookItemModel
                                                .paragraphs.length -
                                                1) {
                                          controller.player.seekToPlayer(
                                              Duration(
                                                  milliseconds: controller
                                                      .bookItemModel
                                                      .paragraphs[
                                                  controller.ind +
                                                      1]
                                                      .pst));
                                        }
                                      },
                                      child: const Icon(Icons.arrow_back)),

                                  // play or pause
                                  Obx(() => InkWell(
                                      onTap: () {
                                        controller.togglePlayer(getUrlFileName(controller.appDoc.path,widget.itemId,controller.bookItemModel.podcastPath));
                                      },
                                      child: Icon(controller.isPlaying.value
                                          ? Icons.pause
                                          : Icons.play_arrow))),

                                  // backward
                                  InkWell(
                                      onTap: () {
                                        if (controller.ind != 0) {
                                          controller.player.seekToPlayer(
                                              Duration(
                                                  milliseconds: controller
                                                      .bookItemModel
                                                      .paragraphs[
                                                  controller.ind -
                                                      1]
                                                      .pst));
                                        }
                                      },
                                      child:
                                      const Icon(Icons.arrow_forward)),

                                  // repeat
                                  InkWell(
                                      onTap: () {
                                        controller.repeat.toggle();
                                      },
                                      child: Obx(() => Icon(
                                          controller.repeat.value
                                              ? Icons.repeat_one
                                              : Icons.repeat))),
                                ],
                              ),
                            )
                          ]))),
                    ),
                    SizedBox(
                      height: Get.height / 45,
                    )
                  ]),
                ],
              )),
        ),
      )),
    );
  }
}
