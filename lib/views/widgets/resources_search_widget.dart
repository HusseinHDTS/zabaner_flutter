import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/screens/chapter_list_screen.dart';
import 'package:zabaner/views/screens/podcast_play_screen.dart';
import 'package:zabaner/views/screens/video_detailt_screen.dart';

class ResourcesSearchWidget extends StatelessWidget {
  const ResourcesSearchWidget({
    Key? key,
    required this.type,
    required this.title,
    required this.faTitle,
    required this.id,
    required this.imagePath,
  }) : super(key: key);
  final String title,faTitle, type, imagePath, id;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        debugPrint("asdwaesaoooo : " + type);
        if (type == "news") {
          // Navigator.pushNamed(context, '/newsDetail', arguments: id);
        }
        if (type == "podcasts") {
          Get.to(PodcastPlay(
              isGuest: false,
              id: id));
          // Navigator.pushNamed(context, '/podcast', arguments: id);
        }
        if (type == "books") {
          // Navigator.pushNamed(context, '/bookScreen', arguments: id);
          Get.to(() => ChapterListScreen(
            id: id,
            imageLink: imagePath,
            type: "book",
          ));
        }
        if (type == "videos") {
          Get.to(VideoDetailScreen(
              isGuest: false,
              id: id));
          // Navigator.pushNamed(context, '/video', arguments: id);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5.8,
        margin: EdgeInsetsDirectional.only(
          bottom: MediaQuery.of(context).size.height / 50,
        ),
        decoration: BoxDecoration(
            color: const Color(0xffDBDBDB),
            borderRadius: BorderRadius.circular(18)),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // title and describtion text
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2.6,
                height: MediaQuery.of(context).size.height / 8,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        faTitle,
                        textAlign: TextAlign.left,
                        style:
                            const TextStyle(fontFamily: "Arial", fontSize: 12),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 100,
                        ),
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontFamily: "Arial",
                              fontSize: 10,
                              color: Color(0xff676767)),
                        ),
                      ),
                    ]),
              ),
            ),

            // Image
            Container(
              width: MediaQuery.of(context).size.width / 2.7,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                      image: CachedNetworkImageProvider("$imagePath"),)),
            )
          ],
        ),
      ),
    );
  }
}
