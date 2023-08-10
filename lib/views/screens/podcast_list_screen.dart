import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/controllers/podcast_list_controller.dart';
import 'package:zabaner/models/resources_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/podcast_play_screen.dart';
import 'package:zabaner/views/screens/profile_screen.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class PodcastListScreen extends StatelessWidget {
  PodcastListScreen({
    this.filter,
    this.title,
    this.from,
  });
  String? filter;
  String? title;
  String? from;

  @override
  Widget build(BuildContext context) {
    from??="none";
    final PodcastListController _controller = Get.put(PodcastListController(filter:filter,from: from));
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar: ColoredAppBar(),
          body: Obx(()=>_controller.isDataLoaded.isTrue ? Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width / 40),
              child: Column(children: [
                // Top of screen
                SizedBox(
                  height: Get.height / 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // profile image
                      InkWell(
                        onTap: () => Get.to(()=>ProfileScreen(isGuest: false)),
                        child: CircleAvatar(
                          radius: Get.width / 18,
                          // backgroundImage: NetworkImage(_controller
                          //         .getProfileImage ??
                          //     "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/2048px-Solid_white.svg.png"),
                        ),
                      ),

                      // Hello Text
                      Text(
                        title ?? "پادکست ها",
                        style: TextStyle(fontFamily: "Yekan", fontSize: 18),
                      ),

                      // Logo in top left
                      SizedBox.square(
                        // padding: EdgeInsets.only(left: Get.width / 25),
                        dimension: Get.width / 8,
                        // height: Get.height / 14,
                        child: Container(),
                      )
                    ],
                  ),
                ),

                Expanded(
                    child: ListView.builder(
                        itemCount: _controller.model.length,
                        itemBuilder: (_, index) => InkWell(
                          onTap: () => Get.to(() => PodcastPlay(
                              isGuest: false,
                              id: _controller.model[index].id)),
                          child: Container(
                            width: Get.width,
                            height: Get.height / 6,
                            margin:
                            EdgeInsets.only(bottom: Get.height / 40),
                            decoration: BoxDecoration(
                                color: const Color(0xffebebeb),
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(children: [
                              // image
                              Container(
                                width: Get.width / 3,
                                height: Get.height,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(_controller
                                          .model[index].imagePath),)),
                              ),

                              // empty space
                              SizedBox(
                                width: Get.width / 12,
                              ),

                              Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _controller.model[index].title,
                                        style: TextStyle(
                                            fontFamily: "Yekan",
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          ImageIcon(
                                              AssetImage(
                                                  "assets/images/time.png"),
                                              size: 22),
                                          Text("\t\t" + _controller.model[index].podcastTime.toString() + " دقیقه ")
                                        ],
                                      ),
                                    ],
                                  ))
                            ]),
                          ),
                        )))
              ])) : Loading())),
    );
  }
}
