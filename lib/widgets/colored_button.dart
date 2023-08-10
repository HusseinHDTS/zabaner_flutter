import 'package:flutter/material.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_text.dart';

class ColoredButton extends StatelessWidget {
  GestureTapCallback? onTap;
  bool? rippleAnimation;
  bool? gradientBorder;
  bool? fill;
  Color? textColor;
  Color? color;
  String? text;
  Widget? content;
  double? borderRadius;
  double? borderWidth;
  double? width;
  double? height;
  double? textSize;
  EdgeInsets? padding;
  Gradient? gradient;
  ColoredButton(this.text,
      {this.rippleAnimation,
      this.fill,
      this.textColor,
      this.color,
      this.gradientBorder,
      this.borderRadius,
      this.gradient,
      this.width,
      this.content,
      this.height,
      this.borderWidth,
      this.textSize,
      this.padding,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    rippleAnimation ??= false;
    fill ??= true;
    gradientBorder ??= false;
    textColor ??= Colors.white;
    color ??= primaryDark;
    borderRadius ??= 8;
    borderWidth ??= 2;
    textSize ??= 16;
    padding ??= const EdgeInsets.symmetric(horizontal: 18, vertical: 4);
    onTap ??= () {
      debugPrint("NULL ON CLICK!");
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          child: gradientBorder! ? gradientBorderButton() : normalButton(),
        ),
      ],
    );
  }

  gradientBorderButton() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius!),
          gradient: gradient),
      child: Container(
        padding: padding,
        width: width,
        height: height,
        margin: EdgeInsets.all(borderWidth!),
        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular((borderRadius!-2) > 0 ? (borderRadius!-2) : 0)),
        child: Center(child: content ?? ColoredText(text.toString(),textSize:textSize,textColor: textColor,),),
      ),
    );
  }

  normalButton() {
    return Container(
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius!),
          color: gradient == null
              ? fill!
                  ? color
                  : null
              : null,
          gradient: gradient,
          border: fill!
              ? null
              : Border.all(
                  width: borderWidth!,
                  color: textColor!,
                )),
      child: Center(
        child: content ?? ColoredText(text.toString(),
            textSize: textSize, textColor: textColor),
      ),
    );
  }
}
