import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/widgets/colored_text.dart';

class AppIcon extends StatelessWidget {
  Color backgroundColor;
  bool shadow;
  Gradient? gradient;

  AppIcon(
      {Key? key,
      this.gradient,
      this.shadow = false,
      this.backgroundColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: gradient == null ? backgroundColor : null,
        gradient: gradient,
        boxShadow: shadow
            ? [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3))
              ]
            : null,
      ),
      child: Image.asset("assets/images/icon.png"),
    );
  }
}

class AppLogo extends StatelessWidget {
  Axis axis;

  AppLogo({Key? key, this.axis = Axis.vertical}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.vertical) {
      return verticalIcon();
    } else {
      return horizontalIcon();
    }
  }

  Widget verticalIcon() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: Get.height / 15,
              child: AppIcon(
                shadow: true,
              )),
          SizedBox(
            height: 12,
          ),
          ColoredText(
            "ZABANER",
            textColor: Colors.black,
            fontFamily: "Arial",
            textSize: 18,
          ),
          SizedBox(
            height: 4,
          ),
          ColoredText(
            "Learn English With Zabaner",
            fontFamily: "Comic",
            textColor: Colors.black26,
            textSize: 12,
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget horizontalIcon() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
        child: Row(
          children: [
            SizedBox(
                height: Get.height / 15,
                child: AppIcon(
                  shadow: true,
                )),
            SizedBox(width: 8,),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColoredText(
                  "ZABANER",
                  textColor: Colors.black,
                  fontFamily: "Arial",
                  textSize: 18,
                ),
                ColoredText(
                  "Learn English With Zabaner",
                  fontFamily: "Comic",
                  textColor: Colors.black26,
                  textSize: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
