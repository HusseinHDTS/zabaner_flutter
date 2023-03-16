import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/controllers/sub_tabbar_item_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/SubTabbarItemScreen.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class TabbarSubCategoryScreen extends StatefulWidget {
  var filter,items;
  var submitTitle;
  TabbarSubCategoryScreen({required this.filter,required this.items,required this.submitTitle});

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
                          Get.to(() => SubTabbarItemScreen(filter: controller.data[index]["id"], items: widget.items,submitTitle:widget.submitTitle));
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
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(getUrl(
                                        controller.data[index]['imagePath'] ??
                                            "")),
                                  )),
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
                                  controller.data[index]['title'],
                                  style: TextStyle(
                                      fontFamily: "Yekan",
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
