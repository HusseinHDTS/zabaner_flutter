import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_text.dart';

class ColoredAppBar extends StatefulWidget implements PreferredSizeWidget {
  String? title;
  String backText;
  Color? backgroundColor;
  Color? iconColor;
  bool? transparentBackground;
  bool? showBackText;
  bool? avoidBack;
  Widget? backIcon;
  Widget? titleWidget;
  double? elevation;
  Function? onBack;
  List<Widget>? actions;

  ColoredAppBar(
      {this.title,
      this.elevation,
      this.onBack,
      this.backText = "بازگشت",
      this.transparentBackground,
      this.backIcon,
      this.titleWidget,
      this.showBackText,
      this.avoidBack,
      this.backgroundColor,
      this.actions,
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
    widget.avoidBack ??= false;
    widget.showBackText ??= true;
    widget.elevation ??= 0;
    widget.actions ??= [];
    widget.titleWidget ??= ColoredText(
      widget.title.toString(),
      textColor: widget.iconColor,
    );
    widget.backIcon ??= Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width / 40),
      child: InkWell(
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        overlayColor: null,
        onTap: () {
          if(widget.onBack != null){
            widget.onBack!();
          }
          if(!widget.avoidBack!){
            Get.back();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              Icons.arrow_back,
              size: 20,
              color: widget.iconColor,
            ),
            SizedBox(
              width: 8,
            ),
            widget.showBackText!
                ? ColoredText(widget.backText, textColor: Colors.white)
                : Container(),
          ],
        ),
      ),
    );
    if (widget.transparentBackground == true) {
      widget.backgroundColor = Colors.black12;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppBar(
        leadingWidth: Get.width,
        backgroundColor: widget.backgroundColor,
        elevation: widget.elevation,
        leading: widget.backIcon,
        title: Container(
          margin: EdgeInsets.only(top: 4),
          child: widget.titleWidget,
        ),
        actions: widget.actions,
      ),
    );
  }
}
