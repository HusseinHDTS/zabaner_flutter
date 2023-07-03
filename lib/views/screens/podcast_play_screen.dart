import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zabaner/controllers/play_podcast_controller.dart';
import 'package:zabaner/controllers/rebuild_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/widgets/bottom_player.dart';
import 'package:zabaner/views/widgets/subtitle_tile.dart';
import 'package:zabaner/views/widgets/text_highlight.dart';
import 'package:zabaner/models/level.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'dart:io' as io;

import '../../widgets/my_app_bar.dart';

class PodcastPlay extends StatefulWidget {
  PodcastPlay({Key? key, required this.isGuest, required this.id})
      : super(key: key);
  final String id;
  final bool isGuest;

  @override
  State<PodcastPlay> createState() => _PodcastPlayState();
}

class _PodcastPlayState extends State<PodcastPlay> {
  final PlayPodcastController controller = Get.put(PlayPodcastController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.customeInit();

    controller.getPodcastItemData(widget.id, widget.isGuest).then((value) {
      controller.initSubtitle(widget.id);
      controller.isPodcastExists.value = controller.isFileExists(getUrlFileName(
          controller.appDoc.path,
          widget.id,
          controller.podcastItem.podcastPath));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  RebuildController buildController = RebuildController();

  @override
  Widget build(BuildContext context) {
    //!controller.en.value && !controller.fa.value
    var screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        controller.onClose();
        return true;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            appBar: AppBar(
              actions: [
                Builder(
                  builder: (context) {
                    var itemSettings =
                    getItemSettings("podcasts/${widget.id}");
                    controller.fa.value = itemSettings['faTitle'] == "on";
                    controller.en.value = itemSettings['enTitle'] == "on";
                    return Obx(() => langChange(
                        fa: controller.fa.value,
                        en: controller.en.value,
                        faDisable: controller.faDisable.value,
                        enDisable: controller.enDisable.value,
                        onEnChange: (value) {
                          controller.en.value = value;
                          writeSetting("podcasts/${widget.id}/enTitle",
                              value == true ? "on" : "off");
                          PodcastPlay(
                            id: widget.id,
                            isGuest: false,
                          );
                        },
                        onFaChange: (value) {
                          controller.fa.value = value;
                          writeSetting("podcasts/${widget.id}/faTitle",
                              value == true ? "on" : "off");
                          PodcastPlay(
                            id: widget.id,
                            isGuest: false,
                          );
                        }));
                  }
                )
              ],
              leading: InkWell(
                  onTap: () {
                    controller.onClose();
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back)),
              backgroundColor: primary,
            ),
            body: Obx(() => controller.isDataLoaded.isTrue
                ? Stack(children: [
                    // Paragraph
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Obx(() => controller.isSubtitleLoaded.value
                          ? Column(
                              children: [
                                SizedBox(
                                    width: Get.width,
                                    child: Text(
                                      "\n" +
                                          controller.podcastItem.title +
                                          " \n",
                                      style: const TextStyle(
                                        fontFamily: "Yekan",
                                        fontSize: 25,
                                      ),
                                      textAlign: TextAlign.center,
                                    )),
                                Obx(() {
                                  if (controller.fa.value ||
                                      controller.en.value) {}
                                  return Expanded(
                                    flex: 1,
                                    child: controller.christianLyrics.getLyric(
                                        context,
                                        isPlaying: controller.isPlaying.value,
                                        imagePath: getUrl(controller
                                                .podcastItem.imagePath)
                                            .toString(),
                                        faE: controller.fa.value,
                                        enE: controller.en.value,
                                        autoScroll: controller.autoScroll.value,
                                        tStyle: Theme.of(context)
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
                      child: Obx(() => AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: controller.isHide.value
                                ? hiddenHeight
                                : normalHeight,
                            child: BottomPlayer(
                                isVideo: false,
                                enTitle: controller.en,
                                faTitle: controller.fa,
                                autoScroll: controller.autoScroll,
                                settingsId: "podcasts/${widget.id}",
                                forward: () {
                                  var newPos = controller
                                          .playerPosition.value.inMilliseconds +
                                      5100;
                                  if (newPos >
                                      controller.duration.value.inMilliseconds)
                                    newPos = controller
                                            .duration.value.inMilliseconds -
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
                                isFileExists: controller.isPodcastExists,
                                isInitialized: true.obs,
                                onInitialize: () {},
                                isPlaying: controller.isPlaying,
                                resumePlayer: () =>
                                    controller.player.resumePlayer(),
                                pausePlayer: () =>
                                    controller.player.pausePlayer(),
                                downloadRequest: () => controller.download(
                                    controller.podcastItem.podcastPath,
                                    widget.id,
                                    controller.podcastItem.title),
                                togglePlayer: () async {
                                  var filePath = getUrlFileName(
                                      controller.appDoc.path,
                                      widget.id,
                                      controller.podcastItem.podcastPath);
                                  controller.togglePlayer(filePath);
                                  return true;
                                },
                                toggleHide: () => controller.isHide.toggle(),
                                togglePlayerSpeed: () {
                                  if (controller.isPlaying.value) {
                                    if (controller.playSpeed.value == 0.5) {
                                      controller.playSpeed.value = 1;
                                      controller.player.setSpeed(1);
                                    } else if (controller.playSpeed.value ==
                                        1) {
                                      controller.playSpeed.value = 2;
                                      controller.player.setSpeed(2);
                                    } else if (controller.playSpeed.value ==
                                        2) {
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
                  ])
                : subtitleLoading())),
      ),
    );
  }
}
