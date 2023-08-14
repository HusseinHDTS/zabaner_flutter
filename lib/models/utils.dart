import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cached_video_preview/cached_video_preview.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart' as intl;
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:shimmer/shimmer.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:srt_parser/srt_parser.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zabaner/controllers/custom_video_controller.dart';
import 'package:zabaner/controllers/custom_video_player_controller.dart';
import 'package:zabaner/controllers/online_class_controller.dart';
import 'package:zabaner/models/html.dart';
import 'package:zabaner/models/profile_information_model.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/wallet_info.dart';
import 'package:zabaner/views/colors.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/views/screens/tabbar_sub_category_screen.dart';
import 'package:zabaner/views/tabs/list_model.dart';
import 'package:zabaner/views/widgets/custom_text_input.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:html/parser.dart' as parser;
import 'package:srt_parser/srt_parser.dart' as strP;
import 'package:flutter/services.dart';
import 'package:zabaner/widgets/cuostm_rolling_switch.dart';
import 'package:zabaner/widgets/cuostm_showcase.dart';
import 'package:zabaner/widgets/custom_cached_video_preview.dart';
import 'package:zabaner/widgets/custom_video_player.dart';
import 'package:zabaner/widgets/my_app_bar.dart';
import 'package:zabaner/widgets/wallet_info_widget.dart';

import '../widgets/custom_switch.dart';

// final BUILD_MODE = "BAZAAR";
final BUILD_MODE = "OTHER";
final CARD_NUMBER_SEPARATOR = " - ";
final PRICE_SEPARATOR = " , ";

final CLASS_FIRST_TIME_PRICING = "classPriceFirstTime";

final FTP_ACCESS_HOST = "178.216.250.178";
final FTP_ACCESS_USER = "dlserverlang";
final FTP_ACCESS_PASSWORD = "FRTetyroi73edfs";

int lvl1 = 1680;
int lvl2 = 3600;
int lvl3 = 7200;
int lvl4 = 9700;
int lvl5 = lvl4;
int lvl6 = lvl4;
double hiddenHeight = Get.height / 8 / 1.5, normalHeight = Get.height / 8;

String userPhoneNumber = "09XXXXXXXXX";
String userSavedId = "";
String userSavedName = "";
String userSavedFirstName = "";
String userSavedLastName = "";
WalletInfo? savedWalletInfo;

CustomVideoPlayerController? customVideoPlayerController;
Rx<String?> customVideoPlayerTag = "null".obs;

String _getSetting(String name, {bool replaceNull = true}) {
  GetStorage _getStorage = GetStorage();
  String result = (_getStorage.read(name)).toString();
  if (replaceNull && result == "null") {
    return "off";
  }
  return result;
}

void writeSetting(String name, String value) {
  GetStorage _getStorage = GetStorage();
  _getStorage.write(name, value);
}

Widget langChange(
    {required bool fa,
    required bool en,
    bool enDisable = false,
    bool faDisable = false,
    onFaChange,
    onEnChange}) {
  return Container(
    // margin: EdgeInsets.only(left: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        customLangSwitch(
          value: fa,
          onColor: primaryDark,
          isDisable: faDisable,
          text: "فا",
          onChange: (value) {
            if (faDisable) {
              return;
            }
            onFaChange(value);
          },
          offColor: Color(0xffe6e6e9),
          size: 40,
          showText: false,
        ),
        customLangSwitch(
          value: en,
          onColor: primaryDark,
          text: "En",
          isDisable: enDisable,
          onChange: (value) {
            if (enDisable) {
              return;
            }
            onEnChange(value);
          },
          offColor: Color(0xffe6e6e9),
          size: 40,
          showText: false,
        ),
      ],
    ),
  );
}

dynamic getItemSettings(id) {
  String autoScroll = _getSetting("auto_scroll");
  String autoScrollItem = _getSetting("$id/autoScroll", replaceNull: false);
  String faTitle = _getSetting("$id/faTitle", replaceNull: false);
  String enTitle = _getSetting("$id/enTitle", replaceNull: false);
  String repeat = _getSetting("$id/repeat");
  if (faTitle == "null") {
    faTitle = "on";
  }
  if (enTitle == "null") {
    enTitle = "on";
  }
  return {
    "autoScroll": autoScroll,
    "autoScrollItem": autoScrollItem,
    "faTitle": faTitle,
    "enTitle": enTitle,
    "repeat": repeat
  };
}

Widget customLangSwitch(
    {bool value = false,
    bool showText = true,
    bool isDisable = false,
    Color onColor = Colors.green,
    Color offColor = Colors.red,
    String text = "",
    double size = 60,
    onChange}) {
  RxBool cv = isDisable ? false.obs : value.obs;
  return Opacity(
    opacity: isDisable ? 0.4 : 1,
    child: Transform.scale(
      scale: 0.8,
      child: Obx(() => AnimatedToggleSwitch<bool>.dual(
          current: cv.value,
          first: true,
          second: false,
          indicatorSize: Size(30, 30),
          dif: 10.0,
          borderColor: Colors.transparent,
          height: 35,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1.5),
            ),
          ],
          // onTap: (){
          //   // if(isDisable){
          //   //   cv.value = cv.value;
          //   //   onChange(cv.value);
          //   //   return;
          //   // }
          // },
          onChanged: (b) {
            if (isDisable) return;
            cv.value = b;
            onChange(b);
          },
          colorBuilder: (b) => b ? Colors.green : Colors.red,
          iconBuilder: (value) => value
              ? Icon(
                  Icons.done,
                )
              : Icon(Icons.close),
          textBuilder: (value) => value
              ? Center(
                  child: ColoredText(
                  text,
                  // textColor: Colors.green.withOpacity(0.8),
                  textSize: 16,
                ))
              : Center(
                  child: ColoredText(
                  text,
                  // textColor: Colors.red.withOpacity(0.8),
                  textSize: 16,
                )))),
    ),
  );
}

Widget customSwitch(
    {bool value = false,
    bool showText = true,
    bool isDisable = false,
    Color onColor = Colors.green,
    Color offColor = Colors.red,
    double size = 60,
    onChange}) {
  RxBool cVal = value.obs;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      CustomSwitcherButton(
        value: value,
        onColor: onColor,
        isDisable: isDisable,
        size: size,
        offColor: offColor,
        onChange: (cv) {
          cVal.value = cv;
          onChange(cv);
        },
      ),
      if (showText)
        SizedBox(
          width: 4,
        ),
      if (showText)
        Obx(() => Container(
            width: 60,
            child: Center(
                child: ColoredText(cVal.value ? "(فعال)" : "(غیر فعال)")))),
    ],
  );
}

Widget toggleItem(String title, RxBool isChecked,
    {Function(bool value)? onChange}) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Obx(() => Row(
          children: [
            SizedBox(
              width: 18,
            ),
            Flexible(
              flex: 2,
              child: Container(
                child: CustomSwitcherButton(
                  value: isChecked.value,
                  onColor: primary,
                  offColor: Color(0xffe6e6e9),
                  onChange: (value) {
                    isChecked.value = value;
                    if (onChange != null) {
                      onChange(value);
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            ColoredText(title),
            SizedBox(
              width: 8,
            ),
            ColoredText(isChecked.value ? "(فعال)" : "(غیر فعال)"),
          ],
        )),
  );
}

copyToClipboard(String text, {bool? showAlert, String? title}) async {
  showAlert ??= false;
  await Clipboard.setData(ClipboardData(text: text));
  if (showAlert) {
    ColoredSnack(title: title.toString(), type: SnackType.SUCCESS);
  }
}

int randomNumber({int? min, int? max}) {
  min ??= 1;
  max ??= 999999;
  Random rnd = Random();
  return min + rnd.nextInt(max - min);
}

selectableItem(
    {required String price,
    required String description,
    required bool selected,
    bool? testClass,
    onTap}) {
  testClass ??= false;
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: selected ? selectedSettingsColor.withOpacity(0.14) : null),
      child: Container(
        height: 50,
        width: double.infinity,
        child: Row(
          children: [
            Flexible(
              flex: 0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ColoredText(
                      formatPrice(price, showUnit: true),
                      textColor: selected
                          ? Colors.green.shade600
                          : Colors.deepPurpleAccent,
                      textSize: 12.5,
                    ),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: ColoredText(
                        description,
                        textColor: selected ? Colors.green.shade600 : null,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ColoredText(
                      testClass ? "30 دقیقه" : "60 دقیقه",
                      textSize: 12,
                      textColor: selected
                          ? Colors.green.shade800.withOpacity(0.4)
                          : Colors.black45,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

class ShakeWidget extends StatefulWidget {
  ShakeWidget({
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    required this.child,
  });

  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )
      ..forward()
      ..addListener(() {
        if (controller.isCompleted) {
          controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// convert 0-1 to 0-1-0
  double shake(double value) =>
      2 * (0.5 - (0.5 - widget.curve.transform(value)).abs());

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Transform.translate(
        offset: Offset(
            (randomNumber() % 2 == 0)
                ? -(widget.deltaX * shake(controller.value))
                : (widget.deltaX * shake(controller.value)),
            (randomNumber() % 2 == 0)
                ? -(widget.deltaX * shake(controller.value))
                : (widget.deltaX * shake(controller.value))),
        child: child,
      ),
      child: widget.child,
    );
  }
}

Widget topRoundedMiniBar(
    {double? height,
    double? borderRadius,
    Color? mainColor,
    Color? imageColor,
    Widget? child,
    String? title}) {
  height ??= 90;
  borderRadius ??= 18;
  mainColor ??= primary;
  imageColor ??= Colors.white.withOpacity(0.6);
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius)),
          color: mainColor,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.45),
                offset: Offset(1, 4),
                spreadRadius: 2,
                blurRadius: 28)
          ]),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            child: Image.asset(
              "assets/images/user_teacher_pattern.png",
              repeat: ImageRepeat.repeatX,
              color: imageColor,
            ),
          ),
          child ??
              Align(
                alignment: Alignment.center,
                child: ColoredText(
                  title ?? "",
                  textColor: Colors.white,
                  textDirection: TextDirection.rtl,
                ),
              ),
        ],
      ),
    ),
  );
}

