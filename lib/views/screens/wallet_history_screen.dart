import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/views/colors.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';
import 'package:zabaner/widgets/my_app_bar.dart';
import 'package:zabaner/models/utils.dart';
import '../../models/urls.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

class WalletHistoryScreen extends StatefulWidget {
  const WalletHistoryScreen({Key? key}) : super(key: key);

  @override
  State<WalletHistoryScreen> createState() => _WalletHistoryScreenState();
}

class _WalletHistoryScreenState extends State<WalletHistoryScreen> {
  final GetConnect _getConnect = GetConnect();
  final GetStorage _getStorage = GetStorage();

  Future<dynamic> getData() async {
    var result = await _getConnect.get(getPaysHistory,
        headers: {'Authorization': 'Bearer ${_getStorage.read('token')}'});
    var decoded = jsonDecode(result.bodyString ?? "");
    return decoded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ColoredAppBar(),
      body: FutureBuilder<dynamic>(
        future: getData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var pays = snapshot.data;
          return Column(
            children: [
              SizedBox(
                height: 12,
              ),
              Expanded(
                child: pays.length == 0
                    ? NoData()
                    : ListView.builder(
                        itemCount: pays.length,
                        itemBuilder: (context, index) {
                          var item = pays[pays.length - (index + 1)];
                          return GestureDetector(
                            onTap: () {
                              customDialog(
                                  child: Column(
                                children: [
                                  topRoundedMiniBar(
                                      height: 40,
                                      title: "توضیحات",
                                      mainColor: (item['type'] == "remove"
                                          ? Colors.red
                                          : Colors.green)),
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color: (item['type'] == "remove"
                                                ? Colors.red
                                                : Colors.green)
                                            .withOpacity(0.4),
                                        // spreadRadius: 5,
                                        blurRadius: 15,
                                        offset: Offset(0.0,
                                            0.55), // changes position of shadow
                                      )
                                    ]),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: Get.width,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: ColoredText(
                                        item['description'],
                                        textAlign: TextAlign.right,
                                        textDirection: TextDirection.rtl,
                                      )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: ColoredText(
                                          item['date'] ?? "",
                                          textSize: 10,
                                          textColor: (item['type'] == "remove"
                                              ? Colors.red
                                              : Colors.green),
                                        ),
                                      )),
                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                        color: (item['type'] == "remove"
                                            ? Colors.red
                                            : Colors.green)
                                            .withOpacity(0.4),
                                        // spreadRadius: 5,
                                        blurRadius: 15,
                                        offset: Offset(0.0,
                                            0.55), // changes position of shadow
                                      )
                                    ]),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Colors.grey.shade200.withOpacity(0.5),
                                    Colors.grey.shade300.withOpacity(0.5)
                                  ]),
                                  border: Border.all(
                                      color: item['type'] == "remove"
                                          ? Colors.red.withOpacity(0.2)
                                          : Colors.green.withOpacity(0.2)),
                                  borderRadius: BorderRadius.circular(18)),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              height: 80,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: SizedBox(
                                  height: double.infinity,
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 0,
                                        child: Container(
                                            margin: EdgeInsets.only(left: 18),
                                            child: Icon(
                                              item['type'] == "remove"
                                                  ? Icons.call_made
                                                  : Icons.call_received,
                                              color: item['type'] == "remove"
                                                  ? Colors.red.withOpacity(0.7)
                                                  : Colors.green
                                                      .withOpacity(0.7),
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 18,
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          child: Center(
                                            child: Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ColoredText(
                                                    item['description'],
                                                    textSize: 13,
                                                    maxLines: 1,
                                                  ),
                                                  ColoredText(
                                                    item['date'] ?? "",
                                                    textSize: 9,
                                                    textColor: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          width: double.infinity,
                                          child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 18),
                                                  child: ColoredText(
                                                    (item['type'] == "remove"
                                                            ? "-"
                                                            : "+") +
                                                        formatPrice(
                                                            item['price']),
                                                    textSize: 13,
                                                    textColor:
                                                        item['type'] == "remove"
                                                            ? Colors.red
                                                            : Colors.green,
                                                  ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
              )
            ],
          );
        },
      ),
    );
  }
}
