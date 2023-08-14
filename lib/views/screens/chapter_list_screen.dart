import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/chapter_list_controller.dart';
import 'package:zabaner/models/resources_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/book_screen.dart';
import 'package:zabaner/views/screens/profile_screen.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/icon_widget.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

import '../colors.dart';

class ChapterListScreen extends StatelessWidget {
  const ChapterListScreen(
      {Key? key, required this.id, required this.type, required this.imageLink})
      : super(key: key);
  final String id, type, imageLink;

  @override
  Widget build(BuildContext context) {
    final ChapterController _controller =
        Get.put(ChapterController(id: id, type: type));
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: ColoredAppBar(),
          body: Obx(() => _controller.isDataLoaded.isTrue
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 300,
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: _controller.bookModel.imagePath,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            height: 200,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: Get.width / 15,
                                left: Get.width / 15,
                                top: 160),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3))
                                ]),
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              child: Column(
                                children: [
                                  ColoredText(
                                    _controller.bookModel.faTitle,
                                    textSize: 18,
                                    maxLines: 1,
                                  ),
                                  ColoredText(
                                    _controller.bookModel.title,
                                    textSize: 12,
                                    maxLines: 1,
                                    textColor: Colors.black.withOpacity(0.5),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: resourceIconDetail(
                                              title:
                                                  "لهجه: ${_controller.bookModel.accent}",
                                              iconPath:
                                                  "assets/images/audio_book.png")),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: resourceIconDetail(
                                              title:
                                                  "${_controller.getFullTime()} دقیقه ",
                                              iconPath:
                                                  "assets/images/time_length.png")),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          child: resourceIconDetail(
                                              title:
                                                  "سطح: ${_controller.bookModel.level}",
                                              iconPath:
                                                  "assets/images/level-ltr.png")),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: resourceIconDetail(
                                              title:
                                                  "ژانر: ${_controller.bookModel.genre}",
                                              iconPath:
                                                  "assets/images/genre.png")),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height / 30,
                    ),
                    Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        child: ColoredText(
                          "داستان ها",
                          textColor: Colors.black.withOpacity(0.5),
                        )),
                    Expanded(
                      child: ListView.builder(
                          itemCount: _controller.bookModel.items.length,
                          itemBuilder: (_, index) {
                            return InkWell(
                              onTap: (){
                                Get.to(() => BookScreen(
                                    isGuest: false,
                                    bookId: _controller
                                        .bookModel.id,
                                    chapterTitle:
                                    _controller
                                        .bookModel
                                        .items[
                                    index]
                                        .faTitle,
                                    enChapterTitle:
                                    _controller
                                        .bookModel
                                        .items[
                                    index]
                                        .title,
                                    imageLink:
                                    imageLink,
                                    itemId: _controller
                                        .bookModel
                                        .items[index]
                                        .id));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 8),
                                decoration: BoxDecoration(
                                  color: (index % 2 == 0)
                                      ? Colors.black.withOpacity(0.03)
                                      : Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                        flex: 0,
                                        child: ImageIcon(
                                          AssetImage(
                                              "assets/images/mic_1.png"),
                                          color: primaryDarkMore,
                                          size: 30,
                                        )),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: Column(children: [
                                          Container(
                                              width: double.infinity,
                                              child: Align(
                                                alignment:
                                                Alignment.centerRight,
                                                child: ColoredText(
                                                  isTextEmpty(_controller
                                                      .bookModel
                                                      .items[index]
                                                      .customText)
                                                      ? _controller.bookModel
                                                      .items[index].faTitle
                                                      : _controller
                                                      .bookModel
                                                      .items[index]
                                                      .customText,
                                                  maxLines: 1,
                                                ),
                                              )),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 8),
                                            width: double.infinity,
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ImageIcon(
                                                    AssetImage(
                                                        "assets/images/time_length.png"),
                                                    size: 13,
                                                    color:
                                                    Colors.black.withOpacity(0.5),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  ColoredText(
                                                    _controller.bookModel.items[index]
                                                        .podcastTime
                                                        .toString() +
                                                        " دقیقه ",
                                                    textSize: 12,
                                                    textColor:
                                                    Colors.black.withOpacity(0.5),
                                                  ),
                                                  SizedBox(
                                                    width: 18,
                                                  ),
                                                  ImageIcon(
                                                    AssetImage(
                                                        "assets/images/words_1.png"),
                                                    size: 13,
                                                    color:
                                                    Colors.black.withOpacity(0.5),
                                                  ),
                                                  ColoredText(
                                                    _controller.bookModel.items[index]
                                                        .wordsCount
                                                        .toString() +
                                                        " کلمه ",
                                                    textSize: 12,
                                                    textColor:
                                                    Colors.black.withOpacity(0.5),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],)),
                                    Flexible(
                                        flex: 0,
                                        child: Icon(Icons.play_circle_outline,size: 30,color: primaryDarkMore,)),
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                )
              : Loading())),
    );
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: ColoredAppBar(),
          body: Obx(() => _controller.isDataLoaded.isTrue
              ? Stack(
                  children: [
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width / 40),
                        child: SmartRefresher(
                          controller: _controller.refreshController,
                          onRefresh: () {
                            _controller.getBookData();
                          },
                          header: const MaterialClassicHeader(),
                          child: Obx(() => _controller.errorData.isTrue
                              ? ErrorLoading()
                              : Column(children: [
                                  // Top of screen
                                  SizedBox(
                                    height: Get.height / 10,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // profile image
                                        InkWell(
                                          onTap: () => Get.to(() =>
                                              ProfileScreen(isGuest: false)),
                                          child: CircleAvatar(
                                            radius: Get.width / 18,
                                            // backgroundImage: NetworkImage(_controller
                                            //         .getProfileImage ??
                                            //     "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/2048px-Solid_white.svg.png"),
                                          ),
                                        ),

                                        // Hello Text
                                        const Text(
                                          "داستان های کوتاه",
                                          style: TextStyle(
                                              fontFamily: "IRANSansPro",
                                              fontSize: 18),
                                        ),

                                        // Logo in top left
                                        SizedBox.square(
                                          // padding: EdgeInsets.only(left: Get.width / 25),
                                          dimension: Get.width / 8,
                                          // height: Get.height / 14,
                                          child: AppIcon(),
                                        )
                                      ],
                                    ),
                                  ),
                                  // information container
                                  Container(
                                    width: Get.width,
                                    height: Get.height / 6,
                                    decoration: BoxDecoration(
                                        color: Color(0xffDBDBDB),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Row(children: [
                                      // image
                                      Container(
                                        width: Get.width / 3,
                                        height: Get.height,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                  _controller
                                                      .bookModel.imagePath),
                                            )),
                                      ),

                                      // empty space
                                      SizedBox(
                                        width: Get.width / 12,
                                      ),

                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _controller.bookModel.faTitle,
                                            style: TextStyle(
                                                fontFamily: "IRANSansPro",
                                                fontWeight: FontWeight.bold),
                                          ),
                                          if (!isTextEmpty(
                                              _controller.bookModel.customText))
                                            ColoredText(
                                              _controller.bookModel.customText,
                                              textSize: 11,
                                              textDirection: TextDirection.rtl,
                                              maxLines: 1,
                                              textAlign: TextAlign.right,
                                            ),
                                          Row(
                                            children: [
                                              ImageIcon(
                                                  AssetImage(
                                                      "assets/images/time_length.png"),
                                                  size: 22),
                                              Text("    " "زمان کل داستان : " +
                                                  _controller.getFullTime() +
                                                  " دقیقه ")
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Transform.scale(
                                                scaleX: 1,
                                                child: ImageIcon(
                                                    AssetImage(
                                                        "assets/images/audio_book.png"),
                                                    size: 22),
                                              ),
                                              Text("    " "لهجه: " +
                                                  _controller.bookModel.accent +
                                                  "")
                                            ],
                                          )
                                        ],
                                      ))
                                    ]),
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // chapter list
                                  Expanded(
                                      child: _controller
                                                  .bookModel.items.length ==
                                              0
                                          ? NoData()
                                          : ListView.builder(
                                              itemCount: _controller
                                                  .bookModel.items.length,
                                              itemBuilder: (_, index) =>
                                                  InkWell(
                                                    onTap: () {
                                                      if (type == "book") {
                                                        Get.to(() => BookScreen(
                                                            isGuest: false,
                                                            bookId: _controller
                                                                .bookModel.id,
                                                            chapterTitle:
                                                                _controller
                                                                    .bookModel
                                                                    .items[
                                                                        index]
                                                                    .faTitle,
                                                            enChapterTitle:
                                                                _controller
                                                                    .bookModel
                                                                    .items[
                                                                        index]
                                                                    .title,
                                                            imageLink:
                                                                imageLink,
                                                            itemId: _controller
                                                                .bookModel
                                                                .items[index]
                                                                .id));
                                                      }
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height /
                                                              40),
                                                      width: Get.width,
                                                      height: Get.height / 14,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xffebebeb),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Row(
                                                        mainAxisAlignment: isTextEmpty(
                                                                _controller
                                                                    .bookModel
                                                                    .items[
                                                                        index]
                                                                    .customText)
                                                            ? MainAxisAlignment
                                                                .spaceEvenly
                                                            : MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          if (isTextEmpty(
                                                              _controller
                                                                  .bookModel
                                                                  .items[index]
                                                                  .customText))
                                                            Container(
                                                              width:
                                                                  Get.width / 3,
                                                              margin: isTextEmpty(_controller
                                                                      .bookModel
                                                                      .items[
                                                                          index]
                                                                      .customText)
                                                                  ? null
                                                                  : const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          22),
                                                              child: Text(
                                                                _controller
                                                                    .bookModel
                                                                    .items[
                                                                        index]
                                                                    .title,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          if (isTextEmpty(
                                                              _controller
                                                                  .bookModel
                                                                  .items[index]
                                                                  .customText))
                                                            Row(
                                                              children: [
                                                                const ImageIcon(
                                                                    AssetImage(
                                                                        "assets/images/time.png"),
                                                                    size: 22),
                                                                Text("    "
                                                                    "${_controller.bookModel.items[index].podcastTime} دقیقه")
                                                              ],
                                                            )
                                                          else
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          22),
                                                              child:
                                                                  ColoredText(
                                                                _controller
                                                                    .bookModel
                                                                    .items[
                                                                        index]
                                                                    .customText,
                                                                textSize: 14,
                                                                textDirection:
                                                                    TextDirection
                                                                        .rtl,
                                                                maxLines: 1,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              ),
                                                            ),
                                                          if (isTextEmpty(
                                                              _controller
                                                                  .bookModel
                                                                  .items[index]
                                                                  .customText))
                                                            Row(
                                                              children: [
                                                                ImageIcon(
                                                                    AssetImage(
                                                                        "assets/images/words.png"),
                                                                    size: 22),
                                                                Text("    "
                                                                    "${_controller.bookModel.items[index].wordsCount} کلمه")
                                                              ],
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  )))
                                ])),
                        )),
                  ],
                )
              : Loading())),
    );
  }
}
