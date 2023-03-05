import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_text.dart';

enum SnackType {
  SUCCESS,
  ERROR,
  WARNING,
  OLD,
}

class ColoredSnack {
  String? title, description;
  SnackPosition? position;
  EdgeInsets? margin , padding;
  Color? titleColor, descriptionColor;
  double? borderRadius;
  Duration? duration;
  SnackType? type;
  bool? newFace;

  ColoredSnack(
      {this.position,
      this.margin,
      this.padding,
      this.type,
      this.title,
      this.description,
      this.newFace,
      this.titleColor,
      this.descriptionColor,
      this.duration,
      this.borderRadius}) {
    position ??= SnackPosition.TOP;
    margin ??= const EdgeInsets.only(right: 18, left: 18, top: 18);
    padding ??= const EdgeInsets.all(18);
    titleColor ??= Colors.white;
    descriptionColor ??= Colors.white;
    borderRadius ??= 8;
    duration ??= const Duration(seconds: 5);
    title ??= "";
    newFace ??= false;
    description ??= "";
    type ??= SnackType.OLD;

    Color snackColor = snackbarSuccessTransparent;
    if (type == SnackType.SUCCESS) {
      snackColor = snackbarSuccessTransparent;
    }else if (type == SnackType.ERROR) {
      snackColor = snackbarFailedTransparent;
    }else if (type == SnackType.WARNING) {
      snackColor = snackbarWarningTransparent;
    }else if(type == SnackType.OLD){
      snackColor = snackbarOldTransparent;
    }
    if(!newFace!){
      oldSnack(snackColor);
    }else{
      newSnack(snackColor);
    }
  }

  newSnack(snackColor){
    // SnackBar(
    //   /// need to set following properties for best effect of awesome_snackbar_content
    //   elevation: 0,
    //   behavior: SnackBarBehavior.floating,
    //   backgroundColor: Colors.transparent,
    //   content: AwesomeSnackbarContent(
    //     title: 'On Snap!',
    //     message:
    //     'This is an example error message that will be shown in the body of snackbar!',
    //
    //     /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
    //     contentType: ContentType.failure,
    //   ),
    // );

  }

  oldSnack(snackColor){
    try{
      Get.closeAllSnackbars();
    }catch(e){
      e.printError();
    }
    Get.rawSnackbar(
      backgroundColor: snackColor,
      duration: duration,
      titleText: ColoredText(title!,textColor: titleColor,textSize: 14,textDirection: TextDirection.rtl,),
      messageText: ColoredText(description!, textColor: descriptionColor,textSize: 9,textDirection: TextDirection.rtl),
      borderRadius: borderRadius!,
      margin: margin!,
      padding: padding!,
      barBlur: 0.6,
      snackPosition: position!,
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    );
  }

}
