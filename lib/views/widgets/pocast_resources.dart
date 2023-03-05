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
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width / 30,
                  bottom: MediaQuery.of(context).size.height / 66,
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 17,
                  height: MediaQuery.of(context).size.height / 30,
                  child: Image.asset(
                    "assets/images/podcast.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Text(
                "   پادکست ها",
                style: TextStyle(
                    fontFamily: "Yekan",
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        resourcesBackground(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5.4,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: ListView.separated(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 25,
                    right: MediaQuery.of(context).size.width / 25,
                  ),
                  separatorBuilder: (context, index) => SizedBox(
                    width: MediaQuery.of(context).size.width / 15,
                  ),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        // Get.to(() => PodcastListScreen(filter:categories[index]['title'] ,));
                        if(categories[index]['startFrom'].toString() == "l2"){
                          Get.to(() => PodSubCategory1Screen(
                            filter: categories[index]['_id'],
                            title: categories[index]['title'],
                            normal: false,
                          ));
                          return;
                        }
                        if(categories[index]['isDirect'].toString() == "true"){
                          Get.to(() => PodcastListScreen(title: categories[index]['title'],filter: categories[index]['_id'],from: "mainS",));
                          return;
                        }else{
                          Get.to(() => PodSubCategoryScreen(
                            filter: categories[index]['_id'],
                            title: categories[index]['title'],
                          ));
                          return;
                        }
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 4.2,
                            height: MediaQuery.of(context).size.height / 7.3,
                            child: Center(child: ClipRRect(borderRadius:BorderRadius.circular(8),child: Container(child: CachedNetworkImage(imageUrl: getUrl(categories[index]['imagePath']),),)),),
                          ),
                          Container(
                            child: Center(
                              child: ColoredText(
                                getText(categories[index]['title']),
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                // textDirection: TextDirection.ltr,
                                overflow: TextOverflow.ellipsis,
                                textSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ),
        SizedBox(height: 18,)
      ],
    );
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
                  color: Color(0xff000000), fontSize: 12, fontFamily: "Yekan"),
            ),
          )
        ],
      ),
    );
  }
}
