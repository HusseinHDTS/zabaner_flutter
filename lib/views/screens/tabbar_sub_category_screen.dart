import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/sub_tabbar_item_controller.dart';
import 'package:zabaner/controllers/tabbar_sub_mc_category_controller.dart';
import 'package:zabaner/models/tabbar_item.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/SubTabbarItemScreen.dart';
import 'package:zabaner/views/screens/tabbar_item_screen.dart';
import 'package:zabaner/views/tabs/list_model.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class TabbarSubCategoryScreen extends StatefulWidget {
  var filter, items;
  var submitTitle;
  String firstTitle,secondTitle;
  TabbarSubCategoryScreen(
      {required this.filter, required this.items, required this.submitTitle,this.firstTitle = "",this.secondTitle = ""});

  @override
  State<StatefulWidget> createState() {
    return _TabbarSubCategoryScreen();
  }
}

class _TabbarSubCategoryScreen extends State<TabbarSubCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    SubTabbarItemController controller =
        Get.put(SubTabbarItemController(filter: widget.filter.id));

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: ColoredAppBar(),
          body: Obx(() => controller.isDataLoaded.value
              ? SmartRefresher(
            controller: controller.refreshController,
            onRefresh: () {
              controller.getData();
            },
            header: const MaterialClassicHeader(),
            child: controller.errorData.isTrue
                ? ErrorLoading(retry: () {
              controller.getData();
            })
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                    child: ColoredText(
                      "${widget.firstTitle} > ${widget.secondTitle}",)),
                Expanded(
                    child: controller.data.length == 0
                        ? NoData()
                        : ListView.builder(
                        itemCount:
                        controller.data.length,
                        itemBuilder: (_, index) {
                          return resourceItemHolder(
                              title: (controller.data[index]['mTitle'] ?? "") == ""
                                  ? controller.data[index]['title']
                                  : controller.data[index]['mTitle'],
                              hasMore: true,
                              itemType: "podcast",
                              imagePath: getUrl(controller.data[index]['imagePath']),
                              onClick: () {
                                Get.to(() => SubTabbarItemScreen(
                                    filter: controller.data[index]["id"],
                                    items: widget.items,
                                    firstTitle: "${widget.firstTitle} > ${widget.secondTitle}",
                                    secondTitle: controller.data[index]["title"],
                                    submitTitle: widget.submitTitle
                                ));
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
          body: SmartRefresher(
            controller: controller.refreshController,
            onRefresh: () {
              controller.getData();
            },
            child: Obx(() => controller.isDataLoaded.isTrue
                ? ListView.builder(
                    itemCount: controller.data.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(() => SubTabbarItemScreen(
                              filter: controller.data[index]["id"],
                              items: widget.items,
                              submitTitle: widget.submitTitle));
                        },
                        child: Container(
                          width: Get.width,
                          height: Get.height / 6,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          decoration: BoxDecoration(
                              color: Color(0xffDBDBDB),
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(children: [
                            // image
                            Container(
                              width: Get.width / 3,
                              height: Get.height,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: CachedNetworkImage(
                                  imageUrl: getUrl(controller.data[index]
                                          ['imagePath'] ??
                                      ""),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // empty space
                            SizedBox(
                              width: Get.width / 12,
                            ),

                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (controller.data[index]['mTitle'] ?? "") == ""
                                      ? controller.data[index]['title']
                                      : controller.data[index]['mTitle'],
                                  style: TextStyle(
                                      fontFamily: "IRANSansPro",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ))
                          ]),
                        ),
                      );
                    },
                  )
                : controller.errorData.value
                    ? ErrorLoading()
                    : Loading()),
          ),
        ));
  }
}

class TabbarSubMC1CategoryScreen extends StatefulWidget {
  TabbarTypes tabbarType;
  dynamic item;
  String filter, startFrom;
  String firstTitle,secondTitle;
  TabbarSubMC1CategoryScreen(
      this.tabbarType, this.item, this.filter, this.startFrom,{this.firstTitle = "",this.secondTitle = ""});

  @override
  State<StatefulWidget> createState() {
    return _TabbarSubMC1CategoryScreen();
  }
}
class _TabbarSubMC1CategoryScreen extends State<TabbarSubMC1CategoryScreen> {
  TabbarSubMC1CategoryController controller = Get.put(TabbarSubMC1CategoryController());

  @override
  void initState() {
    super.initState();
    controller.getData("l1",widget.filter,widget.tabbarType);
  }

  @override
  void dispose() {
    super.dispose();
    // controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: ColoredAppBar(),
          body: Obx(() => controller.isDataLoaded.value
              ? SmartRefresher(
            controller: controller.refreshController,
            onRefresh: () {
              controller.getData("l1",widget.filter,widget.tabbarType);
            },
            header: const MaterialClassicHeader(),
            child: controller.errorData.isTrue
                ? ErrorLoading(retry: () {
              controller.getData("l1",widget.filter,widget.tabbarType);
            })
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                    child: ColoredText(
                      "${widget.firstTitle} > ${widget.secondTitle}",)),
                Expanded(
                    child: controller.categories.length == 0
                        ? NoData()
                        : ListView.builder(
                        itemCount:
                        controller.categories.length,
                        itemBuilder: (_, index) {
                          return resourceItemHolder(
                              title: controller.categories[index]['title'],
                              hasMore: true,
                              itemType: "podcast",
                              imagePath:getUrl(controller.categories[index]['imagePath']),
                              onClick: () {
                                controller.onItemClick(widget.tabbarType,controller.categories[index],widget.startFrom);
                              },
                              index: index);
                        })),
              ],
            ),
          )
              : Loading()),
        ));

    return Scaffold(
      appBar: ColoredAppBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Obx(() => controller.isDataLoaded.value
            ? Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: controller.categories.length == 0 ? NoData() : ListView.builder(
                        itemCount: controller.categories.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var item = controller.categories[index];
                          return InkWell(
                            onTap: () => controller.onItemClick(widget.tabbarType,item,widget.startFrom),
                            child: Container(
                              width: Get.width,
                              height: Get.height / 6,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Color(0xffDBDBDB),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(children: [
                                // image
                                Container(
                                  width: Get.width / 3,
                                  height: Get.height,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            getUrl(item['imagePath'])),
                                      )),
                                ),

                                // empty space
                                SizedBox(
                                  width: Get.width / 12,
                                ),

                                Expanded(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: TextStyle(
                                          fontFamily: "IRANSansPro",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ))
                              ]),
                            ),
                          );
                        }),
                  ),
                ],
              )
            : Loading()),
      ),
    );
  }
}


