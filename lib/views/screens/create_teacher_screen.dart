import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zabaner/controllers/teacher_screen_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/image_cropper_screen.dart';
import 'package:zabaner/views/widgets/custom_text_input.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/custom_video_player.dart';
import 'package:zabaner/widgets/my_app_bar.dart';
import 'dart:io' as io;

class CreateTeacherScreen extends StatefulWidget {
  const CreateTeacherScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateTeacherScreen();
  }
}

class _CreateTeacherScreen extends State<CreateTeacherScreen> {
  final pageController = PageController(viewportFraction: 1, keepPage: true);
  TeacherScreenController controller = Get.put(TeacherScreenController());
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    customVideoPlayerController != null ? customVideoPlayerController!.dispose() : {};
  }
  @override
  Widget build(BuildContext context) {
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
                        child: SingleChildScrollView(
                          child: index == 0
                              ? personalInfo()
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
                                          // controller.submitTeacher();
                                          // return;
                                          if (controller.validateFields()) {
                                            controller.submitTeacher();
                                          } else {
                                            int gtp = 0;
                                            if (controller.errorPageOne) {
                                              gtp = 1;
                                            } else {
                                              gtp = 2;
                                            }
                                            pageController.animateToPage(
                                                gtp - 1,
                                                duration: Duration(
                                                    milliseconds: gtp == 1
                                                        ? (480 * 2)
                                                        : 480),
                                                curve: Curves.linear);
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
      child: Scaffold(
        appBar: ColoredAppBar(),
        body: SafeArea(
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
        ),
      ),
    );
  }



  pickVideo() {
    return InkWell(
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
    );
  }

  personalInfo() {
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
                    error: controller.nameError, allowEnglish: false)),
            Flexible(
                flex: 1,
                child: inputText("نام خانوادگی", controller.familyController,
                    error: controller.familyError, allowEnglish: false)),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        InkWell(
            onTap: () async {
              ImagePicker _picker = ImagePicker();
              XFile? _image =
                  await _picker.pickImage(source: ImageSource.gallery);
              if (_image != null) {
                var img = await _image.readAsBytes();
                Get.to(() => ImageCropperScreen(
                      image: img,
                      imageFile: _image,
                      onImageCropped: (image,imageFile) {
                        controller.setCurrentImage(image,imageFile);
                      },
                    ));
              }
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
                          : Lottie.asset('assets/animations/select_image.json',
                              height: 110, repeat: true),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ColoredText(
                      "انتخاب تصویر پروفایل",
                      textColor: primaryDark,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
            )),
        inputText("آدرس ایمیل", controller.emailController,
            error: controller.emailError,
            keyboardType: TextInputType.emailAddress),
        inputText("شهر محل سکونت", controller.cityController,
            error: controller.cityError),
        inputText("درباره خود", controller.descriptionController,
            error: controller.descriptionError,
            maxLines: 6,
            useMaxAndMin: true),
        inputText("شماره تماس", controller.phoneController, enabled: false),
      ],
    );
  }

  professionalInfo() {
    return Column(
      mainAxisSize: MainAxisSize.max,
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
        },
            hint: "سطح تحصیلات",
            error: controller.educationLevelError,
            cValue: controller.selectedEducationLevel.value),
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
        },
            hint: "رده سنی مخاطب",
            error: controller.ageError,
            cValue: controller.selectedAgeRate.value),
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
        )
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
              Obx(() => controller.videoInitialized.isTrue
                  ? Directionality(
                      textDirection: TextDirection.ltr,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Obx(()=>getVideoView(controller.videoFileRx != null && controller.videoFileRx!.value != null ? io.File(controller.videoFileRx!.value!.path) : null, CustomVideoType.STORAGE,fullscreenOnStart: false)),
                                // child: Chewie(
                                //     controller: controller.chewieController),
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
                      ))
                  : pickVideo()),
            ],
          ),
        )
      ],
    );
  }
}
