import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/resources_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/screens/video_detailt_screen.dart';
import 'package:zabaner/views/screens/video_list_screen.dart';

class VideoResources extends StatelessWidget {
  const VideoResources(
      {Key? key, required this.resource,required this.videoCategories, required this.isGuest})
      : super(key: key);
  final List<Resource> resource;
  final  videoCategories;
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    // return Container();
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 30,
                // bottom: MediaQuery.of(context).size.height / 150,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 12,
                height: MediaQuery.of(context).size.height / 20,
                child: Image.asset(
                  "assets/images/video.png",
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const Text(
              "  مصاحبه های ویدیویی",
              style: TextStyle(
                  fontFamily: "Yekan",
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5.4,
          decoration: BoxDecoration(
              color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: videoCategories.length,
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 25,
                right: MediaQuery.of(context).size.width / 25,
              ),
              reverse: true,
              itemBuilder: (context, index) {
                return VideoListTile(
                    resource: resource,
                    isGuest: isGuest,
                    imagePath: getUrl(videoCategories[index]['imagePath']),
                    title: videoCategories[index]['title'],
                    id: videoCategories[index]['_id']);
              },
              separatorBuilder: (context, index) => SizedBox(
                width: MediaQuery.of(context).size.width / 15,
              ),
            ),
          ),
        ),
        // Divider(
        //   color: const Color(0xffDBDBDB),
        //   height: MediaQuery.of(context).size.height / 30,
        // )
      ],
    );
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
      onTap: () => Get.to(() => VideoListScreen(filter: title,)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 4,
            height: MediaQuery.of(context).size.height / 7.3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      imagePath,
                    ),)),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3.8,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xff000000), fontSize: 10, fontFamily: "Yekan"),
            ),
          )
        ],
      ),
    );
  }
}