class TabbarSubMC2CategoryScreen extends StatefulWidget {
  TabbarTypes tabbarType;
  dynamic item;
  String filter, startFrom;
  String firstTitle, secondTitle;

  TabbarSubMC2CategoryScreen(
      this.tabbarType, this.item, this.filter, this.startFrom,{this.firstTitle = "",this.secondTitle = ""});

  @override
  State<StatefulWidget> createState() {
    return _TabbarSubMC2CategoryScreen();
  }
}
class _TabbarSubMC2CategoryScreen extends State<TabbarSubMC2CategoryScreen> {
  TabbarSubMC2CategoryController controller = Get.put(TabbarSubMC2CategoryController());

  @override
  void initState() {
    super.initState();
    controller.getData("l2",widget.filter,widget.tabbarType);
  }

  @override
  void dispose() {
    super.dispose();
    // controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: ColoredAppBar(),
          body: Obx(() => controller.isDataLoaded.value
              ? SmartRefresher(
            controller: controller.refreshController,
            onRefresh: () {
              controller.getData("l2",widget.filter,widget.tabbarType);
            },
            header: const MaterialClassicHeader(),
            child: controller.errorData.isTrue
                ? ErrorLoading(retry: () {
              controller.getData("l2",widget.filter,widget.tabbarType);
            })
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                    child: ColoredText(
                      "${widget.firstTitle} > ${widget.secondTitle}",)),
                Expanded(
                    child: controller.categories.length == 0
                        ? NoData()
                        : ListView.builder(
                        itemCount:
                        controller.categories.length,
                        itemBuilder: (_, index) {
                          return resourceItemHolder(
                              title: controller.categories[index]['title'],
                              hasMore: true,
                              itemType: "podcast",
                              imagePath:getUrl(controller.categories[index]['imagePath']),
                              onClick: () {
                                controller.onItemClick(widget.tabbarType,controller.categories[index],widget.startFrom);
                              },
                              index: index);
                        })),
              ],
            ),
          )
              : Loading()),
        ));

    return Scaffold(
      appBar: ColoredAppBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Obx(() => controller.isDataLoaded.value
            ? Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: controller.categories.length == 0 ? NoData() : ListView.builder(
                        itemCount: controller.categories.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var item = controller.categories[index];
                          return InkWell(
                            onTap: () => controller.onItemClick(widget.tabbarType,item,widget.startFrom),
                            child: Container(
                              width: Get.width,
                              height: Get.height / 6,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Color(0xffDBDBDB),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Row(children: [
                                // image
                                Container(
                                  width: Get.width / 3,
                                  height: Get.height,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            getUrl(item['imagePath'])),
                                      )),
                                ),

                                // empty space
                                SizedBox(
                                  width: Get.width / 12,
                                ),

                                Expanded(
                                    child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: TextStyle(
                                          fontFamily: "IRANSansPro",
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ))
                              ]),
                            ),
                          );
                        }),
                  ),
                ],
              )
            : Loading()),
      ),
    );
  }
}



