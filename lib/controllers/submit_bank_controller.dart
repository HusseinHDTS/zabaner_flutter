import 'dart:convert';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ftpconnect/ftpconnect.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:zabaner/controllers/online_class_controller.dart';
import 'package:zabaner/controllers/video_controller.dart';
import 'package:zabaner/models/online_class.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;


class SubmitBankController extends GetxController{
  var data;
  List<OnlineClass> classData = [];
  SubmitBankController(this.data);
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  Rx<ChewieController>? chewieController;
  late VideoPlayerController _videoController;

  Rx<Uint8List?> image = Uint8List(0).obs;
  XFile? imageFile;
  XFile? videoFile;
  var currentSelectedPos = 1.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController teachLanguage = TextEditingController();
  TextEditingController educationIn = TextEditingController();

  TextEditingController cardNumber = TextEditingController();
  TextEditingController shebaNumber = TextEditingController();
  TextEditingController cardName = TextEditingController();
  RxBool bankNumberOrShebaError = false.obs;
  RxBool bankNameError = false.obs;

  RxBool hasVideoPath = false.obs;
  RxBool hasVideo = false.obs;

  RxBool english01 = false.obs;
  RxBool english02 = false.obs;
  RxBool english03 = false.obs;
  RxBool english04 = false.obs;
  RxBool english05 = false.obs;

  RxBool isDataLoaded = false.obs;
  String english01Content = "انگلیسی عمومی";
  String english02Content = "آیلتس (IELTS)";
  String english03Content = "تافل (TOEFL)";
  String english04Content = "دولینگو (Duolingo)";
  String english05Content = "پی تی ای (PTE)";

  String preAgeRange = "";
  String preEducationLevel = "";
  resetRxCheckbox(){}

  bool errorPageOne = false, errorPageTwo = false;

  var selectedEducationLevel = "دیپلم".obs;
  var defaultEducationLevel = "دیپلم".obs;
  var _selectedEducationLevel = "NaN";
  var educationLevels = [
    "لطفا انتخاب کنید ...",
    "دیپلم",
    "فوق دیپلم",
    "لیسانس",
    "فوق لیسانس",
    "دکترا",
  ];

  setCurrentSelectedEducationLevel(String level){
    selectedEducationLevel.value = level;
    _selectedEducationLevel = level;
  }

  var selectedAgeRate = "کودکان".obs;
  var defaultAgeRate = "کودکان".obs;
  var _selectedAgeRate = "NaN";
  var ageRates = [
    "لطفا انتخاب کنید ...",
    "کودکان",
    "بزرگسالان",
  ];

  setCurrentSelectedAgeRate(String rate){
    selectedAgeRate.value = rate;
    _selectedAgeRate = rate;
  }
  setSelectedEducationLevel(String level){
    selectedEducationLevel.value = level;
  }
  setSelectedAgeRate(String age){
    selectedAgeRate.value = age;
  }

