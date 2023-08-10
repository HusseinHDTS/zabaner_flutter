import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyric_ui/ui_netease.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:zabaner/controllers/book_detail_controller.dart';
import 'package:zabaner/models/html.dart';
import 'package:zabaner/models/level.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/widgets/bottom_player.dart';
import 'package:zabaner/views/widgets/custom_lyrics_view.dart';
import 'package:zabaner/views/widgets/subtitle_tile.dart';
import 'package:zabaner/views/widgets/text_highlight.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/custom_lyric/christian_lyrics.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class BookScreen extends StatefulWidget {
  BookScreen({Key? key,
    required this.isGuest,
    required this.bookId,
    required this.chapterTitle,
    this.enChapterTitle = "",
    required this.imageLink,
    required this.itemId})
      : super(key: key);
  final String bookId, itemId, imageLink, chapterTitle, enChapterTitle;
  final bool isGuest;

  @override
  State<BookScreen> createState() => BookScreenState();
}

class BookScreenState extends State<BookScreen> {
  String? _imageLink, _chapterTitle;
  final BookController controller = Get.put(BookController());

  var inlineSpans = <List<InlineSpan>>[];
  var inlineSpansFa = <List<InlineSpan>>[];

  void setLists(_inlineSpans, _inlineSpansFa) {
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
    var screenSize = MediaQuery
        .of(context)
        .size;
    GetStorage.init();
    controller.customeInit(this, widget.bookId, widget.itemId, widget.isGuest);
    return WillPopScope(
      onWillPop: () async {
        controller.onClose();
        return true;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: ColoredAppBar(
              actions: [
                Builder(builder: (context) {
                  var itemSettings =
                  getItemSettings("${widget.bookId}/${widget.itemId}");
                  controller.fa.value = itemSettings['faTitle'] == "on";
                  controller.en.value = itemSettings['enTitle'] == "on";
                  return Obx(()=>langChange(
                      fa: itemSettings['faTitle'] == "on",
                      en: itemSettings['enTitle'] == "on",
                      enDisable: controller.enDisable.value,
                      faDisable: controller.faDisable.value,
                      onEnChange: (value) {
                        controller.en.value = value;
                        writeSetting(
                            "${widget.bookId}/${widget.itemId}/enTitle",
                            value == true ? "on" : "off");
                        // controller.christianLyrics.resetLyric(faEnable: controller.fa.value , enEnable: controller.en.value);
                      },
                      onFaChange: (value) {
                        controller.fa.value = value;
                        writeSetting(
                            "${widget.bookId}/${widget.itemId}/faTitle",
                            value == true ? "on" : "off");
                        // controller.christianLyrics.resetLyric(faEnable: controller.fa.value , enEnable: controller.en.value);
                      }));
                }),
              ],
              onBack: () {
                controller.onClose();
              },
            ),
            body: Stack(
              children: [
                Stack(children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Obx(() =>
                    controller.isSubtitleLoaded.value
                        ? Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                            width: Get.width,
                            child: Text(
                              "\n" +
                                  widget.chapterTitle +
                                  " \n",
                              style: const TextStyle(
                                fontFamily: "Yekan",
                                fontSize: 25,
                              ),
                              textAlign: TextAlign.center,
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Obx(() {
                          if (controller.fa.value || controller.en.value || controller.autoScroll.value) {

                          }
                          return Expanded(
                            flex: 1,
                            child: controller.christianLyrics.getLyric(
                                context,
                                isPlaying: controller.isPlaying.value,
                                imagePath: _imageLink.toString(),
                                faE: controller.fa.value,
                                enE: controller.en.value,
                                scrollOffset: 200,
                                autoScrollE: controller.autoScroll.value,
                                tStyle: Theme
                                    .of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                    height: 1.5,
                                    fontSize: 20,
                                    color: Colors.black)),
                          );
                        })
                      ],
                    )
                        : subtitleLoading()),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Obx(() =>
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          height: controller.isHide.value
                              ? hiddenHeight
                              : normalHeight,
                          child: BottomPlayer(
                              isVideo: false,
                              autoScroll: controller.autoScroll,
                              faTitle: controller.fa,
                              enTitle: controller.en,
                              settingsId: "${widget.bookId}/${widget.itemId}",
                              forward: () {
                                var newPos = controller
                                    .playerPosition.value.inMilliseconds +
                                    5100;
                                if (newPos >
                                    controller.duration.value.inMilliseconds)
                                  newPos =
                                      controller.duration.value.inMilliseconds -
                                          100;
                                controller.playerPosition.value =
                                    Duration(milliseconds: newPos);
                                controller.player.seekToPlayer(
                                    Duration(milliseconds: newPos));
                              },
                              backward: () {
                                var newPos = controller
                                    .playerPosition.value.inMilliseconds -
                                    5100;
                                if (newPos < 0) newPos = 0;
                                controller.playerPosition.value =
                                    Duration(milliseconds: newPos);
                                controller.player.seekToPlayer(
                                    Duration(milliseconds: newPos));
                              },
                              isFileExists: controller.isBookExists,
                              onInitialize: () {},
                              isInitialized: true.obs,
                              isPlaying: controller.isPlaying,
                              resumePlayer: () =>
                                  controller.player.resumePlayer(),
                              pausePlayer: () =>
                                  controller.player.pausePlayer(),
                              downloadRequest: () =>
                                  controller.download(
                                      controller.bookItemModel.podcastPath,
                                      widget.itemId,
                                      controller.bookItemModel.title),
                              togglePlayer: () async {
                                var filePath = getUrlFileName(
                                    controller.appDoc.path,
                                    widget.itemId,
                                    controller.bookItemModel.podcastPath);
                                controller.togglePlayer(filePath);
                                return true;
                              },
                              toggleHide: () => controller.isHide.toggle(),
                              togglePlayerSpeed: () {
                                if (controller.isPlaying.value) {
                                  if (controller.playSpeed.value == 0.5) {
                                    controller.playSpeed.value = 1;
                                    controller.player.setSpeed(1);
                                  } else if (controller.playSpeed.value == 1) {
                                    controller.playSpeed.value = 2;
                                    controller.player.setSpeed(2);
                                  } else if (controller.playSpeed.value == 2) {
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
                        )),
                  ),
                ]),
              ],
            )),
      ),
    );
  }
}
