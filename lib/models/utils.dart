import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:cached_video_preview/cached_video_preview.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:lottie/lottie.dart';
import 'package:srt_parser/srt_parser.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wakelock/wakelock.dart';
import 'package:zabaner/controllers/custom_video_controller.dart';
import 'package:zabaner/controllers/custom_video_player_controller.dart';
import 'package:zabaner/models/html.dart';
import 'package:zabaner/models/sentence_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/colors.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:zabaner/views/widgets/custom_text_input.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:html/parser.dart' as parser;
import 'package:srt_parser/srt_parser.dart' as strP;
import 'package:flutter/services.dart';
import 'package:zabaner/widgets/custom_cached_video_preview.dart';
import 'package:zabaner/widgets/custom_video_player.dart';

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
int lvl4 = 4800;
int lvl5 = lvl4;
int lvl6 = lvl4;
double hiddenHeight = Get.height / 8 / 1.5, normalHeight = Get.height / 8;

String userPhoneNumber = "09XXXXXXXXX";
String userSavedId = "";
String userSavedName = "";
String userSavedFirstName = "";
String userSavedLastName = "";

CustomVideoPlayerController? customVideoPlayerController;
Rx<String?> customVideoPlayerTag = "null".obs;

copyToClipboard(String text, {bool? showAlert, String? title}) async {
  showAlert ??= false;
  await Clipboard.setData(ClipboardData(text: text));
  if (showAlert) {
    ColoredSnack(title: title.toString(), type: SnackType.SUCCESS);
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

customDialog({Color? headerColor, Widget? child, double? borderRadius}) {
  borderRadius ??= 8;
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
      child: Obx(() => WillPopScope(child: Container(
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            topRoundedMiniBar(title: title,height: 40),
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
      ), onWillPop: () async => downloadingPercent.value == 1 ? true : false)));
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

loadingDialog(title) {
  Get.defaultDialog(
      title: title,
      barrierDismissible: false,
      content: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: const CircularProgressIndicator()));
}

TextStyle getSubtitleTextStyle(isNowCurrentText) {
  return TextStyle(
      // fontSize: isNowCurrentText ? 17.0 : 18,
      fontWeight: isNowCurrentText ? FontWeight.w900 : FontWeight.w900,
      fontFamily: isNowCurrentText ? "Iransans_Fa_MD" : "Iransans_Fa_MD",
      color: isNowCurrentText ? Colors.black : Colors.grey);
}

TextStyle getSubDefault(isFa) {
  return TextStyle(
      fontSize: isFa ? 17 : 18, color: Colors.black, fontFamily: "Neue_MD");
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

MultiChildScrollView({child}) {
  return CustomScrollView(
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

checkBox(String title, RxBool value, onChange,{Color? boxColor,Color? textColor,Color? activeColor,Color? checkColor,bool? circular}) {
  circular??=false;
  textColor??= Colors.black;
  boxColor??= Colors.black;
  activeColor??= primaryDark;
  checkColor??= Colors.white;
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
          shape: circular? CircleBorder(side: BorderSide(color: activeColor,width: 1.4,style: BorderStyle.solid)) : null,
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
  return Obx(() => Container(
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
      )));
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
        color: primary,
        size: size,
      ));
}

Widget StarRating({int? current, int? count, bool? showText, startSize}) {
  current ??= 0;
  count ??= 0;
  startSize ??= 16.0;
  showText ??= false;
  current = int.parse(current.toString());
  count = int.parse(count.toString());

  int mainRate = 0;
  String rateString = "0.0";
  // current ~/ count
  // (current / count).toStringAsFixed(1);
  if (count != 0) {
    mainRate = 0;
    rateString = (current / count).toStringAsFixed(1);
  }
  var splitRate = rateString.split(".");
  if (rateString == "0.0") {
    showText = false;
  }
  return Container(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OneStar(mainRate >= 1, startSize),
        OneStar(mainRate >= 2, startSize),
        OneStar(mainRate >= 3, startSize),
        OneStar(mainRate >= 4, startSize),
        OneStar(mainRate == 5, startSize),
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

Widget ErrorLoading({String? title}) {
  title = title ?? "خطا هنگام دریافت اطلاعات از سرور! لطفا مجددا تلاش کنید.";
  return Center(
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
  ));
}

Widget Loading() {
  return Center(child: CircularProgressIndicator(),);
  return Center(
      child: Container(
    child: Lottie.asset('assets/animations/loading_main1.json', height: 350),
  ));
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

Widget NoData({String? message}) {
  String mC = "";
  mC = message ?? "هیچ اطلاعاتی یافت نشد!";
  return Center(
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
  ));
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
  ]).replaceAll(RegExp(r"(?! )\s+| \s+"), " ");
}

