import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intro/flutter_intro.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MainScreenController extends GetxController {
  late PageController pageController;
  var currentIndex = 0.obs;
  var _shouldShowContent = true.obs;
  final GetStorage getStorage = GetStorage();
  late void Function()? onPressed;
  var first = 0.obs;
  late DateTime currentBackPressTime;
  GlobalKey keyOne = GlobalKey();
  GlobalKey keyTwo = GlobalKey();
  GlobalKey keyThree = GlobalKey();
  GlobalKey keyFour = GlobalKey();
  GlobalKey keyFive = GlobalKey();
  GlobalKey keySix = GlobalKey();


  List<GlobalKey<NavigatorState>> navigationKey = [
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
  ];

  bool shouldShowContent() {
    return _shouldShowContent.isTrue;
  }

  void changeCurrentPage(int pos) {
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
    // TODO: implement onInit
    super.onInit();

    pageController = PageController();
    await GetStorage.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }
}