String getLongCountNumber(num) {
  var number = int.tryParse(num.toString()) ?? 0;
  String result = number.toString();
  if (number >= 1000) {
    result = "${number ~/ 1000}K";
    if (number >= 1000000) {
      result = "${number ~/ 1000000}M";
      if (number >= 1000000000) {
        result = "${number ~/ 1000000000}B";
      }
    }
  }

  return result;
}

customDialog({Color? headerColor, Widget? child, double? borderRadius}) {
  borderRadius ??= 18;
  Get.dialog(AlertDialog(
    backgroundColor: Colors.transparent,
    content: Wrap(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            color: Colors.white,
            child: child,
          ),
        )
      ],
    ),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0))),
    insetPadding: EdgeInsets.zero,
  ));
}

downloadDialog(
    {required RxDouble downloadingPercent,
    required title,
    required onDownloadCancel}) {
  // Get.defaultDialog(
  //     title: title,
  //     onWillPop: () async => downloadingPercent.value == 1 ? true : false,
  //     backgroundColor: Colors.white,
  //     content: ));
  customDialog(
      borderRadius: 18,
      child: Obx(() => WillPopScope(
          child: Container(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                topRoundedMiniBar(title: title, height: 40),
                SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: downloadingPercent.value,
                      ),
                    ),
                    SizedBox(
                        width: 60,
                        height: 60,
                        child: Center(
                            child: ColoredText(
                                "${parseDownloadPercent((downloadingPercent.value * 100).toDouble())} %",
                                textAlign: TextAlign.center)))
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: double.infinity,
                  child: Center(
                    child: ColoredButton(
                      "لغو دانلود",
                      color: cancelDownloadColor,
                      textColor: Colors.black,
                      onTap: onDownloadCancel,
                    ),
                  ),
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
          onWillPop: () async =>
              downloadingPercent.value == 1 ? true : false)));
}

infoBox(String content, {double? textSize}) {
  textSize ??= 12;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.only(top: 8, right: 8),
            decoration:
                BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          )),
      SizedBox(
        width: 12,
      ),
      Flexible(
          child: ColoredText(
        content,
        textAlign: TextAlign.right,
        textSize: textSize,
      )),
    ],
  );
}

String parseDownloadPercent(double download) {
  String res = "";
  var content = download.toString().split(".");
  res = content[0];
  String secondPart = content[1].toString();
  if (secondPart.length >= 2) {
    secondPart = secondPart.substring(0, 2);
  }
  // if(int.tryParse(secondPart) != null && int.parse(secondPart) == 0){
  //   secondPart = "";
  // }else{
  secondPart = ".$secondPart";
  // }
  // if(secondPart != "00" && secondPart == "0"){
  res += secondPart;
  // }
  return res;
}

loadingDialog(title, {bool? dismiss}) {
  dismiss ??= false;
  TextDirection direction = intl.Bidi.detectRtlDirectionality(title)
      ? TextDirection.rtl
      : TextDirection.ltr;
  Get.dialog(
    AlertDialog(
      title: Directionality(
          textDirection: TextDirection.rtl, child: ColoredText(title)),
      content: WillPopScope(
          onWillPop: () async {
            return dismiss!;
          },
          child: Container(height: 50, child: Loading())),
    ),
    barrierDismissible: dismiss,
  );
}

double getSubtitleFontSize() {
  return 20;
}

FontWeight getSubtitleFontWeight() {
  return FontWeight.normal;
}

TextStyle getSubtitleTextStyle(isNowCurrentText) {
  return TextStyle(
      // fontSize: isNowCurrentText ? 17.0 : 18,
      fontWeight:
          isNowCurrentText ? getSubtitleFontWeight() : getSubtitleFontWeight(),
      fontFamily: isNowCurrentText ? "Iransans_Fa_MD" : "Iransans_Fa_MD",
      color: isNowCurrentText ? Colors.black : Colors.grey);
}

TextStyle getSubDefault(isFa) {
  return TextStyle(
    fontSize: isFa ? 17 : 18,
    color: Colors.black,
    fontFamily: "Neue_MD",
  );
}

List<int> getPlayerIndex(
    List<SentenceModel> models, int listIndex, int inListIndex, bool forward) {
  var results = [listIndex, inListIndex];
  if (forward) {
    var b = models[listIndex].sentencesList;

    if (inListIndex + 1 < b.length) {
      results[0] = listIndex;
      results[1] = inListIndex + 1;
    } else {
      // debugPrint("dsakdaksjekwajlkejas : ListIndex : " + listIndex.toString() +"    inListIndex : " + inListIndex.toString());

      if (listIndex + 1 < models.length) {
        results[0] = listIndex + 1;
        results[1] = 0;
      }
    }
  } else {
    if (inListIndex - 1 > 0) {
      results[0] = listIndex;
      results[1] = inListIndex - 1;
    } else {
      if (listIndex - 1 > 0) {
        var b = models[listIndex - 1].sentencesList;
        results[0] = listIndex - 1;
        results[1] = b.length - 1;
      }
    }
  }
  // debugPrint("dsakdaksjekwajlkejas : ListIndex : " + results[0].toString() +"    inListIndex : " + results[1].toString());
  return [
    results[0],
    results[1],
    models[results[0]].sentencesList[results[1]].time
  ];
}

MultiChildScrollView({child, controller}) {
  return CustomScrollView(
    controller: controller,
    slivers: [
      SliverFillRemaining(
        hasScrollBody: false,
        child: child,
      )
    ],
  );
}

dropdownItems(List<String> items, RxString cItem, onChange,
    {String? hint, RxBool? error, required String cValue}) {
  error ??= false.obs;
  return Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: ColoredText(
                  hint.toString(),
                  textSize: 12,
                  textColor: Colors.black54,
                )),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              border: Border.all(
                  color: error!.value ? Colors.red : primary, width: 1),
            ),
            child: Center(
              child: DropdownButton(
                  value: cValue,
                  borderRadius: BorderRadius.circular(8),
                  iconEnabledColor: error.value ? Colors.red : primaryDark,
                  underline: Container(),
                  selectedItemBuilder: (context) {
                    return [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 2),
                        child:
                            Center(child: Obx(() => ColoredText(cItem.value))),
                      )
                    ];
                  },
                  items: items.map((String item) {
                    return DropdownMenuItem(
                        value: item,
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: ColoredText(
                              item,
                              textDirection: TextDirection.rtl,
                            )));
                  }).toList(),
                  onChanged: onChange),
            ),
          ),
        ],
      ));
}

Widget genderSelector(
    {required RxBool isMale,
    required RxBool isFemale,
    required RxBool hasError,
    onItemTap,
    bool isEnable = true}) {
  return Obx(() => Opacity(
        opacity: isEnable ? 1 : 0.6,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: hasError.value
                  ? Border.all(
                      color: Colors.red,
                      width: 1,
                    )
                  : null),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      onItemTap("male");
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isMale.value ? primary : null),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/animations/male-avatar.json',
                              width: 60, height: 40),
                          SizedBox(
                            width: 8,
                          ),
                          ColoredText(
                            "آقا",
                            textColor: isMale.value ? Colors.white : null,
                          ),
                        ],
                      ),
                    ),
                  )),
              SizedBox(
                width: 18,
              ),
              Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      onItemTap("female");
                    },
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isFemale.value ? primary : null),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/animations/female-avatar.json',
                              width: 60, height: 40),
                          SizedBox(
                            width: 8,
                          ),
                          ColoredText(
                            "خانم",
                            textColor: isFemale.value ? Colors.white : null,
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ));
}

