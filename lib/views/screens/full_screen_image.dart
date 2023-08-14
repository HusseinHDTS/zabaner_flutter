import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class FullScreenImage extends StatefulWidget {
  String image;

  FullScreenImage({Key? key, required this.image}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImage();
}

class _FullScreenImage extends State<FullScreenImage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: Stack(
          children: [
            PinchZoom(
              child: Image.network(widget.image),
              resetDuration: const Duration(milliseconds: 100),
              maxScale: 2.5,
              onZoomStart: () {},
              onZoomEnd: () {},
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 18,horizontal: 5),
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
                              fontFamily: "IRANSansPro", color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
