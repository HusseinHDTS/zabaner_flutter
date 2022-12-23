import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/views/screens/main_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';

class SetNewPasswordController extends GetConnect {
  final GetStorage _getStorage = GetStorage();

  Future<void> sendData(String code, String mobail, String password) async {
    allowAutoSignedCert = true;
    var _request = await post(
      setNewPasswordUrl,
      mobail.isPhoneNumber
          ? {"code": code, "password": password, "mobile": mobail}
          : {
              "code": code,
              "password": password,
              "email": mobail,
            },
    );
    if (_request.statusCode == 201) {
      ColoredSnack(title: "گذرواژه با موفقیت تغییر داده شد",type: SnackType.SUCCESS);
      _getStorage.write('token', _request.body['accessToken'].toString());
      Get.offAll(() => MainScreen(
        isGuest: false,
      ));
    } else {
      if (_request.body['error'] == 4011) {
        ColoredSnack(title: "گذرواژه با موفقیت تغییر داده نشد!",type: SnackType.ERROR);
        Get.back();
      }
    }
  }
}
