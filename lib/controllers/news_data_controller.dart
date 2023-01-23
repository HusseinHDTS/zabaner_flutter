import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/models/category_content_model.dart';
import 'package:zabaner/models/child_tabbar_sub_category.dart';
import 'package:zabaner/models/profile_information_model.dart';
import 'package:zabaner/models/tabbar_item.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class NewsDataController extends GetxController with StateMixin {
  NewsDataController(this.isGuest);
  final GetConnect _getConnect = GetConnect();
  final GetStorage _getStorage = GetStorage();
  var categories = [].obs;
  final bool isGuest;
  RxList<CategoryContent> content = [
    CategoryContent(
        bookmark: false,
        imagePath: "",
        createdAt: DateTime(1),
        description: "",
        id: "",
        title: "")
  ].obs;

  @override
  void onInit() async {
    super.onInit();
    _getConnect.allowAutoSignedCert = true;
    await GetStorage.init();
    change(null, status: RxStatus.loading());
    var response = await _getConnect.get(newsCategoryUrl);
    categories.insert(0, 'همه');
    categories.addAll(jsonDecode(response.bodyString ?? "[]"));
    if (categories.isNotEmpty) getContent(categories[0], isGuest);
    _getConnect.allowAutoSignedCert = true;
  }

  void getContent(String category, bool isGuest) async {
    _getConnect.allowAutoSignedCert = true;
    content.clear();
    if (category != 'همه') {
      var req = isGuest
          ? await _getConnect.get(
              newsCategoryContentUrl,
              query: {'category': category},
            )
          : await _getConnect.get(
              newsCategoryContentUrl,
              query: {'category': category},
              headers: {
                'accept': 'application/json',
                'Authorization': 'Bearer ${_getStorage.read('token')}'
              },
            );
      if (req.statusCode == 200) {
        content.addAll(categoryContentFromJson(req.bodyString ?? ""));
        change(null, status: RxStatus.success());
      } else if (req.statusCode == 401) {
        _getStorage.remove('timers');
        _getStorage.remove('token');
        _getStorage.remove('timers');
        Get.offAll(LoginScreen());
      } else {
        ///ERROR
      }
    } else {
      var req = isGuest
          ? await _getConnect.get(
              newsCategoryContentUrl,
            )
          : await _getConnect.get(
              newsCategoryContentUrl,
              headers: {
                'accept': 'application/json',
                'Authorization': 'Bearer ${_getStorage.read('token')}'
              },
            );
      if (req.statusCode == 200) {
        content.addAll(categoryContentFromJson(req.bodyString ?? ""));
        change(null, status: RxStatus.success());
      } else if (req.statusCode == 401) {
        _getStorage.remove('timers');
        _getStorage.remove('token');
        _getStorage.remove('timers');
        Get.offAll(LoginScreen());
      } else {
        ///ERROR
      }
    }
  }

  void bookmarkToggle(String id) async {
    var _request = await _getConnect.post(
        bookmarkToggleUrl, {'type': 'news', 'bookmarkAbleId': id},
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${_getStorage.read('token')}'
        },
        contentType: "application/json");
    if (_request.statusCode != 201) {
      ColoredSnack(title: "Error",description:_request.statusText.toString(),type: SnackType.ERROR);
    }
  }

  get getProfileImage {
    final GetStorage _getStorage = GetStorage();
    return _getStorage.read('profile_image');
  }
}

class NewsSearchController extends GetConnect {
  List<CategoryContent> searchContent = [];
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  RefreshController refreshController1 = RefreshController();
  RefreshController refreshController2 = RefreshController();
  RefreshController refreshController3 = RefreshController();
  RefreshController refreshController4 = RefreshController();
  var dataError = false.obs;

  var _dataLoaded = false.obs;
  var titles = [].obs;
  @override
  void onInit() {
    super.onInit();
    getData();
  }

  bool isDataLoaded(){
    return _dataLoaded.isTrue;
  }

  void setDataLoaded(bool isLoaded){
    if(_dataLoaded.value != isLoaded) {
      _dataLoaded.value = isLoaded;
    }
  }

  var allChildTabCategories  = [];
  var allAdultTabCategories = [];
  var allNationalTabCategories = [];

  late List<SubCategoryItem> subCategoryModel;
  late List<TabbarItem> childTabbarItemModel;
  late List<TabbarItem> adultTabbarItemModel;
  late List<TabbarItem> nationalTabbarItemModel;
  late ProfileInformation profileInformation;
  final GetStorage _getStorage = GetStorage();


  void getData() async{
    setDataLoaded(false);
    dataError.value = false;
    final _request = await _getConnect.get(getTabbarCategory);
    final _request1 = await _getConnect.get(getChildTabbarCategory);
    final _request2 = await _getConnect.get(getChildTabbarItems);
    final _request3 = await _getConnect.get(getAdultTabbarItems);
    final _request4 = await _getConnect.get(getNationalTabbarItems);
    final _requestProfile = await _getConnect.get(profileInformationUrl, headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer ${_getStorage.read('token')}'
    });
    final _request5 = await _getConnect.get(getAllChildTabCategories);
    final _request6 = await _getConnect.get(getAllAdultTabCategories);
    final _request7 = await _getConnect.get(getAllNationalTabCategories);
    titles.clear();
    titles.value = ["" , "" , ""];
    if (_request.statusCode == 200 && _request1.statusCode == 200 && _request2.statusCode == 200 && _request3.statusCode == 200
        && _request4.statusCode == 200 && _request5.statusCode == 200 && _request6.statusCode == 200 && _request7.statusCode == 200 && _requestProfile.statusCode == 200) {
      subCategoryModel = subCategoryListModelFromJson(_request1.bodyString ??"");
      childTabbarItemModel = tabbarItemListModelFromJson(_request2.bodyString ??"");
      adultTabbarItemModel = tabbarItemListModelFromJson(_request3.bodyString ??"");
      nationalTabbarItemModel = tabbarItemListModelFromJson(_request4.bodyString ??"");

      profileInformation = profileInformationFromJson(_requestProfile.bodyString ?? "");

      allChildTabCategories = jsonDecode(_request5.bodyString ?? "");
      allAdultTabCategories = jsonDecode(_request6.bodyString ?? "");
      allNationalTabCategories = jsonDecode(_request7.bodyString ?? "");

      var datas = jsonDecode(_request.bodyString??"");
      int size = datas.length;
      for(int i = 0 ; i < size ; i ++){
        var data = datas[i];
        if(data['forTab'] == "0"){
          titles[0] = data['title'];
        }else if(data['forTab'] == "1"){
          titles[1] = data['title'];
        }else if(data['forTab'] == "2"){
          titles[2] = data['title'];
        }
      }
      refreshController1.refreshCompleted();
      refreshController2.refreshCompleted();
      refreshController3.refreshCompleted();
      refreshController4.refreshCompleted();
      setDataLoaded(true);
    }
    else{
      dataError.value = true;
    }
  }

  String getTitle(int index){
    if(titles.length >=index){
      return titles[index].toString();
    }else{
      return "null Index";
    }
  }

}
