import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as dateHelper;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:showcaseview/showcaseview.dart';
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
import 'package:zabaner/views/screens/video_detailt_screen.dart';

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
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xffffffff),
          body: SmartRefresher(
            controller:_controller.refreshController,
            onRefresh: (){
              _controller.getData(isGuest);
            },
            header: const MaterialClassicHeader(),
            child:  Obx(()=> _controller.isDataLoaded.isFalse ? Column(
              children: [
                Container(height: Get.height / 7,),
                CircularProgressIndicator(),
              ],
            ) : _controller.dataError.isTrue ? Column(
              children: [
                Container(height: Get.height / 7,),
                ErrorLoading(),
              ],
            ) :Column(
                children: [
                  // Top of screen
                  Container(
                    height: Get.height / 7,
                    padding: EdgeInsets.symmetric(horizontal: Get.width / 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // profile image
                        InkWell(
                            // onTap: () => Navigator.pushNamed(context, '/profile'),
                            onTap: () =>
                                Get.to(() => ProfileScreen(isGuest: isGuest)),
                            child: Icon(Icons.menu, size: Get.width / 8)),
                      ],
                    ),
                  ),

                  // sum of duration
                  Showcase(
                    targetPadding: const EdgeInsets.all(5),
                    key: _mainController.keyFive,
                    description: _mainController.intros[4],
                    child: SizedBox(
                      width: Get.width / 1.22,
                      child: Text(
                        _controller.homeModel.statistics.durationSum
                                .split(":")[0] +
                            "D" +
                            ":" +
                            _controller.homeModel.statistics.durationSum
                                .split(":")[1] +
                            "H" +
                            ":" +
                            _controller.homeModel.statistics.durationSum
                                .split(":")[2] +
                            "M",
                        style: const TextStyle(
                          color: Color(0xff5A5A5A),
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),

                  // charts in middle of screen
                  Expanded(
                    child: SizedBox(
                      width: Get.width,
                      child: Card(
                        margin: EdgeInsets.all(Get.width / 20),
                        color: const Color(0xffF9F9F9),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(37)),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Circle Level
                              Expanded(
                                flex: 0,
                                child: Showcase(
                                  targetPadding: const EdgeInsets.all(5),
                                  key: _mainController.keySix,
                                  description: _mainController.intros[5],
                                  child: SizedBox(
                                      width: Get.width / 2,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Level text
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 8, bottom: Get.height / 100),
                                            child: Text(
                                              _controller.totallSecond.level(),
                                              style: const TextStyle(
                                                  fontFamily: "Aria",
                                                  fontSize: 18,
                                                  color: Color(0xff707070)),
                                            ),
                                          ),

                                          SizedBox(
                                            height: Get.height / 3.8,
                                            width: Get.width / 2,
                                            child: CircularPercentIndicator(
                                              radius: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              percent: _controller.totallSecond
                                                  .levelPercent(),
                                              animation: true,
                                              progressColor: orange,
                                              animationDuration: 1000,
                                              lineWidth: 6,
                                              center: Text(
                                                _controller.totallSecond
                                                    .showCurrent(),
                                                style: const TextStyle(
                                                    fontFamily: "Arial",
                                                    fontSize: 15,
                                                    color: Color(0xff707070)),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),

                              Expanded(
                                flex: 1,
                                child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 0,
                                            child: InkWell(
                                              child: Container(
                                                width: Get.width / 7.3,
                                                height: Get.height / 13,
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 18),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffffffff),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.4),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                    shape: BoxShape.circle),
                                                child: Image.asset(
                                                  "assets/images/CHART2.png",
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              onTap: () =>
                                                  Get.to(() => StaticsScreen()),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: double.infinity,
                                              width: double.infinity,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 8),
                                              child: Showcase(
                                                key: _mainController.keyFour,
                                                description:
                                                    _mainController.intros[3],
                                                child: Container(
                                                  margin:
                                                      EdgeInsets.only(bottom: 18),
                                                  child: Column(
                                                    children: List.generate(
                                                      _controller
                                                          .homeModel
                                                          .statistics
                                                          .last4Days
                                                          .length,
                                                      (index) {
                                                        return Expanded(
                                                          flex: 1,
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            child: Align(
                                                              alignment: Alignment
                                                                  .bottomCenter,
                                                              child: Text(
                                                                "${dateHelper.DateFormat('EEEE').format(DateTime.parse(_controller.homeModel.statistics.last4Days[index]['date'])).substring(0, 2)} :    ${getTime(_controller.homeModel.statistics.last4Days[index]['duration'])} ",
                                                                style: const TextStyle(
                                                                    fontFamily:
                                                                        "Arial",
                                                                    fontSize: 12,
                                                                    color: Color(
                                                                        0xff9F9F9F)),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ])),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    flex: 7,
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
                                  if (_controller
                                          .homeModel.histories[index].type ==
                                      "news") {
                                    // Navigator.pushNamed(context, '/newsDetail',
                                    //     arguments:
                                    //         _controller.homeModel.histories[index].id);
                                    // Get.to(NewsDetailScreen(isGuest: isGuest),
                                    //     arguments:
                                    //         _controller.homeModel.histories[index].id);
                                  }
                                  if (_controller
                                          .homeModel.histories[index].type ==
                                      "podcasts") {
                                    // Navigator.pushNamed(context, '/podcast',
                                    //     arguments:
                                    //         _controller.homeModel.histories[index].id);
                                    Get.to(PodcastPlay(
                                        isGuest: isGuest,
                                        id: _controller
                                            .homeModel.histories[index].id));
                                  }
                                  if (_controller
                                          .homeModel.histories[index].type ==
                                      "books") {
                                    // Navigator.pushNamed(context, '/bookScreen',
                                    //     arguments:
                                    //         _controller.homeModel.histories[index].id);
                                    Get.to(() => ChapterListScreen(
                                          id: _controller
                                              .homeModel.histories[index].id,
                                          imageLink: _controller.homeModel
                                              .histories[index].imagePath,
                                          type: "book",
                                        ));
                                  }
                                  if (_controller
                                          .homeModel.histories[index].type ==
                                      "videos") {
                                    // Navigator.pushNamed(context, '/video',
                                    //     arguments:
                                    //         _controller.homeModel.histories[index].id);
                                    Get.to(VideoDetailScreen(
                                        isGuest: isGuest,
                                        id: _controller
                                            .homeModel.histories[index].id));
                                  }
                                },
                                child: Center(
                                    child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: Offset(
                                          4, 3), // changes position of shadow
                                    ),
                                  ], borderRadius: BorderRadius.circular(8)),
                                  width: Get.width / 2.6,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: Container(
                                          margin: EdgeInsets.all(2),
                                          child: CachedNetworkImage(
                                            imageUrl: _controller.homeModel
                                                .histories[index].imagePath,
                                          ))),
                                )),
                              );
                            },
                          ),
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  // Expanded(
                  //   flex: 5,
                  //   child: Container(
                  //     height: MediaQuery.of(context).size.height / 7.3,
                  //     margin: EdgeInsets.symmetric(vertical: Get.height / 48),
                  //     child: ListView.builder(
                  //       scrollDirection: Axis.horizontal,
                  //       itemCount: _controller.homeModel.histories.length,
                  //       reverse: true,
                  //       shrinkWrap: false,
                  //       padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                  //       itemBuilder: (context, index) => InkWell(
                  //         onTap: () {
                  //           if (_controller.homeModel.histories[index].type ==
                  //               "news") {
                  //             // Navigator.pushNamed(context, '/newsDetail',
                  //             //     arguments:
                  //             //         _controller.homeModel.histories[index].id);
                  //             // Get.to(NewsDetailScreen(isGuest: isGuest),
                  //             //     arguments:
                  //             //         _controller.homeModel.histories[index].id);
                  //           }
                  //           if (_controller.homeModel.histories[index].type ==
                  //               "podcasts") {
                  //             // Navigator.pushNamed(context, '/podcast',
                  //             //     arguments:
                  //             //         _controller.homeModel.histories[index].id);
                  //             Get.to(PodcastPlay(
                  //                 isGuest: isGuest,
                  //                 id: _controller.homeModel.histories[index].id));
                  //           }
                  //           if (_controller.homeModel.histories[index].type ==
                  //               "books") {
                  //             // Navigator.pushNamed(context, '/bookScreen',
                  //             //     arguments:
                  //             //         _controller.homeModel.histories[index].id);
                  //             Get.to(() => ChapterListScreen(
                  //                   id: _controller.homeModel.histories[index].id,
                  //                   imageLink: _controller
                  //                       .homeModel.histories[index].imagePath,
                  //                   type: "book",
                  //                 ));
                  //           }
                  //           if (_controller.homeModel.histories[index].type ==
                  //               "videos") {
                  //             // Navigator.pushNamed(context, '/video',
                  //             //     arguments:
                  //             //         _controller.homeModel.histories[index].id);
                  //             Get.to(VideoDetailScreen(
                  //                 isGuest: isGuest,
                  //                 id: _controller.homeModel.histories[index].id));
                  //           }
                  //         },
                  //         child: Container(
                  //           height: index * 10,
                  //           margin: const EdgeInsets.all(12),
                  //           child: Container(decoration:BoxDecoration(color: Colors.blue),child: CachedNetworkImage(imageUrl: _controller.homeModel.histories[index].imagePath,width: Get.width / 2.6,) ,),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              )),
          )),
    );
  }
}
