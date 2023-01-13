import 'package:flutter/cupertino.dart';
import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/models/sub-settings-model.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/tabs/list_model.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class SubscribeController extends GetxController {
  final _selectedPos = 0.obs;
  final _isDataLoaded = false.obs;
  SubSettingsModel? _model;
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  final GetStorage _getStorage = GetStorage();
  TabbarTypes type;
  List<SkuDetails>? bazaarLists;
  SubscribeController(this.type);


  @override
  void onInit() async{
    super.onInit();
    var data = await _getConnect.get(getSubscribeSettings);
    _model = profileInformationFromJson(data.bodyString ?? "");
    setDataLoaded(true);
  }


  bool isDataLoaded(){
    return _isDataLoaded.isTrue;
  }

  void setDataLoaded(bool dataLoaded){
    _isDataLoaded.value = dataLoaded;
  }

  void setCurrentPos(int pos){
    _selectedPos.value = pos;
  }

  int getCurrentPos(){
      return _selectedPos.value;
  }

  void setupSubscribe(TabbarTypes type) async{
    String subscribe = "";
    if(type == TabbarTypes.CHILD){
      subscribe = "hasChildSub";
    }else if(type == TabbarTypes.ADULT){
      subscribe = "hasAdultSub";
    }else if(type == TabbarTypes.NATIONAL){
      subscribe = "hasNationalSub";
    }
    var bodyRequest = {
      subscribe: "on",
    };
    await _getConnect.post(updateSubscribeProfile, bodyRequest ,headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer ${_getStorage.read('token')}'
    });
  }

  String getCurrentSelectedMonth(int pos){
    String result = "";
    if(pos == 0){
      result = "ماهانه";
    }else if(pos == 1){
      result = "سه ماهه";
    }else if(pos == 2){
      result = "سالانه";
    }
    return result;
  }
  int getCurrentSelectedMonthInt(int pos){
    int result = 0;
    if(pos == 0){
      result = 1;
    }else if(pos == 1){
      result = 3;
    }else if(pos == 2){
      result = 12;
    }
    return result;
  }

  Future<PurchaseInfo?> bazaarPay(typeForBuy)async{
    PurchaseInfo? result;
    String pId= "";
    int cMonth = getCurrentSelectedMonthInt(getCurrentPos());
    if(cMonth == 1){
      pId = "OM_";
    }else if(cMonth == 3){
      pId = "TM_";
    }else if(cMonth == 12){
      pId = "OY_";
    }
    if(typeForBuy == TabbarTypes.CHILD){
      pId += "CHILD";
    }else if(typeForBuy == TabbarTypes.ADULT){
      pId += "ADULT";
    }else if(typeForBuy == TabbarTypes.NATIONAL){
      pId += "NATIONAL";
    }
    try{
      result = await FlutterPoolakey.subscribe(pId,payload: "HDTS");
    }catch(e){
      // ColoredSnack(title: "خطا از سمت بازار!",type: SnackType.ERROR,description: e.toString());
      e.printError();
    }
    return result;
  }
  Future<PurchaseInfo?> bazaarPayTest()async{
    PurchaseInfo? result;
    try{
      result = await FlutterPoolakey.subscribe("TestSub",payload: "HDTS");
    }catch(e){
      // ColoredSnack(title: "خطا از سمت بازار!",type: SnackType.ERROR,description: e.toString());
      e.printError();}
    return result;
  }

  String getCurrentSelectedPrice(int pos,{bool? isHezarToman}){
    isHezarToman ??= false;
    String result = "";
    if(pos == 0){
      if(type == TabbarTypes.CHILD){
        result = _model!.childOMPrice.toString();
      }else if(type == TabbarTypes.ADULT){
        result = _model!.adultOMPrice.toString();
      }else if(type == TabbarTypes.NATIONAL){
        result = _model!.nationalOMPrice.toString();
      }
    }else if(pos == 1){
      if(type == TabbarTypes.CHILD){
        result = _model!.childTMPrice.toString();
      }else if(type == TabbarTypes.ADULT){
        result = _model!.adultTMPrice.toString();
      }else if(type == TabbarTypes.NATIONAL){
        result = _model!.nationalTMPrice.toString();
      }
    }else if(pos == 2){
      if(type == TabbarTypes.CHILD){
        result = _model!.childOYPrice.toString();
      }else if(type == TabbarTypes.ADULT){
        result = _model!.adultOYPrice.toString();
      }else if(type == TabbarTypes.NATIONAL){
        result = _model!.nationalOYPrice.toString();
      }
    }
    if(isHezarToman){
      return (int.parse(result) * 1000).toString();
    }else{
      return result;
    }
  }

  String getDescription(title) {
    return title + " / " + getCurrentSelectedMonth(getCurrentPos()) + " / " + getCurrentSelectedPrice(getCurrentPos()) + " هزار تومان ";
  }


}