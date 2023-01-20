import 'package:flutter/material.dart';
import 'package:final_academic_project/constants.dart';
import 'package:final_academic_project/Screens/MainMenu.dart';
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

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:final_academic_project/Services/ad_helper.dart';

class Home extends StatefulWidget {

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  late BannerAd _bannerAd;
  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  int work = 25;
  int shortBreak = 5;
  int longBreak = 15;
  int rounds = 4;



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
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Main Menu',
          style: kTitleTextStyle,
        ),
      ),
      body: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              Row(
                children: <Widget>[
                  Expanded(
                    child: ReusableCardTaskDisplay(
                        colour: kActiveCardColour2,
                        cardChild: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('data'),
                        ),
                        onPress: () {}),
                  ),
                  Expanded(
                    child: ReusableCardTaskDisplay(
                        colour: kActiveCardColour2,
                        cardChild: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('data'),
                        ),
                        onPress: () {}),
                  ),
                ],
              ),
              ReusableCardTaskDisplay(
                  colour: Color.fromRGBO(29, 132, 29, 1.0),
                  cardChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('data'),
                  ),
                  onPress: () {}),
              if (_isBannerAdReady)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: _bannerAd.size.width.toDouble(),
                    height: _bannerAd.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
