import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zabaner/controllers/web_view_controller.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/models/utils.dart';
import 'package:zabaner/views/screens/login_screen.dart';
import 'package:zabaner/views/screens/splash_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';
import 'package:zabaner/widgets/colored_text.dart';

class WebViewScreen extends StatefulWidget {
  String url, amount, description, email, phone, type, timeOfSub;

  WebViewScreen(this.url, this.phone, this.email, this.description, this.amount,
      this.type, this.timeOfSub);

  @override
  State<StatefulWidget> createState() {
    return _WebViewScreen(
        url, phone, email, description, amount, type, timeOfSub);
  }
}

class _WebViewScreen extends State<WebViewScreen> {
  String url, amount, description, email, phone, type, timeOfSub;
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);

  _WebViewScreen(this.url, this.phone, this.email, this.description,
      this.amount, this.type, this.timeOfSub);

  final WebViewController _controller = Get.put(WebViewController());

  InAppWebViewController? webViewController;
  final GetStorage _getStorage = GetStorage();
  String authority = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            leadingWidth: Get.width,
            backgroundColor: const Color(0xffEBB632),
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.only(right: Get.width / 40),
              child: InkWell(
                onTap: () => Get.back(),
                child: Row(
                  children: const [
                    Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      "بازگشت",
                      style:
                          TextStyle(fontFamily: "Yekan", color: Colors.white),
                    ),
                  ],
                ),
              ),
            )),
        body: Obx(() => Column(
              children: [
                Directionality(
                    textDirection: TextDirection.ltr,
                    child: _controller.getProgress() == 1 ||
                            _controller.getProgress() == 0
                        ? Container()
                        : Expanded(
                            flex: 0,
                            child: Container(
                              child: LinearProgressIndicator(
                                  value: _controller.getProgress()),
                            ))),
                _controller.isResultReceived()
                    ? Container(
                        child: Center(
                          child: ColoredText("لطفا کمی صبر کنید ...."),
                        ),
                      )
                    : Expanded(
                        flex: 1,
                        child: Container(
                          height: double.infinity,
                          child: InAppWebView(
                            initialUrlRequest: URLRequest(
                                url: Uri.dataFromString(
                                    '<html> <body> <center style="font-size: 60px;margin-top:80px; direction: rtl;">درحال انتقال به درگاه پرداخت ...</center> </body> </html>',
                                    mimeType: 'text/html',
                                    encoding: Encoding.getByName('utf-8')
                                )
                            ),
                            onProgressChanged: (controller, progress) {
                              _controller.setProgress(
                                  double.parse((progress / 100).toString()));
                            },
                            onReceivedServerTrustAuthRequest:
                                (controller, challenge) async {
                              return ServerTrustAuthResponse(
                                  action:
                                      ServerTrustAuthResponseAction.PROCEED);
                            },
                            onLoadStart: (controller, url) async {
                              String scheme = url!.scheme.toString();
                              if (scheme == "zabaner" ||
                                  scheme == "app.zabaner") {
                                _controller.setResultReceived(true);
                                return;
                              }
                              _controller.setResultReceived(false);
                              if (scheme == "zabanerappresult") {
                                String subscribe = "";
                                if (type == "کودکان") {
                                  subscribe = "hasChildSub";
                                } else if (type == "بزرگسالان") {
                                  subscribe = "hasAdultSub";
                                } else if (type == "آزمون ها") {
                                  subscribe = "hasNationalSub";
                                }
                                String finalSubTime = "1";
                                if (timeOfSub == "0") {
                                  finalSubTime = "1";
                                } else if (timeOfSub == "1") {
                                  finalSubTime = "3";
                                } else if (timeOfSub == "2") {
                                  finalSubTime = "12";
                                }
                                _controller.setResultReceived(true);
                                loadingDialog("درحال ثبت پرداخت ...");
                                if (url.queryParameters['status']
                                        .toString()
                                        .toLowerCase() !=
                                    "OK".toLowerCase()) {
                                  Get.back();
                                  return;
                                }
                                var bodyRequest = {
                                  subscribe: "on",
                                  "timeOfSub": finalSubTime,
                                };
                                await _getConnect.post(
                                    updateSubscribeProfile, bodyRequest,
                                    headers: {
                                      'accept': 'application/json',
                                      'Authorization':
                                          'Bearer ${_getStorage.read('token')}'
                                    });
                                Get.back();
                                ColoredSnack(title: "پرداخت موفقیت آمیز بود",type: SnackType.SUCCESS);
                                Get.offAll(() => LoginScreen());
                              }
                            },
                            onLoadError: (controller, url, code, message) {
                              Get.back();
                            },
                            onWebViewCreated: ((controller) {
                              var bodyRequest = {
                                "amount": amount + "0",
                                "description": description,
                                "phone": "0",
                                "email": "husseindts@gmail.com",
                                "type": type,
                                "timeOfSub": timeOfSub,
                              };
                              _getConnect.post(userPaymentCheck, bodyRequest,
                                  headers: {
                                    'accept': 'application/json',
                                    'Authorization':
                                        'Bearer ${_getStorage.read('token')}'
                                  }).then((value) {
                                controller.loadUrl(
                                    urlRequest: URLRequest(
                                        url: Uri.parse(
                                            value.bodyString.toString())));
                              });

                            }),
                          ),
                        ),
                      ),
              ],
            )),
      ),
    );
  }
}
