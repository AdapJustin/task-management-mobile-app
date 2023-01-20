
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:final_academic_project/main.dart';
import 'package:final_academic_project/Widgets/progress_icons.dart';
import 'package:final_academic_project/Widgets/custom_button.dart';
import 'package:final_academic_project/Models/pomodoro_status.dart';
import 'package:final_academic_project/constants.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:final_academic_project/Services/ad_helper.dart';

//Pomodoro Button Texts
const _btnTextStart = 'START POMODORO';
const _btnTextResumePomodoro = 'RESUME POMODORO';
const _btnTextResumeBreak = 'RESUME BREAK';
const _btnTextStartShortBreak = 'TAKE SHORT BREAK';
const _btnTextStartLongBreak = 'TAKE LONG BREAK';
const _btnTextStartNewSet = 'START NEW SET';
const _btnTextPause = 'PAUSE';
const _btnTextReset = 'RESET';

//Alert Texts
const _alertPomodoroDone = 'Time for a short break!';
const _alertShortBreakDone = 'Let\'s get back to work!';
const _alertLongBreak = 'It\'s time for a long break';
const _alertLongBreakDone = 'You just completed the pomodoro';

class Pomodoro extends StatefulWidget {

  @override
  _Pomodoro createState() => _Pomodoro();
}

class _Pomodoro extends State<Pomodoro> {
  late BannerAd _bannerAd;
  // TODO: Add _isBannerAdReady
  bool _isBannerAdReady = false;

  PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
  Timer? _timer;
  int remainingTime = pomodoroTotalTime;
  String mainBtnText = _btnTextStart;
  String alertTxt = _alertPomodoroDone;
  int pomodoroNum = 0;
  int setNum = 0;



