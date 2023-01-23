import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/resources_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/profile_screen.dart';
import 'package:zabaner/views/widgets/book_resources.dart';
import 'package:zabaner/views/widgets/pocast_resources.dart';
import 'package:zabaner/views/widgets/resources_search_widget.dart';
import 'package:zabaner/views/widgets/serach_text_input.dart';
import 'package:zabaner/views/widgets/video_resources.dart';

class ResourcesScreen extends StatelessWidget {
  ResourcesScreen({Key? key, required this.isGuest}) : super(key: key);
  final bool isGuest;
  static final onSearchClick = false.obs;

  @override
  Widget build(BuildContext context) {
    final ResourcesController _controller = Get.put(ResourcesController());
    final ResourcesSearch _searchController = Get.put(ResourcesSearch());
    return SafeArea(
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                backgroundColor: const Color(0xffffffff),
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width / 40),
                  child: Column(children: [
                    // Top of screen
                    SizedBox(
                      height: Get.height / 10,
                      child: Row(
                        children: [
                          SizedBox(width: 10,),
                          InkWell(
                            onTap: () =>
                                Get.to(()=>ProfileScreen(isGuest: false)),
                            child: CircleAvatar(
                              radius: Get.width / 18,
                              backgroundImage: NetworkImage(_controller
                                      .getProfileImage ??
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/Solid_white.svg/2048px-Solid_white.svg.png"),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: Get.width / 1.72,
                              child: const Text(
                                "منابع زبان انگلیسی",
                                style:
                                    TextStyle(fontFamily: "Yekan", fontSize: 18),
                              ),
                            ),
                          ),

                          // Logo in top left
                        ],
                      ),
                    ),

                    // Search Text Input
                    Obx(()=>SizedBox(
                      width: Get.width,
                      height: Get.height / 22,
                      child: SearchTextInput(
                        onClick: ()=>onSearchClick.value =true,
                        focus: _controller.focus,
                        textController: _controller.textController,
                        onChange: onSearchClick.value == true ? InkWell(child: const Padding(
                          padding:
                          EdgeInsets.only(left: 13, top: 4, bottom: 4, right: 13),
                          child: Icon(Icons.close,color: Colors.grey,),
                        ),onTap: (){
                          _controller.closeSearch();
                          },) : Padding(
                          padding:
                          const EdgeInsets.only(left: 13, top: 4, bottom: 4, right: 13),
                          child: Image.asset(
                            "assets/images/search.png",
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        onFieldSubmitted: (value) => value.isEmpty
                            ? onSearchClick.value = false
                            : {_searchController.search(value)},
                      ),
                    )),

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
                            child:  SmartRefresher(
                              controller: _controller.refreshController,
                              onRefresh: (){
                                _controller.getResources();
                              },
                              header: const MaterialClassicHeader(),
                              child: Obx(()=> _controller.dataError.isTrue ? ErrorLoading() : _controller.isDataLoaded.isTrue ? ListView(
                                children: [
                                  BookResources(
                                    isGuest: isGuest,
                                    categories:  _controller.categories ,
                                  ),
                                  _controller.resourcesList.length > 1 ? PocastResources(
                                      isGuest: isGuest,
                                      categories: _controller
                                          .podcastCategories) : Container(),
                                  _controller.resourcesList.length > 2
                                      ? VideoResources(
                                      isGuest: isGuest,
                                      resource: _controller.resourcesList[2].resources,
                                      videoCategories: _controller.videoCategories)
                                      : SizedBox()
                                ],
                              ) : Loading() ),
                            ),
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
                                                    .searchContent[index]
                                                    .imagePath,
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
                                        child: Center(
                                            child: Loading()),
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
                ))));
  }
}
