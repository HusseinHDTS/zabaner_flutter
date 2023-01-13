import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zabaner/models/app_versions.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';

class SplashScreenTimer extends GetxController {
  final BuildContext context;

  SplashScreenTimer(this.context);

  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);

  var starting = false.obs;
  var currentAppVersion = "".obs;
  var currentStatus = "".obs;
  var currentLoadPercent = 0.0.obs;
  @override
  void onInit() async {
    super.onInit();

    bool hasUpdate = false;
    String version = "";
    currentStatus.value="درحال گرفتن اطلاعات گوشی ...";
    currentLoadPercent.value = 0.2;
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      version = packageInfo.version;
      currentAppVersion.value = version;
      String buildNumber = packageInfo.buildNumber;
    }catch(e){
      // ColoredSnack(title: e.toString());
      e.printError();
    }
    currentLoadPercent.value = 0.4;
    currentStatus.value="درحال بررسی نسخه‌ی جدید ...";
    var request = await _getConnect.get(getUpdateVersions);
    var cvv;
    if (request.statusCode == 200) {
      var result = versionListModelFromJson(request.bodyString ?? "");
      for (int i = 0; i < result.length; i++) {
        var cv = result[i];
        if (cv.isActive) {
          if (getExtendedVersionNumber(cv.version) >
              getExtendedVersionNumber(version)) {
            cvv = cv;
            hasUpdate = true;
          }
        }
      }
    }
    currentLoadPercent.value = 0.6;
    if (!hasUpdate) {
      try {
        if(BUILD_MODE.toLowerCase() == "bazaar"){
          currentStatus.value="درحال برسی اتصال به بازار ...";
          await connectToBazaar();
        }
      }catch(e){
        // ColoredSnack(title: e.toString());
        e.printError();
      }
      startApp();
    }else{
      showUpdateDialog(cvv);
    }

  }

  void startApp() {
    currentLoadPercent.value = 0.8;
    currentStatus.value="درحال اجرا ...";
    starting = true.obs;
    try {
      Future.delayed(const Duration(milliseconds: 2300), () {
        currentLoadPercent.value = 1.0;
        Future.delayed(const Duration(milliseconds: 600), () {
          Get.offAll(() => LoginScreen());
          dispose();
        });
      });
    } catch (e) {
    }
  }

  void showUpdateDialog(AppVersions cv) {
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        backgroundColor: Colors.transparent,
        child: WillPopScope(
          onWillPop: () async {
            if (cv.isForce) {
              return false;
            }
            startApp();
            return true;
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(18),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 120),
                  padding: EdgeInsets.only(top: 130),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ColoredText(
                        "نسخه‌ی جدید زبانر منتشر شد",
                        textSize: 16,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      ColoredText(
                        "به‌روزرسانی می‌کنید؟",
                        textSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      ColoredText(
                        cv.version,
                        textSize: 12,
                        textColor: Colors.blueAccent,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(children: [
                          Flexible(
                              child: Container(
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(8)),
                            width: double.infinity,
                            height: 50,
                            child: InkWell(
                              onTap: () {
                                Get.back();
                                showDownloadDialog(cv);
                              },
                              child: Center(
                                  child: ColoredText(
                                "بله",
                                textSize: 17,
                                fontWeight: FontWeight.bold,
                                textColor: Colors.white,
                              )),
                            ),
                          )),
                          SizedBox(
                            width: 2,
                          ),
                          cv.isForce
                              ? Container()
                              : Flexible(
                                  child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.blueAccent, width: 2),
                                      borderRadius: BorderRadius.circular(8)),
                                  width: double.infinity,
                                  height: 50,
                                  child: InkWell(
                                    onTap: () {
                                      startApp();
                                      Get.back();
                                    },
                                    child: Center(
                                        child: ColoredText(
                                      "بعدا",
                                      textSize: 17,
                                      fontWeight: FontWeight.bold,
                                      textColor: Colors.blueAccent,
                                    )),
                                  ),
                                )),
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.topCenter,
                    child: Lottie.asset(
                        'assets/animations/update_animation.json',
                        height: 250)),
              ],
            ),
          ),
        ),
      ),
      useSafeArea: true,
      barrierDismissible: false,
    );
  }

  downloadItem(imagePath, title , url) {
    return InkWell(
      onTap: () async{
        if(url == ""){
          return;
        }else{
          bool canLaunch = await canLaunchUrl(Uri.parse(url.toString()));
          if(canLaunch){
            launchUrl(Uri.parse(url.toString()));
          }
        }
      },
      child: Opacity(
        opacity: url == "" ? 0.4 : 1,
        child: Container(
          height: 80,
          child: Row(
            children: [
              Flexible(
                  flex: 1,
                  child: Container(
                      width: 100,
                      height: double.infinity,
                      margin: EdgeInsets.only(left: 26),
                      child: Image.network(imagePath))),
              Flexible(
                  flex: 4,
                  child: Center(
                      child: Container(
                    width: double.infinity,
                    child: ColoredText(
                      title,
                      textSize: 18,
                    ),
                  ))),
            ],
          ),
        ),
      ),
    );
  }

  divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      width: double.infinity,
      height: 1,
      decoration: BoxDecoration(color: Colors.black26),
    );
  }

  void showDownloadDialog(AppVersions cv) {
    Get.bottomSheet(
      WillPopScope(
        onWillPop: ()async{
          if(cv.isForce){
            SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
          }else{
            startApp();
            Get.back();
          }
          return false;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(22), topLeft: Radius.circular(22))),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
            downloadItem("https://app.zabaner.ir/app_images/logo_direct.png",
                "دانلود مستقیم از سایت",cv.directLink),
            divider(),
            downloadItem("https://app.zabaner.ir/app_images/logo_googleplay.png",
                "دانلود از گوگل پلی",cv.googlePlayLink),
            divider(),
            downloadItem("https://app.zabaner.ir/app_images/logo_bazaar.png",
                "دانلود از  بازار",cv.bazaarLink),
                SizedBox(height: 10,),
          ]),
        ),
      ),
      enableDrag: false,
      isDismissible: false,
    );
  }
}