checkBox(String title, RxBool value, onChange,
    {Color? boxColor,
    Color? textColor,
    Color? activeColor,
    Color? checkColor,
    bool? circular}) {
  circular ??= false;
  textColor ??= Colors.black;
  boxColor ??= primaryDark;
  activeColor ??= primaryDark;
  checkColor ??= Colors.white;
  return InkWell(
    onTap: () {
      onChange(!value.value);
    },
    child: Row(
      children: [
        Checkbox(
          value: value.value,
          onChanged: onChange,
          fillColor: MaterialStateColor.resolveWith((states) => boxColor!),
          hoverColor: boxColor,
          splashRadius: 18,
          shape: circular
              ? CircleBorder(
                  side: BorderSide(
                      color: activeColor, width: 1.4, style: BorderStyle.solid))
              : null,
          side: MaterialStateBorderSide.resolveWith(
            (states) => BorderSide(width: 1.4, color: activeColor!),
          ),
          checkColor: checkColor,
          activeColor: activeColor,
        ),
        ColoredText(
          title,
          textSize: 12,
          textColor: textColor,
        ),
      ],
    ),
  );
}

roundCheckBox(
    {String title = "",
    RxBool? isChecked,
    Color? color,
    Color? borderColor,
    Function(bool?)? onChange,
    double size = 30}) {
  color ??= primary;
  borderColor ??= primary;
  isChecked ??= false.obs;
  return InkWell(
    child: Row(
      children: [
        Obx(() => RoundCheckBox(
              onTap: onChange,
              size: size,
              uncheckedColor: primary,
              checkedColor: color,
              borderColor: borderColor,
              isChecked: isChecked!.value,
              isRound: false,
            )),
      ],
    ),
  );
}

divider({double? height}) {
  height ??= 1;
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    width: double.infinity,
    color: Colors.black12,
    height: height,
  );
}

inputText(hint, controller,
    {bool? enabled,
    RxBool? error,
    bool? readOnly,
    bool? allowEnglish,
    onChange,
    inputFormatters,
    textDirection,
    priceUnit,
    maxLength,
    textAlign,
    keyboardType,
    maxLines,
    useMaxAndMin}) {
  allowEnglish ??= true;
  error ??= false.obs;
  return Obx(() => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: CustomTextInput(
              hintText: hint,
              error: error!.value,
              enabled: enabled,
              useMaxAndMinLine: useMaxAndMin,
              textDirection: textDirection,
              inputFormatters: inputFormatters,
              maxLines: maxLines,
              maxLength: maxLength,
              textAlign: textAlign,
              readOnly: readOnly,
              priceUnit: priceUnit,
              allowEnglish: allowEnglish,
              onChanged: onChange,
              keyboardType: keyboardType,
              textEditingController: controller,
              hintSize: 14,
              fontSize: 15,
            )),
      ));
}

Image ImageWithLoading(ImageProvider image) {
  return Image(
    image: image,
    loadingBuilder: (contx, widget, loadingProgress) {
      if (loadingProgress == null) {
        return widget;
      }
      return Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
        ),
      );
    },
  );
}

Widget OneStar(bool active, size) {
  return Container(
      padding: EdgeInsets.symmetric(horizontal: 1),
      child: Icon(
        active ? Icons.star : Icons.star_border,
        color: active ? Colors.amber : Colors.grey,
        size: size,
      ));
}

CustomSliverAppBar({
  body,
}) {
  return Directionality(
    textDirection: TextDirection.rtl,
    child: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          // SliverAppBar(
          //   expandedHeight: 200.0,
          //   floating: false,
          //   pinned: true,
          //   actions: [],
          //   leading: null,
          //   backgroundColor: Colors.transparent,
          //   flexibleSpace: FlexibleSpaceBar(collapseMode: CollapseMode.pin,background: WalletInfoWidget(),),
          // ),
          SliverPersistentHeader(
            delegate: _SliverAppBarDelegate(
                WalletInfoWidget(),
                Stack(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              primaryLight,
                              primaryLight,
                              primary,
                              primaryDark,
                              primaryDark
                            ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: ColoredAppBar(
                          backgroundColor: Colors.transparent,
                        )),
                    SafeArea(
                      child: Container(
                          height: double.infinity,
                          margin: EdgeInsets.only(left: 18),
                          child: Center(
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ColoredText(
                                    formatPrice(savedWalletInfo!.currentPrice),
                                    textColor: Colors.white,
                                    textDirection: TextDirection.rtl,
                                  )))),
                    )
                  ],
                )),
            pinned: true,
            floating: false,
          )
        ];
      },
      body: body,
    ),
  );
}

bool isTextEmpty(String text) {
  return text.toString().trim().isEmpty || text.toString().trim() == "null";
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._body, this._title);

  final Widget _body;
  final Widget _title;

  @override
  double get minExtent => ColoredAppBar().preferredSize.height * 1.5;

  @override
  double get maxExtent => 250;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    RxDouble titleOp = 0.0.obs;
    RxDouble bodyOp = 1.0.obs;
    if (shrinkOffset.toInt() > 140) {
      titleOp.value = 1.0;
      bodyOp.value = 0.0;
      return Obx(() => AnimatedOpacity(
          opacity: titleOp.value,
          duration: Duration(milliseconds: 300),
          child: Container(
            child: _title,
          )));
    } else {
      titleOp.value = 0.0;
      bodyOp.value = 1.0;
      return Obx(() => AnimatedOpacity(
          opacity: bodyOp.value,
          duration: Duration(milliseconds: 300),
          child: Container(
            child: _body,
          )));
    }
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}

Widget customRating({
  int? current,
  int? count,
  bool? showText,
  bool? changeOnClick,
  startSize,
  bool preview = false,
  onPreviewClick,
  onStarChanged,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  current ??= 0;
  count ??= 0;
  startSize ??= 16.0;
  changeOnClick ??= false;
  showText ??= false;

  int mainRate = 0;
  String rateString = "0.0";
  // current ~/ count
  // (current / count).toStringAsFixed(1);
  if (count != 0) {
    mainRate = (current / count).toInt();
    rateString = (current / count).toStringAsFixed(1);
  }
  RxInt mainRxRate = mainRate.obs;
  RxDouble cRating = (double.tryParse(rateString) ?? 0.0).obs;
  if (preview) {
    return InkWell(
        onTap: onPreviewClick,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: [
              OneStar(cRating.value >= 1, startSize - 6),
              OneStar(cRating.value >= 2, startSize - 3),
              OneStar(cRating.value >= 3, startSize),
              OneStar(cRating.value >= 4, startSize - 3),
              OneStar(cRating.value >= 5, startSize - 6),
            ],
          ),
        ));
  }

  return Obx(() => SmoothStarRating(
        rating: cRating.value,
        size: startSize,
        filledIconData: Icons.star,
        halfFilledIconData: Icons.star_half,
        defaultIconData: Icons.star_border,
        starCount: 5,
        color: Colors.amber,
        borderColor: Colors.grey,
        allowHalfRating: false,
        spacing: 2.0,
        onRatingChanged: (value) {
          cRating.value = value;
          onStarChanged(value);
        },
      ));
}

Widget StarRating(
    {int? current,
    int? count,
    bool? showText,
    bool? changeOnClick,
    startSize,
    onStarChanged}) {
  current ??= 0;
  count ??= 0;
  startSize ??= 16.0;
  changeOnClick ??= false;
  showText ??= false;

  int mainRate = 0;
  String rateString = "0.0";
  // current ~/ count
  // (current / count).toStringAsFixed(1);
  if (count != 0) {
    mainRate = (current / count).toInt();
    rateString = (current / count).toStringAsFixed(1);
  }
  var splitRate = rateString.split(".");
  if (rateString == "0.0") {
    showText = false;
  }

  RxInt mainRxRate = mainRate.obs;
  return Container(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
            onTap: changeOnClick
                ? () {
                    if (mainRxRate.value != 0) {
                      return;
                    }
                    onStarChanged(1);
                    mainRxRate.value = 1;
                  }
                : null,
            child: Obx(() => OneStar(mainRxRate.value >= 1, startSize))),
        InkWell(
            onTap: changeOnClick
                ? () {
                    if (mainRxRate.value != 0) {
                      return;
                    }
                    onStarChanged(2);
                    mainRxRate.value = 2;
                  }
                : null,
            child: Obx(() => OneStar(mainRxRate.value >= 2, startSize))),
        InkWell(
            onTap: changeOnClick
                ? () {
                    if (mainRxRate.value != 0) {
                      return;
                    }
                    onStarChanged(3);
                    mainRxRate.value = 3;
                  }
                : null,
            child: Obx(() => OneStar(mainRxRate.value >= 3, startSize))),
        InkWell(
            onTap: changeOnClick
                ? () {
                    if (mainRxRate.value != 0) {
                      return;
                    }
                    onStarChanged(4);
                    mainRxRate.value = 4;
                  }
                : null,
            child: Obx(() => OneStar(mainRxRate.value >= 4, startSize))),
        InkWell(
            onTap: changeOnClick
                ? () {
                    if (mainRxRate.value != 0) {
                      return;
                    }
                    onStarChanged(5);
                    mainRxRate.value = 5;
                  }
                : null,
            child: Obx(() => OneStar(mainRxRate.value >= 5, startSize))),
        SizedBox(
          width: 4,
        ),
        showText
            ? Align(
                alignment: Alignment.center,
                child: Center(
                    child: ColoredText(
                  rateString,
                  textSize: 10,
                  textColor: Colors.black54,
                )),
              )
            : Container(),
        SizedBox(
          width: 4,
        ),
      ],
    ),
  );
}

