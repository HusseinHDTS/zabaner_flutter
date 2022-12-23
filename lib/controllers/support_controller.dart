import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/models/support_message_model.dart';
import 'package:zabaner/models/support_tickets.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class SupportController extends GetxController {
  final GetConnect _getConnect = GetConnect();
  // create get storage to get token
  final GetStorage _getStorage = GetStorage();

  var messagesList = <SupportMessageModel>[].obs;
  String message = "";
  List<SupportTickets> tickets = [];
  var isDataLoaded = false.obs;


  @override
  void onInit() {
    super.onInit();
    _getConnect.allowAutoSignedCert = true;
    GetStorage.init();
    getTickets();
  }

  Future<void> getTickets() async{
    isDataLoaded.value = false;

    var bodyRequest1 = {
      "mobile": "09358628661",
    };


    var request = await _getConnect.post(getTicketsList,bodyRequest1);
    tickets = ticketsListModelFromJson(request.bodyString ?? "");
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
