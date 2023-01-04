import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:zabaner/controllers/splash_timer_controller.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/widgets/colored_text.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
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
          SizedBox(
              height: Get.height,
              width: Get.width,
              child: Image.asset(
                "assets/images/splash_background2.png",
                fit: BoxFit.fill,
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: Get.height / 20),
              child: SizedBox(
                height: Get.height / 8.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width / 1.8,
                      child: Stack(children: [
                         Center(
                          child: Obx(()=>ProgressBar(
                            value: controller.currentLoadPercent.value,
                            height: 35,
                            backgroundColor: Colors.black12,
                            gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Colors.orangeAccent,Colors.orange, Colors.deepOrange]),
                          )),
                        ),
                        Obx(() => SizedBox(height:35,child: Center(child: ColoredText(controller.currentStatus.value,textDirection: TextDirection.rtl,textColor: Colors.white,)))),
                      ],),
                    ),
                    Obx(() => Text(
                          "Version ${controller.currentAppVersion.value}",
                          style: TextStyle(fontSize: 10),
                        )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
