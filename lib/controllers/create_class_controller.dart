import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/controllers/online_class_controller.dart';
import 'package:zabaner/controllers/submit_bank_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class CreateClassController extends GetxController {
  OnlineClassController controller = Get.find();
  ExpandableController expandableController = ExpandableController();
  TextEditingController testClassPrice = TextEditingController();
  TextEditingController normal1ClassPrice = TextEditingController();
  TextEditingController normal3ClassPrice = TextEditingController();
  TextEditingController normal5ClassPrice = TextEditingController();
  TextEditingController normal10ClassPrice = TextEditingController();
  RxString testClassPriceString = "0".obs;
  RxString normal1ClassPriceString = "0".obs;
  RxString normal3ClassPriceString = "0".obs;
  RxString normal5ClassPriceString = "0".obs;
  RxString normal10ClassPriceString = "0".obs;
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  final GetStorage _getStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    initListeners();
  }

  initData() {
    normal1ClassPrice.text = controller.data['normal1ClassPrice'];
    normal3ClassPrice.text = controller.data['normal3ClassPrice'];
    normal5ClassPrice.text = controller.data['normal5ClassPrice'];
    normal10ClassPrice.text = controller.data['normal10ClassPrice'];
    testClassPrice.text = controller.data['testClassPrice'];
    testClassPriceString.value =
        getRealPriceWithPercent(testClassPrice.text.replaceAll(",", ""));
    normal1ClassPriceString.value =
        getRealPriceWithPercent(normal1ClassPrice.text.replaceAll(",", ""));
    normal3ClassPriceString.value =
        getRealPriceWithPercent(normal3ClassPrice.text.replaceAll(",", ""));
    normal5ClassPriceString.value =
        getRealPriceWithPercent(normal5ClassPrice.text.replaceAll(",", ""));
    normal10ClassPriceString.value =
        getRealPriceWithPercent(normal10ClassPrice.text.replaceAll(",", ""));
  }

  submitPrice() async {
    if (testClassPrice.text == controller.data['testClassPrice'] &&
        normal1ClassPrice.text == controller.data['normal1ClassPrice'] &&
        normal3ClassPrice.text == controller.data['normal3ClassPrice'] &&
        normal5ClassPrice.text == controller.data['normal5ClassPrice'] &&
        normal10ClassPrice.text == controller.data['normal10ClassPrice']) {
      ColoredSnack(
          title: "ویرایشی برای ثبت وجود ندارد", type: SnackType.WARNING);
      return;
    }
    loadingDialog("لطفا صبر کنید");
    var result = await _getConnect.post(updateUserTeacherPrice, {
      "id": userSavedId,
      "normal1ClassPrice": normal1ClassPrice.text,
      "normal3ClassPrice": normal3ClassPrice.text,
      "normal5ClassPrice": normal5ClassPrice.text,
      "normal10ClassPrice": normal10ClassPrice.text,
      "testClassPrice": testClassPrice.text
    });
    Get.back();
    Get.back();
    // controller.getData();
    ColoredSnack(title: "قیمت های جدید ثبت شد", type: SnackType.SUCCESS);
  }

  String getPriceAfterPercent(String value, int percent) {
    String result = "0";
    return result;
  }

  void onTestPriceChange(String value) {
    testClassPriceString.value = getRealPriceWithPercent(value);
  }

  String getRealPriceWithPercent(String value) {
    return value;
    int? price = int.tryParse(value.toString().replaceAll(",", ""));
    if (price == null) return "0";
    return (price - (price * getPercentage()) ~/ 100).toString();
  }

  void onNormalPriceChange(String value, int index) {
    if (index == 1) {
      normal1ClassPriceString.value = getRealPriceWithPercent(value);
    } else if (index == 3) {
      normal3ClassPriceString.value = getRealPriceWithPercent(value);
    } else if (index == 5) {
      normal5ClassPriceString.value = getRealPriceWithPercent(value);
    } else if (index == 10) {
      normal10ClassPriceString.value = getRealPriceWithPercent(value);
    }
  }

  bool isFirstTime({bool? makeFalse}) {
    makeFalse ??= false;
    _getStorage.writeIfNull(CLASS_FIRST_TIME_PRICING, "true");
    bool res = _getStorage.read(CLASS_FIRST_TIME_PRICING) == "true";
    if (makeFalse) {
      setFirstTime(false);
    }
    return res;
  }

  setFirstTime(bool firstTime) {
    _getStorage.write(CLASS_FIRST_TIME_PRICING, firstTime.toString());
  }

  int getPercentage() {
    int allClass = 0;
    int percent = 27;
    if (allClass <= 20) {
      percent = 27;
    } else if (allClass <= 50) {
      percent = 25;
    } else if (allClass <= 100) {
      percent = 23;
    } else if (allClass <= 200) {
      percent = 21;
    } else if (allClass <= 400) {
      percent = 19;
    } else if (allClass > 400) {
      percent = 17;
    }
    return percent;
  }

  void initListeners() {}
}
