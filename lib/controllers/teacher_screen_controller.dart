import 'dart:convert';
import 'dart:typed_data';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:zabaner/controllers/online_class_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class TeacherScreenController extends GetxController{
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  late ChewieController chewieController;
  late VideoPlayerController _videoController;

  Rx<Uint8List?> image = Uint8List(0).obs;
  XFile? imageFile;
  XFile? videoFile;
  Rx<XFile?>? videoFileRx;
  TextEditingController nameController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController teachLanguage = TextEditingController();
  TextEditingController educationIn = TextEditingController();

  RxBool videoInitialized = false.obs;

  RxBool nameError = false.obs;
  RxBool familyError = false.obs;
  RxBool emailError = false.obs;
  RxBool cityError = false.obs;
  RxBool descriptionError = false.obs;
  RxBool educationLevelError = false.obs;
  RxBool abilitiesError = false.obs;
  RxBool ageError = false.obs;

  RxBool english01 = false.obs;
  RxBool english02 = false.obs;
  RxBool english03 = false.obs;
  RxBool english04 = false.obs;
  RxBool english05 = false.obs;

  String english01Content = "انگلیسی عمومی";
  String english02Content = "آیلتس (IELTS)";
  String english03Content = "تافل (TOEFL)";
  String english04Content = "دولینگو (Duolingo)";
  String english05Content = "پی تی ای (PTE)";


  bool errorPageOne = false, errorPageTwo = false;

  var selectedEducationLevel = "دیپلم".obs;
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

  Uint8List? getCurrentImage(){
    return image.value;
  }

  resetRxCheckbox(){
    // english01.value = false;
    // english02.value = false;
    // english03.value = false;
    // english04.value = false;
    // english05.value = false;
  }


  submitTeacher()async{
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
      "normal1ClassPrice": "",
      "normal3ClassPrice": "",
      "normal5ClassPrice": "",
      "normal10ClassPrice": "",
      "testClassPrice": "",
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
        loadingDialog("درحال ثبت اطلاعات ....");
        var request = http.MultipartRequest("POST", Uri.parse(createUserTeacher));
        try {
          var pic = http.MultipartFile.fromBytes('uploadedImage', image.value!,filename: "${getRandomString(15)}.jpg");
          request.files.add(pic);
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

  bool validateFields(){
    errorPageOne = false;
    errorPageTwo = false;
    nameError.value = false;
    familyError.value = false;
    emailError.value = false;
    cityError.value = false;
    abilitiesError.value = false;
    descriptionError.value = false;
    educationLevelError.value = false;
    ageError.value = false;

    bool isValid = true;

    if(imageFile == null){
      isValid = false;
      errorPageOne = true;
      ColoredSnack(title: "انتخاب عکس اجباری است",type: SnackType.ERROR);
    }
    if(nameController.text.toString().trim().isEmpty){
      nameError.value = true;
      isValid = false;
      errorPageOne = true;
    }
    if(familyController.text.toString().trim().isEmpty){
      familyError.value = true;
      isValid = false;
      errorPageOne = true;
    }
    if(emailController.text.toString().trim().isEmpty && !emailController.text.toString().contains("@")){
      emailError.value = true;
      isValid = false;
      errorPageOne = true;
    }
    if(cityController.text.toString().trim().isEmpty){
      cityError.value = true;
      isValid = false;
      errorPageOne = true;
    }
    if(descriptionController.text.toString().trim().isEmpty || descriptionController.text.toString().trim().length < 10){
      descriptionError.value = true;
      isValid = false;
      errorPageOne = true;
    }
    if(_selectedEducationLevel == "NaN"){
      educationLevelError.value = true;
      isValid = false;
      errorPageTwo = true;
    }
    if(_selectedAgeRate == "NaN"){
      ageError.value = true;
      isValid = false;
      errorPageTwo = true;
    }
    if(english01.isFalse && english02.isFalse && english03.isFalse && english04.isFalse && english05.isFalse ){
      abilitiesError.value = true;
      isValid=false;
      errorPageTwo = true;
    }

    return isValid;
  }

  setSelectedEducationLevel(String level){
    selectedEducationLevel.value = level;
  }
  setSelectedAgeRate(String age){
    selectedAgeRate.value = age;
  }

  setCurrentImage(Uint8List? cImg,imgFile){
    image.value = cImg;
    imageFile = imgFile;
  }

  @override
  void onInit() {
    super.onInit();
    selectedEducationLevel.value = educationLevels[0];
    selectedAgeRate.value = ageRates[0];
    initListeners();
  }

  void initListeners() {
    // if(RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(text)){
      // ColoredSnack(title: "");
    // }
    phoneController.text = userPhoneNumber;
    teachLanguage.text = "انگلیسی";

  }

  pickVideo()async{
    videoInitialized.value = false;
    ImagePicker _picker = ImagePicker();
    loadingDialog("لطفا صبر کنید ...");
    XFile? _image = await _picker.pickVideo(source: ImageSource.gallery);
    if(_image != null){
      videoFile = _image;
      videoFileRx ??= videoFile.obs;
      videoFileRx!.value = videoFile;
      _videoController = VideoPlayerController.file(io.File(_image.path));
      chewieController = ChewieController(
        videoPlayerController: _videoController,
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
      videoInitialized.value = true;
    }
    Get.back();

  }



}