import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/resources_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/magoosh_resources.dart';
import 'package:zabaner/views/screens/profile_screen.dart';
import 'package:zabaner/views/widgets/book_resources.dart';
import 'package:zabaner/views/widgets/pocast_resources.dart';
import 'package:zabaner/views/widgets/resources_search_widget.dart';
import 'package:zabaner/views/widgets/serach_text_input.dart';
import 'package:zabaner/views/widgets/video_resources.dart';
import 'package:zabaner/widgets/custom_anim_search.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class ResourcesScreen extends StatelessWidget {
  ResourcesScreen({Key? key, required this.isGuest}) : super(key: key);
  final bool isGuest;
  static final onSearchClick = false.obs;

  @override
  Widget build(BuildContext context) {
    final ResourcesController _controller = Get.put(ResourcesController());
    final ResourcesSearch _searchController = Get.put(ResourcesSearch());
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: const Color(0xffffffff),
            appBar: ColoredAppBar(
              title: "منابع زبان انگلیسی",
              actions: [
                Container(
                  padding: EdgeInsets.all(8),
                  child: CustomAnimSearch(
                      width: (Get.width * 4) / 5,
                      helpText: "نام کتاب، انیمیشن، پادکست...",
                      textController: _controller.textController,
                      autoFocus: true,
                      onSuffixTap: () {},
                      onOpen: () {
                        onSearchClick.value = true;
                      },
                      onClose: () {
                        _controller.closeSearch();
                        _searchController.searchContent.clear();
                      },
                      closeSearchOnSuffixTap: true,
                      style: TextStyle(fontFamily: "IRANSansPro", fontSize: 14),
                      onSubmitted: (value) {
                        _searchController.search(value);
                      }),
                )
              ],
              backIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: InkWell(
                  onTap: () {
                    Get.to(() => ProfileScreen(isGuest: isGuest));
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.menu,
                        size: 30,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Column(children: [
                // Top of screen
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: Get.height / 70,
                ),

                Expanded(
                  child: Stack(
                    children: [
                      // Resources
                      SizedBox(
                        height: Get.height,
                        width: Get.width,
                        child: Obx(() => _controller.dataError.isTrue
                            ? ErrorLoading()
                            : _controller.isDataLoaded.isTrue
                                ? SmartRefresher(
                                    controller: _controller.refreshController,
                                    onRefresh: () {
                                      _controller.getResources();
                                    },
                                    header: const MaterialClassicHeader(),
                                    child: ListView(
                                      children: [
                                        BookResources(
                                          isGuest: isGuest,
                                          categories: _controller.categories,
                                        ),
                                        _controller.resourcesList.length > 1
                                            ? PocastResources(
                                                isGuest: isGuest,
                                                categories: _controller
                                                    .podcastCategories)
                                            : Container(),
                                        _controller.resourcesList.length > 2
                                            ? VideoResources(
                                                isGuest: isGuest,
                                                resource: _controller
                                                    .resourcesList[2].resources,
                                                videoCategories:
                                                    _controller.videoCategories)
                                            : SizedBox(),
                                        if (_controller
                                            .tedCategories.isNotEmpty)
                                          TedResources(category: _controller.tedCategories,),
                                          if (_controller
                                            .ieltsCategories.isNotEmpty)
                                          MagooshResources(
                                            category:
                                                _controller.ieltsCategories,
                                            type: "ielts",
                                          ),
                                        if (_controller
                                            .ieltsGeneralCategories.isNotEmpty)
                                          MagooshResources(
                                            category: _controller
                                                .ieltsGeneralCategories,
                                            type: "ielts-general",
                                          ),

                                        SizedBox(
                                          height: 80,
                                        ),
                                      ],
                                    ),
                                  )
                                : Loading()),
                      ),

                      /// search items
                      Obx(() => Visibility(
                          visible: onSearchClick.value,
                          child: Container(
                            width: Get.width,
                            height: Get.height,
                            color: Colors.white,
                            child: Obx(() {
                              switch (_searchController.searchState.value) {
                                case "success":
                                  return ListView.builder(
                                      itemCount: _searchController
                                          .searchContent.length,
                                      itemBuilder: (context, index) =>
                                          ResourcesSearchWidget(
                                            id: _searchController
                                                .searchContent[index].id,
                                            imagePath: _searchController
                                                .searchContent[index].imagePath,
                                            faTitle: _searchController
                                                .searchContent[index].faTitle,
                                            title: _searchController
                                                .searchContent[index].title,
                                            type: _searchController
                                                .searchContent[index].type,
                                          ));
                                case "empty":
                                  return Container(
                                    height: Get.height / 1.5,
                                    width: Get.width,
                                    color: Colors.white,
                                    child: const Center(
                                      child: Text(
                                          "نتیجه ای برای جستجوی شما یافت نشد"),
                                    ),
                                  );

                                case "loading":
                                  return Container(
                                    height: Get.height / 1.5,
                                    width: Get.width,
                                    color: Colors.white,
                                    child: Center(child: Loading()),
                                  );
                              }
                              return Container(
                                height: Get.height / 1.5,
                                width: Get.width,
                                color: Colors.white,
                              );
                            }),
                          )))
                    ],
                  ),
                )
              ]),
            )));
  }
}
