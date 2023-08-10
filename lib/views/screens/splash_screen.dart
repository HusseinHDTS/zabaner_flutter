import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get/get.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:zabaner/controllers/splash_timer_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/icon_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // exitFullScreenMode();
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SplashScreenTimer(context));
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width:Get.width/2,child: AppIcon()),
                SizedBox(height: 18,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  ColoredText("ZABANER",
                      fontFamily: "Arial",
                      textColor: Colors.black,
                      textSize: 40),
                  ColoredText("Learn English With Zabaner",
                      fontFamily: "Comic",
                      textColor: Colors.black26,
                      textSize: 16),
                ],),
                SizedBox(height: 18,),
                SizedBox(width:Get.width * 2 / 3 ,child: ClipRRect(borderRadius:BorderRadius.circular(18),child: LinearProgressIndicator())),
              ],
            ),
          ),
          Align(alignment: Alignment.bottomCenter,child: Container(
            margin: EdgeInsets.only(bottom: 18),
            child: Obx(() => Text(
              "Version ${controller.currentAppVersion.value}",
              style: TextStyle(fontSize: 10),
            )),
          ),),
        ],
      ),
    );
    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       Container(
    //         width: Get.width,
    //         height: Get.height,
    //         decoration: BoxDecoration(
    //             gradient: LinearGradient(
    //                 colors: [primarySplashScreen, secondarySplashScreen],
    //                 begin: Alignment.topCenter,
    //                 end: Alignment.bottomCenter)),
    //         child: Opacity(
    //           opacity: 0.9,
    //           child: Image.asset(
    //             "assets/images/school_pattern.png",
    //             repeat: ImageRepeat.repeatY,
    //             color: Colors.black.withOpacity(0.25),
    //           ),
    //         ),
    //       ),
    //       SafeArea(
    //           child: Column(
    //         children: [
    //           SizedBox(
    //             height: 40,
    //           ),
    //           Center(
    //               child: SizedBox(
    //             width: Get.width / 2,
    //             child: AppIcon(
    //               backgroundColor: Colors.transparent,
    //               // shadow: true,
    //             ),
    //           )),
    //           SizedBox(
    //             height: 30,
    //           ),
    //           Center(
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 ColoredText("ZABANER",
    //                     fontFamily: "Arial",
    //                     textColor: Colors.black,
    //                     textSize: 50),
    //                 ColoredText("Learn English With Zabaner",
    //                     fontFamily: "Comic",
    //                     textColor: Colors.black26,
    //                     textSize: 18)
    //               ],
    //             ),
    //           ),
    //         ],
    //       )),
    //       Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Padding(
    //           padding: EdgeInsets.only(bottom: Get.height / 20),
    //           child: SizedBox(
    //             height: Get.height / 8.5,
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 SizedBox(
    //                   width: Get.width / 1.8,
    //                   child: Stack(
    //                     children: [
    //                       Center(
    //                         child: Obx(() => ProgressBar(
    //                               value: controller.currentLoadPercent.value,
    //                               height: 35,
    //                               backgroundColor: Colors.black12,
    //                               gradient: const LinearGradient(
    //                                   begin: Alignment.topLeft,
    //                                   end: Alignment.bottomRight,
    //                                   colors: [
    //                                     Colors.lightBlueAccent,
    //                                     Colors.blueAccent,
    //                                     Colors.deepPurpleAccent
    //                                   ]),
    //                             )),
    //                       ),
    //                       Obx(() => SizedBox(
    //                           height: 35,
    //                           child: Directionality(
    //                               textDirection: TextDirection.rtl,
    //                               child: Center(
    //                                   child: ColoredText(
    //                                 controller.currentStatus.value,
    //                                 textDirection: TextDirection.rtl,
    //                                 textColor: Colors.white,
    //                               ))))),
    //                     ],
    //                   ),
    //                 ),
    //                 Obx(() => Text(
    //                       "Version ${controller.currentAppVersion.value}",
    //                       style: TextStyle(fontSize: 10),
    //                     )),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
