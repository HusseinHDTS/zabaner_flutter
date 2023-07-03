import 'dart:convert';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:zabaner/controllers/custom_video_controller.dart';
import 'package:zabaner/controllers/online_class_controller.dart';
import 'package:zabaner/models/profile_information_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/models/wallet_info.dart';

class MainScreenController extends GetxController {
  late PageController pageController;
  var currentIndex = 0.obs;
  var _shouldShowContent = true.obs;
  final GetStorage getStorage = GetStorage();
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);

  late void Function()? onPressed;
  var first = 0.obs;
  late DateTime currentBackPressTime;
  GlobalKey keyOne = GlobalKey();
  GlobalKey keyTwo = GlobalKey();
  GlobalKey keyThree = GlobalKey();
  GlobalKey keyFour = GlobalKey();
  GlobalKey keyFive = GlobalKey();
  GlobalKey keySix = GlobalKey();
  GlobalKey keySeven = GlobalKey();
  NotchBottomBarController bottomBarController = NotchBottomBarController(index: 3);

  List<GlobalKey<NavigatorState>> navigationKey = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];
  var intros = [
    'در اینجا میتوانید نمودار خود و منابع مطاله شده را ببینید',
    'در اینجا می توانید منابع را مطالعه، تماشا و گوش کنید',
    'در اینجا دوره های اختصاصی زبانر ارائه شده اند',
    'اینجا مدت زمان استفاده شما از منابع طی 4 روز اخیر قابل مشاهده است',
    'مجموعه مدت زمان استفاده شما از منابع اینجا نمایش داده می شود',
    'با توجه به میزان مطالعه شما، میزان پیشرفت تان در اینجا قابل مشاهده است',
    'در اینجا میتوانید به صورت آنلاین در کلاس های ما شرکت نمایید',
  ];

  bool shouldShowContent() {
    return _shouldShowContent.isTrue;
  }

  void changeCurrentPage(int pos,_context) {
    if(ShowCaseWidget.of(_context).activeWidgetId != null){
      return;
    }
    if (currentIndex.value != pos) {
      currentIndex.value = pos;
      pageController.jumpToPage(currentIndex.value);
    }
  }

  int getCurrentPos() {
    return currentIndex.value;
  }

  @override
  void onInit() async {
    super.onInit();
    pageController = PageController();
    await GetStorage.init();
  }

  @override
  void dispose() {
    super.dispose();
    // pageController.dispose();
  }
}
