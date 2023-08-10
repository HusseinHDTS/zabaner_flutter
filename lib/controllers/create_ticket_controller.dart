import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zabaner/controllers/support_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:http/http.dart' as http;
import 'package:zabaner/views/screens/conversation_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class CreateTicketController extends GetxController with StateMixin{
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  final SupportController _sController = Get.find();
  TextEditingController titleController = TextEditingController() , descriptionController = TextEditingController();

  var hasError = false.obs;
  var imageChanged = false.obs;
  XFile? image;

  Future<ImageProvider<Object>> xFileToImage(XFile xFile) async {
    final Uint8List bytes = await xFile.readAsBytes();
    return Image.memory(bytes).image;
  }
  void getImage() async {
    imageChanged.value = false;
    _getConnect.allowAutoSignedCert = true;

    final ImagePicker _picker = ImagePicker();
    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
    image = _image;
    imageChanged.value = true;
    hasError.value = false;
    // change(null,status: RxStatus.success());
  }


  submitTicket({String? type,onDone})async{
    loadingDialog("درحال ثبت پیام");
    var bodyRequest = {
      "mobile": SupportController.mobile.toString(),
      "title": titleController.text,
      "type": type,
    };
    var titleResult = await _getConnect.post(sendSupportTitle, bodyRequest);
    var titleId = titleResult.bodyString ?? "";
    if(titleId.toString().isEmpty){
      Get.back();
      ColoredSnack(title: "تیکت شما ثبت نشد!",type: SnackType.ERROR);
      return;
    }
    var bodyRequest1 = {
      "forS": titleId.toString(),
      "id": "null".toString(),
      "description": descriptionController.text.toString().replaceAll("\n", " <br/> "),
    };
    final _request = await _getConnect.post(sendSupportDescription, bodyRequest1);
    if(image != null){
      try {
        int sizeInMB = 4;
        if ((await image?.length())! / 1024 * sizeInMB < 9.8) {
          var request = http.MultipartRequest("POST", Uri.parse(sendSupportDescription));

          try {
            var pic = await http.MultipartFile.fromPath('msgImage', image!.path);

            request.files.add(pic);
            request.fields.addAll({"forS" : titleId.toString(),"id":"null"});
            var response = await request.send();

            var responseData = await response.stream.toBytes();
            var responseString = String.fromCharCodes(responseData);
          } catch(e){}
        } else {
          ColoredSnack(title: "سایز عکس شما باید زیر 4 مگابایت باشد!",type: SnackType.ERROR);
        }
      }catch(e){e.printError();}
    }
    _sController.getTickets();
    Get.back();
    onDone != null ? onDone() : {};
    Get.off(()=>ConversationScreen(title: titleId, id: "null"));
  }

}