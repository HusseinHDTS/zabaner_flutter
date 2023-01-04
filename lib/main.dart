import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zabaner/models/urls.dart';
import 'package:zabaner/views/screens/splash_screen.dart';
import 'package:zabaner/widgets/colored_snack.dart';

FirebaseMessaging? _messaging;
RemoteMessage? initialMessage;
String fcmToken = "NaN";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String webhook =
      "https://discord.com/api/webhooks/1018449530817101897/IWcngaJIqjUrIsJJ8tHap0xMeLtTnVzyL6esamr7MXdRfhzwUW_-BhvT7029e7HvYhYP";
  CatcherOptions debugOptions = CatcherOptions(
    SilentReportMode(),
    [
      DiscordHandler(webhook,
          enableDeviceParameters: true,
          enableApplicationParameters: true,
          enableCustomParameters: true,
          enableStackTrace: true,
          printLogs: true),
    ],
    screenshotsPath: "/storage/emulated/0/Android/data/com.ir.zabaner/cache/",
  );

  CatcherOptions releaseOptions = CatcherOptions(
    SilentReportMode(),
    [
      DiscordHandler(webhook,
          enableDeviceParameters: true,
          enableApplicationParameters: true,
          enableCustomParameters: true,
          enableStackTrace: true,
          printLogs: true),
    ],
    screenshotsPath: "/storage/emulated/0/Android/data/com.ir.zabaner/cache/",
  );
  try{
    HttpOverrides.global = MyHttpOverrides();
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    _messaging = FirebaseMessaging.instance;
    String _token = (await _messaging?.getToken()).toString();
    fcmToken = _token;
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

    });
    if(fcmToken.trim() == "" || fcmToken.trim().toLowerCase() == "null"){
      fcmToken = "NaN";
    }
    registerNotification();

  }catch(e){
    ColoredSnack(title: e.toString());
    e.printError();
  }

  Catcher(
      rootWidget: const MyApp(),
      releaseConfig: releaseOptions,
      profileConfig: releaseOptions,
      debugConfig: debugOptions);


}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}

void registerNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {

  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        navigatorKey: Catcher.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: CatcherScreenshot(
            catcher: Catcher.getInstance(),
            child: const SplashScreen()));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