Widget ProfileImage(image, {borderColor, borderWith}) {
  borderColor ??= Colors.white;
  borderWith ??= 0.0;
  return CircularProfileAvatar(
    "",
    child: image,
    radius: 50,
    elevation: 2,
    borderColor: borderColor,
    borderWidth: borderWith,
    cacheImage: true,
  );
  // return Container(decoration: BoxDecoration(shape: BoxShape.circle,image: DecorationImage(fit: BoxFit.fitWidth,image: image)),);
}

Widget ErrorLoading({String? title, Function? retry}) {
  title = title ?? "خطا هنگام دریافت اطلاعات از سرور! لطفا مجددا تلاش کنید.";
  RefreshController c = RefreshController();
  return SmartRefresher(
    controller: c,
    onRefresh: () {
      if (retry != null) {
        retry();
      }
    },
    header: const MaterialClassicHeader(),
    child: Center(
        child: Container(
      child: Column(
        children: [
          Lottie.asset('assets/animations/server_error.json', height: 350),
          ColoredText(
            title,
            textDirection: TextDirection.rtl,
            textColor: Colors.red,
          ),
        ],
      ),
    )),
  );
}

Widget Loading() {
  return Center(
    child: CircularProgressIndicator(),
  );
  return Center(
      child: Container(
    child: Lottie.asset('assets/animations/loading_main1.json', height: 350),
  ));
}

bool isLink(String? value) {
  value ??= "";
  return value.startsWith(RegExp("^(http|https)://"));
}

Future<String> getUrlContent(String url) async {
  String result = "";
  HttpClient client = HttpClient();
  var request = await client.postUrl(Uri.parse(url));
  request.close().then((response) {
    utf8.decoder.bind(response.cast<List<int>>()).listen((content) {
      result = content;
    });
  });
  return result;
}

reloadApp() async {
  loadingDialog("لطفا صبر کنید ...");
  GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  GetStorage _getStorage = GetStorage();
  await getPersonInfo(_getConnect, _getStorage);
  await getWalletInfo(_getConnect, _getStorage);
  Get.back();
  Get.offAll(LoginScreen());
}

getPersonInfo(_getConnect, _getStorage) async {
  ProfileInformation profileInformation;
  if (_getStorage.read('token') == null) {
    return;
  }
  final _request = await _getConnect.get(profileInformationUrl, headers: {
    'accept': 'application/json',
    'Authorization': 'Bearer ${_getStorage.read('token')}'
  });
  try {
    profileInformation = profileInformationFromJson(_request.bodyString ?? "");
    userPhoneNumber = profileInformation.mobile;
    userSavedId = profileInformation.userId;
    userSavedFirstName = profileInformation.firstName;
    userSavedLastName = profileInformation.lastName;
    userSavedName = "$userSavedFirstName $userSavedLastName";
  } catch (e) {
    e.printError();
  }
}

void checkForValidSubsOrBuy(currentType, controller, {onContinue}) {
  if (currentType == TabbarTypes.NATIONAL) {
    if (controller.validatedSubs['isNationalSubValid'].toString() == "false") {
      Get.defaultDialog(
          title: "شما اشتراک بخش آزمون ها را ندارید",
          titleStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          content: SubscribeDialog(currentType));
      return;
    }
  } else if (currentType == TabbarTypes.ADULT) {
    if (controller.validatedSubs['isAdultSubValid'].toString() == "false") {
      Get.defaultDialog(
          title: "شما اشتراک بخش بزرگسالان را ندارید",
          titleStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          content: SubscribeDialog(currentType));
      return;
    }
  } else if (currentType == TabbarTypes.CHILD) {
    if (controller.validatedSubs['isChildSubValid'].toString() == "false") {
      Get.defaultDialog(
          title: "شما اشتراک بخش کودکان را ندارید",
          titleStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          content: SubscribeDialog(currentType));
      return;
    }
  }
  onContinue();
}

getWalletInfo(_getConnect, _getStorage) async {
  final _request1 = await _getConnect.get(getUserProfile, headers: {
    'accept': 'application/json',
    'Authorization': 'Bearer ${_getStorage.read('token')}'
  });
  try {
    savedWalletInfo = walletInfoModelFromJson(
        (json.decode(_request1.bodyString ?? "")['walletInfo'] ?? ""));
  } catch (e) {
    savedWalletInfo = WalletInfo(
        currentPrice: "0",
        blockPrice: "0",
        totalPrice: "0",
        lastMonthPrice: "0",
        pays: "");
    e.printError();
  }
  Get.put(OnlineClassController());
  Get.put(CustomVideoController());
}

Widget NoData({String? message}) {
  String mC = "";
  mC = message ?? "هیچ اطلاعاتی یافت نشد!";
  return Directionality(
    textDirection: TextDirection.rtl,
    child: Center(
        child: Container(
      child: Column(
        children: [
          Lottie.asset('assets/animations/no_data.json', height: 350),
          ColoredText(
            mC,
            textDirection: TextDirection.rtl,
            textColor: Colors.deepOrange,
          ),
        ],
      ),
    )),
  );
}

String replaceQuote(value, List<String> char) {
  String result = value.toString();
  char.forEach((element) {
    result = result
        .replaceAll(element + " \"", element + "\"")
        .replaceAll(element + " ”", element + "”")
        .replaceAll(element + " “", element + "“")
        .replaceAll(element + " ,", element + ",")
        .replaceAll(element + " ،", element + "،");
  });
  return result;
}

bool isOrientationHorizontal = false;

void toggleUpdateResolution() {
  if (isOrientationHorizontal) {
    exitFullScreenMode();
  } else {
    enterFullScreenMode();
  }
}

void exitFullScreenMode() {
  isOrientationHorizontal = false;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

  // FullScreen.exitFullScreen();
}

/* To Update Screen Resolution LandscapeLeft,LandscapeRight */
void enterFullScreenMode() {
  isOrientationHorizontal = true;
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  // FullScreen.enterFullScreen(FullScreenMode.EMERSIVE);
}

String whiteSpaceForSentence(String sentence) {
  String res = sentence
          .replaceAll(RegExp(r"(?! )\s+| \s+"), " ")
          .replaceAll('!', "! ") // برای ایجاد فاصله بعد از علامت تعجب
          .replaceAll('?', "? ") // برای ایجاد فاصله بعد از علامت سوال
          .replaceAll('؟', "؟ ") // برای ایجاد فاصله بعد از علامت سوال (فارسی)
          .replaceAll(".", ". ") // برای ایجاد فاصله بعد از علامت نقطه
          .replaceAll(",", ", ") // برای ایجاد فاصله بعد از علامت کاما
      ;
  return replaceQuote(res, [
    "!",
    "?",
    "؟",
    ".",
    ",",
    "،",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9"
  ]);
}

String getText(String text, {int? length}) {
  String result = text;
  length ??= 15;
  if (text.length > length) {
    result = "${text.substring(0, length)}...";
  }
  return result;
}

Widget resourceIconDetail(
    {String iconPath = "", String title = "", double iconSize = 18}) {
  Color mainColor = Colors.black.withOpacity(0.5);
  return Row(
    children: [
      Flexible(
        flex: 0,
        child: ImageIcon(
          AssetImage(iconPath),
          size: iconSize,
          color: primaryDarkMore,
        ),
      ),
      SizedBox(
        width: 8,
      ),
      Flexible(
          flex: 1,
          child: Container(
              width: double.infinity,
              child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText(title,
                    maxFontSize: 12,
                    minFontSize: 7,
                    maxLines: 1,
                    style:
                        TextStyle(color: mainColor, fontFamily: "IRANSansPro")),
              ))),
    ],
  );
}

