import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum _ColoredTextMode{
  SELECTABLE,
  AUTOSIZE,
  NORMAL,
}

class ColoredText extends StatelessWidget {
  String? text;
  String fontFamily;
  double? textSize;
  double? minFontSize;
  double? maxFontSize;
  int? maxLines;
  Color? textColor;
  Color? backgroundColor;
  TextStyle? textStyle;
  FontWeight? fontWeight;
  TextDirection? textDirection;
  TextAlign? textAlign;
  bool? defaultFont , selectable , autoHeight;
  TextOverflow? overflow;
  ColoredText(String this.text,
      {this.maxLines,
      this.textColor,
      this.textSize,
      this.maxFontSize,
      this.minFontSize,
      this.textAlign,
      this.fontFamily = "IRANSansPro",
      this.overflow,
      this.fontWeight,
      this.defaultFont,
      this.selectable,
      this.autoHeight,
      this.backgroundColor,
      this.textDirection}) {
    textAlign ??= TextAlign.center;
    defaultFont ??= false;
    selectable ??= false;
    autoHeight ??= false;
    textColor ??= CupertinoColors.black;
    fontWeight ??= FontWeight.normal;
    backgroundColor ??= Colors.transparent;
    textSize ??= 14.0;
    maxFontSize ??= textSize;
    minFontSize ??= textSize;
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

  Widget getText(_ColoredTextMode type){
    if(type == _ColoredTextMode.SELECTABLE){
      return SelectableText(text.toString(),style: textStyle,maxLines: maxLines,textAlign: textAlign,);
    }else if(type == _ColoredTextMode.AUTOSIZE){
      return AutoSizeText(text.toString(),style: textStyle,maxLines: maxLines,textAlign: textAlign,minFontSize: minFontSize!,maxFontSize: maxFontSize!,);
    }else{
      return Text(text.toString(),style: textStyle,maxLines: maxLines,textAlign: textAlign,);
    }
  }


  @override
  Widget build(BuildContext context) {
    _ColoredTextMode textType;
    if(selectable == true){
      textType = _ColoredTextMode.SELECTABLE;
    }else if(autoHeight!){
      textType = _ColoredTextMode.AUTOSIZE;
    }else{
      textType = _ColoredTextMode.NORMAL;
    }
    return getText(textType);
  }
}
