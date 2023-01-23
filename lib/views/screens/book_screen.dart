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
import 'package:zabaner/views/widgets/bottom_player.dart';
import 'package:zabaner/views/widgets/subtitle_tile.dart';
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
  State<BookScreen> createState() => BookScreenState();
}

class BookScreenState extends State<BookScreen> {
  String? _imageLink, _chapterTitle;
  final BookController controller = Get.put(BookController());


  var inlineSpans = <List<InlineSpan>>[];
  var inlineSpansFa = <List<InlineSpan>>[];
  void setLists(_inlineSpans , _inlineSpansFa){
    // setState(() {
      inlineSpans = _inlineSpans;
      inlineSpansFa = _inlineSpansFa;
    // });
  }


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
    controller.customeInit(this,widget.bookId,widget.itemId,widget.isGuest);
    return Container(decoration:BoxDecoration(color: Colors.white),height: Get.height,width: Get.height,child: Obx(()=> controller.isDataLoaded.isTrue ? controller.errorData.isTrue ? ErrorLoading() : Directionality(
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
                Stack(children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                    child: GetBuilder<BookController>(init: controller,builder: (_ctrler){
                      return SingleChildScrollView(
                        controller: _ctrler.scrollController,
                        child: Obx(()=> _ctrler.isSubtitleLoaded.isFalse ? Center(child: Container(margin:EdgeInsets.only(top: 20),child: Loading()),) : Column(children: List.generate(_ctrler.getParAsLang(null).length+1, (index){
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
                              : Obx(()=>SubtitleTile(faVisible: _ctrler.fa.value, enVisible: _ctrler.en.value, faTile: _ctrler.getCurrentText(index-1, true),enTile: _ctrler.getCurrentText(index-1, false)));
                          if(index == controller.getParAsLang(null).length){
                            return Column(children: [
                              returnWidget,
                              Obx(()=>SizedBox(height: _ctrler.isHide.value ? hiddenHeight : normalHeight,)),
                            ],);
                          }
                          return returnWidget;
                        }) ) ),
                      );
                    },),
                  ),

                  Align(alignment: Alignment.bottomCenter,child: Obx(()=>AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: controller.isHide.value
                        ? hiddenHeight
                        : normalHeight,
                    child: BottomPlayer(
                        isVideo: false,
                        forward: () {
                          // var data = getPlayerIndex(
                          //     controller
                          //         .getParAsLang(
                          //         null),
                          //     controller
                          //         .playIndexList,
                          //     controller
                          //         .playIndexInList,
                          //     true);
                          // controller.currentSavedTime.value = data[2];
                          // controller.playerPosition.value = Duration(milliseconds: data[2]);
                          // controller.playIndexList = data[0];
                          // controller.playIndexInList = data[1];
                          var newPos = controller.playerPosition.value.inMilliseconds+5100;
                          if(newPos > controller.duration.value.inMilliseconds) newPos = controller.duration.value.inMilliseconds -100;
                          controller.playerPosition.value = Duration(milliseconds: newPos);
                          controller.player.seekToPlayer(Duration(
                              milliseconds: newPos));
                        },
                        backward: () {
                          // var data = getPlayerIndex(
                          //     controller
                          //         .getParAsLang(
                          //         null),
                          //     controller
                          //         .playIndexList,
                          //     controller
                          //         .playIndexInList,
                          //     false);
                          // controller.currentSavedTime.value = data[2];
                          // controller.playerPosition.value = Duration(milliseconds: data[2]);
                          // controller.playIndexList = data[0];
                          // controller.playIndexInList = data[1];
                          var newPos = controller.playerPosition.value.inMilliseconds-5100;
                          if(newPos < 0) newPos = 0;
                          controller.playerPosition.value = Duration(milliseconds: newPos);
                          controller.player.seekToPlayer(Duration(
                              milliseconds: newPos));
                        },
                        isFileExists: controller.isBookExists,
                        onInitialize: (){},
                        isInitialized:true.obs,
                        isPlaying: controller.isPlaying,
                        resumePlayer: ()=> controller.player.resumePlayer(),
                        pausePlayer: ()=> controller.player.pausePlayer(),
                        downloadRequest: ()=> controller.download(controller.bookItemModel.podcastPath, widget.itemId, controller.bookItemModel.title),
                        togglePlayer: () async{
                          var filePath = getUrlFileName(controller.appDoc.path,widget.itemId,controller.bookItemModel.podcastPath);
                          controller.togglePlayer(filePath);
                          return true;
                        },
                        toggleHide: ()=>controller.isHide.toggle(),
                        togglePlayerSpeed: (){
                          if (controller.isPlaying.value) {
                            if (controller.playSpeed.value ==
                                0.5) {
                              controller.playSpeed.value = 1;
                              controller.player.setSpeed(1);
                            } else if (controller.playSpeed.value ==1) {
                              controller.playSpeed.value = 2;
                              controller.player.setSpeed(2);
                            } else if (controller.playSpeed.value ==2) {
                              controller.playSpeed.value = 0.5;
                              controller.player.setSpeed(0.5);
                            }
                          }
                        },
                        playSpeed: controller.playSpeed,
                        player: controller.player,
                        isHide: controller.isHide,
                        repeat: controller.repeat,
                        duration: controller.duration.value,
                        position: controller.playerPosition),
                  )),),
                ]),
              ],
            )),
      ),
    ) : Loading()),);
  }
}
