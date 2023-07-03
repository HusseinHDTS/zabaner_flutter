import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/controllers/user_dashboard_screen_controller.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/widgets/teachers_classess_tile.dart';
import 'package:zabaner/widgets/my_app_bar.dart';
import 'package:zabaner/widgets/wallet_info_widget.dart';

class UserDashboardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserDashboardScreen();
  }
}

class _UserDashboardScreen extends State<UserDashboardScreen> {
  UserDashboardScreenController controller =
      Get.put(UserDashboardScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomSliverAppBar(
          body: Obx(
                () => controller.isDataLoaded.isFalse
                ? Loading()
                : ListView.builder(
                shrinkWrap: true,
                itemCount: controller.classData.length,
                itemBuilder: (context, index) {
                  // debugPrint("dsadkjaskjcxzqweqds : " + controller.classData[index].toJson().toString());
                  return UsersClassTile(
                    controller.classData[index],
                    onPayClick: () {
                      controller.onPay(controller.classData[index]);
                    },
                  );
                }),
          )),
    );
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 0,
            child: WalletInfoWidget(),
          ),
          Expanded(
              flex: 1,
              child: Obx(
                () => controller.isDataLoaded.isFalse
                    ? Loading()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.classData.length,
                        itemBuilder: (context, index) {
                          return UsersClassTile(
                            controller.classData[index],
                            onPayClick: () {
                              controller.onPay(controller.classData[index]);
                            },
                          );
                        }),
              ))
        ],
      ),
    );
  }
}
