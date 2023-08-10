import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:zabaner/views/screens/tabbar_sub_category_screen.dart';
import 'package:zabaner/views/tabs/list_model.dart';

import '../models/urls.dart';

class TabbarSubMC1CategoryController extends GetxController {
  RxBool isDataLoaded = false.obs;
  var categories;

  TabbarSubMC1CategoryController();

  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);

  @override
  void onInit() {
    super.onInit();
  }

  void onItemClick(tabbarType, item, sF) {
    debugPrint("dsalkjdsakjdkasjdkjsakdjs : " + item.toString());
    if (sF == "l1") {
      // Get.back();
      Get.to(
          () => TabbarSubMC2CategoryScreen(
              tabbarType, item, item['category'], "l2"),
          preventDuplicates: false);
    } else if (sF == "l2") {
      // Get.back();
      Get.to(() => TabbarSubMCMScreen(tabbarType,item), preventDuplicates: false);
    } else {
      // Get.back();
      // Get.to(()=>TabbarSubMCMScreen(item),preventDuplicates: false);
    }
  }

  void getData(startFrom, filter,type) async {
    isDataLoaded.value = false;
    var bodyRequest = {"filter":filter};
    String categoryLink = "";
    if(type == TabbarTypes.ADULT){
      if(startFrom == "l1"){
        categoryLink = getAllAdultMC1TabCategories;
      }else{
        categoryLink = getAllAdultMC2TabCategories;
      }
    }else if(type == TabbarTypes.NATIONAL){
      if(startFrom == "l1"){
        categoryLink = getAllNationalMC1TabCategories;
      }else{
        categoryLink = getAllNationalMC2TabCategories;
      }
    }
    var response = await _getConnect.post(categoryLink, bodyRequest);
    categories = jsonDecode(response.bodyString ?? "");
    isDataLoaded.value = true;
  }
}

class TabbarSubMC2CategoryController extends GetxController {
  RxBool isDataLoaded = false.obs;
  var categories;

  TabbarSubMC2CategoryController();

  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);

  @override
  void onInit() {
    super.onInit();
  }

  void onItemClick(tabbarType, item, sF) {
    if (sF == "l1") {
      // Get.back();
      Get.to(
          () => TabbarSubMC2CategoryScreen(
              tabbarType, item, item['category'], "l2"),
          preventDuplicates: false);
    } else if (sF == "l2") {
      // Get.back();
      Get.to(() => TabbarSubMCMScreen(tabbarType,item), preventDuplicates: false);
    } else {
      // Get.back();
      // Get.to(()=>TabbarSubMCMScreen(item),preventDuplicates: false);
    }
  }

  void getData(startFrom, filter,type) async {
    isDataLoaded.value = false;
    var bodyRequest = {"filter":filter};
    String categoryLink = "";
    if(type == TabbarTypes.ADULT){
      if(startFrom == "l1"){
        categoryLink = getAllAdultMC1TabCategories;
      }else{
        categoryLink = getAllAdultMC2TabCategories;
      }
    }else if(type == TabbarTypes.NATIONAL){
      if(startFrom == "l1"){
        categoryLink = getAllNationalMC1TabCategories;
      }else{
        categoryLink = getAllNationalMC2TabCategories;
      }
    }
    var response = await _getConnect.post(categoryLink, bodyRequest);
    categories = jsonDecode(response.bodyString ?? "");
    isDataLoaded.value = true;
  }

}

class TabbarSubMCMController extends GetxController {
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  var items;
  RxBool isDataLoaded = false.obs;

  void getData(tabbarType,filter,bool categoryLm) async {
    isDataLoaded.value = false;
    String linkToGet = "";
    if(tabbarType == TabbarTypes.ADULT){
      linkToGet = getAdultTabbarItems;
    }
    if(tabbarType == TabbarTypes.NATIONAL){
      linkToGet = getNationalTabbarItems;
    }
    var response = await _getConnect.post(linkToGet, {"filter": filter,"categoryLm":categoryLm.toString()});
    items = jsonDecode(response.bodyString ?? "");
    isDataLoaded.value = true;
  }
}
