import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColoredText extends StatelessWidget {
  String? text,fontFamily;
  double? textSize;
  int? maxLines;
  Color? textColor;
  Color? backgroundColor;
  TextStyle? textStyle;
  FontWeight? fontWeight;
  TextDirection? textDirection;
  TextAlign? textAlign;
  bool? defaultFont , selectable;
  TextOverflow? overflow;
  ColoredText(String this.text,
      {this.maxLines,
      this.textColor,
      this.textSize,
      this.textAlign,
      this.fontFamily,
      this.overflow,
      this.fontWeight,
      this.defaultFont,
      this.selectable,
      this.backgroundColor,
      this.textDirection}) {
    textAlign ??= TextAlign.center;
    defaultFont ??= false;
    selectable ??= false;
    textColor ??= CupertinoColors.black;
    fontWeight ??= FontWeight.normal;
    backgroundColor ??= Colors.transparent;
    textSize ??= 14.0;

    if(defaultFont!){
      textStyle = TextStyle(
        color: textColor,
        fontSize: textSize,
        fontWeight: fontWeight,
        backgroundColor: backgroundColor,
        overflow: overflow,
      );
    }else{
      textStyle = TextStyle(
        color: textColor,
        fontFamily: fontFamily,
        fontSize: textSize,
        fontWeight: fontWeight,
        backgroundColor: backgroundColor,
        overflow: overflow
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    if (maxLines != null) {
      if(selectable!){
        return SelectableText(
          text.toString(),
          style: textStyle,
          maxLines: maxLines,
        );
      }else {
        return Text(
          text.toString(),
          style: textStyle,
          maxLines: maxLines,
        );
      }
    } else {
      if(selectable!){
        return SelectableText(
          text.toString(),
          textAlign: textAlign,
          style: textStyle,
          textDirection: textDirection,
        );
      }else {
        return Text(
          text.toString(),
          textAlign: textAlign,
          style: textStyle,
          textDirection: textDirection,
        );
      }
    }
  }
}
