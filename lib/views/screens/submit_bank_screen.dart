import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zabaner/controllers/submit_bank_controller.dart';
import 'package:zabaner/models/card_number_seperator.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/create_class_screen.dart';
import 'package:zabaner/views/screens/image_cropper_screen.dart';
import 'package:zabaner/views/widgets/teachers_classess_tile.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/custom_video_player.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class SubmitBankScreen extends StatefulWidget {
  bool isSubmitDone, isAllowToComplete;
  var profileData;

  SubmitBankScreen(this.isSubmitDone, this.isAllowToComplete, this.profileData,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SubmitBankScreen();
  }
}

class _SubmitBankScreen extends State<SubmitBankScreen> {
  late SubmitBankController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SubmitBankController(widget.profileData));
  }

  @override
  Widget build(BuildContext context) {
    String profileStatus = widget.profileData['profileStatus'];
    controller.initData();
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: ColoredAppBar(),
          body: Column(
            children: [
              Expanded(
                flex: 0,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  height: 80,
                  child: Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Obx(() => InkWell(
                                onTap: () {
                                  controller.setCurrentSelectedPos(1);
                                },
                                child: topMenuItem(Icons.info_outline_rounded,
                                    isSelected:
                                        controller.currentSelectedPos.value ==
                                            1,
                                    text: 'اطلاعات اولیه',
                                    color: profileStatus == "done" ||
                                            profileStatus == "firstPendingOk"
                                        ? Colors.green.shade300
                                        : Colors.orange.shade300),
                              ))),
                      Flexible(
                          flex: 1,
                          child: Obx(() => InkWell(
                                onTap: () {
                                  controller.setCurrentSelectedPos(2);
                                },
                                child: topMenuItem(Icons.payment_rounded,
                                    color: profileStatus != "firstPendingOk"
                                        ? Colors.green.shade300
                                        : null,
                                    isSelected:
                                        controller.currentSelectedPos.value ==
                                            2,
                                    text: 'اطلاعات بانکی'),
                              ))),
                      Flexible(
                          flex: 1,
                          child: Obx(() => InkWell(
                                onTap: () {
                                  controller.setCurrentSelectedPos(3);
                                },
                                child: topMenuItem(Icons.roofing_rounded,
                                    isSelected:
                                        controller.currentSelectedPos.value ==
                                            3,
                                    text: 'کلاس های من'),
                              ))),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Obx(() => controller.currentSelectedPos.value == 1
                      ? baseInfo(profileStatus)
                      : controller.currentSelectedPos.value == 2
                          ? bankInfo(profileStatus)
                          : controller.currentSelectedPos.value == 3
                              ? myClass()
                              : Container()),
                ),
              ),
            ],
          ),
        ));
  }

  baseInfo(profileStatus) {
    final pageController = PageController(viewportFraction: 1, keepPage: true);
    int pageSize = 3;
    var titles = [
      "اطلاعات فردی",
      "اطلاعات تخصصی",
      "ویدئوی معرفی",
    ];
    final pages = List.generate(
        pageSize,
        (index) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade200,
                  boxShadow: [
                    BoxShadow(
                      color: primaryDark.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  border: Border.all(color: selectedSettingsColor, width: 1)),
              margin: EdgeInsets.only(right: 10, left: 10, top: 4, bottom: 18),
              child: Column(
                children: [
                  Expanded(
                    flex: 0,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          margin: EdgeInsets.only(top: 8),
                          child: ColoredText(
                            "صفحه ${index + 1}/$pageSize  –  ${titles[index]}",
                            textSize: 13,
                            textColor: Colors.black54,
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        height: double.infinity,
                        child: MultiChildScrollView(
                          child: index == 0
                              ? personalInfo(profileStatus)
                              : index == 1
                                  ? professionalInfo()
                                  : index == 2
                                      ? videoInfo()
                                      : Container(),
                        ),
                      )),
                  Expanded(
                      flex: 0,
                      child: Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  width: double.infinity,
                                  child: InkWell(
                                      onTap: () {
                                        if (index != 0) {
                                          pageController.previousPage(
                                              duration:
                                                  Duration(milliseconds: 480),
                                              curve: Curves.linear);
                                        }
                                      },
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: index == 0
                                              ? null
                                              : ColoredText(
                                                  "صفحه قبلی",
                                                  textColor: redExitColor,
                                                ))),
                                )),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  width: double.infinity,
                                  child: InkWell(
                                      onTap: () {
                                        if (index != pageSize - 1) {
                                          pageController.nextPage(
                                              duration:
                                                  Duration(milliseconds: 480),
                                              curve: Curves.linear);
                                        } else {
                                          if (controller.hasChanges()) {
                                            controller.submitInfo();
                                          } else {
                                            ColoredSnack(
                                                title:
                                                    "تغییری برای ثبت وجود ندارد",
                                                type: SnackType.SUCCESS);
                                          }
                                        }
                                      },
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: ColoredText(
                                            index == pageSize - 1
                                                ? "ثبت اطلاعات"
                                                : "صفحه بعدی",
                                            textColor: index == pageSize - 1
                                                ? Colors.green
                                                : primaryDark,
                                          ))),
                                )),
                          ],
                        ),
                      )),
                ],
              ),
            ));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: Get.width,
        height: Get.height,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Stack(
          children: <Widget>[
            Container(
              height: Get.height,
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                itemBuilder: (_, index) {
                  return pages[index % pages.length];
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SmoothPageIndicator(
                controller: pageController,
                count: pages.length,
                effect: const WormEffect(
                  dotHeight: 7,
                  dotWidth: 13,
                  spacing: 9,
                  type: WormType.thin,
                  dotColor: Colors.black12,
                  activeDotColor: primaryDark,
                ),
              ),
            ),
            SizedBox(
              height: 4,
            ),
          ],
        ),
      ),
    );
  }

  personalInfo(profileStatus) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
                flex: 1,
                child: inputText("نام", controller.nameController,
                    enabled: false, allowEnglish: false)),
            Flexible(
                flex: 1,
                child: inputText("نام خانوادگی", controller.familyController,
                    enabled: false, allowEnglish: false)),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        InkWell(
            onTap: profileStatus == "firstPendingOk" || profileStatus == "done"
                ? () async {
                    ImagePicker _picker = ImagePicker();
                    XFile? _image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (_image != null) {
                      var img = await _image.readAsBytes();
                      Get.to(() => ImageCropperScreen(
                            image: img,
                            imageFile: _image,
                            onImageCropped: (image, imageFile) {
                              controller.setCurrentImage(image, imageFile);
                            },
                          ));
                    }
                  }
                : () {
                    ColoredSnack(
                        title: "لطفا منتظر تایید شدن اطلاعات بمانید.",
                        type: SnackType.WARNING);
                  },
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 150,
                height: 160,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Obx(
                      () => controller.image.value!.isNotEmpty
                          ? ProfileImage(ImageWithLoading(
                              MemoryImage(controller.image.value!)))
                          : ProfileImage(ImageWithLoading(
                              CachedNetworkImageProvider(getUrl(
                                  widget.profileData['currentImagePath'])))),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: controller.image.value!.isNotEmpty
                          ? () {
                              controller.uploadImage();
                            }
                          : null,
                      child: Obx(() => ColoredText(
                            controller.image.value!.isNotEmpty
                                ? "ثبت عکس جدید"
                                : "انتخاب تصویر پروفایل",
                            textColor: controller.image.value!.isNotEmpty
                                ? Colors.green
                                : primaryDark,
                          )),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
            )),
        inputText("آدرس ایمیل", controller.emailController,
            keyboardType: TextInputType.emailAddress, enabled: false),
        inputText("شهر محل سکونت", controller.cityController, enabled: false),
        inputText("درباره خود", controller.descriptionController,
            maxLines: 6, useMaxAndMin: true, enabled: false),
        inputText("شماره تماس", controller.phoneController, enabled: false),
      ],
    );
  }

  initControllerDropDown() {
    controller.initDropDown();
    return Container();
  }

  professionalInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        inputText("زبان تدریس", controller.teachLanguage, enabled: false),
        SizedBox(
          height: 12,
        ),
        dropdownItems(
            controller.educationLevels, controller.selectedEducationLevel,
            (String? newValue) {
          controller.setCurrentSelectedEducationLevel(newValue ?? "");
        }, hint: "سطح تحصیلات", cValue: controller.defaultEducationLevel.value),
        SizedBox(
          height: 12,
        ),
        inputText("رشته تحصیلی (اختیاری)", controller.educationIn),
        SizedBox(
          height: 12,
        ),
        dropdownItems(controller.ageRates, controller.selectedAgeRate,
            (String? newValue) {
          controller.setCurrentSelectedAgeRate(newValue ?? "");
        }, hint: "رده سنی مخاطب", cValue: controller.defaultAgeRate.value),
        initControllerDropDown(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: ColoredText(
                    "تخصص",
                    textSize: 12,
                    textColor: Colors.black54,
                  ),
                ),
              ),
              Obx(() => Row(
                    children: [
                      checkBox(
                          controller.english01Content, controller.english01,
                          (isChecked) {
                        controller.resetRxCheckbox();
                        controller.english01.value = isChecked;
                      }),
                      SizedBox(
                        width: 12,
                      ),
                      checkBox(
                          controller.english02Content, controller.english02,
                          (isChecked) {
                        controller.resetRxCheckbox();
                        controller.english02.value = isChecked;
                      }),
                    ],
                  )),
              Obx(() => Row(
                    children: [
                      checkBox(
                          controller.english03Content, controller.english03,
                          (isChecked) {
                        controller.resetRxCheckbox();
                        controller.english03.value = isChecked;
                      }),
                      SizedBox(
                        width: 12,
                      ),
                      checkBox(
                          controller.english04Content, controller.english04,
                          (isChecked) {
                        controller.resetRxCheckbox();
                        controller.english04.value = isChecked;
                      }),
                    ],
                  )),
              Obx(() => Row(
                    children: [
                      checkBox(
                          controller.english05Content, controller.english05,
                          (isChecked) {
                        controller.resetRxCheckbox();
                        controller.english05.value = isChecked;
                      }),
                    ],
                  )),
            ],
          ),
        ),
      ],
    );
  }

  videoInfo() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoBox(
                  "با توجه به تاثیر بالای ویدئوی معرفی برای جذب زبان آموز، پیشنهاد می شود کیفیت قابل قبولی را برای ضبط در نظر بگیرید."),
              SizedBox(
                height: 6,
              ),
              infoBox(
                  "برای تاثیر گذاری بیشتر ویدئو، پیشنهاد می شود از زبان انگلیسی استفاده نمایید."),
              SizedBox(
                height: 6,
              ),
              infoBox(
                  "حداکثر حجم مجاز ویدئو 20 مگابایت است. ویدئوی حجم بالاتر را می توانید از طریق شماره 09914049115 در تلگرام ارسال نمایید."),
              SizedBox(
                height: 6,
              ),
              infoBox("حداکثر مدت زمان مجاز ویدئو 3 دقیقه است."),
              SizedBox(
                height: 6,
              ),
              infoBox("ویدئو را به صورت افقی ضبط نمایید."),
              SizedBox(
                height: 6,
              ),
              infoBox(
                  "در ویدئوی معرفی ذکر کردن راه های ارتباطی مدرس مجاز نمی باشد."),
              SizedBox(
                height: 16,
              ),
              Directionality(
                textDirection: TextDirection.ltr,
                child: Obx(() => controller.hasVideo.value
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Obx(() => getVideoView(
                                    getUrl(controller.data['videoPath']),
                                    CustomVideoType.NETWORK,
                                    withThumb: true,
                                    retryImage: customVideoPlayerTag.value == getUrl(controller.data['videoPath']))),
                              )),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              child: InkWell(
                                onTap: () {
                                  controller.pickVideo();
                                },
                                child: ColoredText(
                                  "تغییر ویدئو",
                                  textColor: primaryDark,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : InkWell(
                        onTap: () {
                          controller.pickVideo();
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                child: Lottie.asset(
                                  'assets/animations/select_video.json',
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: ColoredText(
                                "برای انتخاب ویدیو کلیک کنید",
                                textColor: primaryDark,
                              ),
                            ),
                          ],
                        ),
                      )),
              )
            ],
          ),
        )
      ],
    );
  }

  bankInfo(profileStatus) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
      child: MultiChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          inputText("شماره کارت", controller.cardNumber,
              textDirection: TextDirection.ltr,
              error: controller.bankNumberOrShebaError,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 16 + (CARD_NUMBER_SEPARATOR.length * 3),
              inputFormatters: [
                CardFormatter(separator: CARD_NUMBER_SEPARATOR)
              ]),
          SizedBox(
            height: 18,
          ),
          inputText("شماره شبا (اختیاری)", controller.shebaNumber,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number),
          SizedBox(
            height: 18,
          ),
          inputText("نام مالک کارت", controller.cardName,
              error: controller.bankNameError,
              keyboardType: TextInputType.name),
          SizedBox(
            height: 18,
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
          InkWell(
            onTap: () {
              if (controller.validateBank()) {
                controller.submitBank(profileStatus);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 18),
              child: Center(
                child: ColoredText(
                  profileStatus == "done"
                      ? "ویرایش اطلاعات بانکی"
                      : "ثبت اطلاعات بانکی",
                  textColor: Colors.white,
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(8)),
            ),
          ),
          SizedBox(
            height: 18,
          )
        ],
      )),
    );
  }

  //52.14.152.190

  myClass() {
    controller.getData();
    return Container(
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              child: Obx(() => controller.isDataLoaded.value
                  ? Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 8),
                                child: ProfileImage(ImageWithLoading(
                                    CachedNetworkImageProvider(getUrl(
                                        controller.data['showingImagePath'])))),
                              ),
                              Flexible(
                                  flex: 1,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ColoredText(
                                        "${controller.nameController.text} ${controller.familyController.text}   /   ${controller.data['educationLevel']} ${controller.educationIn.text}",
                                        textSize: 12.5,
                                        textColor: Colors.black87,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        children: [
                                          StarRating(
                                              count: controller
                                                          .data["ratingCount"]
                                                          .toString() ==
                                                      ""
                                                  ? 0
                                                  : int.parse(controller
                                                      .data["ratingCount"]
                                                      .toString()),
                                              showText: true,
                                              startSize: 25.0),
                                          controller.data['ratingCount']
                                                          .toString() ==
                                                      "" ||
                                                  controller.data['ratingCount']
                                                          .toString() ==
                                                      "0"
                                              ? Container()
                                              : ColoredText(
                                                  "(${controller.data['rating']})",
                                                  textColor: Colors.black54,
                                                ),
                                        ],
                                      )
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: double.infinity,
                            child: controller.classData.isNotEmpty
                                ? ListView.builder(
                                    itemCount: controller.classData.length,
                                    itemBuilder: (context, index) {
                                      return TeachersClassTile(
                                          controller.classData[index]);
                                    },
                                  )
                                : NoData(),
                          ),
                        )
                      ],
                    )
                  : Loading()),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
              flex: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 18),
                            child: Center(
                              child: ColoredButton(
                                "قیمت گذاری کلاس‌ها",
                                textSize: 13,
                                gradient: LinearGradient(
                                    colors: [primary, primaryDark]),
                                onTap: () {
                                  Get.to(() => CreateClassScreen());
                                },
                              ),
                            ),
                          )),
                      SizedBox(
                        width: 18,
                      ),
                      Flexible(
                          flex: 1,
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 18),
                            child: Center(
                              child: ColoredButton(
                                "زمانبندی کلاس ها",
                                textSize: 13,
                                gradient: LinearGradient(colors: [
                                  Colors.green.shade300,
                                  Colors.green
                                ]),
                                gradientBorder: true,
                                textColor: Colors.green,
                                onTap: () {
                                  Get.to(() => CreateClassTimingScreen(controller.data['freeTimes']));
                                },
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  topMenuItem(icon, {color, required isSelected, required String text}) {
    color ??= Colors.black38;
    return Center(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: primary.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(2, 3), // changes position of shadow
              ),
            ],
            color: Colors.white,
            border: isSelected
                ? Border.all(color: primary.withOpacity(0.8), width: 2)
                : null),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 35,
            ),
            ColoredText(
              text,
              textColor: Colors.black87,
              textSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