Widget resourceItemHolder({
  String imagePath = "",
  String title = "",
  bool hasMore = false,
  String itemType = "podcast",
  VoidCallback? onClick,
  List<Widget>? extraContent,
  int index = 0,
}) {
  extraContent ??= [];
  String iconPath = "";
  if (itemType == "podcast") {
    iconPath = "assets/images/mic_1.png";
  } else if (itemType == "video") {
    iconPath = "assets/images/video_1.png";
  }
  return InkWell(
    onTap: onClick,
    child: Container(
      width: double.infinity,
      height: 110,
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: (index % 2 == 0)
            ? Colors.black.withOpacity(0.03)
            : Colors.transparent,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Flexible(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(color:primaryDarkMore.withOpacity(0.2),borderRadius: BorderRadius.circular(8)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                            imageUrl: imagePath, fit: BoxFit.fill),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black.withOpacity(0.23)),
                        margin:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2, vertical: 3),
                            child: ImageIcon(
                              AssetImage(iconPath),
                              color: Colors.white.withOpacity(0.8),
                              size: 15,
                            )),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              width: 12,
            ),
            Flexible(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColoredText(
                        title,
                        maxLines: 1,
                        textSize: 13,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Column(
                        children: extraContent,
                      ),
                    ],
                  ),
                )),
            SizedBox(
              width: 4,
            ),
            Flexible(
                flex: 0,
                child: hasMore
                    ? Center(
                    child: Container(
                      child: Icon(
                        Icons.format_list_bulleted_outlined,
                        color: Colors.black.withOpacity(0.23),
                        size: 30,
                      ),
                    ))
                    : Center(
                        child: Container(
                        child: Icon(
                          Icons.play_circle_outline,
                          color: Colors.black.withOpacity(0.23),
                          size: 30,
                        ),
                      ))),
            SizedBox(
              width: 4,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget resourcesHolder(
    {String title = "",
    String iconPath = "",
    EdgeInsets? margin,
    Widget? iconWidget,
    bool normalType = true,
    String? titleName = "title",
    String? imagePathName = "imagePath",
    onClick,
    items}) {
  margin ??= EdgeInsets.symmetric(horizontal: 18, vertical: 8);
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          spreadRadius: 1,
          blurRadius: 2,
          offset: Offset(0, 1.5),
        ),
      ],
    ),
    margin: margin,
    padding: EdgeInsets.symmetric(vertical: 8),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 0,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: Get.width / 30,
                  ),
                  child: SizedBox(
                    // width: Get.width / 30,
                    height: Get.height / 40,
                    child: iconWidget ??
                        Image.asset(
                          iconPath,
                          fit: BoxFit.fill,
                        ),
                  ),
                ),
                ColoredText(
                  title,
                  textSize: 14,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Container(
          width: double.infinity,
          height: 180,
          child: ListView.builder(
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () {
                    onClick(index);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    // decoration: BoxDecoration(border: Border.all(color: Colors.black12,width: 1),borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: normalType
                                  ? getUrl(items[index][imagePathName])
                                  : items[index].image,
                              width: 90,
                              height: 140,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        ColoredText(
                          getText(normalType
                              ? items[index][titleName]
                              : items[index].title),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          textSize: 12,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        )
      ],
    ),
  );
}

Widget resourcesBackground({Widget? child, double? width, double? height}) {
  return Container(
    width: width,
    height: height,
    margin: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
        //     gradient: LinearGradient(colors: [
        //   Colors.white,
        //   Colors.white,
        //   Colors.white,
        //   Colors.white,
        //   Colors.grey.shade200,
        //   Colors.grey.shade300,
        //   Colors.white,
        // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade200),
    child: Stack(
      children: [
        // Container(
        //   width: double.infinity,
        //   child: Image.asset(
        //     "assets/images/user_teacher_pattern.png",
        //     repeat: ImageRepeat.repeatX,
        //     color: Colors.white,
        //   ),
        // ),
        child ?? Container(),
      ],
    ),
  );
}

Widget getVideoView(var path, CustomVideoType type,
    {bool? withThumb,
    bool? retryImage,
    bool isLoop = false,
    bool? showPreviewOverlay,
    String? customPreviewLink,
    bool? fullscreenOnStart}) {
  withThumb ??= false;
  retryImage ??= false;
  fullscreenOnStart ??= true;
  showPreviewOverlay ??= true;
  if (customPreviewLink == "") {
    customPreviewLink = null;
  }
  File? file;
  if (type == CustomVideoType.STORAGE) {
    file = path;
  }
  RxBool isImageReady = (!withThumb).obs;
  RxBool isVideoInitializing = false.obs;

  var videoPlayerWid = CustomVideoPlayer(
    null,
    null,
    isInitialized: true,
    isLoop: isLoop,
    initializedVideoPlayerController: customVideoPlayerController,
  );
  isImageReady = retryImage.obs;
  return Obx(() => isImageReady.value
      ? customVideoPlayerController!.isInitialize.value
          ? videoPlayerWid
          : Loading()
      : LayoutBuilder(builder: (context, constraints) {
          return Stack(
            children: [
              type == CustomVideoType.NETWORK
                  ? Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: customPreviewLink ??
                              getThumbnailUrl(url: path, size: "720x480"),
                          width: double.infinity,
                          height: double.infinity,
                          progressIndicatorBuilder: (
                            BuildContext context,
                            String url,
                            DownloadProgress progress,
                          ) {
                            double downloaded = progress.progress ?? 0;
                            return LiquidLinearProgressIndicator(
                              value: downloaded,
                              // Defaults to 0.5.
                              valueColor: AlwaysStoppedAnimation(primaryLight),
                              // Defaults to the current Theme's accentColor.
                              backgroundColor: Colors.white,
                              // Defaults to the current Theme's backgroundColor.
                              direction: Axis.vertical,
                              // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                              center: ColoredText(""),
                            );
                          },
                          fit: BoxFit.cover,
                        ),
                        showPreviewOverlay!
                            ? Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black38,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white30, width: 1)),
                                      width: constraints.maxWidth / (3.5 * 1),
                                      height: constraints.maxHeight / (3.5 * 1),
                                      child: InkWell(
                                        onTap: () async {
                                          if (customVideoPlayerController !=
                                              null) {
                                            customVideoPlayerController!
                                                .dispose();
                                          }
                                          isVideoInitializing.value = true;
                                          var fileInfo =
                                              await checkCacheFor(path);
                                          if (fileInfo == null) {
                                            customVideoPlayerController =
                                                CustomVideoPlayerController(
                                                    CachedVideoPlayerController
                                                        .network(path,
                                                            videoPlayerOptions:
                                                                VideoPlayerOptions(
                                                                    mixWithOthers:
                                                                        true)),
                                                    autoInit: false,
                                                    fullscreenOnStart:
                                                        fullscreenOnStart);
                                          } else {
                                            customVideoPlayerController =
                                                CustomVideoPlayerController(
                                                    CachedVideoPlayerController.file(
                                                        fileInfo.file,
                                                        videoPlayerOptions:
                                                            VideoPlayerOptions(
                                                                mixWithOthers:
                                                                    true)),
                                                    autoInit: false,
                                                    fullscreenOnStart: true);
                                          }

                                          customVideoPlayerController!
                                              .init(autoPlay: true)
                                              .then((value) {
                                            if (fileInfo == null) {
                                              checkedForUrl(path);
                                            }
                                            isImageReady.value = true;
                                          });
                                          customVideoPlayerTag.value = path;
                                        },
                                        child: Obx(() => SizedBox(
                                            width: (constraints.maxWidth /
                                                (3.5 * 2)),
                                            height: (constraints.maxHeight /
                                                (3.5 * 2)),
                                            child: isVideoInitializing.value
                                                ? Loading()
                                                : Icon(
                                                    Icons.play_arrow_rounded,
                                                    color: Colors.white70,
                                                    size:
                                                        (constraints.maxWidth /
                                                            (3.5 * 2)),
                                                  ))),
                                      )),
                                ))
                            : Container()
                      ],
                    )
                  : file!.existsSync()
                      ? CustomCachedVideoPreviewWidget(
                          path: path.path,
                          placeHolder: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          type: SourceType.local,
                          fileImageBuilder: (context, file) {
                            return Stack(
                              children: [
                                Image.memory(
                                  file,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.fill,
                                ),
                                showPreviewOverlay!
                                    ? Align(
                                        alignment: Alignment.center,
                                        child: InkWell(
                                          onTap: () {},
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.white30,
                                                      width: 1)),
                                              width: constraints.maxWidth /
                                                  (3.5 * 1),
                                              height: constraints.maxHeight /
                                                  (3.5 * 1),
                                              child: InkWell(
                                                onTap: () {
                                                  if (customVideoPlayerController !=
                                                      null) {
                                                    customVideoPlayerController!
                                                        .dispose();
                                                  }
                                                  isVideoInitializing.value =
                                                      true;
                                                  // if (!customVideoPlayerController!.isCurrentPlayer(path)) {
                                                  //   customVideoPlayerController!.initVideoPlayer(path, type,
                                                  //       tag: path, autoInit: false);
                                                  // }
                                                  customVideoPlayerController =
                                                      CustomVideoPlayerController(
                                                          CachedVideoPlayerController.file(
                                                              path,
                                                              videoPlayerOptions:
                                                                  VideoPlayerOptions(
                                                                      mixWithOthers:
                                                                          true)),
                                                          autoInit: false,
                                                          fullscreenOnStart:
                                                              fullscreenOnStart);

                                                  customVideoPlayerController!
                                                      .init(autoPlay: true)
                                                      .then((value) {
                                                    isImageReady.value = true;
                                                  });
                                                  customVideoPlayerTag.value =
                                                      path.path;
                                                },
                                                child: Obx(() => SizedBox(
                                                    width:
                                                        (constraints.maxWidth /
                                                            (3.5 * 2)),
                                                    height:
                                                        (constraints.maxHeight /
                                                            (3.5 * 2)),
                                                    child: isVideoInitializing
                                                            .value
                                                        ? Loading()
                                                        : Icon(
                                                            Icons
                                                                .play_arrow_rounded,
                                                            color:
                                                                Colors.white70,
                                                            size: (constraints
                                                                    .maxWidth /
                                                                (3.5 * 2)),
                                                          ))),
                                              )),
                                        ))
                                    : Container(),
                              ],
                            );
                          },
                        )
                      : Container(
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: Lottie.asset(
                              'assets/animations/select_image.json'),
                        ),
            ],
          );
        }));
}