  @override
  void initState() {

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


  void showAlert(title, message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        elevation: 0,
        title: Text(
          title,
          style: TextStyle(
            color: Color.fromRGBO(3, 3, 3, 1.0),
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 14.0,
            color: Color.fromRGBO(3, 3, 3, 1.0),
          ),
        ),
        actions: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(
                  color: Color.fromRGBO(0, 109, 119, 1.0), fontSize: 20),
            ),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop('alert'),
            width: 120,
            color: Color.fromRGBO(52, 199, 194, 1.0),
          )
        ],
        backgroundColor: kAlertColour2,
      ),
    );
  }

  @override
  void dispose() {
    _cancelTimer();
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Pomodoro',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: (){
                String msg =  'Pomodoro Technique is a time management method. It helps you to become productive and stops you from getting distracted.'
                    '\n\n1 Pomodoro is equivalent to 25 mins of focused work and 5 mins  of short break.'
                    '\n\n1 set is equivalent to completing 4 Pomodori'
                    '\n\nDid you know? \nPomodoro is an italian word for "Tomato"';
                showAlert('What is the Pomodoro Technique?', msg);

              },
              icon: Icon(
                FontAwesomeIcons.questionCircle,
                color:  Color.fromRGBO(0,0,0,0.3),
              ))
        ],
        backgroundColor: Color.fromRGBO(237, 246, 249, 1.0),
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height,
                  maxWidth: MediaQuery.of(context).size.width
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularPercentIndicator(
                            radius: 260.0,
                            lineWidth: 18.0,
                            percent: _getPomodoroPercentage(),
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Container(
                              height: double.maxFinite,
                              width: double.maxFinite,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 85,
                                  ),
                                  Text(
                                    _secondsToFormatedString(remainingTime),
                                    style: TextStyle(fontSize: 60, color: Colors.black),
                                  ),
                                  Text(
                                      statusDescription[pomodoroStatus]?.toString() ?? '',
                                      //dunno how dis works but it works anyway dont touch
                                      style: TextStyle(color: Colors.black)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Set: $setNum',
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            progressColor: statusColor[pomodoroStatus],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ProgressIcons(
                            total: pomodoroPerSet,
                            done: pomodoroNum - (setNum * pomodoroPerSet),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                            onTap: () {
                              mainButtonPressed();
                            },
                            text: mainBtnText,
                          ),
                          CustomButton(
                            onTap: () {
                              _resetButtonPressed();
                            },
                            text: _btnTextReset,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ),
          ),
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
    );
  }

  _secondsToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;

    if (remainingSeconds < 10) {
      remainingSecondsFormated = '0$remainingSeconds';
    } else {
      remainingSecondsFormated = remainingSeconds.toString();
    }
    return '$roundedMinutes:$remainingSecondsFormated';
  }

  _getPomodoroPercentage() {
    int totalTime;
    switch (pomodoroStatus) {
      case PomodoroStatus.runningPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.pausedPomodoro:
        totalTime = pomodoroTotalTime;
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = shortBreakTime;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = longBreakTime;
        break;
      case PomodoroStatus.setFinished:
        totalTime = pomodoroTotalTime;
        break;
    }
    double percentage = 1 - ((totalTime - remainingTime) / totalTime);
    return percentage;
  }

  void mainButtonPressed() {
    switch (pomodoroStatus) {
      case PomodoroStatus.runningPomodoro:
        _pausedPomodoroCountdown();
        break;
      case PomodoroStatus.pausedPomodoro:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runningShortBreak:
        _pauseShortBreakCountdown();
        break;
      case PomodoroStatus.pausedShortBreak:
        _startShortBreak();
        break;
      case PomodoroStatus.runningLongBreak:
        _pauseLongBreakCountdown();
        break;
      case PomodoroStatus.pausedLongBreak:
        _startLongBreak();
        break;
      case PomodoroStatus.setFinished:
        setNum++;
        _startPomodoroCountdown();
        break;
    }
  }

  _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runningPomodoro;
    _cancelTimer();

    _timer = Timer.periodic(
        Duration(seconds: 1),
            (timer) => {
          if (remainingTime > 0)
            {
              setState(() {
                remainingTime--;
                mainBtnText = _btnTextPause;
              })
            }
          else
            {
              pomodoroNum++,
              _cancelTimer(),
              if (pomodoroNum % pomodoroPerSet == 0)
                {
                  pomodoroStatus = PomodoroStatus.pausedLongBreak,
                  setState(() {
                    remainingTime = longBreakTime;
                    mainBtnText = _btnTextStartLongBreak;
                    alertTxt = _alertLongBreak;
                  }),
                  soundAlarm(),
                  setState(() {
                    alertTxt = _alertLongBreakDone;
                  })
                }
              else
                {
                  soundAlarm(),
                  pomodoroStatus = PomodoroStatus.pausedShortBreak,
                  setState(() {
                    remainingTime = shortBreakTime;
                    mainBtnText = _btnTextStartShortBreak;
                    alertTxt = _alertShortBreakDone;
                  }),
                }
            }
        });
  }

  _startShortBreak() {
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _timer = Timer.periodic(
        Duration(seconds: 1),
            (timer) => {
          if (remainingTime > 0)
            {
              setState(() {
                remainingTime--;
              })
            }
          else
            {
              soundAlarm(),
              remainingTime = pomodoroTotalTime,
              _cancelTimer(),
              pomodoroStatus = PomodoroStatus.pausedPomodoro,
              setState(() {
                mainBtnText = _btnTextStart;
                alertTxt = _alertPomodoroDone;
              })
            }
        });
  }

  _startLongBreak() {
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextPause;
    });
    _timer = Timer.periodic(
        Duration(seconds: 1),
            (timer) => {
          if (remainingTime > 0)
            {
              setState(() {
                remainingTime--;
              })
            }
          else
            {
              soundAlarm(),
              remainingTime = pomodoroTotalTime,
              _cancelTimer(),
              pomodoroStatus = PomodoroStatus.setFinished,
              setState(() {
                mainBtnText = _btnTextStartNewSet;
                alertTxt = _alertPomodoroDone;
              })
            }
        });
  }

  _resetButtonPressed() {
    pomodoroNum = 0;
    setNum = 0;
    _cancelTimer();
    _stopCountdown();
  }

  _stopCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    setState(() {
      mainBtnText = _btnTextStart;
      remainingTime = pomodoroTotalTime;
      alertTxt = _alertPomodoroDone;
    });
  }

  _pausedPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumePomodoro;
    });
  }

  _pauseShortBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedShortBreak;
    _pauseBreakCountdown();
  }

  _pauseLongBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedLongBreak;
    _pauseBreakCountdown();
  }

  _pauseBreakCountdown() {
    _cancelTimer();
    setState(() {
      mainBtnText = _btnTextResumeBreak;
    });
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  void soundAlarm() async {

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channelId',
      'channelName',
      'channelDescription',
      onlyAlertOnce: false,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notif'),
      largeIcon: DrawableResourceAndroidBitmap('taskly2'),

    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true, presentBadge: true, presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    DateTime time = DateTime.now();
    await flutterLocalNotificationsPlugin.schedule(
        0, 'Taskly', alertTxt, time, platformChannelSpecifics);
  }
}
