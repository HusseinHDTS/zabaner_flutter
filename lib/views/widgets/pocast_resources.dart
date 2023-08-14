import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/resources_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/podcast_list_screen.dart';
import 'package:zabaner/views/screens/podcast_play_screen.dart';
import 'package:zabaner/views/screens/podcast_sub_category_screen.dart';
import 'package:zabaner/widgets/colored_text.dart';

class PocastResources extends StatelessWidget {
  const PocastResources(
      {Key? key, required this.categories, required this.isGuest})
      : super(key: key);
  final categories;

  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return resourcesHolder(
        iconPath: "assets/images/podcast.png",
        title: "پادکست ها",
        items: categories,
        onClick: (index) {
          if (categories[index]['startFrom'].toString() == "l2") {
            Get.to(() => PodSubCategory1Screen(
                  filter: categories[index]['_id'],
                  title: categories[index]['title'],
                  normal: false,
                ));
            return;
          }
          if (categories[index]['isDirect'].toString() == "true") {
            Get.to(() => PodcastListScreen(
                  title: categories[index]['title'],
                  filter: categories[index]['_id'],
                  from: "mainS",
                ));
            return;
          } else {
            Get.to(() => PodSubCategoryScreen(
                  filter: categories[index]['_id'],
                  title: categories[index]['title'],
                ));
            return;
          }
        });
  }
}

class PocastListTile extends StatelessWidget {
  const PocastListTile(
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
      // onTap: () => Navigator.pushNamed(context, '/podcast', arguments: id),
      // onTap: () => Get.to(()=>PodcastPlay(isGuest: isGuest), arguments: id),
      onTap: () => Get.to(() => PodcastListScreen()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 4.2,
            height: MediaQuery.of(context).size.height / 7.3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    imagePath,
                  ),
                )),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4.2,
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xff000000), fontSize: 12, fontFamily: "IRANSansPro"),
            ),
          )
        ],
      ),
    );
  }
}