Widget bottomBarItem({
  required BuildContext context,
  bool nextButton = true,
  var introKey,
  String introDesc = "",
  bool previousButton = true,
  bool active = false,
  String iconPath = "",
}) {
  String _nextButtonText = "بعدی";
  String _previousButtonText = "رد کردن";
  return Opacity(
    opacity: active ? 1 : 0.4,
    child: CustomShowcase(
      onNextButtonTap: () {
        ShowCaseWidget.of(context).next();
      },
      onPreviousButtonTap: () {
        ShowCaseWidget.of(context).dismiss();
      },
      description: introDesc,
      key: introKey,
      child: Image.asset(
        iconPath,
        color: Colors.white,
      ),
    ),
  );
  //Row(
  //                                   children: [
  //                                     Flexible(
  //                                         flex: 1,
  //                                         child: Container(
  //                                           width: double.infinity,
  //                                           height: double.infinity,
  //                                           margin: EdgeInsets.symmetric(
  //                                               horizontal: 12, vertical: 8),
  //                                           decoration: BoxDecoration(),
  //                                           child: CustomShowcase(
  //                                             nextButtonText: "رد کردن",
  //                                             previousButtonText: "بعدی",
  //                                             onPreviousButtonTap: (){
  //                                               ShowCaseWidget.of(_context).next();
  //                                             },
  //                                             onNextButtonTap: (){
  //                                               ShowCaseWidget.of(_context).dismiss();
  //                                             },
  //                                             disableDefaultTargetGestures: true,
  //                                             targetPadding:
  //                                             const EdgeInsets.all(5),
  //                                             key: _controller.keyOne,
  //                                             description:
  //                                             _controller.intros[0],
  //                                             child: InkWell(
  //                                               onTap: () {
  //                                                 _controller
  //                                                     .changeCurrentPage(0,_context);
  //                                               },
  //                                               child: Center(
  //                                                   child: Column(
  //                                                     children: [
  //                                                       Expanded(
  //                                                         flex:1,
  //                                                         child: Opacity(
  //                                                             opacity: _controller
  //                                                                 .getCurrentPos() ==
  //                                                                 0
  //                                                                 ? 1
  //                                                                 : 0.4,
  //                                                             child: Image.asset(
  //                                                               "assets/images/homeS.png",
  //                                                               color: Colors.white,
  //                                                             )),
  //                                                       ),
  //                                                       SizedBox(height: 2,),
  //                                                       Expanded(
  //                                                         flex:0,
  //                                                         child: Center(
  //                                                             child: ColoredText(
  //                                                               "خانه",
  //                                                               textColor: _controller
  //                                                                   .getCurrentPos() ==
  //                                                                   0
  //                                                                   ? Colors.white
  //                                                                   : Colors.white38,
  //                                                               textSize: 12,
  //                                                               fontWeight:
  //                                                               FontWeight.bold,
  //                                                             )),
  //                                                       ),
  //                                                     ],
  //                                                   )),
  //                                             ),
  //                                           ),
  //                                         )),
  //                                     Flexible(
  //                                         flex: 1,
  //                                         child: Container(
  //                                           width: double.infinity,
  //                                           height: double.infinity,
  //                                           margin: EdgeInsets.symmetric(
  //                                               horizontal: 12, vertical: 8),
  //                                           decoration: BoxDecoration(),
  //                                           child: CustomShowcase(
  //                                             nextButtonText: "رد کردن",
  //                                             previousButtonText: "بعدی",
  //                                             onPreviousButtonTap: (){
  //                                               ShowCaseWidget.of(_context).next();
  //                                             },
  //                                             onNextButtonTap: (){
  //                                               ShowCaseWidget.of(_context).dismiss();
  //                                             },
  //                                             disableDefaultTargetGestures: true,
  //                                             targetPadding:
  //                                             const EdgeInsets.all(5),
  //                                             key: _controller.keyTwo,
  //                                             description:
  //                                             _controller.intros[1],
  //                                             child: InkWell(
  //                                               onTap: () {
  //                                                 _controller
  //                                                     .changeCurrentPage(1,_context);
  //                                               },
  //                                               child: Center(
  //                                                   child: Column(
  //                                                     children: [
  //                                                       Expanded(
  //                                                         flex:1,
  //                                                         child: Opacity(
  //                                                             opacity: _controller
  //                                                                 .getCurrentPos() ==
  //                                                                 1
  //                                                                 ? 1
  //                                                                 : 0.4,
  //                                                             child: Image.asset(
  //                                                               "assets/images/book_enable.png",
  //                                                               color: Colors.white,
  //                                                             )),
  //                                                       ),
  //                                                       SizedBox(height: 2,),
  //                                                       Expanded(
  //                                                         flex:0,
  //                                                         child: Center(
  //                                                             child: ColoredText(
  //                                                               "منابع",
  //                                                               textColor: _controller
  //                                                                   .getCurrentPos() ==
  //                                                                   1
  //                                                                   ? Colors.white
  //                                                                   : Colors.white38,
  //                                                               textSize: 12,
  //                                                               fontWeight:
  //                                                               FontWeight.bold,
  //                                                             )),
  //                                                       ),
  //                                                     ],
  //                                                   )),
  //                                             ),
  //                                           ),
  //                                         )),
  //                                     Flexible(
  //                                         flex: 1,
  //                                         child: Container(
  //                                           width: double.infinity,
  //                                           height: double.infinity,
  //                                           margin: EdgeInsets.symmetric(
  //                                               horizontal: 12, vertical: 8),
  //                                           decoration: BoxDecoration(),
  //                                           child: CustomShowcase(
  //                                             nextButtonText: "رد کردن",
  //                                             previousButtonText: "بعدی",
  //                                             onPreviousButtonTap: (){
  //                                               ShowCaseWidget.of(_context).next();
  //                                             },
  //                                             onNextButtonTap: (){
  //                                               ShowCaseWidget.of(_context).dismiss();
  //                                             },
  //                                             disableDefaultTargetGestures: true,
  //                                             targetPadding:
  //                                             const EdgeInsets.all(5),
  //                                             key: _controller.keyThree,
  //                                             description:
  //                                             _controller.intros[2],
  //                                             child: InkWell(
  //                                               onTap: () {
  //                                                 _controller
  //                                                     .changeCurrentPage(2,_context);
  //                                               },
  //                                               child: Center(
  //                                                   child: Column(
  //                                                     children: [
  //                                                       Expanded(
  //                                                         flex:1,
  //                                                         child: Opacity(
  //                                                             opacity: _controller
  //                                                                 .getCurrentPos() ==
  //                                                                 2
  //                                                                 ? 1
  //                                                                 : 0.4,
  //                                                             child: Image.asset(
  //                                                               "assets/images/course.png",
  //                                                               color: Colors.white,
  //                                                             )),
  //                                                       ),
  //                                                       SizedBox(height: 2,),
  //                                                       Expanded(
  //                                                         flex:0,
  //                                                         child: Center(
  //                                                             child: ColoredText(
  //                                                               "دوره ها",
  //                                                               textColor: _controller
  //                                                                   .getCurrentPos() ==
  //                                                                   2
  //                                                                   ? Colors.white
  //                                                                   : Colors.white38,
  //                                                               textSize: 12,
  //                                                               fontWeight:
  //                                                               FontWeight.bold,
  //                                                             )),
  //                                                       ),
  //                                                     ],
  //                                                   )),
  //                                             ),
  //                                           ),
  //                                         )),
  //                                     Flexible(
  //                                         flex: 1,
  //                                         child: Container(
  //                                           width: double.infinity,
  //                                           height: double.infinity,
  //                                           margin: EdgeInsets.symmetric(
  //                                               horizontal: 12, vertical: 8),
  //                                           decoration: BoxDecoration(),
  //                                           child: CustomShowcase(
  //                                             nextButtonText: "رد کردن",
  //                                             previousButtonText: "بعدی",
  //                                             onPreviousButtonTap: (){
  //                                               ShowCaseWidget.of(_context).next();
  //                                             },
  //                                             onNextButtonTap: (){
  //                                               ShowCaseWidget.of(_context).dismiss();
  //                                             },
  //                                             disableDefaultTargetGestures: true,
  //                                             targetPadding:
  //                                             const EdgeInsets.all(5),
  //                                             key: _controller.keySeven,
  //                                             description:
  //                                             _controller.intros[6],
  //                                             child: InkWell(
  //                                               onTap: () {
  //                                                 _controller
  //                                                     .changeCurrentPage(3,_context);
  //                                               },
  //                                               child: Center(
  //                                                   child: Column(
  //                                                     children: [
  //                                                       Expanded(
  //                                                         flex:1,
  //                                                         child: Opacity(
  //                                                             opacity: _controller
  //                                                                 .getCurrentPos() ==
  //                                                                 3
  //                                                                 ? 1
  //                                                                 : 0.4,
  //                                                             child: Image.asset(
  //                                                               "assets/images/online_class.png",
  //                                                               color: Colors.white,
  //                                                             )),
  //                                                       ),
  //                                                       SizedBox(height: 2,),
  //                                                       Expanded(
  //                                                         flex:0,
  //                                                         child: Center(
  //                                                             child: ColoredText(
  //                                                               "کلاس آنلاین",
  //                                                               textColor: _controller
  //                                                                   .getCurrentPos() ==
  //                                                                   3
  //                                                                   ? Colors.white
  //                                                                   : Colors.white38,
  //                                                               textSize: 12,
  //                                                               fontWeight:
  //                                                               FontWeight.bold,
  //                                                             )),
  //                                                       ),
  //                                                     ],
  //                                                   )),
  //                                             ),
  //                                           ),
  //                                         )),
  //                                   ],
  //                                 )
}

