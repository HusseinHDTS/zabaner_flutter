import 'dart:async';
import 'dart:ui';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:zabaner/controllers/custom_date_picker_controller.dart';
import 'package:zabaner/controllers/main_screen_controller.dart';
import 'package:zabaner/controllers/resources_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/book_screen.dart';
import 'package:zabaner/views/screens/client_statics_screen.dart';
import 'package:zabaner/views/screens/home_screen.dart';
import 'package:zabaner/views/screens/news_detail_screen.dart';
import 'package:zabaner/views/screens/news_screen.dart';
import 'package:zabaner/views/screens/online_class.dart';
import 'package:zabaner/views/screens/pocast_screen.dart';
import 'package:zabaner/views/screens/podcast_play_screen.dart';
import 'package:zabaner/views/screens/profile_screen.dart';
import 'package:zabaner/views/screens/resources_screen.dart';
import 'package:zabaner/views/screens/video_detailt_screen.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/cuostm_showcase.dart';
import 'package:zabaner/widgets/custom_bottom_bar.dart';

import '../../widgets/colored_text.dart';
import '../../widgets/custom_coach_mark.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key, required this.isGuest, this.firstTime = false})
      : super(key: key) {
    Get.put(CustomDatePickerController());
  }

  late CustomTutorialCoachMark tutorialCoachMark;
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
  int _showCaseSize = 0;

  List<TargetFocus> _createTargets() {
    return List.generate(
        _controller.intros.length,
        (index) => TargetFocus(
                identify: "Identify $index",
                shape: ShapeLightFocus.Circle,
                color: primaryDarkMore,
                enableTargetTab: true,
                enableOverlayTab: false,
                paddingFocus: 30,
                alignSkip: (index == 0 || index == 1)
                    ? Alignment.bottomLeft
                    : (index == 2 || index == 3)
                        ? Alignment.bottomRight
                        : Alignment.bottomRight,
                keyTarget: _controller.showCaseKeys[index],
                contents: [
                  TargetContent(
                    align: index > 4 ? ContentAlign.bottom : ContentAlign.top,
                    child: ColoredText(
                      _controller.intros[index],
                      textColor: Colors.white,
                    ),
                  )
                ]));
  }

  void showTutorial(BuildContext context) {
    tutorialCoachMark.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = CustomTutorialCoachMark(
      targets: _createTargets(),
      colorShadow: primaryDarkMore,
      skipWidget: ColoredButton("رد کردن",
          color: Colors.white,
          textColor: primaryDark,
          borderRadius: 5,
          height: 35),
      paddingFocus: 10,
      opacityShadow: 0.3,
      showSkipInLastTarget: false,
      imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      onFinish: () {},
      onClickTarget: (target) {},
      onClickTargetWithTapPosition: (target, tapDetails) {},
      onClickOverlay: (target) {},
      onSkip: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    createTutorial();
    bool doubleTap = false;
    // Catcher.sendTestException();
    return Container(
      color: Colors.white,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: WillPopScope(
          onWillPop: () async {
            try {
              ResourcesController _resController = Get.find();
              if (ResourcesScreen.onSearchClick.value) {
                _resController.closeSearch();
                return false;
              }
            } catch (e) {
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
                var s =
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("برای خروج دوباره کلیک کنید"),
                  duration: Duration(milliseconds: 1500),
                ));
                s.closed.then((value) => doubleTap = false);
              } else {
                SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop');
              }
            }
            return false;
          },
          child: Stack(
            children: [
              ShowCaseWidget(builder: Builder(
                builder: (_context) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    bool tourTime =
                        _controller.getStorage.read("tour") ?? false;
                    Timer(const Duration(milliseconds: 500), () {
                      if (!tourTime) {
                        ShowCaseWidget.of(_context)
                            .startShowCase(_controller.showCaseKeys);
                        // showTutorial(_context);
                        // Intro.of(context).start();
                        _controller.getStorage.write('tour', true);
                      }
                    });
                  });
                  return Scaffold(
                    body: SizedBox.expand(child: Builder(builder: (_) {
                      return Stack(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(_).size.width,
                            height: MediaQuery.of(_).size.height,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: PageView(
                                      controller: _controller.pageController,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                        ),
                                        Navigator(
                                          key: _controller.navigationKey[3],
                                          onGenerateRoute: (settings) =>
                                              MaterialPageRoute(
                                            settings: settings,
                                            builder: (context) {
                                              return OnlineClass();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(() => _controller.shouldShowContent()
                              ? Builder(builder: (context) {
                                  return Transform.scale(
                                    scale: 1.03,
                                    child: CustomBottomBar(
                                      color: primary,
                                      notchColor: primaryDark,
                                      itemLabelStyle: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                      onTap: (index) {
                                        _controller.changeCurrentPage(
                                            3 - index, _context);
                                      },
                                      notchBottomBarController:
                                          _controller.bottomBarController,
                                      bottomBarItems: List.generate(4, (index) {
                                        String iconPath = "";
                                        String title = "", description = "";
                                        GlobalKey key =
                                            _controller.showCaseKeys[0];
                                        if (index == 3) {
                                          title = "خانه";
                                          description = _controller.intros[0];
                                          key = _controller.showCaseKeys[0];
                                          iconPath = "assets/images/homeS.png";
                                        }
                                        if (index == 2) {
                                          title = "منابع";
                                          description = _controller.intros[1];
                                          key = _controller.showCaseKeys[1];
                                          iconPath =
                                              "assets/images/book_enable.png";
                                        }
                                        if (index == 1) {
                                          title = "دوره ها";
                                          description = _controller.intros[2];
                                          key = _controller.showCaseKeys[2];
                                          iconPath = "assets/images/course.png";
                                        }
                                        if (index == 0) {
                                          title = "کلاس آنلاین";
                                          description = _controller.intros[3];
                                          key = _controller.showCaseKeys[3];
                                          iconPath =
                                              "assets/images/online_class.png";
                                        }
                                        var item = bottomBarItem(
                                            context: _context,
                                            iconPath: iconPath,
                                            introKey: key,
                                            introDesc: description,
                                            active: true);
                                        return BottomBarItem(
                                            itemLabel: title,
                                            activeItem: item,
                                            inActiveItem: item);
                                      }),
                                    ),
                                  );
                                })
                              : Container())
                        ],
                      );
                    })),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
