import 'package:cached_network_image/cached_network_image.dart';
import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as dateHelper;
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:zabaner/controllers/home_data_controller.dart';
import 'package:zabaner/controllers/main_screen_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/level.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/chapter_list_screen.dart';
import 'package:zabaner/views/screens/client_statics_screen.dart';
import 'package:zabaner/views/screens/podcast_play_screen.dart';
import 'package:zabaner/views/screens/profile_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zabaner/views/screens/test_lyrics_page.dart';
import 'package:zabaner/views/screens/video_detailt_screen.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/cuostm_showcase.dart';
import 'package:zabaner/widgets/custom_wave.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

import '../../widgets/custom_circular_progress_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, required this.isGuest}) : super(key: key);
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    final HomeDataController _controller = Get.put(HomeDataController());
    final MainScreenController _mainController =
        Get.find<MainScreenController>();
    _controller.getData(isGuest);
    isGuest ? {} : _controller.sendStatics();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xffffffff),
        appBar: ColoredAppBar(
          titleWidget: CustomShowcase(
              onNextButtonTap: (){
                ShowCaseWidget.of(context).next();
              },
              onPreviousButtonTap: (){
                ShowCaseWidget.of(context).dismiss();
              },
              description:_mainController.intros[5],key:_mainController.showCaseKeys[5],child:Obx(() => _controller.isDataLoaded.value
              ? SizedBox(
            width: Get.width / 1.22,
            child: Text(
              "${_controller.homeModel.statistics.durationSum.split(":")[0]}D:${_controller.homeModel.statistics.durationSum.split(":")[1]}H:${_controller.homeModel.statistics.durationSum.split(":")[2]}M",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.end,
            ),
          )
              : Container())),
          backIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: InkWell(
              onTap: () {
                Get.to(() => ProfileScreen(isGuest: isGuest));
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SmartRefresher(
          controller: _controller.refreshController,
          onRefresh: () {
            _controller.getData(isGuest);
          },
          header: const MaterialClassicHeader(),
          child: SafeArea(
            child: Obx(() => _controller.isDataLoaded.isFalse
                ? Column(
                    children: [
                      Container(
                        height: Get.height / 7,
                      ),
                      Loading(),
                    ],
                  )
                : _controller.dataError.isTrue
                    ? Column(
                        children: [
                          Container(
                            height: Get.height / 7,
                          ),
                          ErrorLoading(),
                        ],
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            flex: 7,
                            child: SizedBox(
                              width: Get.width,
                              child: Container(
                                margin: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0, 3))
                                    ],
                                    borderRadius: BorderRadius.circular(18)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomRight,
                                          end: Alignment.topLeft,
                                          colors: [
                                            primaryDark.withOpacity(0.2),
                                            primaryDark.withOpacity(0.1),
                                            primaryDark.withOpacity(0.05),
                                            primaryDark.withOpacity(0.0),
                                            Colors.transparent,
                                            Colors.transparent,
                                            Colors.transparent
                                          ])),
                                  child: InkWell(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Circle Level
                                        Expanded(
                                          flex: 0,
                                          child: CustomShowcase(
                                            onNextButtonTap: (){
                                              ShowCaseWidget.of(context).next();
                                            },
                                            onPreviousButtonTap: (){
                                              ShowCaseWidget.of(context).dismiss();
                                            },
                                            description:_mainController.intros[6],key:_mainController.showCaseKeys[6],child: SizedBox(
                                              width: Get.width / 2,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  // Level text
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8,
                                                        bottom:
                                                        Get.height / 100),
                                                    child: Text(
                                                      _controller.totallSecond
                                                          .level(),
                                                      style: const TextStyle(
                                                          fontFamily: "Aria",
                                                          fontSize: 18,
                                                          color: Color(
                                                              0xff707070)),
                                                    ),
                                                  ),

                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child:
                                                    CircularPercentIndicator(
                                                      radius: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width /
                                                          4.2,
                                                      percent: (_controller
                                                          .totallSecond
                                                          .levelPercent() >
                                                          1)
                                                          ? 1
                                                          : _controller
                                                          .totallSecond
                                                          .levelPercent(),
                                                      animation: true,
                                                      progressColor: primary,
                                                      animationDuration: 1000,
                                                      lineWidth: 6,
                                                      center: Text(
                                                        _controller
                                                            .totallSecond
                                                            .showCurrent(),
                                                        style: const TextStyle(
                                                            fontFamily:
                                                            "Arial",
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xff707070)),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),),
                                        ),

                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex: 0,
                                                      child: InkWell(
                                                        child: Container(
                                                          width:
                                                              Get.width / 7.3,
                                                          height:
                                                              Get.height / 13,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 18),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: const Color(
                                                                      0xffffffff),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.4),
                                                                      spreadRadius:
                                                                          5,
                                                                      blurRadius:
                                                                          7,
                                                                      offset: Offset(
                                                                          0,
                                                                          3), // changes position of shadow
                                                                    ),
                                                                  ],
                                                                  shape: BoxShape
                                                                      .circle),
                                                          child: Image.asset(
                                                            "assets/images/CHART2.png",
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                        onTap: () => Get.to(() =>
                                                            StaticsScreen()),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Container(
                                                        height: double.infinity,
                                                        width: double.infinity,
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 8),
                                                        child: CustomShowcase(
                                                          onNextButtonTap: (){
                                                            ShowCaseWidget.of(context).next();
                                                          },
                                                          onPreviousButtonTap: (){
                                                            ShowCaseWidget.of(context).dismiss();
                                                          },
                                                          key:_mainController.showCaseKeys[4],description: _mainController.intros[4],
                                                        child:Container(
                                                          margin:
                                                          EdgeInsets.only(
                                                              bottom: 18),
                                                          child: Column(
                                                            children:
                                                            List.generate(
                                                              4,
                                                                  (index) {
                                                                String _time =
                                                                    "null";
                                                                String _date =
                                                                    "";
                                                                String
                                                                _duration =
                                                                    "";

                                                                try {
                                                                  var cDate = Jalali.fromDateTime(DateTime.parse(_controller
                                                                      .homeModel
                                                                      .statistics
                                                                      .last4Days[index]['date']));
                                                                  var duration = getTime(_controller
                                                                      .homeModel
                                                                      .statistics
                                                                      .last4Days[index]['duration']);
                                                                  _date = getCurrentDayDatePicker(
                                                                      cDate.weekDay -
                                                                          1,
                                                                      allText:
                                                                      true);
                                                                  _duration =
                                                                      duration;
                                                                  _time =
                                                                  "${getCurrentDayDatePicker(cDate.weekDay - 1, allText: true)} :    $duration";
                                                                } catch (e) {
                                                                  e.printError();
                                                                }
                                                                if (_time ==
                                                                    "null") {
                                                                  var cDate =
                                                                  Jalali
                                                                      .now();
                                                                  int dayNum =
                                                                      cDate
                                                                          .weekDay;
                                                                  dayNum =
                                                                      dayNum -
                                                                          (3 -
                                                                              index);
                                                                  if (dayNum ==
                                                                      0) {
                                                                    dayNum =
                                                                    7;
                                                                  } else if (dayNum <
                                                                      0) {
                                                                    dayNum = 7 -
                                                                        dayNum;
                                                                  }
                                                                  _date = getCurrentDayDatePicker(
                                                                      dayNum -
                                                                          1,
                                                                      allText:
                                                                      true);
                                                                  _duration =
                                                                  "00:00:00";
                                                                  _time =
                                                                  "${getCurrentDayDatePicker(dayNum - 1, allText: true)} :    00:00:00";
                                                                }
                                                                return Expanded(
                                                                  flex: 1,
                                                                  child:
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height: double
                                                                        .infinity,
                                                                    child:
                                                                    Align(
                                                                      alignment:
                                                                      Alignment.bottomCenter,
                                                                      child:
                                                                      Container(
                                                                        width:
                                                                        double.infinity,
                                                                        margin:
                                                                        EdgeInsets.only(left: 10),
                                                                        child:
                                                                        Align(
                                                                          alignment:
                                                                          Alignment.centerLeft,
                                                                          child:
                                                                          ColoredText(
                                                                            "$_date :    $_duration",
                                                                            textColor: Color(0xff9F9F9F),
                                                                            textSize: 12,
                                                                            fontFamily: "Arial",
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),),
                                                      ),
                                                    ),
                                                  ])),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // recent article text
                          SizedBox(
                              width: Get.width / 1.1,
                              child: const Text(
                                "منابع اخیرا دیده شده توسط شما",
                                style: TextStyle(
                                    fontFamily: "Yekan",
                                    fontSize: 12,
                                    color: Color(0xff919191)),
                              )),

                          // recent article in bottom of screen
                          Expanded(
                              flex: 5,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                reverse: true,
                                child: Row(
                                  textDirection: TextDirection.ltr,
                                  children: List.generate(
                                    _controller.homeModel.histories.length,
                                    (index) {
                                      return InkWell(
                                        onTap: () {
                                          if (_controller.homeModel
                                                  .histories[index].type ==
                                              "news") {}
                                          if (_controller.homeModel
                                                  .histories[index].type ==
                                              "podcasts") {
                                            Get.to(PodcastPlay(
                                                isGuest: isGuest,
                                                id: _controller.homeModel
                                                    .histories[index].id));
                                          }
                                          if (_controller.homeModel
                                                  .histories[index].type ==
                                              "books") {
                                            Get.to(() => ChapterListScreen(
                                                  id: _controller.homeModel
                                                      .histories[index].id,
                                                  imageLink: _controller
                                                      .homeModel
                                                      .histories[index]
                                                      .imagePath,
                                                  type: "book",
                                                ));
                                          }
                                          if (_controller.homeModel
                                                  .histories[index].type ==
                                              "videos") {
                                            // Navigator.pushNamed(context, '/video',
                                            //     arguments:
                                            //         _controller.homeModel.histories[index].id);
                                            Get.to(VideoDetailScreen(
                                              isGuest: isGuest,
                                              id: _controller.homeModel
                                                  .histories[index].id,
                                              itemType: "video",
                                            ));
                                          }
                                        },
                                        child: Center(
                                            child: Container(
                                          width: Get.width / 2.6,
                                          child: Container(
                                              width: double.infinity,
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
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    )
                                                  ]),
                                              margin: EdgeInsets.all(8),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: ClipRRect(
                                                      borderRadius:BorderRadius.circular(8),
                                                      child: Stack(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl:
                                                                _controller
                                                                    .homeModel
                                                                    .histories[
                                                                        index]
                                                                    .imagePath,
                                                          ),
                                                          Container(
                                                              width: 20,
                                                              height: 20,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 8,
                                                                      right: 8),
                                                              child: getIcon(
                                                                  _controller
                                                                      .homeModel
                                                                      .histories[
                                                                          index]
                                                                      .type,
                                                                  context))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        )),
                                      );
                                    },
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 70,
                          )
                        ],
                      )),
          ),
        ));
  }

  Widget getIcon(String type, BuildContext context) {
    Widget result = Container();
    if (type == "podcasts") {
      result = Align(
        alignment: Alignment.topRight,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/podcast.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
            Image.asset(
              "assets/images/podcast.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
          ],
        ),
      );
    }
    if (type == "books") {
      result = Align(
        alignment: Alignment.topRight,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/bookr.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
            Image.asset(
              "assets/images/bookr.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
          ],
        ),
      );
    }
    if (type == "videos") {
      result = Align(
        alignment: Alignment.topRight,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/video.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
            Image.asset(
              "assets/images/video.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
          ],
        ),
      );
    }
    return result;
  }
}

