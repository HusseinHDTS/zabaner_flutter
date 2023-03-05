import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/pod_sub_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/podcast_list_screen.dart';
import 'package:zabaner/views/screens/profile_screen.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class PodSubCategoryScreen extends StatelessWidget {
  PodSubCategoryScreen({
    this.filter,
    this.title,
  });

  String? filter;
  String? title;

  @override
  Widget build(BuildContext context) {
    final PodcSubController _controller =
        Get.put(PodcSubController(filter: filter,link: getPodcastSub1Categories));
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar:ColoredAppBar(),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: SmartRefresher(
                controller: _controller.refreshController,
                onRefresh: () => _controller.getData(),
                header: const MaterialClassicHeader(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8,),
                  child: Column(children: [
                    SizedBox(
                      height: Get.height / 10,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          // profile image
                          InkWell(
                            onTap: () => Get.to(
                                    () => ProfileScreen(isGuest: false)),
                            child: CircleAvatar(
                              radius: Get.width / 18,
                              // backgroundImage: NetworkImage(_controller
                              //         .getProfileImage ??
                              //     "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/2048px-Solid_white.svg.png"),
                            ),
                          ),

                          // Hello Text
                          Text(
                          title ?? "پادکست ها" ,
                            style: TextStyle(
                                fontFamily: "Yekan", fontSize: 18),
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

                    Expanded(child: Obx(()=>_controller.isDataLoaded.isTrue ? Padding(padding: EdgeInsets.symmetric(horizontal: 6,vertical: 6),child:  ListView.builder(
                        itemCount:
                        _controller.subCategories.length,
                        itemBuilder: (_, index) {
                          return InkWell(
                            onTap: (){
                              if(_controller.subCategories[index].isDirect == "true"){
                                Get.to(() => PodcastListScreen(title: _controller.subCategories[index].title,from: "L1S",filter: _controller.subCategories[index].id,));
                              }else{
                                Get.to(() => PodSubCategory1Screen(title: _controller.subCategories[index].title,filter: _controller.subCategories[index].id,));
                              }
                            },
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
                                                .subCategories[index].imagePath),)),
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
                                          _controller.subCategories[index].title,
                                          style: TextStyle(
                                              fontFamily: "Yekan",
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ))
                              ]),
                            ),
                          );
                        }),) : Loading())),
                  ]),
                )),
          )),
    );
  }
}
class PodSubCategory1Screen extends StatelessWidget {
  PodSubCategory1Screen({
    this.filter,
    this.title,
    this.normal,
  });

  String? filter;
  String? title;
  bool? normal;
  @override
  Widget build(BuildContext context) {
    normal??=true;
    final PodcSub1Controller _controller = Get.put(PodcSub1Controller(filter: filter,link: getPodcastSubCategories,normal: normal));
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: const Color(0xffffffff),
          appBar:ColoredAppBar(),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            child: SmartRefresher(
                controller: _controller.refreshController,
                onRefresh: () => _controller.getData(),
                header: const MaterialClassicHeader(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8,),
                  child: Column(children: [
                    SizedBox(
                      height: Get.height / 10,
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          // profile image
                          InkWell(
                            onTap: () => Get.to(
                                    () => ProfileScreen(isGuest: false)),
                            child: CircleAvatar(
                              radius: Get.width / 18,
                              // backgroundImage: NetworkImage(_controller
                              //         .getProfileImage ??
                              //     "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/2048px-Solid_white.svg.png"),
                            ),
                          ),

                          // Hello Text
                          Text(
                          title ?? "پادکست ها" ,
                            style: TextStyle(
                                fontFamily: "Yekan", fontSize: 18),
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

                    Expanded(child: Obx(()=>_controller.isDataLoaded.isTrue ? Padding(padding: EdgeInsets.symmetric(horizontal: 6,vertical: 6),child:  ListView.builder(
                        itemCount:
                        _controller.subCategories.length,
                        itemBuilder: (_, index) {
                          return InkWell(
                            onTap: () => Get.to(() => PodcastListScreen(filter: _controller.subCategories[index].id,title: _controller.subCategories[index].title,)),
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
                                                .subCategories[index].imagePath),)),
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
                                          _controller.subCategories[index].title,
                                          style: TextStyle(
                                              fontFamily: "Yekan",
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ))
                              ]),
                            ),
                          );
                        }),) : Loading())),
                  ]),
                )),
          )),
    );
  }
}
