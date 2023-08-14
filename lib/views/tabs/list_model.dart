import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  bool differentType = false;
  var mainModel = [];
  String currentTitle = "";

  ListModel(
      {required this.index,
      this.hasSubCategory,
      required this.currentType,
      required this.controller}) {
    mainModel = [];
    hasSubCategory ??= false;
    differentType = (currentType == TabbarTypes.ADULT ||
        currentType == TabbarTypes.NATIONAL);
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
          if (element['category'].toString() ==
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
          if (element['category'].toString() ==
              controller.allNationalTabCategories[index]["_id"].toString()) {
            mainModel.add(element);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return resourcesHolder(
        iconWidget: Container(),
        title: currentTitle.toString(),
        items: mainModel,
        normalType: differentType,
        onClick: (index) async {
          checkForValidSubsOrBuy(currentType, controller, onContinue: () {
            if (differentType) {
              if (mainModel[index]['startFrom'] == "l1") {
                Get.to(
                    () => TabbarSubMC1CategoryScreen(
                          currentType,
                          mainModel[index],
                          mainModel[index]['id'],
                          "l1",
                          firstTitle: currentTitle,
                          secondTitle: differentType
                              ? mainModel[index]['title']
                              : mainModel[index].title,
                        ),
                    preventDuplicates: false);
              } else if (mainModel[index]['startFrom'] == "l2") {
                Get.to(
                    () => TabbarSubMC2CategoryScreen(
                          currentType,
                          mainModel[index],
                          mainModel[index]['id'],
                          "l2",
                          firstTitle: currentTitle,
                          secondTitle: differentType
                              ? mainModel[index]['title']
                              : mainModel[index].title,
                        ),
                    preventDuplicates: false);
              } else if (mainModel[index]['startFrom'] == "l3") {
                Get.to(
                    () => TabbarSubMCMScreen(currentType, mainModel[index],
                        firstTitle: currentTitle,
                        secondTitle: differentType
                            ? mainModel[index]['title']
                            : mainModel[index].title,
                        categoryLm: true),
                    preventDuplicates: false);
              }
              return;
            }
            if (hasSubCategory!) {
              var items = controller.childTabbarItemModel;
              Get.to(() => TabbarSubCategoryScreen(
                    filter: mainModel[index],
                    items: items,
                    submitTitle: differentType
                        ? mainModel[index]['title']
                        : mainModel[index].title,
                    firstTitle: currentTitle,
                    secondTitle: differentType
                        ? mainModel[index]['title']
                        : mainModel[index].title,
                  ));
            } else {
              if (mainModel[index]
                      .video
                      .substring(mainModel[index].video.lastIndexOf("/") + 1) ==
                  "undefined") {
                ColoredSnack(
                    title: "خطا هنگام پیدا کردن ویدیو", type: SnackType.ERROR);
                return;
              }
              Get.to(() => TabbarItemScreen(mainModel[index]));
            }
          });
        });
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