class HomeScreen2 extends StatelessWidget {
  HomeScreen2({Key? key, required this.isGuest}) : super(key: key);
  final bool isGuest;
  double topBarHeight = (Get.height * 3) / 7;

  Widget getIcon(String type, BuildContext context) {
    Widget result = Container();
    if (type == "podcasts") {
      result = Align(
        alignment: Alignment.topRight,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/podcast.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
            Image.asset(
              "assets/images/podcast.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
          ],
        ),
      );
    }
    if (type == "books") {
      result = Align(
        alignment: Alignment.topRight,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/bookr.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
            Image.asset(
              "assets/images/bookr.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
          ],
        ),
      );
    }
    if (type == "videos") {
      result = Align(
        alignment: Alignment.topRight,
        child: Stack(
          children: [
            Image.asset(
              "assets/images/video.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
            Image.asset(
              "assets/images/video.png",
              fit: BoxFit.fill,
              color: Colors.white,
            ),
          ],
        ),
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final HomeDataController _controller = Get.put(HomeDataController());
    final MainScreenController _mainController =
        Get.find<MainScreenController>();
    _controller.getData(isGuest);
    isGuest ? {} : _controller.sendStatics();
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: ColoredAppBar(
            backgroundColor: primaryDarkMore,
            titleWidget: CustomShowcase(
              onNextButtonTap: (){
                ShowCaseWidget.of(context).next();
              },
              onPreviousButtonTap: (){
                ShowCaseWidget.of(context).dismiss();
              },
              description:_mainController.intros[5],key:_mainController.showCaseKeys[5],child:Obx(() => _controller.isDataLoaded.value
                ? SizedBox(
              width: Get.width / 1.22,
              child: Text(
                "${_controller.homeModel.statistics.durationSum.split(":")[0]}D:${_controller.homeModel.statistics.durationSum.split(":")[1]}H:${_controller.homeModel.statistics.durationSum.split(":")[2]}M",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.end,
              ),
            )
                : Container()),),
            backIcon: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(right: 18),
                  child: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                )),
          ),
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(top: topBarHeight - 150),
                child: Obx(() => _controller.isDataLoaded.value
                    ? MasonryGridView.count(
                        itemCount:
                            _controller.homeModel.histories.length + (2 * 3),
                        crossAxisCount: 3,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                        itemBuilder: (context, index) {
                          if (index == 0 || index == 1 || index == 2) {
                            return SizedBox(
                              width: Get.width,
                              height: 150,
                            );
                          }
                          if (index ==
                                  _controller.homeModel.histories.length + 5 ||
                              index ==
                                  _controller.homeModel.histories.length + 4 ||
                              index ==
                                  _controller.homeModel.histories.length + 3) {
                            return SizedBox(
                              width: Get.width,
                              height: 120,
                            );
                          }
                          return Center(
                              child: InkWell(
                                onTap: () {
                                  if (_controller.homeModel
                                      .histories[index].type ==
                                      "news") {}
                                  if (_controller.homeModel
                                      .histories[index].type ==
                                      "podcasts") {
                                    Get.to(PodcastPlay(
                                        isGuest: isGuest,
                                        id: _controller.homeModel
                                            .histories[index].id));
                                  }
                                  if (_controller.homeModel
                                      .histories[index].type ==
                                      "books") {
                                    Get.to(() => ChapterListScreen(
                                      id: _controller.homeModel
                                          .histories[index].id,
                                      imageLink: _controller
                                          .homeModel
                                          .histories[index]
                                          .imagePath,
                                      type: "book",
                                    ));
                                  }
                                  if (_controller.homeModel
                                      .histories[index].type ==
                                      "videos") {
                                    // Navigator.pushNamed(context, '/video',
                                    //     arguments:
                                    //         _controller.homeModel.histories[index].id);
                                    Get.to(VideoDetailScreen(
                                      isGuest: isGuest,
                                      id: _controller.homeModel
                                          .histories[index].id,
                                      itemType: "video",
                                    ));
                                  }
                                },
                                child: Container(
                                    width: Get.width / 2.6,
                                    child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.grey.withOpacity(0.4),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              )
                                            ]),
                                        margin: EdgeInsets.all(8),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(8),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    CachedNetworkImage(
                                                      imageUrl: _controller
                                                          .homeModel
                                                          .histories[index - 3]
                                                          .imagePath,
                                                    ),
                                                    Container(
                                                        width: 20,
                                                        height: 20,
                                                        margin: EdgeInsets.only(
                                                            top: 8, right: 8),
                                                        child: getIcon(
                                                            _controller
                                                                .homeModel
                                                                .histories[
                                                                    index - 3]
                                                                .type,
                                                            context))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 8,
                                              decoration:
                                                  BoxDecoration(boxShadow: [
                                                BoxShadow(
                                                  color: primary.withOpacity(0.4),
                                                  // spreadRadius: 5,
                                                  blurRadius: 15,
                                                  offset: Offset(0.0,
                                                      0.55), // changes position of shadow
                                                )
                                              ]),
                                            ),
                                            ColoredText(
                                              _controller.homeModel
                                                  .histories[index - 3].title,
                                              textSize: 12,
                                            ),
                                            SizedBox(
                                              height: 8,
                                            ),
                                          ],
                                        ))),
                              ));
                        },
                      )
                    : Loading()),
              ),
              Container(
                  width: Get.width,
                  height: topBarHeight,
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(8000)),
                      child: Stack(
                        children: [
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(180 / 360),
                            child: WaveWidget(
                              size: Size(double.infinity, double.infinity),
                              config: CustomConfig(
                                colors: [
                                  primaryDarkMore,
                                ],
                                durations: [
                                  20000,
                                ],
                                heightPercentages: [
                                  0.19,
                                ],
                              ),
                              waveAmplitude: 0,
                              waveFrequency: 3,
                            ),
                          ),
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(180 / 360),
                            child: WaveWidget(
                              size: Size(double.infinity, double.infinity),
                              config: CustomConfig(
                                colors: [
                                  primaryDarkMore.withOpacity(0.7),
                                ],
                                durations: [
                                  15000,
                                ],
                                heightPercentages: [
                                  0.1,
                                ],
                              ),
                              waveAmplitude: 0,
                              waveFrequency: 4,
                            ),
                          ),
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(180 / 360),
                            child: WaveWidget(
                              size: Size(double.infinity, double.infinity),
                              config: CustomConfig(
                                colors: [
                                  primaryDarkMore.withOpacity(0.5),
                                ],
                                durations: [
                                  10000,
                                ],
                                heightPercentages: [
                                  0.0,
                                ],
                              ),
                              waveAmplitude: 0,
                              waveFrequency: 6,
                            ),
                          ),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                margin: EdgeInsets.only(top: 18),
                                child: SafeArea(
                                  child: SizedBox(
                                    width: (Get.width / 2),
                                    height: (Get.width / 2),
                                    child: Stack(
                                      children: [
                                        RotationTransition(
                                          turns: AlwaysStoppedAnimation(0 / 360),
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                  width: (Get.width / 2),
                                                  height: (Get.width / 2),
                                                  child: CustomCircularProgressBar(
                                                    progress: 0,
                                                    hasAnimation: true,
                                                  )),
                                              Center(
                                                child: SizedBox(
                                                    width: (Get.width / 2),
                                                    height: (Get.width / 2),
                                                    child:
                                                        CustomCircularProgressBar(
                                                            progress: 0,
                                                            radius: 0.73)),
                                              ),
                                              Center(
                                                child: SizedBox(
                                                    width: (Get.width / 2),
                                                    height: (Get.width / 2),
                                                    child:
                                                        CustomCircularProgressBar(
                                                      progress: 80,
                                                      hasAnimation: true,
                                                      radius: 0.5,
                                                    )),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:EdgeInsets.only(right: ((Get.width / 2) / 2) + 8),
                                                      child: ColoredText(
                                                        "Level 3",
                                                        textSize: 14,
                                                        textColor: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 4,),
                                                    Container(
                                                      margin:EdgeInsets.only(right: ((Get.width / 2) / 2) + 8),
                                                      child: ColoredText(
                                                        "Level 2",
                                                        textSize: 12,
                                                        textColor: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 6,),
                                                    Container(
                                                      margin:EdgeInsets.only(right: ((Get.width / 2) / 2) + 8),
                                                      child: ColoredText(
                                                        "Level 1",
                                                        textSize: 10,
                                                        textColor: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: ColoredText(
                                            "80%",
                                            textColor: Colors.white,
                                            textSize: 12,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                          Align(alignment:Alignment.bottomCenter,child: Container(margin:EdgeInsets.only(bottom:50,),child: ColoredText("یاد گیری بدون کتاب اصلا مگه میشه؟"+"\n\n"+"",textColor: Colors.white,)),),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
