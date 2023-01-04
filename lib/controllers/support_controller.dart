import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:zabaner/models/profile_information_model.dart';
import 'package:zabaner/models/support_message_model.dart';
import 'package:zabaner/models/support_tickets.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class SupportController extends GetxController {
  final GetConnect _getConnect = GetConnect();
  final GetStorage _getStorage = GetStorage();
  late ProfileInformation profileInformation;
  static String? mobile;

  var messagesList = <SupportMessageModel>[].obs;
  String message = "";
  List<SupportTickets> tickets = [];
  var isDataLoaded = false.obs;
  RefreshController refreshController1 = RefreshController();


  @override
  void onInit() {
    super.onInit();
    _getConnect.allowAutoSignedCert = true;
    GetStorage.init();
    getProfileInfos();
  }

  getProfileInfos()async{
    final _request = await _getConnect.get(profileInformationUrl, headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer ${_getStorage.read('token')}'
    });
    profileInformation = profileInformationFromJson(_request.bodyString ?? "");
    mobile = profileInformation.mobile;
    getTickets();
  }

  Future<void> getTickets() async{
    isDataLoaded.value = false;

    var bodyRequest1 = {
      "mobile": profileInformation.mobile,
    };


    var request = await _getConnect.post(getTicketsList,bodyRequest1);
    tickets = ticketsListModelFromJson(request.bodyString ?? "").reversed.toList();
    isDataLoaded.value = true;

  }

  Future<void> sendMessage() async {
    // send post request with GetConnect to sendSupportMessageUrl body is message and token in header
    final _response = await _getConnect.post(
        supportMessageUrl, {'message': message},
        headers: {'Authorization': 'Bearer ${_getStorage.read('token')}'});

    // if response is ok
    if (_response.statusCode == 201) {
      // show success message
      ColoredSnack(title: "پیام شما با موفقیت ارسال شد",type: SnackType.SUCCESS);

      // add message to messagesList
      messagesList.insert(
          0,
          SupportMessageModel(
            user: "",
            id: "",
            createdAt: DateTime.now(),
            jalaliCreatedAt: "",
            message: message,
            type: "question",
          ));
    }
  }

}
