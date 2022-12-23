import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/conversations.dart';
import 'package:zabaner/models/urls.dart';

class ConversationController extends GetxController {
  AnimationController? animationController;
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  List<Conversation> conversations = [];
  var isDataLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getData(title) async {
    isDataLoaded.value = false;
    var bodyRequest = {
      "title": title.toString(),
    };
    final _request = await _getConnect.post(getConversationList, bodyRequest);
    debugPrint("sadsadoauweoisuad : " + _request.bodyString.toString());
    conversations = conversationListModelFromJson(_request.bodyString ?? "");
    isDataLoaded.value = true;
  }
}
