import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/views/screens/profile_account_screen.dart';
import 'package:zabaner/views/screens/profile_setting_screen.dart';
import 'package:zabaner/views/screens/profile_support_screen.dart';
import 'package:zabaner/views/widgets/profile_tab_widget.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key, required this.isGuest}) : super(key: key);
  final bool isGuest;
  final GetStorage _getStorage = GetStorage();
  @override
  Widget build(BuildContext context) {
    GetStorage.init();
    RxInt tab = 0.obs;
    final PageController _pageController = PageController();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: ColoredAppBar(),
        backgroundColor: const Color(0xffffffff),
        // resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
          child: Column(
            children: [
              // top of profile screen
              Container(
                width: Get.width,
                margin: const EdgeInsets.only(top: 24,right: 8,left: 8),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        child: Obx(()=>Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: tab.value == 0 ? selectedSettingsColor : deSelectedSettingsColor),
                          child: ProfileTab(
                            image: "subscribe_icon.png",
                            imageColor: tab.value == 0 ? Colors.white : null,
                            imageMargin: EdgeInsets.all(4),
                            title: "اشتراک",
                            onTap: () => _pageController.jumpToPage(0)),
                        ),
                        )
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        child: Obx(()=>Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: tab.value == 1 ? selectedSettingsColor : deSelectedSettingsColor),
                          child: ProfileTab(
                            image:  "account_enable2.png",
                            title: "حساب",
                            imageColor: tab.value == 1 ? Colors.white : null,
                            onTap: () => _pageController.jumpToPage(1),
                          ),
                        ),
                        )
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                          width: double.infinity,
                          child: Obx(()=>Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: tab.value == 2 ? selectedSettingsColor : deSelectedSettingsColor),
                            child: ProfileTab(
                              image: "support_enable2.png",
                              imageColor: tab.value == 2 ? Colors.white : null,
                              title: "پشتیبانی",
                              onTap: () => _pageController.jumpToPage(2),
                            ),
                          ),
                          )
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                          width: double.infinity,
                          child: Obx(()=>Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: tab.value == 3 ? selectedSettingsColor : deSelectedSettingsColor),
                            child: ProfileTab(
                              image: "setting_enable2.png",
                              imageColor: tab.value == 3 ? Colors.white : null,
                              title: "تنظیمات",
                              onTap: () => _pageController.jumpToPage(3),
                            ),
                          ),
                          )
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                          width: double.infinity,
                          child: Obx(()=>Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),color: tab.value == 5 ? selectedSettingsColor : deSelectedSettingsColor),
                            child: ProfileTab(
                              image: "exit.png",
                              title: "خروج",
                              textColor: Color(0xff5A5A5A),
                              imageColor: redExitColor,
                              onTap: () async {
                                await GetStorage.init();
                                final GetStorage _getStorage = GetStorage();
                                _getStorage.remove('timers');
                                _getStorage.remove('token');
                                _getStorage.remove('timers');
                                Get.offAll(LoginScreen());
                              },
                            ),
                          ),
                          )
                      ),
                    ),



                  ],
                ),
              ),

              // Empty Space Between text and top section
              SizedBox(
                height: Get.height / 35,
              ),

              Expanded(
                  child: PageView(
                onPageChanged: (int index) {
                  tab.value = index;
                },
                controller: _pageController,
                children: [
                  ProfileAccount(true,
                    isGuest: isGuest,
                  ),
                  ProfileAccount(false,
                    isGuest: isGuest,
                  ),
                  ProfileSupport(),
                  ProfileSetting(isGuest: isGuest),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
