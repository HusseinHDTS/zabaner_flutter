import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/user_dashboard_screen.dart';
import 'package:zabaner/widgets/colored_button.dart';
import 'package:zabaner/widgets/my_app_bar.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({Key? key}) : super(key: key);

  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  final GetStorage _getStorage = GetStorage();
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);
  Jalali? picked;
  TextEditingController name = TextEditingController();
  TextEditingController family = TextEditingController();
  TextEditingController bDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ColoredAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 18,
          ),
          inputText("نام", name),
          SizedBox(
            height: 18,
          ),
          inputText("نام خانوادگی", family),
          SizedBox(
            height: 18,
          ),
          GestureDetector(
            onTap: () async{
              picked = await showPersianDatePicker(context: context,
                  initialDate: Jalali.now(),
                  firstDate: Jalali.now(),
                  lastDate: Jalali.now().add(months: 8));
              if(picked != null) {
                bDate.text = picked!.formatFullDate();
              }
            },
            child: inputText("تاریخ تولد", bDate, enabled: false),
          ),
          Expanded(
              flex: 1,
              child: Container(
                height: double.infinity,
              )),
          Expanded(
            flex: 0,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 18),
                child: ColoredButton(
                  "ثبت اطلاعات",
                  color: Colors.green,
                  width: 200,
                  onTap: () {
                    updateInformation();
                  },
                )),
          ),
          SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }

  void updateInformation() async {
    if(name.text.trim().isEmpty || family.text.trim().isEmpty){
      return;
    }
    loadingDialog("درحال ثبت...");
    var _request = await _getConnect.patch(updateProfileUrl, {
      'firstName': name.text,
      'lastName': family.text,
      'bDay': picked!.toDateTime().toString(),
    }, headers: {
      'accept': 'application/json',
      'Authorization': 'Bearer ${_getStorage.read('token')}'
    });
    Get.back();
    Get.off(UserDashboardScreen());
  }
}
