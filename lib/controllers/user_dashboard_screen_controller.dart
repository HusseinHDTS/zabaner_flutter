import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/controllers/web_view_controller.dart';
import 'package:zabaner/models/online_class.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/views/screens/web_view_screen.dart';

class UserDashboardScreenController extends GetxController {
  RxBool isDataLoaded = false.obs;
  RxBool hasVideo = false.obs;
  List<OnlineClass> classData = [];

  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  final GetStorage _getStorage = GetStorage();

  onPay(OnlineClass item) {
    if (int.parse(savedWalletInfo!.currentPrice.toString()) >
        int.parse(item.classPrice.toString().replaceAll(",", ""))) {
      loadingDialog("درحال پرداخت");
      var bodyRequest = {
        "id": item.id,
        "paymentState": "success",
      };
      var result =
          _getConnect.post(updatePaymentForClass, bodyRequest).then((value) {
            String classCountType = "";
            if(item.classCount == "0"){
              classCountType = "جلسه آزمایشی";
            }else{
              classCountType = "جلسه " + item.classCount + "ساعتی";
            }
        var requestBody = {
          "type": "remove",
          "toUserId": item.teacherId,
          "description": " حساب برای کلاس ${item.teacherName} / $classCountType",
          "price": "${item.classPrice.toString().replaceAll(",", "")}",
        };
        _getConnect.post(addRemoveWallet, requestBody, headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer ${_getStorage.read('token')}'
        }).then((value) {
          Get.back();
          reloadApp();
        });
      });
      return;
    }
    Get.to(() => WebViewScreen(
          paymentCheck,
          bodyRequest: {
            "amount": "${item.classPrice.toString().replaceAll(",", "")}0",
            "description": "[" +
                " کلاس ${item.language} ${item.classCount == "0" ? "1" : item.classCount}   جلسه ای " +
                "]",
            "phone": "0",
            "email": "husseindts@gmail.com",
            "type": "type",
            "timeOfSub": "timeOfSub",
          },
          onPaymentCallBack: (WebViewController _ctrl, url) async {
            _ctrl.setResultReceived(true);
            loadingDialog("درحال ثبت پرداخت ...");
            String pStat = url.queryParameters['status'].toString();
            String paymentState = "none";
            if (pStat.toLowerCase() == "OK".toLowerCase()) {
              paymentState = "success";
            } else {
              paymentState = "failed";
            }
            var bodyRequest = {
              "id": item.id,
              "paymentState": paymentState,
            };
            var result =
                await _getConnect.post(updatePaymentForClass, bodyRequest);
            if (url.queryParameters['status'].toString().toLowerCase() !=
                "OK".toLowerCase()) {
              getData();
              Get.back();
              reloadApp();
              return;
            }
          },
        ));
  }

  getData() async {
    isDataLoaded.value = false;
    var result = await _getConnect
        .post(getAllUserClass, {"userId": userSavedId.toString()});
    try {
      classData = onlineClassListModelFromJson(result.bodyString ?? "");
    } catch (e) {
      e.printError();
    }
    isDataLoaded.value = true;
  }

  @override
  void onInit() {
    super.onInit();
    getData();
  }
}