  setCurrentSelectedPos(int cPos){
    if(currentSelectedPos.value != cPos){
      currentSelectedPos.value = cPos;
    }
  }
  setCurrentImage(Uint8List? cImg,imgFile){
    image.value = cImg;
    imageFile = imgFile;
  }

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  initData(){
    nameController.text = data['name'];
    familyController.text = data['family'];
    emailController.text = data['email'];
    cityController.text = data['city'];
    descriptionController.text = data['description'];
    phoneController.text = data['phone'];
    teachLanguage.text = "انگلیسی";
    educationIn.text = data['educationIn'];
    cardNumber.text = data['cardNumber'];
    shebaNumber.text = data['shebaNumber'];
    cardName.text = data['cardName'];
    defaultAgeRate.value = ageRates[0].toString();
    defaultEducationLevel.value = educationLevels[0].toString();
    if(data['video'] != ""){
      chewieController = ChewieController(
        videoPlayerController: VideoPlayerController.network(getUrl(data['videoPath']),videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true,allowBackgroundPlayback: false)),
        autoPlay: false,
        looping: false,
        hideControlsTimer: const Duration(seconds: 2),
        aspectRatio: 16 / 9,
        showControls: true,
        showControlsOnInitialize: false,
        placeholder: Container(
          color: Colors.transparent,
        ),
        autoInitialize: true,
      ).obs;
      hasVideo.value = true;
    }
    parseExpertise(data['expertise']);
  }

  getData()async{
    isDataLoaded.value = false;
    var result = await _getConnect.post(getAllTeacherClass,{"teacherId":userSavedId.toString()});
    debugPrint("wqeioivoicoivozixcsadklksgflk : " + result.bodyString.toString());
    classData = onlineClassListModelFromJson(result.bodyString ?? "");
    isDataLoaded.value = true;
  }

  initDropDown(){
    selectedEducationLevel.value =  (data['educationLevel'].toString());
    selectedAgeRate.value =  (data['ageRating'].toString());
  }

  pickVideo()async{
    hasVideo.value = false;
    ImagePicker _picker = ImagePicker();
    loadingDialog("لطفا صبر کنید ...");
    XFile? _image = await _picker.pickVideo(source: ImageSource.gallery);
    if(_image != null){
      videoFile = _image;
      var cC = ChewieController(
        videoPlayerController: VideoPlayerController.file(io.File(_image.path)),
        autoPlay: false,
        looping: false,
        hideControlsTimer: const Duration(seconds: 2),
        aspectRatio: 16 / 9,
        showControls: true,
        showControlsOnInitialize: false,
        placeholder: Container(
          color: Colors.transparent,
        ),
        autoInitialize: true,
      );
      if(chewieController == null){
        chewieController = cC.obs;
      }else{
        chewieController!.value = cC;
      }
      hasVideo.value = true;
    }
    Get.back();

  }


  bool validateBank(){
    bankNumberOrShebaError.value = false;
    bankNameError.value = false;
    bool isValid = true;
    if(cardNumber.text.toString().replaceAll(CARD_NUMBER_SEPARATOR, "").length != 16 || cardNumber.text.toString().trim().isEmpty){
      isValid = false;
      bankNumberOrShebaError.value = true;
    }

    if(cardName.text.toString().trim().isEmpty || cardName.text.toString().trim().length < 3){
      isValid = false;
      bankNameError.value = true;
    }
    return isValid;
  }

  uploadImage()async{
    OnlineClassController onlineClassController = Get.find();
    var bodyRequest = {
      "id":data['id'].toString(),
    };
    try {
      int sizeInMB = 4;
      if (image.value!.lengthInBytes / (1024 * (1024 * sizeInMB)) < 9.8) {
        loadingDialog("درحال آپلود عکس");
        var request = http.MultipartRequest("POST", Uri.parse(updateTeacherProfileImage));

        try {
          var pic = http.MultipartFile.fromBytes('uploadedImage', image.value!,filename: "${getRandomString(15)}.jpg");
          request.files.add(pic);
          request.fields.addAll(bodyRequest);
          var response = await request.send();

          var responseData = await response.stream.toBytes();
          var responseString = utf8.decode(responseData);
          onlineClassController.isNewUser.value = false;
          Get.back();
          Get.back();
          Get.back();
          if(jsonDecode(responseString.toString())['statusCode'] == null){
            // onlineClassController.getData();
            ColoredSnack(title: "عکس شما برای بررسی ارسال شد و پس از تایید شدن نمایش داده خواهد شد",type: SnackType.SUCCESS,duration: Duration(seconds: 6));
          }else{
            ColoredSnack(title: "شما قبلا ثبت نام کرده اید",type: SnackType.ERROR);
          }
        } catch(e){}
      } else {
        Get.back();
        ColoredSnack(title: "  سایز عکس شما باید زیر $sizeInMB مگابایت باشد!  ",type: SnackType.ERROR);
      }
    }catch(e){e.printError();}
  }

  bool hasChanges(){
    bool hasChange = false;
    var abilities = <String>[];
    if(english01.isTrue){
      abilities.add(english01Content);
    }
    if(english02.isTrue){
      abilities.add(english02Content);
    }
    if(english03.isTrue){
      abilities.add(english03Content);
    }
    if(english04.isTrue){
      abilities.add(english04Content);
    }
    if(english05.isTrue){
      abilities.add(english05Content);
    }
    if(jsonEncode(abilities) != data['expertise']){
      hasChange = true;
    }
    if(selectedEducationLevel.value != data['educationLevel'].toString()){
      hasChange = true;
    }
    if(selectedAgeRate.value != data['ageRating'].toString()){
      hasChange = true;
    }
    if(videoFile != null){
      hasChange = true;
    }
    if(educationIn.text != data['educationIn']){
      hasChange = true;
    }

    return hasChange;
  }

  submitInfo() async{
    OnlineClassController onlineClassController = Get.find();
    var abilities = <String>[];
    if(english01.isTrue){
      abilities.add(english01Content);
    }
    if(english02.isTrue){
      abilities.add(english02Content);
    }
    if(english03.isTrue){
      abilities.add(english03Content);
    }
    if(english04.isTrue){
      abilities.add(english04Content);
    }
    if(english05.isTrue){
      abilities.add(english05Content);
    }
    var bodyRequest = {
      "userId": userSavedId,
      "title": userSavedId,
      "currentImage": "",
      "preImage": "",
      "showingImage": "",
      "name": nameController.text,
      "family": familyController.text,
      "phone": userPhoneNumber,
      "email": emailController.text,
      "city": cityController.text,
      "description": descriptionController.text,
      "video": "",
      "educationLevel": selectedEducationLevel.value,
      "educationIn": educationIn.text,
      "ageRating": selectedAgeRate.value,
      "expertise": jsonEncode(abilities),
      "showProfile": "false",
      "profileStatus": "firstPending",
      "cardNumber": "",
      "lastEdit": "",
      "shebaNumber": "",
      "cardName": "",
      "rating": "",
      "ratingCount": "",
    };
    try {
      int sizeInMB = 4;
      int videoSizeInMB = 20;
      if(videoFile != null){
        if(await videoFile!.length() / (1024 * (1024 * sizeInMB)) > 9.8){
          ColoredSnack(title: "حجم ویدیو نمیتواند بیشتر از $videoSizeInMB باشد ! ");
          return;
        }
      }
      if (image.value!.lengthInBytes / (1024 * (1024 * sizeInMB)) < 9.8) {
        loadingDialog("درحال ثبت ...");
        var request = http.MultipartRequest("POST", Uri.parse(updateUserTeacher));

        try {
          if(videoFile != null){
            var video =await  http.MultipartFile.fromPath('uploadedVideo', videoFile!.path,filename: "${getRandomString(15)}.mp4");
            request.files.add(video);
          }
          request.fields.addAll(bodyRequest);
          var response = await request.send();

          var responseData = await response.stream.toBytes();
          var responseString = utf8.decode(responseData);
          onlineClassController.isNewUser.value = false;
          Get.back();
          Get.back();
          Get.back();
          if(jsonDecode(responseString.toString())['statusCode'] == null){
            onlineClassController.isNewUser.value = false;
            ColoredSnack(title: "سپاسگزاریم! \n اطلاعات ارسالی شما در کمتر از 24 ساعت آینده بررسی خواهد شد و در صورت تایید، پروفایل شما فعال خواهد شد.",type: SnackType.SUCCESS,duration: Duration(seconds: 6));
          }else{
            ColoredSnack(title: "شما قبلا ثبت نام کرده اید",type: SnackType.ERROR);
          }
        } catch(e){}
      } else {
        Get.back();
        ColoredSnack(title: "  سایز عکس شما باید زیر $sizeInMB مگابایت باشد!  ",type: SnackType.ERROR);
      }
    }catch(e){e.printError();}
  }

  submitBank(profileStatus)async{
    OnlineClassController controller = Get.find();
    bool hasEdit = false;
    if(cardName.text != data['cardName']){
      hasEdit = true;
    }
    if(cardNumber.text != data['cardNumber']){
      hasEdit = true;
    }
    if(shebaNumber.text != data['shebaNumber']){
      hasEdit = true;
    }
    if(!hasEdit){
      ColoredSnack(title: "ویرایشی برای ثبت وجود ندارد.",type: SnackType.WARNING);
      return;
    }
    loadingDialog("لطفا صبر کنید ...");
    var requestBody = {
      "id":data['id'],
      "cardName":cardName.text,
      "cardNumber":cardNumber.text,
      "shebaNumber":shebaNumber.text,
    };
    var result = await _getConnect.post(createBankUserTeacher, requestBody);
    Get.back();
    Get.back();
    ColoredSnack(title: "اطلاعات بانکی شما ذخیره شد و پس از بررسی نتیجه آن اعلام خواهد شد.",type: SnackType.SUCCESS);
    controller.isAllowToCompleteSubmit.value = false;
    controller.isSubmitDone.value = false;

  }

  void parseExpertise(expertise) {
    if(expertise.toString().contains(english01Content)){
      english01.value = true;
    }
    if(expertise.toString().contains(english02Content)){
      english02.value = true;
    }
    if(expertise.toString().contains(english03Content)){
      english03.value = true;
    }
    if(expertise.toString().contains(english04Content)){
      english04.value = true;
    }
    if(expertise.toString().contains(english05Content)){
      english05.value = true;
    }

  }


}