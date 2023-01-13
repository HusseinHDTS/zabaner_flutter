// const baseUrl = "https://3sotweb-projects.com";
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:zabaner/widgets/colored_snack.dart';

const baseUrl = "https://app.zabaner.ir";
// const baseUrl = "https://138.201.100.200:3000";
const signinUrl = "$baseUrl/api/v1/auth/signin";
const signupUrl = "$baseUrl/api/v1/auth/signup";
const newsCategoryUrl = "$baseUrl/api/v1/news-categories";
const subCategoryUrl = "$baseUrl/api/v1/sub-categories";
const videoCategoryUrl = "$baseUrl/api/v1/video-categories";
const podcastCategoryUrl = "$baseUrl/api/v1/podcast-categories";
const getTabbarCategory = "$baseUrl/api/v1/tabbar-categories";
const getChildTabbarCategory = "$baseUrl/api/v1/child-tabbar-categories";
const getChildTabbarItems = "$baseUrl/api/v1/child-tabbar";
const getAdultTabbarItems = "$baseUrl/api/v1/adult-tabbar";
const getUpdateVersions = "$baseUrl/api/v1/versions";
const getNationalTabbarItems = "$baseUrl/api/v1/national-tabbar";
const getAllChildTabCategories = "$baseUrl/api/v1/child-mc-categories";
const getAllAdultTabCategories = "$baseUrl/api/v1/adult-mc-categories";
const getAllNationalTabCategories = "$baseUrl/api/v1/national-mc-categories";
const newsCategoryContentUrl = "$baseUrl/api/v1/news";
const getPodcastSubCategories = "$baseUrl/api/v1/podcast-sub-categories";
const resourcesUrl = "$baseUrl/api/v1/resources/home";
const profileInformationUrl = "$baseUrl/api/v1/user";
const paymentCheck = "$baseUrl/api/v1/user/payment";
const updateSubscribeProfile = "$baseUrl/api/v1/user/insert-new-sub";
const getUserId = "$baseUrl/api/v1/user/userId";
const paymentResultSubmit = "$baseUrl/api/v1/payment/result";
const getSubscribeSettings = "$baseUrl/api/v1/subscribe-settings";
const getSubscribeHistory = "$baseUrl/api/v1/payment";
const userPaymentCheck = "$baseUrl/api/v1/user/payment";
const updateProfileUrl = "$baseUrl/api/v1/user";
const getBookDetailUrl = "$baseUrl/api/v1/books/";
const homeDataUrl = "$baseUrl/api/v1/home";
const summaryTimeUrl = "$baseUrl/api/v1/statistics";
const getPodcastDetailUrl = "$baseUrl/api/v1/podcasts/";
const newsDetailUrl = "$baseUrl/api/v1/news/";
const bookmarkToggleUrl = "$baseUrl/api/v1/bookmarks/toggle";
const resourcesSearchUrl = "$baseUrl/api/v1/resources/search";
const updateStaticsUrl = "$baseUrl/api/v1/statistics";
const updateLastSeenAt = "$baseUrl/api/v1/user/update-user-last-seen";
const getTicketsList = "$baseUrl/api/v1/support1";
const getConversationList = "$baseUrl/api/v1/support2";
const sendSupportTitle = "$baseUrl/api/v1/support1/create";
const sendSupportDescription = "$baseUrl/api/v1/support2/create";
const getIssues = "$baseUrl/api/v1/issue";
const validateCodeUrl = "$baseUrl/api/v1/auth/validate-auth-code";
const forgotPasswordUrl = "$baseUrl/api/v1/auth/forgot-password";
const setNewPasswordUrl = "$baseUrl/api/v1/auth/reset-password";
const getVideoDataUrl = "$baseUrl/api/v1/videos/";
const supportMessageUrl = "$baseUrl/api/v1/support";
const tokenConst =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MWFiMjdmOGY4OGEwYjEyZjUwMzBiMTUiLCJpYXQiOjE2Mzk5Nzg0NDYsImV4cCI6MTY0MDAxNDQ0Nn0.WKftB3SDzdutTLkgnqUbhs03WegnzAkmZ3JjYtk3BdQ";

