import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:zabaner/controllers/main_screen_controller.dart';
import 'package:zabaner/controllers/resources_controller.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/book_screen.dart';
import 'package:zabaner/views/screens/client_statics_screen.dart';
import 'package:zabaner/views/screens/home_screen.dart';
import 'package:zabaner/views/screens/news_detail_screen.dart';
import 'package:zabaner/views/screens/news_screen.dart';
import 'package:zabaner/views/screens/pocast_screen.dart';
import 'package:zabaner/views/screens/podcast_play_screen.dart';
import 'package:zabaner/views/screens/profile_screen.dart';
import 'package:zabaner/views/screens/resources_screen.dart';
import 'package:zabaner/views/screens/video_detailt_screen.dart';

import '../../widgets/colored_text.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key, required this.isGuest, this.firstTime = false})
      : super(key: key);
  final MainScreenController _controller = Get.put(MainScreenController());

  final bool isGuest;
  final bool firstTime;
  late BookScreen bookScreen;
  late NewsDetailScreen newsDetailScreen;
  late PodcastPlay podcastScreen;
  late VideoDetailScreen videoScreen;
  bool bookScreenBool = false;
  bool newsDetailScreenBool = false;
  bool podcastScreenBool = false;
  bool videoScreenBool = false;

  @override
  Widget build(BuildContext context) {
    bool doubleTap = false;
    // Timer(const Duration(milliseconds: 500), () {
    //   _controller.intro.start(context);
    //   _controller.getStorage.write('tour', true);
    // });
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          try{
              ResourcesController _resController = Get.find();
            if(ResourcesScreen.onSearchClick.value){
              _resController.closeSearch();
              return false;
            }
          }catch(e){
            e.printError();
          }
          if (_controller
              .navigationKey[_controller.currentIndex.value].currentState!
              .canPop()) {
            _controller
                .navigationKey[_controller.currentIndex.value].currentState!
                .pop(_controller.navigationKey[_controller.currentIndex.value]
                    .currentContext);
          } else {
            if (!doubleTap) {
              doubleTap = true;
              var s = ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("برای خروج دوباره کلیک کنید"),
                duration: Duration(milliseconds: 1500),
              ));
              s.closed.then((value) => doubleTap = false);
            } else {
              SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
            }
          }
          return false;
        },
        child: Stack(
          children: [
            ShowCaseWidget(
                autoPlay: false,
                enableAutoPlayLock: false,
                builder: Builder(
                  builder: (_context) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      bool tourTime =
                          _controller.getStorage.read("tour") ?? false;
                      Timer(const Duration(milliseconds: 500), () {
                        if (!tourTime) {
                          ShowCaseWidget.of(_context).startShowCase([
                            _controller.keyOne,
                            _controller.keyTwo,
                            _controller.keyThree,
                            _controller.keyFour,
                            _controller.keyFive,
                            _controller.keySix,
                          ]);
                          _controller.getStorage.write('tour', true);
                        }
                      });
                    });
                    return Scaffold(
                      body: SizedBox.expand(
                          child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: double.infinity,
                              width: double.infinity,
                              child: PageView(
                                controller: _controller.pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  // Home screen and navigate to profile screen
                                  Navigator(
                                    key: _controller.navigationKey[0],
                                    onGenerateRoute: (settings) =>
                                        MaterialPageRoute(
                                      settings: settings,
                                      builder: (context) {
                                        switch (settings.name) {
                                          case '/statics':
                                            return StaticsScreen();
                                          case '/profile':
                                            return ProfileScreen(
                                              isGuest: isGuest,
                                            );
                                            // case '/bookScreen':
                                            bookScreenBool = true;
                                          // return bookScreen = BookScreen(
                                          //   isGuest: isGuest,
                                          // );
                                          case "/podcast":
                                            return PodcastScreen(
                                              isGuest: isGuest,
                                            );
                                          case "/playPodcast":
                                            podcastScreenBool = true;
                                            // return podcastScreen = PodcastPlay(
                                            //   isGuest: isGuest,
                                            // );
                                            break;
                                          // case "/newsDetail":
                                          //   return NewsDetailScreen(isGuest: isGuest);
                                          case "/home":
                                            return HomeScreen(
                                              isGuest: isGuest,
                                            );
                                          case "/video":
                                            videoScreenBool = true;
                                            // return videoScreen =
                                            //     VideoDetailScreen(isGuest: isGuest);
                                            break;
                                        }
                                        return HomeScreen(
                                          isGuest: isGuest,
                                        );
                                      },
                                    ),
                                  ),

                                  // Resources screen and navigate and Book, Podcast screen
                                  Navigator(
                                    key: _controller.navigationKey[1],
                                    onGenerateRoute: (settings) =>
                                        MaterialPageRoute(
                                      settings: settings,
                                      builder: (context) {
                                        switch (settings.name) {
                                          case '/bookScreen':
                                            bookScreenBool = true;
                                            // return bookScreen = BookScreen(
                                            //   isGuest: isGuest,
                                            // );
                                            break;
                                          case '/profile':
                                            return ProfileScreen(
                                              isGuest: isGuest,
                                            );
                                          case "/podcast":
                                            return PodcastScreen(
                                              isGuest: isGuest,
                                            );
                                          case "/playPodcast":
                                            podcastScreenBool = true;
                                            // return podcastScreen = PodcastPlay(
                                            //   isGuest: isGuest,
                                            // );
                                            break;

                                          case "/resource":
                                            return ResourcesScreen(
                                              isGuest: isGuest,
                                            );
                                          case "/video":
                                            videoScreenBool = true;
                                            // return videoScreen =
                                            //     VideoDetailScreen(isGuest: isGuest);
                                            break;
                                        }
                                        return ResourcesScreen(
                                          isGuest: isGuest,
                                        );
                                      },
                                    ),
                                  ),

                                  // News screen and navigate to news pages
                                  Navigator(
                                    key: _controller.navigationKey[2],
                                    onGenerateRoute: (settings) =>
                                        MaterialPageRoute(
                                      settings: settings,
                                      builder: (context) {
                                        if (settings.name == '/news') {
                                          return NewsScreen(
                                            isGuest: isGuest,
                                          );
                                        }
                                        if (settings.name == '/profile') {
                                          return ProfileScreen(
                                            isGuest: isGuest,
                                          );
                                        }
                                        return NewsScreen(
                                          isGuest: isGuest,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Obx(() => _controller.shouldShowContent()
                              ? Expanded(
                                  flex: 0,
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Flexible(
                                            flex: 1,
                                            child: Container(
                                              child: Showcase(
                                                targetPadding:
                                                    const EdgeInsets.all(5),
                                                key: _controller.keyOne,
                                                description:
                                                    _controller.intros[0],
                                                child: InkWell(
                                                  onTap: () {
                                                    _controller
                                                        .changeCurrentPage(0);
                                                  },
                                                  child: Center(
                                                      child: Column(
                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Opacity(
                                                            opacity: _controller
                                                                        .getCurrentPos() ==
                                                                    0
                                                                ? 1
                                                                : 0.4,
                                                            child: Image.asset(
                                                              "assets/images/homeS.png",
                                                            )),
                                                      ),
                                                      SizedBox(height: 2,),
                                                      Expanded(
                                                        flex:0,
                                                        child: Center(
                                                            child: ColoredText(
                                                          "خانه",
                                                          textColor: _controller
                                                                      .getCurrentPos() ==
                                                                  0
                                                              ? Colors.black87
                                                              : Colors.black38,
                                                          textSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                              ),
                                              width: double.infinity,
                                              height: double.infinity,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(),
                                            )),
                                        Flexible(
                                            flex: 1,
                                            child: Container(
                                              child: Showcase(
                                                targetPadding:
                                                    const EdgeInsets.all(5),
                                                key: _controller.keyTwo,
                                                description:
                                                    _controller.intros[1],
                                                child: InkWell(
                                                  onTap: () {
                                                    _controller
                                                        .changeCurrentPage(1);
                                                  },
                                                  child: Center(
                                                      child: Column(
                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Opacity(
                                                            opacity: _controller
                                                                .getCurrentPos() ==
                                                                1
                                                                ? 1
                                                                : 0.4,
                                                            child: Image.asset(
                                                              "assets/images/book_enable.png",
                                                            )),
                                                      ),
                                                      SizedBox(height: 2,),
                                                      Expanded(
                                                        flex:0,
                                                        child: Center(
                                                            child: ColoredText(
                                                              "منابع",
                                                              textColor: _controller
                                                                  .getCurrentPos() ==
                                                                  1
                                                                  ? Colors.black87
                                                                  : Colors.black38,
                                                              textSize: 12,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                            )),
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                              ),
                                              width: double.infinity,
                                              height: double.infinity,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(),
                                            )),
                                        Flexible(
                                            flex: 1,
                                            child: Container(
                                              child: Showcase(
                                                targetPadding:
                                                    const EdgeInsets.all(5),
                                                key: _controller.keyThree,
                                                description:
                                                    _controller.intros[2],
                                                child: InkWell(
                                                  onTap: () {
                                                    _controller
                                                        .changeCurrentPage(2);
                                                  },
                                                  child: Center(
                                                      child: Column(
                                                    children: [
                                                      Expanded(
                                                        flex:1,
                                                        child: Opacity(
                                                            opacity: _controller
                                                                .getCurrentPos() ==
                                                                2
                                                                ? 1
                                                                : 0.4,
                                                            child: Image.asset(
                                                              "assets/images/course.png",
                                                            )),
                                                      ),
                                                      SizedBox(height: 2,),
                                                      Expanded(
                                                        flex:0,
                                                        child: Center(
                                                            child: ColoredText(
                                                              "دوره ها",
                                                              textColor: _controller
                                                                  .getCurrentPos() ==
                                                                  2
                                                                  ? Colors.black87
                                                                  : Colors.black38,
                                                              textSize: 12,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                            )),
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                              ),
                                              width: double.infinity,
                                              height: double.infinity,
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 8),
                                              decoration: BoxDecoration(),
                                            )),
                                      ],
                                    ),
                                    width: double.infinity,
                                    height: 60,
                                    decoration: BoxDecoration(color: orange),
                                  ))
                              : Container())
                        ],
                      )),
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }
}
