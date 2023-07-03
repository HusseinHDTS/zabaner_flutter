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
import 'package:zabaner/widgets/my_app_bar.dart';

class WebViewScreen extends StatefulWidget {
  String url;
  var bodyRequest, onPaymentCallBack;

  WebViewScreen(this.url, {this.onPaymentCallBack, this.bodyRequest});

  @override
  State<StatefulWidget> createState() {
    return _WebViewScreen(url,
        bodyRequest: bodyRequest, onPaymentCallBack: onPaymentCallBack);
  }
}

class _WebViewScreen extends State<WebViewScreen> {
  String url;
  var bodyRequest, onPaymentCallBack;
  final GetConnect _getConnect = GetConnect(allowAutoSignedCert: true);

  _WebViewScreen(this.url, {this.bodyRequest, this.onPaymentCallBack});

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
        appBar: ColoredAppBar(),
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
                                    encoding: Encoding.getByName('utf-8'))),
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
                                Get.back();
                                onPaymentCallBack(_controller, url);
                              }
                            },
                            onLoadError: (controller, url, code, message) {
                              ColoredSnack(title: "خطا",description: message,type: SnackType.ERROR);
                              Get.back();
                            },
                            onWebViewCreated: ((controller) {
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
