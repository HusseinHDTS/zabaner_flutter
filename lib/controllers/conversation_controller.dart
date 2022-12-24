import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:zabaner/models/conversations.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/widgets/colored_snack.dart';

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

  Future<void> sendMessage(title,id) async{
    String message = textController.text;
    if(message.toString().trim().isEmpty){
      return;
    }
    textController.clear();
    var bodyRequest = {
      "forS": title.toString(),
      "description": message.toString(),
    };
    Conversation b = Conversation(id: "a.id",type: "loading",description:message.toString() ,createAt:"" ,forS:"a.forS" );
    conversations.add(b);
    change(null, status: RxStatus.success());
    scrollController.scrollToIndex(conversations.length+1);
    final _request = await _getConnect.post(sendSupportDescription, bodyRequest);
    b.type = "question";
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
    scrollController.scrollToIndex(conversations.length+1);
  }
}
