import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zabaner/models/issues.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:http/http.dart' as http;
import 'package:zabaner/views/screens/conversation_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class IssueController extends GetxController{
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  var issues = <Issues>[].obs;
  var isDataLoaded = false.obs;
  @override
  void onInit() {
    super.onInit();
    getData();
  }

  getData()async{
    isDataLoaded.value = false;
    var result = await _getConnect.get(getIssues);
    issues.value = issueListModelFromJson(result.bodyString ?? "");
    isDataLoaded.value = true;
  }


}