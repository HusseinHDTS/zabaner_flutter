import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/controllers/custom_date_picker_controller.dart';
import 'package:zabaner/models/profile_information_model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/user_teachers.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class SubmitClassController extends GetxController{

  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  final GetStorage _getStorage = GetStorage();
  List<DateTime> selectedDates = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    phoneController.text = userPhoneNumber;
    nameController.text = userSavedFirstName;
    familyController.text = userSavedLastName;
  }

  submitUserData(item,count,{bool? useInputText,String? uName , String? uFamily})async{
    useInputText??=true;
    String name , family;
    if(useInputText){
      name = nameController.text;
      family = familyController.text;
    }else{
      name = uName.toString();
      family = uFamily.toString();
    }
    loadingDialog("لطفا صبر کنید");
    var _request = await _getConnect.patch(updateProfileUrl, {
      'firstName': name,
      'lastName': family,
    }, headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer ${_getStorage.read('token')}'
    });
    Get.back();
    if (_request.statusCode == 200) {
      userSavedName = "${nameController.text} ${familyController.text}";
      Get.back();
      submitData(item,count);
    } else {
      ColoredSnack(title: "لطفا تمامی فیلد ها را پر کنید",type: SnackType.ERROR);
    }
  }

  submitData(UserTeachers item , int count)async{
    int cpc = count;
    if(cpc == 0){
      cpc = 1;
    }
    if(cpc != 1){
      cpc = cpc*2;
    }
    CustomDatePickerController cppController = Get.find();
    if(cppController.getSelectedDates().length != cpc){
      ColoredSnack(title: "تعداد جلسات انتخاب شده کم تر از جلسات رزرو شده است  ${cppController.getSelectedDates().length} != $cpc",type: SnackType.ERROR);
      return;
    }
    int price;
    if(count == 0){
      price = int.parse(item.testClassPrice.toString().replaceAll(",", ""));
    }else if (count == 1){
      price = int.parse(item.normal1ClassPrice.toString().replaceAll(",", ""));
    }else if (count == 3){
      price = int.parse(item.normal3ClassPrice.toString().replaceAll(",", ""));
    }else if (count == 5){
      price = int.parse(item.normal5ClassPrice.toString().replaceAll(",", ""));
    }else if (count == 10){
      price = int.parse(item.normal10ClassPrice.toString().replaceAll(",", ""));
    }else{
      price = int.parse(item.normal1ClassPrice.toString().replaceAll(",", ""));
    }
    loadingDialog("لطفا صبر کنید");
    var body = {
      "title":getRandomString(30),
      "classCount":"$count",
      "teacherId":item.teacherId,
      "userId":userSavedId,
      "language":"انگلیسی",
      "classPrice":formatPrice(price.toString(),showUnit: false),
      "classTimes":jsonEncode(cppController.getSelectedDates().toList()),
      "classStatus":"",
      "lastUpdate":"",
      "classLink":"",
    };
    var result = await _getConnect.post(createOnlineClass, body);
    if(jsonDecode(result.bodyString??"")['statusCode'] != null){
      Get.back();
      ColoredSnack(title:"خطا در ثبت اطلاعات",type: SnackType.ERROR);
    }else{
      Get.back();
      Get.back();
      ColoredSnack(title:"ثبت شد",type: SnackType.SUCCESS);
    }
  }

}