import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:zabaner/controllers/support_controller.dart';
import 'package:zabaner/models/conversations.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:http/http.dart' as http;


class ConversationController extends GetxController with StateMixin {
  AnimationController? animationController;
  TextEditingController textController = TextEditingController();
  FocusNode focus = FocusNode();
  AutoScrollController scrollController = AutoScrollController();
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  var conversations = <Conversation>[].obs;
  var isDataLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
  }
  void getImage(title,id) async {
    _getConnect.allowAutoSignedCert = true;
    final ImagePicker _picker = ImagePicker();
    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
    try {
      int sizeInMB = 4;
      if ((await _image?.length())! / 1024 * sizeInMB < 9.8) {
        loadingDialog("درحال آپلود عکس");
        var request = http.MultipartRequest("POST", Uri.parse(sendSupportDescription));

        try {
          var pic = await http.MultipartFile.fromPath('msgImage', _image!.path);

          request.files.add(pic);
          request.fields.addAll({"forS" : title.toString(),"id":id.toString()});
          var response = await request.send();

          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          Get.back();
          getData(title);
          print(responseString);
        } catch(e){}
      } else {
        ColoredSnack(title: "سایز عکس شما باید زیر 4 مگابایت باشد!",type: SnackType.ERROR);
      }
    }catch(e){e.printError();}
  }

  Future<void> sendMessage(title,id) async{
    String message = textController.text;
    if(message.toString().trim().isEmpty){
      return;
    }
    textController.clear();
    var bodyRequest = {
      "id": id.toString(),
      "forS": title.toString(),
      "description": message.toString().replaceAll("\n", " <br/> "),
    };
    Conversation b = Conversation(id: "a.id",type: "loading",description:message.toString(),image: "" ,createAt:"" ,forS:"a.forS" );
    conversations.add(b);
    change(null, status: RxStatus.success());
    scrollController.scrollToIndex(conversations.length,preferPosition: AutoScrollPosition.end);
    final _request = await _getConnect.post(sendSupportDescription, bodyRequest);
    b.type = "question";
    debugPrint("podawodpsodxkdawdq : " + _request.bodyString.toString());
    b.createAt = _request.bodyString.toString();
    conversations[conversations.length-1] = b;
    change(null, status: RxStatus.success());

  }

  Future<void> getData(title) async {
    isDataLoaded.value = false;
    var bodyRequest = {
      "title": title.toString(),
    };
    final _request = await _getConnect.post(getConversationList, bodyRequest);
    debugPrint("sadsadoauweoisuad : " + _request.bodyString.toString());
    conversations.value = conversationListModelFromJson(_request.bodyString ?? "");
    isDataLoaded.value = true;
    scrollController.scrollToIndex(conversations.length,preferPosition: AutoScrollPosition.end);
  }
}