//https://developers.cafebazaar.ir/fa/guidelines/in-app-billing/implementation/flutter#Implementation
//https://pub.dev/packages/flutter_poolakey/install
//https://github.com/cafebazaar/flutter_poolakey
//https://virgool.io/flutter-community/%D9%BE%DA%A9%DB%8C%D8%AC-%D9%BE%D8%B1%D8%AF%D8%A7%D8%AE%D8%AA-%D9%88-%D8%A7%D8%B1%D8%AA%D8%A8%D8%A7%D8%B7-%D8%A8%D8%A7-%DA%A9%D8%A7%D9%81%D9%87-%D8%A8%D8%A7%D8%B2%D8%A7%D8%B1-%D8%A8%D8%B1%D8%A7%DB%8C-%D9%81%D9%84%D8%A7%D8%AA%D8%B1-ngxpnjck9q7n

String getTime(time) {
  String result = "";
  var splitted = time.toString().split(":");
  for (int i = 0; i < splitted.length; i++) {
    String current = splitted[i];
    if (int.tryParse(current.replaceAll(":", "")) != null) {
      int a = int.parse(current.replaceAll(":", ""));
      if (a < 10) {
        result += "0";
      }
      result += a.toString();
    }
    if (i != splitted.length - 1) {
      result += ":";
    }
  }
  return result;
}

Future<List<SkuDetails>?> connectToBazaar() async {
  bool connected = false;
  try {
    connected = await FlutterPoolakey.connect(
        "MIHNMA0GCSqGSIb3DQEBAQUAA4G7ADCBtwKBrwDSexAcx1QkH3p8foYTee2ykXl2vnYS7xy23cOO+TZGcb0JThh5a0tnse9Gi/ahl1v4J/g7/IRqk/0/fmNCZYwPAQ7o02fA+0EaVaGfU99TEnxEQ6LGmmv2T1QixaWYNpNL/OiSD0L8acZxs1htiV4wKfy98rsKucig0EO75sq6z3B95wL3JrRYU8EnxttD2Y7sE2Sh3GQWX/yZXgkWLA37mN8ywOUJTGz7CEWGcycCAwEAAQ==",
        onDisconnected: () {});
    List<SkuDetails> res = await FlutterPoolakey.getSubscriptionSkuDetails([
      'OM_NATIONAL',
      'OM_ADULT',
      'TM_ADULT',
      'TM_NATIONAL',
      'OY_NATIONAL',
      'OY_ADULT',
      'OY_CHILD',
      'TM_CHILD',
      'OM_CHILD',
    ]);
    return res;
  } catch (e) {
    ColoredSnack(
        title: "خطا از طرف بازار !",
        description: e.toString(),
        type: SnackType.ERROR);
  }

  if (!connected) {
    return null;
  }
  return null;
}

String getRandomString(int length) {
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

String getUrlFileName(appDir, id, path) {
  String result = path.toString().substring(path.toString().lastIndexOf("/"));
  result = result
      .substring(0, result.lastIndexOf("."))
      .replaceAll(".", "")
      .trim()
      .replaceAll(" ", "")
      .replaceAll("%20", "");

  return (appDir + id + result).toString().trim();
}

String getUrl(path) {
  String _path = path.toString();
  String _imagePath = _path.toString();
  String imagePath = "";
  if (_imagePath.characters.first == '/') {
    imagePath = baseUrl + _imagePath.replaceAll("//", "/");
  } else {
    imagePath = _imagePath;
  }
  bool validImageLink = checkForValidImageLink(imagePath);
  if (imagePath.contains("/") &&
          imagePath.substring(imagePath.lastIndexOf("/")).replaceAll("/", "") ==
              "undefined" ||
      imagePath.trim().toString() == "" ||
      !validImageLink) {
    imagePath = "https://img.icons8.com/clouds/100/null/question-mark.png";
  }

  return imagePath;
}

bool checkForValidImageLink(String link) {
  if (!link.contains(".")) {
    return false;
  }
  link = link.substring(link.lastIndexOf(".")).toString().replaceAll(".", "");
  bool valid = false;
  if (link == "jpg" ||
      link == "jpeg" ||
      link == "jfif" ||
      link == "pjpeg" ||
      link == "pjp" ||
      link == "png" ||
      link == "svg" ||
      link == "webp" ||
      link == "apng" ||
      link == "gif" ||
      link == "mp4" ||
      link == "mp3" ||
      link == "avi" ||
      link == "wav" ||
      link == "mov" ||
      link == "wmv" ||
      link == "mkv") {
    valid = true;
  }
  return valid;
}