Future<FileInfo?> checkCacheFor(String url) async {
  final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
  return value;
}

void checkedForUrl(String url) async {
  await DefaultCacheManager().getSingleFile(url).then((value) {});
}

String smallerPrice(val1, val2) {
  var var1 = int.parse(val1.toString().replaceAll(",", ""));
  var var2 = int.parse(val2.toString().replaceAll(",", ""));
  if (var1 > var2) {
    return var2.toString();
  } else {
    return var1.toString();
  }
}

String formatPrice(value,
    {bool? showUnit, bool? showFreeText, int? count, String? unitText}) {
  showUnit ??= true;
  showFreeText ??= true;
  unitText ??= "تومان";
  count ??= 1;
  if (value.toString() == "null" || value.toString().trim().isEmpty) {
    value = "0";
  }
  String val = value.toString();
  if (val == "0") {
    if (showFreeText) {
      return "رایگان";
    }
  }
  var formatter = intl.NumberFormat.currency(
    locale: null,
    name: null,
    symbol: "",
    decimalDigits: 0,
    customPattern: null,
  );
  String unit = showUnit ? " $unitText " : "";
  return "${formatter.format(int.parse(val.replaceAll(",", "")))}$unit";
}

String getCurrentDayDatePicker(int index, {bool? allText}) {
  allText ??= false;
  String day = "";
  if (index == 0) {
    day = "شنبه";
  } else if (index == 1) {
    if (allText) {
      day = "یک‌شنبه";
    } else {
      day = "1شنبه";
    }
  } else if (index == 2) {
    if (allText) {
      day = "دو‌شنبه";
    } else {
      day = "2شنبه";
    }
  } else if (index == 3) {
    if (allText) {
      day = "سه‌شنبه";
    } else {
      day = "3شنبه";
    }
  } else if (index == 4) {
    if (allText) {
      day = "چهار‌شنبه";
    } else {
      day = "4شنبه";
    }
  } else if (index == 5) {
    if (allText) {
      day = "یک‌شنبه";
    } else {
      day = "5شنبه";
    }
  } else if (index == 6) {
    day = "جمعه";
  } else {
    if (index < 0) {
      return getCurrentDayDatePicker(6, allText: allText);
    } else if (index > 6) {
      return getCurrentDayDatePicker(0, allText: allText);
    } else {
      day = "???????";
    }
  }
  return day;
}

Future<String> getCurrentHourMinDatePickerAsync(int pos,
    {int? startHour}) async {
  return getCurrentHourMinDatePicker(pos, startHour: startHour);
}

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;
}

String getCurrentHourMinDatePicker(int pos, {int? startHour}) {
  startHour ??= 14;
  String res = "00:00";
  int baseInt = startHour + pos;
  double mainInt = baseInt / 2;
  var mainStrings = mainInt.toString().split(".");
  int hour = int.parse(mainStrings[0]);
  int minutes = int.parse(mainStrings[1]);
  if (hour < 10) {
    res = "0$hour";
  } else {
    res = "$hour";
  }
  res += ":";
  if (minutes > 0) {
    res += "30";
  } else {
    res += "00";
  }
  return res;
}

Future<bool> isScreenForced() async {
  return await Wakelock.enabled;
}

int getExtendedVersionNumber(String version) {
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
}

keepScreenOn() {
  Wakelock.enable();
}

keepScreenNormal() {
  Wakelock.disable();
}

Future<List<SentenceModel>> getSrtSubTitle(lang, id, link) async {
  var returnItem;
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  if (link.toString().trim().isNotEmpty) {
    bool exists = await readExists(getSrtFileName(lang, id, link.toString()));
    if (!exists) {
      var en = await _getConnect.get(link);
      if (!en.hasError) {
        await writeString(
            en.bodyString ?? "", getSrtFileName(lang, id, link.toString()));
      }
    }
    String data = await readString(getSrtFileName(lang, id, link.toString()));
    _getConnect.get(link).then((value) {
      if (value.bodyString != null && data.length != value.bodyString!.length) {
        writeString(
            value.bodyString ?? "", getSrtFileName(lang, id, link.toString()));
      }
    });
    var list = await getFullFromSrt(lang == "fa", strP.parseSrt(data));
    returnItem = list.sentenceModel;
  }
  return returnItem;
}

Widget subtitleLoading({bool hasFirstItem = true}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    enabled: true,
    child: ListView.builder(
        itemCount: 18,
        shrinkWrap: true,
        itemBuilder: (_, index) {
          if (index == 0 && hasFirstItem) {
            return Container(
              width: double.infinity,
              height: 250,
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 60),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.white),
            );
          }
          return Container(
            width: double.infinity,
            height: 30,
            margin: EdgeInsets.only(
                bottom: 12,
                top: 12,
                right: (index % 2 == 0) ? 0 : 35,
                left: (index % 2 == 0) ? 35 : 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8), color: Colors.white),
          );
        }),
  );
}

Future<String> getFormattedFaEnSubTitle(String fa, String en) async {
  String result = "";
  var faList = await getFullFromSrt(true, strP.parseSrt(fa));
  var enList = await getFullFromSrt(false, strP.parseSrt(en));
  List<SentenceModel> faReturnItem = faList.sentenceModel;
  List<SentenceModel> enReturnItem = enList.sentenceModel;
  for (int i = 0; i < enReturnItem.length; i++) {
    SentenceModel faSubItem = faReturnItem[i];
    SentenceModel enSubItem = enReturnItem[i];
    String rs = "";
    for (int o = 0; o < enSubItem.sentencesList.length; o++) {
      SentenceIndex enMainIndex = enSubItem.sentencesList[o];
      SentenceIndex faMainIndex = faSubItem.sentencesList[o];
      rs += enMainIndex.text ?? "";
    }
  }
  return result;
}

Future<String> getRawSrtSubTitle(lang, id, link) async {
  var returnItem = "";
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  if (link.toString().trim().isNotEmpty) {
    bool exists = await readExists(getSrtFileName(lang, id, link.toString()));
    if (!exists) {
      var en = await _getConnect.get(link);
      if (!en.hasError) {
        await writeString(
            en.bodyString ?? "", getSrtFileName(lang, id, link.toString()));
      }
    }
    String data = await readString(getSrtFileName(lang, id, link.toString()));
    returnItem = data;
  }
  return returnItem;
}

writeString(String text, String itemId) async {
  final Directory directory = await path.getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/$itemId.txt');
  await file.writeAsString(text);
}

Future<bool> readExists(String itemId) async {
  bool exists = false;
  final Directory directory = await path.getApplicationDocumentsDirectory();
  final File file = File('${directory.path}/$itemId.txt');
  exists = file.existsSync();
  return exists;
}

Future<String> readString(String itemId) async {
  String text = "";
  try {
    final Directory directory = await path.getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$itemId.txt');
    text = await file.readAsString();
  } catch (e) {}
  return text;
}

String forceRTL(String text, bool rtl) {
  if (rtl) {
    if (intl.Bidi.detectRtlDirectionality(text)) {
      text = intl.Bidi.enforceLtrInText(text);
    } else {
      text = intl.Bidi.enforceRtlInText(text);
    }
  } else {
    text = intl.Bidi.enforceLtrInText(text);
  }
  return text;
}

