// @dart=2.9
import 'package:flutter/material.dart';
import 'Screens/MainMenu.dart';
import 'Screens/Calendar.dart';
import 'Screens/Notes.dart';
import 'Screens/Pomodoro.dart';
import 'constants.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:page_transition/page_transition.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


//void main() => runApp(MyApp());
Future<void> main() async {
  //NOTIFICATIONS
  WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid=
  AndroidInitializationSettings('taskly');
  var initializationSettingsIOS= IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async{});
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if(payload!=null){
          debugPrint('notification payload: '+ payload);
        }
      });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
            duration: 3000,
            backgroundColor: kBackgroundColour,
            splash: Image.asset('assets/Images/task-ly.png'),
            nextScreen: taskManager(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.topToBottom,
        )
    );
  }
}

class taskManager extends StatelessWidget {

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kBackgroundColour,
        scaffoldBackgroundColor: kBackgroundColour,
        platform: TargetPlatform.iOS,
      ),
      home: MainMenu(),
    );
  }
}