class TabbarSubMCMScreen extends StatefulWidget {
  var item;
  var tabbarType;
  bool categoryLm;
  String firstTitle,secondTitle;
  TabbarSubMCMScreen(this.tabbarType,this.item,{this.categoryLm = false,this.firstTitle = "",this.secondTitle = ""});
  @override
  State<StatefulWidget> createState() {
    return _TabbarSubMCMScreen();
  }
}

class _TabbarSubMCMScreen extends State<TabbarSubMCMScreen> {
  TabbarSubMCMController controller = Get.put(TabbarSubMCMController());

  @override
  void initState() {
    super.initState();
    controller.getData(widget.tabbarType,widget.item['id'],widget.categoryLm);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: ColoredAppBar(),
          body: Obx(() => controller.isDataLoaded.value
              ? SmartRefresher(
            controller: controller.refreshController,
            onRefresh: () {
              controller.getData(widget.tabbarType,widget.item['id'],widget.categoryLm);
            },
            header: const MaterialClassicHeader(),
            child: controller.errorData.isTrue
                ? ErrorLoading(retry: () {
              controller.getData(widget.tabbarType,widget.item['id'],widget.categoryLm);
            })
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 18, vertical: 18),
                    child: ColoredText(
                      "${widget.firstTitle} > ${widget.secondTitle}",)),
                Expanded(
                    child: controller.items.length == 0
                        ? NoData()
                        : ListView.builder(
                        itemCount:
                        controller.items.length,
                        itemBuilder: (_, index) {
                          return resourceItemHolder(
                              title: controller.items[index]['title'],
                              hasMore: false,
                              itemType: "podcast",
                              imagePath:getUrl(controller.items[index]['imagePath']),
                              onClick: () {
                                Get.to(() => TabbarItemScreen(TabbarItem.fromJson(controller.items[index])));
                              },
                              index: index);
                        })),
              ],
            ),
          )
              : Loading()),
        ));
    return Scaffold(
      appBar: ColoredAppBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Obx(()=> controller.isDataLoaded.value ? Column(
          children: [
            Expanded(
              flex: 1,
              child: controller.items.length == 0 ? NoData() : ListView.builder(
                  itemCount: controller.items.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var item = controller.items[index];
                    TabbarItem tItem = TabbarItem.fromJson(item);
                    return InkWell(
                      onTap: () => Get.to(() => TabbarItemScreen(tItem)),
                      child: Container(
                        width: Get.width,
                        height: Get.height / 6,
                        margin: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                            color: Color(0xffDBDBDB),
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(children: [
                          // image
                          Container(
                            width: Get.width / 3,
                            height: Get.height,
                            margin: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      getUrl(item['imagePath'])),
                                )),
                          ),

                          // empty space
                          SizedBox(
                            width: Get.width / 12,
                          ),

                          Expanded(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['title'],
                                    style: TextStyle(
                                        fontFamily: "IRANSansPro",
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ))
                        ]),
                      ),
                    );
                  }),
            ),
          ],
        ) : Loading()),
      ),
    );
  }
}