Future<SrtResult> getFullFromSrt(bool fa, List<Subtitle> paragraphs) async {
  List<SentenceModel> listItems = [];
  List<List<InlineSpan>> textsSpans = [];
  List<Subtitle> currentP = paragraphs;
  String result = "";
  String timeResult = "";
  String eTimeResult = "";
  for (var res in currentP) {
    var a = res.lines.join(" ");
    if (a.contains("/l")) {
      result += a.replaceAll("/l", "") + "__NEWSENTENCE__" + "/l";
    } else {
      result += a + "__NEWSENTENCE__";
    }
    timeResult += res.range.begin.toString() + "__NEWSENTENCE__";
    eTimeResult += res.range.end.toString() + "__NEWSENTENCE__";
    if (a.contains("/l")) {
      timeResult += "/l";
      eTimeResult += "/l";
    }
  }
  List<String> b = result.split("/l");
  List<String> tb = timeResult.split("/l");
  List<String> etb = eTimeResult.split("/l");
  for (int i = 0; i < b.length; i++) {
    String parag = b[i];
    List<SentenceIndex> sentencesList = [];
    List<InlineSpan> inlineSpan = [];
    List<String> a = parag.split("__NEWSENTENCE__");
    List<String> ta = tb[i].toString().split("__NEWSENTENCE__");
    List<String> eta = etb[i].toString().split("__NEWSENTENCE__");

    for (int o = 0; o < a.length; o++) {
      String sentens =
          a[o].replaceAll("__NEWSENTENCE__", " ").replaceAll("/l", " ");
      String forCheck =
          ta[o].replaceAll("__NEWSENTENCE__", " ").replaceAll("/l", " ");
      String eForCheck =
          eta[o].replaceAll("__NEWSENTENCE__", " ").replaceAll("/l", " ");
      int currentTime = 0;
      int currentETime = 0;
      int diffrence = 350;
      if (StringHelper()
          .filterString(forCheck.toString().trim())
          .isNumericOnly) {
        currentTime =
            int.parse(StringHelper().filterString(forCheck.toString().trim())) -
                diffrence;
      }
      if (StringHelper()
          .filterString(eForCheck.toString().trim())
          .isNumericOnly) {
        currentETime = int.parse(
                StringHelper().filterString(eForCheck.toString().trim())) -
            diffrence;
      }
      String txt = sentens.replaceAll(RegExp(r"(?! )\s+| \s+"), " ");
      // txt = forceRTL(txt,fa);
      inlineSpan.add(parseHtmlToTextSpan(
          whiteSpaceForSentence(txt.toString()), getSubtitleTextStyle(false)));
      sentencesList.add(SentenceIndex(
          listIndex: i,
          sentenceIndex: o,
          time: currentTime,
          endTime: currentETime,
          key: GlobalKey(),
          text: txt));
    }
    listItems.add(SentenceModel(sentencesList: sentencesList));
    textsSpans.add(inlineSpan);
  }
  return SrtResult(sentenceModel: listItems, subtitleTimes: textsSpans);
}

SrtResult noAsyncGetFullFromSrt(bool fa, List<Subtitle> paragraphs) {
  List<SentenceModel> listItems = [];
  List<List<InlineSpan>> textsSpans = [];
  List<Subtitle> currentP = paragraphs;
  String result = "";
  String timeResult = "";
  String eTimeResult = "";
  for (var res in currentP) {
    var a = res.lines.join(" ");
    if (a.contains("/l")) {
      result += a.replaceAll("/l", "") + "__NEWSENTENCE__" + "/l";
    } else {
      result += a + "__NEWSENTENCE__";
    }
    timeResult += res.range.begin.toString() + "__NEWSENTENCE__";
    eTimeResult += res.range.end.toString() + "__NEWSENTENCE__";
    if (a.contains("/l")) {
      timeResult += "/l";
      eTimeResult += "/l";
    }
  }
  List<String> b = result.split("/l");
  List<String> tb = timeResult.split("/l");
  List<String> etb = eTimeResult.split("/l");
  for (int i = 0; i < b.length; i++) {
    String parag = b[i];
    List<SentenceIndex> sentencesList = [];
    List<InlineSpan> inlineSpan = [];
    List<String> a = parag.split("__NEWSENTENCE__");
    List<String> ta = tb[i].toString().split("__NEWSENTENCE__");
    List<String> eta = etb[i].toString().split("__NEWSENTENCE__");

    for (int o = 0; o < a.length; o++) {
      String sentens =
          a[o].replaceAll("__NEWSENTENCE__", " ").replaceAll("/l", " ");
      String forCheck =
          ta[o].replaceAll("__NEWSENTENCE__", " ").replaceAll("/l", " ");
      String eForCheck =
          eta[o].replaceAll("__NEWSENTENCE__", " ").replaceAll("/l", " ");
      int currentTime = 0;
      int currentETime = 0;
      int diffrence = 350;
      if (StringHelper()
          .filterString(forCheck.toString().trim())
          .isNumericOnly) {
        currentTime =
            int.parse(StringHelper().filterString(forCheck.toString().trim())) -
                diffrence;
      }
      if (StringHelper()
          .filterString(eForCheck.toString().trim())
          .isNumericOnly) {
        currentETime = int.parse(
                StringHelper().filterString(eForCheck.toString().trim())) -
            diffrence;
      }
      String txt = sentens.replaceAll(RegExp(r"(?! )\s+| \s+"), " ");
      // txt = forceRTL(txt,fa);
      inlineSpan.add(parseHtmlToTextSpan(
          whiteSpaceForSentence(txt.toString()), getSubtitleTextStyle(false)));
      sentencesList.add(SentenceIndex(
          listIndex: i,
          sentenceIndex: o,
          time: currentTime,
          endTime: currentETime,
          key: GlobalKey(),
          text: txt));
    }
    listItems.add(SentenceModel(sentencesList: sentencesList));
    textsSpans.add(inlineSpan);
  }
  return SrtResult(sentenceModel: listItems, subtitleTimes: textsSpans);
}

List<SentenceModel> getFullParagraphs(bool fa, var paragraphs) {
  List<SentenceModel> listItemsFa = [];
  List<SentenceModel> listItemsEn = [];
  int size = paragraphs.length;
  String fullFa = "", fullEn = "";
  int time = 0;
  var times = <int>[];
  String timesString = "";
  String endTimesString = "";
  for (int i = 0; i < size; i++) {
    fullFa += paragraphs[i].fa;
    fullEn += paragraphs[i].en;

    timesString += paragraphs[i].pst.toString() + "__NEWSENTENCE__";
    endTimesString += paragraphs[i].pstEnd.toString() + "__NEWSENTENCE__";
    if (paragraphs[i].en.toString().contains("__NEWPARAGRAPH__")) {
      timesString += "__NEWPARAGRAPH__";
      endTimesString += "__NEWPARAGRAPH__";
    }
  }
  List<String> faListItems = fullFa.split("__NEWPARAGRAPH__");
  List<String> enListItems = fullEn.split("__NEWPARAGRAPH__");
  List<String> timesStrings = timesString.split("__NEWPARAGRAPH__");
  List<String> endTimesStrings = timesString.split("__NEWPARAGRAPH__");
  for (int i = 0; i < faListItems.length; i++) {
    String currentFullText = faListItems[i];
    String currentFullTimes = timesStrings[i];
    String currentEndFullTimes = endTimesStrings[i];
    List<String> currentSentences = currentFullText.split("__NEWSENTENCE__");

    List<String> currentTimes = currentFullTimes.split("__NEWSENTENCE__");
    List<String> currentEndTimes = currentEndFullTimes.split("__NEWSENTENCE__");

    List<SentenceIndex> sentencesList = [];
    for (int o = 0; o < currentSentences.length; o++) {
      String currentSentence = currentSentences[o];
      int currentTime = 0;
      if (StringHelper()
          .filterString(currentTimes[o].toString().trim())
          .isNumericOnly) {
        currentTime = int.parse(
            StringHelper().filterString(currentTimes[o].toString().trim()));
      }
      int currentEndTime = 0;
      if (StringHelper()
          .filterString(currentEndTimes[o].toString().trim())
          .isNumericOnly) {
        currentTime = int.parse(
            StringHelper().filterString(currentEndTimes[o].toString().trim()));
      }
      currentSentence.replaceAll("__NEWSENTENCE__", " ");
      sentencesList.add(SentenceIndex(
          listIndex: i,
          sentenceIndex: o,
          time: currentTime,
          endTime: currentEndTime,
          text: currentSentence.replaceAll(RegExp(r"(?! )\s+| \s+"), " ")));
    }
    listItemsFa.add(SentenceModel(sentencesList: sentencesList));
  }

  for (int i = 0; i < enListItems.length; i++) {
    String currentFullText = enListItems[i];
    String currentFullTimes = timesStrings[i];
    String currentEndFullTimes = endTimesStrings[i];
    List<String> currentSentences = currentFullText.split("__NEWSENTENCE__");
    List<String> currentTimes = currentFullTimes.split("__NEWSENTENCE__");
    List<String> currentEndTimes = currentEndFullTimes.split("__NEWSENTENCE__");
    List<SentenceIndex> sentencesList = [];
    for (int o = 0; o < currentSentences.length; o++) {
      int currentTime = 0;
      if (StringHelper()
          .filterString(currentTimes[o].toString().trim())
          .isNumericOnly) {
        currentTime = int.parse(
            StringHelper().filterString(currentTimes[o].toString().trim()));
      }
      int currentEndTime = 0;
      if (StringHelper()
          .filterString(currentEndTimes[o].toString().trim())
          .isNumericOnly) {
        currentEndTime = int.parse(
            StringHelper().filterString(currentEndTimes[o].toString().trim()));
      }
      String currentSentence = currentSentences[o];
      currentSentence.replaceAll("__NEWSENTENCE__", " ");
      sentencesList.add(SentenceIndex(
          listIndex: i,
          sentenceIndex: o,
          time: currentTime,
          endTime: currentEndTime,
          text: currentSentence));
    }
    listItemsEn.add(SentenceModel(sentencesList: sentencesList));
  }
  if (fa) {
    return listItemsFa;
  } else {
    return listItemsEn;
  }
}
