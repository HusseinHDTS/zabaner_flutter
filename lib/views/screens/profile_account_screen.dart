import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/controllers/profile_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/user_subs_model.dart';
import 'package:zabaner/views/widgets/custom_text_input_profile.dart';
import 'package:zabaner/widgets/colored_text.dart';

class ProfileAccount extends StatelessWidget {
  bool fromSub;

  ProfileAccount(this.fromSub, {Key? key, required this.isGuest})
      : super(key: key);
  final bool isGuest;
  static const List textHint = [
    "نام",
    "نام خانوادگی",
    "تاریخ تولد",
    "ایمیل",
    "موبایل"
  ];

  @override
  Widget build(BuildContext context) {
    final ProfileController _controller = Get.put(ProfileController(isGuest));
    final GetStorage _getStorage = GetStorage();
    GetStorage.init();
    if (fromSub) {
      return SingleChildScrollView(
        child: Column(
          children: [
            // text
            SizedBox(
              width: Get.width / 1.2,
              child: const Text(
                "اشتراک های حساب کاربری",
                style: TextStyle(
                    color: Color(0xff686868), fontFamily: "Yekan", fontSize: 12),
              ),
            ),
            SizedBox(
              height: 4,
            ),

            _controller.obx((status) {
              return Card(
                color: const Color(0xffF9F9F9),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: Get.width / 6.5,
                        backgroundImage:
                            const AssetImage("assets/images/subscribe.png"),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ColoredText("اشتراک های موجود : "),
                            ColoredText(_controller.profileInformation.subscribes
                                        .toString() ==
                                    ""
                                ? "بدون اشتراک"
                                : _controller.profileInformation.subscribes
                                    .toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ColoredText("تاریخ شروع اشتراک : "),
                            ColoredText(_controller
                                .profileInformation.startSubJalali
                                .toString()),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ColoredText("تاریخ پایان اشتراک : "),
                            ColoredText(_controller
                                .profileInformation.endSubJalali
                                .toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            Obx(()=>ListView.builder(
                itemCount: _controller.userSubModel.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  UserSubModel model = _controller.userSubModel[index];
                  String paymentStatus = "";
                  if(model.status.toLowerCase() == "OK".toLowerCase()){
                    paymentStatus = "پرداخت موفق";
                  }else{
                    paymentStatus = "پرداخت ناموفق";
                  }
                  return Container(
                    child: Column(children: [
                      ColoredText(model.title,textColor: Colors.white,),
                      SizedBox(height: 28,),
                      Align(alignment:Alignment.bottomLeft,child: ColoredText(paymentStatus,textColor: Colors.white60,)),
                    ],),
                    width: double.infinity,
                    padding: EdgeInsets.all(18),
                    margin: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                        color: model.status.toString().toLowerCase() !=
                                "OK".toLowerCase()
                            ? Colors.red
                            : Colors.green,
                        borderRadius: BorderRadius.circular(8)),
                  );
                }))
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            // text
            SizedBox(
              width: Get.width / 1.2,
              child: const Text(
                "تنظیمات حساب کاربری",
                style: TextStyle(
                    color: Color(0xff686868), fontFamily: "Yekan", fontSize: 12),
              ),
            ),

            _controller.obx((status) {
              List information = [
                _controller.profileInformation.firstName,
                _controller.profileInformation.lastName,
                _controller.profileInformation.bDay.toString()
              ];
              return Card(
                color: const Color(0xffF9F9F9),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: SizedBox(
                  height: Get.height / 1.7,
                  width: Get.width / 1.1,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Get.width / 8, vertical: Get.height / 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Profile Image
                        InkWell(
                          onTap: () => isGuest ? {} : _controller.getImage(),
                          child: CircleAvatar(
                            radius: Get.width / 6.5,
                            backgroundImage: NetworkImage(_getStorage
                                    .read('profile_image') ??
                                "https://htmlcolorcodes.com/assets/images/colors/bright-blue-color-solid-background-1920x1080.png"),
                          ),
                        ),
                        const Text(
                          "تصویر پروفایل",
                          style: TextStyle(fontFamily: "Yekan", fontSize: 10),
                        ),

                        // name text input
                        SizedBox(
                            height: Get.height / 23,
                            width: Get.width / 1.5,
                            // color: Colors.green,
                            child: CustomTextInputProfile(
                              hintText: _controller.profileInformation.firstName,
                              iconPath: "username.png",
                              isEnabled: !isGuest,
                              onChanged: (text) => information[0] = text,
                            )),

                        // last name text input
                        SizedBox(
                            height: Get.height / 23,
                            width: Get.width / 1.5,
                            // color: Colors.green,
                            child: CustomTextInputProfile(
                              hintText: _controller.profileInformation.lastName,
                              iconPath: "username.png",
                              isEnabled: !isGuest,
                              onChanged: (text) => information[1] = text,
                            )),

                        // birthday date text input
                        SizedBox(
                            height: Get.height / 23,
                            width: Get.width / 1.5,
                            // color: Colors.green,
                            child: CustomTextInputProfile(
                                hintText: _controller.profileInformation.bDay.year
                                    .toString(),
                                iconPath: "birthday.png",
                                isEnabled: !isGuest,
                                onChanged: (text) => information[2] =
                                    DateTime(int.parse(text)).toString())),

                        // email text input
                        SizedBox(
                            height: Get.height / 23,
                            width: Get.width / 1.5,
                            child: CustomTextInputProfile(
                              hintText: _controller.profileInformation.email,
                              isEnabled: false,
                              iconPath: "email.png",
                            )),

                        // mobile text input
                        SizedBox(
                            height: Get.height / 23,
                            width: Get.width / 1.5,
                            child: CustomTextInputProfile(
                              hintText: _controller.profileInformation.mobile,
                              isEnabled: false,
                              iconPath: "mobile.png",
                            )),

                        // save changes button
                        SizedBox(
                            height: Get.height / 23,
                            width: Get.width / 1.5,
                            child: ElevatedButton(
                              child: const Text(
                                "ذخیره تغییرات",
                                style:
                                    TextStyle(fontFamily: "Yekan", fontSize: 12),
                              ),
                              onPressed: () {
                                _controller.updateProfile(
                                  information[0],
                                  information[1],
                                  information[2],
                                );
                              },
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xffFFC200))),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      );
    }
  }
}
