import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/video_list_controller.dart';
import 'package:zabaner/models/resources_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/profile_screen.dart';
import 'package:zabaner/views/screens/video_detailt_screen.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class VideoListScreen extends StatelessWidget {
  VideoListScreen({Key? key, this.filter, this.title}) : super(key: key);
  String? filter;
  String? title;

  @override
  Widget build(BuildContext context) {
    final VideoListController _controller = Get.put(VideoListController(filter: filter));
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: ColoredAppBar(),
          body: Obx(() => _controller.isDataLoaded.value
              ? SmartRefresher(
            controller: _controller.refreshController,
            onRefresh: () {
              _controller.getData();
            },
            header: const MaterialClassicHeader(),
            child: _controller.errorData.isTrue
                ? ErrorLoading(retry: () {
              _controller.getData();
            })
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                    child: ColoredText(
                        "مصاحبه های Speakout" + " > " + (title ?? ""),)),
                Expanded(
                    child: _controller.model.length == 0
                        ? NoData()
                        : ListView.builder(
                        itemCount:
                        _controller.model.length,
                        itemBuilder: (_, index) {
                          return resourceItemHolder(
                              title: _controller.model[index].title,
                              hasMore: false,
                              itemType: "video",
                              extraContent: [
                                Row(
                                  children: [
                                    Flexible(
                                        flex: 1,
                                        child: resourceIconDetail(
                                            title: _controller
                                                .model[
                                            index]
                                                .podcastTime
                                                .toString() +
                                                " دقیقه ",
                                            iconPath:
                                            "assets/images/time.png")),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Flexible(
                                        flex: 1,
                                        child: resourceIconDetail(
                                            title:
                                            "سطح: ${_controller.model[index].level}",
                                            iconSize: 12,
                                            iconPath:
                                            "assets/images/level-ltr.png")),
                                  ],
                                ),
                              ],
                              imagePath:_controller.model[index]
                                  .imagePath,
                              onClick: () {
                                Get.to(() => VideoDetailScreen(
                                  isGuest: false,
                                  id: _controller.model[index].id,itemType: "video",));
                              },
                              index: index);
                        })),
              ],
            ),
          )
              : Loading()),
        ));
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
                      ColoredText(title ?? "مصاحبه های Speakout",textSize: 18,textDirection: TextDirection.rtl,),

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
                        itemBuilder: (_, index) {
                          return InkWell(
                            onTap: () => Get.to(() => VideoDetailScreen(
                                isGuest: false,
                                id: _controller.model[index].id,itemType: "video",)),
                            child: Container(
                              width: Get.width,
                              height: Get.height / 5.5,
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
                                        image: CachedNetworkImageProvider(
                                            _controller
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
                                              fontFamily: "IRANSansPro",
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            ImageIcon(
                                                AssetImage(
                                                    "assets/images/time.png"),
                                                size: 22),
                                            Text("    " + _controller.model[index].podcastTime.toString() + " دقیقه ")
                                          ],
                                        ),
                                      ],
                                    ))
                              ]),
                            ),
                          );
                        }))
              ])) : Loading()),
        ));
  }
}
