import 'package:final_academic_project/Screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:final_academic_project/constants.dart';
import 'package:final_academic_project/Screens/Home.dart';
import 'package:final_academic_project/Screens/Calendar.dart';
import 'package:final_academic_project/Screens/Notes.dart';
import 'package:final_academic_project/Screens/Pomodoro.dart';
import 'package:final_academic_project/Widgets/reusable_card.dart';
import 'package:final_academic_project/Widgets/reusable_card_task_display.dart';
import 'package:final_academic_project/Widgets/reusable_card_calendar.dart';

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animations/animations.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:final_academic_project/Services/ad_helper.dart';

class MainMenu extends StatefulWidget {
    MainMenu({this.pageIndex1});
  int? pageIndex1;
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int pageIndex = 1;
  List<Widget> pagelist = <Widget>[
    //Home(),
    Notes(),
    Calendar(),
    Pomodoro(),
  ];

  late BannerAd _bannerAd;

  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  @override
  void initState() {
    // TODO: Initialize _bannerAd
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    );

    _bannerAd.load();
    if(widget.pageIndex1 == null){
      pageIndex = 1;
    }else
      pageIndex = widget.pageIndex1!;
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:  PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
          FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
        child: pagelist[pageIndex],
      ),//pagelist[pageIndex],
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          //unselectedFontSize: 10,
          //selectedFontSize: 12,
          fixedColor: kActiveNavbarIconColour,
          backgroundColor: kBottomNavBarColour,
          currentIndex: pageIndex,
          onTap: (value){
            setState(() {
              pageIndex = value;
            });

          },
          type: BottomNavigationBarType.fixed,
          items: [
            //BottomNavigationBarItem(icon: Icon(mainmenu.icon,), label: 'Main Menu'),
            BottomNavigationBarItem(icon: Icon(notesmenu.icon,), label: 'Notes'),
            BottomNavigationBarItem(icon: Icon(calendar.icon,), label: 'Calendar'),
            BottomNavigationBarItem(icon: Icon(pomodoro.icon,), label: 'Pomodoro'),
          ],
        ),
      ),
    );
  }

}