String getText(String text, {int? length}) {
  String result = text;
  length ??= 15;
  if (text.length > length) {
    result = "${text.substring(0, length)}...";
  }
  return result;
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
    {bool? withThumb, bool? retryImage, bool? showPreviewOverlay,bool? fullscreenOnStart}) {
  withThumb ??= false;
  retryImage ??= false;
  fullscreenOnStart ??= true;
  showPreviewOverlay ??= true;
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
                  ? CustomCachedVideoPreviewWidget(
                      path: path,
                      placeHolder: Loading(),
                      type: SourceType.remote,
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
                                          width:
                                              constraints.maxWidth / (3.5 * 1),
                                          height:
                                              constraints.maxHeight / (3.5 * 1),
                                          child: InkWell(
                                            onTap: () async{
                                              if (customVideoPlayerController !=
                                                  null) {
                                                customVideoPlayerController!
                                                    .dispose();
                                              }
                                              isVideoInitializing.value = true;
                                              var fileInfo = await checkCacheFor(path);
                                              if(fileInfo == null){
                                                customVideoPlayerController =
                                                    CustomVideoPlayerController(
                                                        CachedVideoPlayerController.network(
                                                            path,
                                                            videoPlayerOptions:
                                                            VideoPlayerOptions(
                                                                mixWithOthers:
                                                                true)),
                                                        autoInit: false,
                                                        fullscreenOnStart: fullscreenOnStart);
                                              }else{
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
                                                    if(fileInfo == null){
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
                                                        Icons
                                                            .play_arrow_rounded,
                                                        color: Colors.white70,
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
                  : file!.existsSync()
                      ? CustomCachedVideoPreviewWidget(
                          path: path.path,
                          placeHolder: Loading(),
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

Future<FileInfo?> checkCacheFor(String url) async{
  final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
  return value;
}

void checkedForUrl(String url) async{
  await DefaultCacheManager().getSingleFile(url).then((value){

  });
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

String formatPrice(value, {bool? showUnit, int? count}) {
  showUnit ??= true;
  count ??= 1;
  if (value.toString() == "null" || value.toString().trim().isEmpty) {
    value = "0";
  }
  String val = value.toString();
  if (val == "0") {
    return "رایگان";
  }
  var formatter = intl.NumberFormat.currency(
    locale: null,
    name: null,
    symbol: "",
    decimalDigits: 0,
    customPattern: null,
  );
  String unit = showUnit ? " تومان " : "";
  return "${formatter.format(int.parse(val.replaceAll(",", "")))}$unit";
}

String getCurrentDayDatePicker(int index,{bool? allText}) {
  allText??=false;
  String day = "";
  if (index == 0) {
    day = "شنبه";
  } else if (index == 1) {
    if(allText){
      day = "یک‌شنبه";
    }else {
      day = "1شنبه";
    }
  } else if (index == 2) {
    if(allText){
      day = "دو‌شنبه";
    }else {
      day = "2شنبه";
    }
  } else if (index == 3) {
    if(allText){
      day = "سه‌شنبه";
    }else {
      day = "3شنبه";
    }
  } else if (index == 4) {
    if(allText){
      day = "چهار‌شنبه";
    }else {
      day = "4شنبه";
    }
  } else if (index == 5) {
    if(allText){
      day = "یک‌شنبه";
    }else {
      day = "5شنبه";
    }
  } else if (index == 6) {
    day = "جمعه";
  }else{
    day = "??????";
  }
  return day;
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

getSrtSubTitle(lang, id, link) async {
  var returnItem;
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  if (link.toString().trim().isNotEmpty) {
    bool exists = await readExists(getSrtFileName(lang, id, link.toString()));
    if (!exists) {
      var en = await _getConnect.get(link);
      await writeString(
          en.bodyString ?? "", getSrtFileName(lang, id, link.toString()));
    } else {
      _getConnect.get(link).then((en) async {
        await writeString(
            en.bodyString ?? "", getSrtFileName(lang, id, link.toString()));
      });
    }
    String data = await readString(getSrtFileName(lang, id, link.toString()));

    var list = await getFullFromSrt(false, strP.parseSrt(data));
    returnItem = list.sentenceModel;
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
      inlineSpan.add(parseHtmlToTextSpan(
          whiteSpaceForSentence(txt.toString()), getSubtitleTextStyle(false)));
      sentencesList.add(SentenceIndex(
          listIndex: i,
          sentenceIndex: o,
          time: currentTime,
          endTime: currentETime,
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
