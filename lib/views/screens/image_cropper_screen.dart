import 'dart:typed_data';
import 'dart:ui';

import 'package:cropperx/cropperx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zabaner/controllers/teacher_screen_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/widgets/custom_text_input.dart';
import 'package:zabaner/widgets/colored_text.dart';

class ImageCropperScreen extends StatefulWidget {
  Uint8List image;
  XFile? imageFile;
  Function(Uint8List, XFile?) onImageCropped;

  ImageCropperScreen(
      {required this.image,
      this.imageFile,
      required this.onImageCropped,
      Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ImageCropperScreen();
  }
}

class _ImageCropperScreen extends State<ImageCropperScreen> {
  GlobalKey cropperKey = GlobalKey();
  int rotationTurns = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: MemoryImage(widget.image), fit: BoxFit.cover)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                ),
              ),
            ),
            Container(
              width: Get.width,
              height: Get.height,
              child: Cropper(
                cropperKey: cropperKey,
                overlayType: OverlayType.circle,
                rotationTurns: rotationTurns,
                backgroundColor: Colors.transparent,
                image: ImageWithLoading(MemoryImage(
                  widget.image,
                )),
              ),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 5),
                decoration: BoxDecoration(color: Colors.black12),
                child: Padding(
                  padding: EdgeInsets.only(right: Get.width / 40),
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          "بازگشت",
                          style: TextStyle(
                              fontFamily: "Yekan", color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () async {
                    loadingDialog("لطفا صبر کنید ...");
                    final imageBytes = await Cropper.crop(
                      cropperKey: cropperKey,
                    );
                    Get.back();
                    if (imageBytes != null) {
                      widget.onImageCropped(imageBytes, widget.imageFile);
                      Get.back();
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 22, horizontal: 4),
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: selectedSettingsColor,
                    ),
                    child: ColoredText(
                      "تایید تصویر",
                      textColor: Colors.white,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
