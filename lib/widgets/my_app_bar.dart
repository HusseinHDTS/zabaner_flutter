import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_text.dart';

class ColoredAppBar extends StatefulWidget implements PreferredSizeWidget  {
  String? title;
  Color? backgroundColor;
  Color? iconColor;
  bool? transparentBackground;
  bool? showBackText;
  double? elevation;

  ColoredAppBar(
      {this.title,
      this.elevation,
      this.transparentBackground,
      this.showBackText,
      this.backgroundColor,
      Key? key})
      : super(key: key);

  @override
  State<ColoredAppBar> createState() => _ColoredAppBar();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => AppBar().preferredSize;
}


class _ColoredAppBar extends State<ColoredAppBar> {

  @override
  Widget build(BuildContext context) {
    widget.title ??= "";
    widget.backgroundColor ??= primary;
    widget.iconColor ??= Colors.white;
    widget.transparentBackground ??= false;
    widget.showBackText ??= true;
    widget.elevation ??= 0;

    if(widget.transparentBackground == true){
      widget.backgroundColor = Colors.black12;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppBar(
          leadingWidth: Get.width,
          backgroundColor: widget.backgroundColor,
          elevation: widget.elevation,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width / 40),
            child: InkWell(
              onTap: () => Get.back(),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: widget.iconColor,
                  ),
                  SizedBox(width: 8,),
                  widget.showBackText! ? ColoredText("بازگشت", textColor: Colors.white) : Container()
                ],
              ),
            ),
          )),
    );
  }
}
