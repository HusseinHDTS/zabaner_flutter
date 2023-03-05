import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/controllers/news_data_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/views/screens/SubTabbarItemScreen.dart';
import 'package:zabaner/views/screens/subscribe_screen.dart';
import 'package:zabaner/views/screens/tabbar_item_screen.dart';
import 'package:zabaner/views/screens/tabbar_sub_category_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';

enum TabbarTypes { ADULT, CHILD, NATIONAL }

class ListModel extends StatelessWidget {
  int index;
  bool? hasSubCategory = false;
  NewsSearchController controller;
  TabbarTypes currentType;
  var mainModel = [];
  String currentTitle = "";

  ListModel(
      {required this.index,
      this.hasSubCategory,
      required this.currentType,
      required this.controller}) {
    mainModel = [];
    hasSubCategory ??= false;
    if (hasSubCategory!) {
      currentTitle =
          controller.allChildTabCategories[index]["title"].toString();
      controller.subCategoryModel.forEach((element) {
        if (element.category.toString() ==
            controller.allChildTabCategories[index]["_id"].toString()) {
          mainModel.add(element);
        }
      });
    } else {
      if (currentType == TabbarTypes.ADULT) {
        currentTitle =
            controller.allAdultTabCategories[index]["title"].toString();
        controller.adultTabbarItemModel.forEach((element) {
          if (element.category.toString() ==
              controller.allAdultTabCategories[index]["_id"].toString()) {
            mainModel.add(element);
          }
        });
      } else if (currentType == TabbarTypes.CHILD) {
        currentTitle =
            controller.allChildTabCategories[index]["title"].toString();
        controller.childTabbarItemModel.forEach((element) {
          if (element.category.toString() ==
              controller.allChildTabCategories[index]["_id"].toString()) {
            mainModel.add(element);
          }
        });
      } else if (currentType == TabbarTypes.NATIONAL) {
        currentTitle =
            controller.allNationalTabCategories[index]["title"].toString();
        controller.nationalTabbarItemModel.forEach((element) {
          if (element.category.toString() ==
              controller.allNationalTabCategories[index]["_id"].toString()) {
            mainModel.add(element);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Align(
            alignment: Alignment.centerRight,
            child: ColoredText(currentTitle.toString())),
        SizedBox(
          height: 5,
        ),
        resourcesBackground(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.4,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(
                        width: MediaQuery.of(context).size.width / 15,
                      ),
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 25,
                    right: MediaQuery.of(context).size.width / 25,
                  ),
                  itemCount: mainModel.length,
                  itemBuilder: (_context, index) {
                    return InkWell(
                      onTap: () {
                        if (currentType == TabbarTypes.NATIONAL) {
                          if (controller.profileInformation.hasNationalSub ==
                              null) {
                            Get.defaultDialog(
                                title: "شما اشتراک بخش آزمون ها را ندارید",
                                titleStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                                content: SubscribeDialog(currentType));
                            return;
                          }
                        } else if (currentType == TabbarTypes.ADULT) {
                          if (controller.profileInformation.hasAdultSub ==
                              null) {
                            Get.defaultDialog(
                                title: "شما اشتراک بخش بزرگسالان را ندارید",
                                titleStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                                content: SubscribeDialog(currentType));
                            return;
                          }
                        } else if (currentType == TabbarTypes.CHILD) {
                          if (controller.profileInformation.hasChildSub ==
                              null) {
                            Get.defaultDialog(
                                title: "شما اشتراک بخش کودکان را ندارید",
                                titleStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                                content: SubscribeDialog(currentType));
                            return;
                          }
                        }
                        if (hasSubCategory!) {
                          var items = controller.childTabbarItemModel;
                          // Get.to(() => SubTabbarItemScreen(
                          //     filter: mainModel[index].id, items: items));
                          Get.to(() => TabbarSubCategoryScreen(
                                filter: mainModel[index],
                                items: items,
                              ));
                        } else {
                          if (mainModel[index].video.substring(
                                  mainModel[index].video.lastIndexOf("/") +
                                      1) ==
                              "undefined") {
                            ColoredSnack(
                                title: "خطا هنگام پیدا کردن ویدیو",
                                type: SnackType.ERROR);
                            return;
                          }
                          Get.to(() => TabbarItemScreen(mainModel[index]));
                        }
                      },
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: CachedNetworkImage(
                                        imageUrl: mainModel[index].image,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3.8,
                                child: Text(
                                  mainModel[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 10,
                                      fontFamily: "Yekan"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ))
      ],
    );
  }
}

class SubscribeDialog extends StatelessWidget {
  TabbarTypes typeForBuy;

  SubscribeDialog(this.typeForBuy);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          const Icon(
            Icons.lock,
            color: Color(0xffddc0c0),
            size: 120,
          ),
          SizedBox(
            height: 12,
          ),
          ColoredText("آیا می خواهید اشتراک این بخش را تهیه کنید؟"),
          SizedBox(
            height: 12,
          ),
          Row(
            children: [
              Flexible(
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey),
                    child: Center(
                        child: Row(
                      children: [
                        const Flexible(
                            flex: 0,
                            child: Icon(
                              Icons.close,
                              color: Colors.white54,
                            )),
                        Flexible(
                            flex: 1,
                            child: Container(
                                width: double.infinity,
                                child: ColoredText(
                                  "بستن",
                                  textColor: Colors.white,
                                ))),
                      ],
                    )),
                  ),
                ),
                flex: 1,
              ),
              Flexible(
                child: InkWell(
                  onTap: () {
                    Get.back();
                    Get.to(() => SubscribeScreen(typeForBuy));
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green),
                    child: Center(
                        child: Row(
                      children: [
                        const Flexible(
                            flex: 0,
                            child: Icon(
                              Icons.lock_open_outlined,
                              color: Colors.white70,
                            )),
                        Flexible(
                            flex: 1,
                            child: Container(
                                width: double.infinity,
                                child: ColoredText(
                                  "خرید",
                                  textColor: Colors.white,
                                ))),
                      ],
                    )),
                  ),
                ),
                flex: 1,
              ),
            ],
          )
        ],
      ),
    );
  }
}
