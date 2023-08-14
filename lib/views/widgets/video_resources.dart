import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/resources_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/video_detailt_screen.dart';
import 'package:zabaner/views/screens/video_list_screen.dart';
import 'package:zabaner/widgets/colored_text.dart';

class VideoResources extends StatelessWidget {
  const VideoResources(
      {Key? key,
      required this.resource,
      required this.videoCategories,
      required this.isGuest})
      : super(key: key);
  final List<Resource> resource;
  final videoCategories;
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return resourcesHolder(
        items: videoCategories,
        title: "مصاحبه های Speakout",
        iconPath: "assets/images/video.png",
        onClick: (index) {
          Get.to(() => VideoListScreen(
            filter: videoCategories[index]['_id'],
            title: videoCategories[index]['title'],
          ));
        });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('videoCategories', videoCategories));
  }
}

class VideoListTile extends StatelessWidget {
  const VideoListTile(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.isGuest,
      required this.resource,
      required this.id})
      : super(key: key);
  final String imagePath, title, id;
  final bool isGuest;
  final List<Resource> resource;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => VideoListScreen(
            filter: id,
            title: title,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.height / 7.3,
            child: Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    child: CachedNetworkImage(
                      imageUrl: imagePath,
                    ),
                  )),
            ),
          ),
          Container(
            child: Center(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: ColoredText(
                  getText(title),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  overflow: TextOverflow.ellipsis,
                  textSize: 12,
                ),
              ),
            ),
          )

          // SizedBox(
          //   width: MediaQuery.of(context).size.width / 3.8,
          //   child: Text(
          //     getText(title),
          //     overflow: TextOverflow.ellipsis,
          //     textAlign: TextAlign.center,
          //     style: const TextStyle(
          //         color: Color(0xff000000), fontSize: 12, fontFamily: "IRANSansPro"),
          //   ),
          // )
        ],
      ),
    );
  }
}
