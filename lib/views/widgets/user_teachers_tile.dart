import 'dart:convert';

import 'package:animated_button_bar/animated_button_bar.dart';
import 'package:better_player/better_player.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:zabaner/controllers/video_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/user_teachers.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/create_class_screen.dart';
import 'package:zabaner/views/screens/submit_class.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/custom_video_player.dart';

class UserTeachersTile extends StatelessWidget {
  UserTeachers item;
  var videoPlayerWidgetController;

  UserTeachersTile(this.item, this.videoPlayerWidgetController, {Key? key})
      : super(key: key);
  PageController pageController =
      PageController(keepPage: true, viewportFraction: 1);
  RxInt tab = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 18, left: 18, bottom: 18),
      width: double.infinity,
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              offset: Offset(1, 4),
              spreadRadius: 2,
              blurRadius: 18)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: baseInformation2(),
        ),
      ),
    );
  }

  String getPersianPart(String text) {
    String result = text.substring(0, text.toString().indexOf("(") + 1);
    if (result.length - 1 > 0) {
      result = result.substring(0, result.length - 1);
    }
    result = result.replaceAll(RegExp(r"(?! )\s+| \s+"), " ");
    if (result.toString().trim().isEmpty) {
      result = text;
    }
    return result;
  }

  String getShowingItems(var items) {
    if (items.length == 0) {
      return "بدون تخصص";
    } else {
      if (items.length > 3) {
        return "${getPersianPart(items[0])} و ${getPersianPart(items[1])} و ${getPersianPart(items[2])} و ... ";
      } else {
        String res = "";
        for (var itm in items) {
          res += getPersianPart(itm) + " و ";
        }
        return "$res ...";
      }
    }
  }

  baseInformation2() {
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    RxBool videoSelected = true.obs;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          topRoundedMiniBar(
              height: 50,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ColoredText(
                    "${item.name} ${item.family}",
                    textColor: Colors.white,
                    textSize: 16,
                  ),
                ),
              )),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            child: ProfileImage(
                                ImageWithLoading(
                                    CachedNetworkImageProvider(item.imagePath)),
                                borderColor: primaryDark,
                                borderWith: 1.0),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: customRating(
                                preview: true,
                                current: item.rating.isEmpty
                                    ? 0
                                    : int.parse(item.rating.toString()),
                                count: item.ratingCount.isEmpty
                                    ? 0
                                    : int.parse(item.ratingCount.toString()),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Center(
                            child: ColoredText(
                              "${item.ratingCount.toString()} نفر " +
                                  " / " +
                                  " امتیاز ${((int.tryParse(item.rating.toString()) ?? 0) / (int.tryParse(item.ratingCount.toString()) ?? 0)).toStringAsFixed(1)}",
                              textSize: 10.5,
                              textColor: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        children: [
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(width: 2, color: primary),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(8))),
                              margin: EdgeInsets.only(
                                top: 8,
                              ),
                              child: Row(
                                children: [
                                  Obx(() => Flexible(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          if (cardKey.currentState!.isFront) {
                                            return;
                                          }
                                          if (videoSelected.value == true) {
                                            videoSelected.value = false;
                                            cardKey.currentState!.toggleCard();
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 4),
                                          margin: EdgeInsets.all(6),
                                          decoration: videoSelected.value
                                              ? null
                                              : BoxDecoration(
                                                  color:
                                                      primary.withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                          child: Center(
                                            child: ColoredText(
                                              "معرفی",
                                              textColor: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ))),
                                  Obx(() => Flexible(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          if (!cardKey.currentState!.isFront) {
                                            return;
                                          }
                                          if (videoSelected.value == false) {
                                            videoSelected.value = true;
                                            cardKey.currentState!.toggleCard();
                                          }
                                        },
                                        child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 4),
                                            margin: EdgeInsets.all(6),
                                            decoration: videoSelected.value
                                                ? BoxDecoration(
                                                    color: primary
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))
                                                : null,
                                            child: Center(
                                              child: ColoredText(
                                                "ویدئو",
                                                textColor: Colors.black,
                                              ),
                                            )),
                                      ))),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Stack(
                            children: [
                              FlipCard(
                                  direction: FlipDirection.HORIZONTAL,
                                  side: CardSide.BACK,
                                  flipOnTouch: false,
                                  key: cardKey,
                                  front: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(8))),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: SingleChildScrollView(
                                          child: ColoredText(
                                            item.description,
                                            textAlign: TextAlign.right,
                                            textColor: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  back: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        color: primary,
                                        borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(8))),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          width: double.infinity,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.white),
                                          child: Directionality(
                                            textDirection: TextDirection.ltr,
                                            // child: VideoPlayer(VideoPlayerController.network(getUrl(item.videoPath))..initialize()),
                                            // child: CustomVideoPlayer(getUrl(item.videoPath),CustomVideoType.NETWORK,initializedVideoPlayerController: videoPlayerWidgetController,isInitialized: true,fullscreenOnStart: true,),
                                            child: Obx(() => getVideoView(
                                                getUrl(item.videoPath),
                                                CustomVideoType.NETWORK,
                                                withThumb: true,
                                                customPreviewLink:
                                                    getUrl(item.videoImagePath),
                                                retryImage: customVideoPlayerTag
                                                        .value ==
                                                    getUrl(item.videoPath))),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: ColoredText("تدریس"),
                      ),
                      Flexible(
                        flex: 1,
                        child: ColoredText("انگلیسی"),
                      ),
                      Flexible(
                        flex: 1,
                        child: ColoredText("مخاطب"),
                      ),
                      Flexible(
                        flex: 1,
                        child: ColoredText(item.ageRating),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 18),
                  child: ColoredText(
                    "تخصص : " + getShowingItems(jsonDecode(item.expertise)),
                    textSize: 12.5,
                    textColor: Colors.black54,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Flexible(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          child: Center(
                            child: ColoredButton(
                              "رزرو کلاس",
                              color: item.teacherId == userSavedId
                                  ? Colors.grey.withOpacity(0.4)
                                  : primary.withOpacity(0.3),
                              textColor: Colors.black,
                              onTap: () {
                                if (item.teacherId == userSavedId) {
                                  return;
                                }
                                submitInfo(item);
                              },
                            ),
                          ),
                        )),
                    Flexible(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          child: Center(
                            child: ColoredButton(
                              "زمانبندی کلاس ها",
                              height: 40,
                              color: primary.withOpacity(0.3),
                              textColor: Colors.black,
                              textSize: 12,
                              onTap: () {
                                Get.to(() => ShowTeacherTimes(item.freeTimes));
                              },
                            ),
                          ),
                        )),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                divider(),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ColoredText(
                                "جلسه آزمایشی : ${item.testClassPrice} تومان "),
                            SizedBox(
                              height: 8,
                            ),
                            ColoredText(
                                "جلسه 1 ساعتی : ${item.normal1ClassPrice} تومان ")
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ColoredText(
                              "تعداد زبان آموز : ${getLongCountNumber(item.ratingCount)}",
                              textSize: 11,
                              textColor: Colors.grey,
                              textAlign: TextAlign.right,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ColoredText("ساعات کلاسی : ${item.totalCTime}",
                                textSize: 11,
                                textColor: Colors.grey,
                                textAlign: TextAlign.right)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  baseInformation() {
    return Stack(
      children: [
        topRoundedMiniBar(
            child: Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ColoredText(
                "${item.name} ${item.family}",
                textColor: Colors.white,
                textSize: 16,
              ),
              SizedBox(
                height: 8,
              ),
              ColoredText(
                "${item.educationLevel} ${item.educationIn}",
                textColor: Colors.white,
              ),
            ],
          ),
        )),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.only(left: 18, top: 50),
            child: Container(
              width: 62,
              height: 62,
              child: ProfileImage(
                  ImageWithLoading(CachedNetworkImageProvider(item.imagePath)),
                  borderColor: primaryDark,
                  borderWith: 1.0),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            margin:
                EdgeInsets.only(top: (90 + 30), right: 8, left: 8, bottom: 8),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColoredText(
                  jsonDecode(item.expertise).toList().join(" و "),
                  textSize: 12.5,
                  textColor: Colors.black54,
                  textAlign: TextAlign.right,
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 22, vertical: 4),
                  child: Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              width: 80,
                              child: InkWell(
                                onTap: () {
                                  submitInfo(item);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 14),
                                  decoration: BoxDecoration(
                                      color: primaryDark,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                    child: ColoredText(
                                      "رزرو کلاس",
                                      textColor: Colors.white,
                                      textSize: 12.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 35,
                      ),
                      Flexible(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                ColoredText(
                                  "شروع قیمت کلاس  ",
                                  textColor: Colors.black54,
                                  textSize: 10,
                                ),
                                ColoredText(
                                  formatPrice(smallerPrice(item.testClassPrice,
                                      item.normal1ClassPrice)),
                                  textSize: 16,
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
                Center(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: customRating(
                      preview: true,
                      showText: true,
                      current: item.rating.isEmpty
                          ? 0
                          : int.parse(item.rating.toString()),
                      count: item.ratingCount.isEmpty
                          ? 0
                          : int.parse(item.ratingCount.toString()),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.black12,
                ),
                SizedBox(
                  height: 8,
                ),
                Expanded(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      child: Row(
                        children: [
                          Flexible(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 8),
                                  child: ColoredButton(
                                    "زمانبندی کلاس ها",
                                    height: 40,
                                    fill: false,
                                    textColor: primaryDarkTransparent,
                                    textSize: 12,
                                  ),
                                ),
                              )),
                          Flexible(
                            flex: 1,
                            child: Center(
                              child: ColoredText(
                                "کلاس‌های برگذار شده : 0",
                                textSize: 12,
                                textColor: Colors.black87,
                              ),
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        )
      ],
    );
  }

  submitInfo(UserTeachers item) {
    RxInt selectedPos = 0.obs;
    customDialog(
        borderRadius: 18,
        child: Container(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              topRoundedMiniBar(title: "لطفا تعداد جلسات خود را انتخاب کنید."),
              Obx(() => selectableItem(
                  testClass: true,
                  onTap: () {
                    selectedPos.value = 0;
                  },
                  price:
                      (int.parse(item.testClassPrice.replaceAll(",", "")) * 1)
                          .toString(),
                  description: "کلاس آزمایشی",
                  selected: selectedPos.value == 0)),
              Obx(() => selectableItem(
                  onTap: () {
                    selectedPos.value = 1;
                  },
                  price:
                      (int.parse(item.normal1ClassPrice.replaceAll(",", "")) *
                              1)
                          .toString(),
                  description: "1 جلسه یک ساعتی",
                  selected: selectedPos.value == 1)),
              Obx(() => selectableItem(
                  onTap: () {
                    selectedPos.value = 3;
                  },
                  price:
                      (int.parse(item.normal3ClassPrice.replaceAll(",", "")) *
                              3)
                          .toString(),
                  description: "3 جلسه یک ساعتی",
                  selected: selectedPos.value == 3)),
              Obx(() => selectableItem(
                  onTap: () {
                    selectedPos.value = 5;
                  },
                  price:
                      (int.parse(item.normal5ClassPrice.replaceAll(",", "")) *
                              5)
                          .toString(),
                  description: "5 جلسه یک ساعتی",
                  selected: selectedPos.value == 5)),
              Obx(() => selectableItem(
                  onTap: () {
                    selectedPos.value = 10;
                  },
                  price:
                      (int.parse(item.normal10ClassPrice.replaceAll(",", "")) *
                              10)
                          .toString(),
                  description: "10 جلسه یک ساعتی",
                  selected: selectedPos.value == 10)),
              SizedBox(
                height: 8,
              ),
              Center(
                child: ColoredButton(
                  "رزرو کلاس",
                  gradientBorder: true,
                  textSize: 14,
                  textColor: primaryDark,
                  gradient: LinearGradient(colors: [
                    primary,
                    primaryDark,
                  ]),
                  onTap: () {
                    Get.back();
                    Get.to(() => SubmitClass(item, selectedPos.value));
                  },
                ),
              ),
              SizedBox(
                height: 18,
              ),
            ],
          ),
        ));
    return;
  }

  videoInformation(videoController) {
    GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
    RxBool isOnDescription = false.obs;
    return Column(
      children: [
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedButtonBar(
            radius: 18.0,
            padding: const EdgeInsets.all(22.0),
            backgroundColor: primaryDark,
            foregroundColor: Colors.white24,
            elevation: 4,
            borderWidth: 2,
            innerVerticalPadding: 8,
            children: [
              ButtonBarEntry(
                  onTap: () {
                    if (!cardKey.currentState!.isFront) {
                      cardKey.currentState!.toggleCard();
                    }
                  },
                  child: Icon(
                    Icons.video_collection,
                    color: Colors.white,
                  )),
              ButtonBarEntry(
                  onTap: () {
                    if (cardKey.currentState!.isFront) {
                      cardKey.currentState!.toggleCard();
                    }
                  },
                  child: Icon(Icons.description, color: Colors.white)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Stack(
            children: [
              FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  side: CardSide.FRONT,
                  flipOnTouch: false,
                  key: cardKey,
                  front: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(18)),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                  back: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(18)),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(18)),
                        child: SingleChildScrollView(
                          child: ColoredText(
                            item.description,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
