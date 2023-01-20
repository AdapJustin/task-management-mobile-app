import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:final_academic_project/Models/pomodoro_status.dart';


//#region pomodoro constants
//Pomodoro Times
const pomodoroTotalTime = 25*60;
const shortBreakTime = 5*60;
const longBreakTime= 30*60;
const pomodoroPerSet = 4;



//Pomodoro Descriptions
const Map<PomodoroStatus, String> statusDescription={
  PomodoroStatus.runningPomodoro: 'It\'s work time!',
  PomodoroStatus.pausedPomodoro: 'Ready for a focused pomodoro?',
  PomodoroStatus.runningShortBreak: 'Let\'s take a breather',
  PomodoroStatus.pausedShortBreak: 'Time for a short break',
  PomodoroStatus.runningLongBreak: 'Time for a long rest',
  PomodoroStatus.pausedLongBreak: 'Let\'s have a long break',
  PomodoroStatus.setFinished: 'You made it!',
};

//Pomodoro Colors
const Map<PomodoroStatus, Color> statusColor = {
  PomodoroStatus.runningPomodoro: Color.fromRGBO(3, 160, 98, 1.0),
  PomodoroStatus.pausedPomodoro: Color.fromRGBO(203, 0, 01, 1.0),
  PomodoroStatus.runningShortBreak: Color.fromRGBO(226, 149, 120, 1.0),
  PomodoroStatus.pausedShortBreak: Color.fromRGBO(0, 109, 119, 1.0),
  PomodoroStatus.runningLongBreak: Color.fromRGBO(226, 149, 120, 1.0),
  PomodoroStatus.pausedLongBreak:Color.fromRGBO(0, 109, 119, 1.0),
  PomodoroStatus.setFinished:Color.fromRGBO(203, 0, 01, 1.0),
};

//#endregion

const kBottomContainerHeight = 80.0;
const kBackgroundColour = Color.fromRGBO(237, 246, 249, 1.0);
const kAppbarShadowColour = Color.fromRGBO(87, 123, 121, 1.0);
const kAppbarColour = Color.fromRGBO(255, 255, 255, 1.0);
const kScrollBarColour = Color.fromRGBO(67, 137, 107, 0.5);

const kActiveCardColour = Color.fromRGBO(255, 255, 255, 1.0);
const kActiveCardColour2 = Color.fromRGBO(29, 196, 178, 0.5);
const kInactiveCardColour = Color.fromRGBO(124, 170, 170, 0.2);

const kAlertColour = Color.fromRGBO(0, 109, 119, 1.0);
const kAlertColour2 = Color.fromRGBO(229, 229, 229, 1.0);


const kBottomNavBarColour = Color.fromRGBO(255, 255, 255, 1.0);
const kNavbarIconColour = Color.fromRGBO(114, 114, 113, 0.5);
const kActiveNavbarIconColour = Color.fromRGBO(234, 181, 27, 0.7254901960784313);

const kSelectedDayColour = Color.fromRGBO(131, 197, 190, 0.7019607843137254);
const kDayColour = Color.fromRGBO(0, 0, 0, 0.7019607843137254);
const kMonthColour = Color.fromRGBO(0, 0, 0, 0.7019607843137254);

const kTagColor1 = Color.fromRGBO(238, 153, 23, 1.0);
const kTagContentStyle = Color.fromRGBO(0, 0, 0, 1.0);
const kTagDateColour = Color.fromRGBO(16, 169, 173, 1.0);

const kWorkSliderColor = Color.fromRGBO(255, 77, 77, 1.0);
const kShortbreakSliderColor = Color.fromRGBO(3, 235, 141, 1.0);
const kLongBreakSliderColor = Color.fromRGBO(11, 188, 221, 1.0);
const kRoundsSliderColor = Color.fromRGBO(132, 139, 153, 1.0);

const kWorkThumbColor = Color.fromRGBO(255, 77, 77, 1.0);
const kShortbreakThumbColor = Color.fromRGBO(3, 235, 141, 1.0);
const kLongBreakThumbColor = Color.fromRGBO(11, 188, 221, 1.0);
const kRoundsThumbColor = Color.fromRGBO(132, 139, 153, 1.0);

const kWorkThumbOverlayColor = Color.fromRGBO(147, 40, 40, 0.3);
const kShortbreakThumbOverlayColor = Color.fromRGBO(1, 149, 89, 0.3);
const kLongBreakThumbOverlayColor = Color.fromRGBO(7, 120, 141, 0.3);
const kRoundsThumbOverlayColor = Color.fromRGBO(85, 86, 97, 0.3);

const kNotesFormTitleColor = Color.fromRGBO(0, 0, 0, 1.0);
const kNotesFormContentColor = Color.fromRGBO(0, 0, 0, 1.0);
const kNotesFormSaveFontColor = Color.fromRGBO(255, 255, 255, 1.0);
const kNotesFormSaveColor = Color.fromRGBO(16, 169, 173, 1.0);
const kNotesFormSaveInvalidColor = Color.fromRGBO(103, 104, 104, 0.5);
const kNotesAddColor = Color.fromRGBO(13, 203, 177, 1.0);

const mainmenu = Icon(
  FontAwesomeIcons.home,
);
const notesmenu = Icon(
  FontAwesomeIcons.fileAlt,
);
const calendar = Icon(
  FontAwesomeIcons.calendarAlt,
);
const pomodoro = Icon(
  FontAwesomeIcons.stopwatch,

);


const kLabelTextStyle = TextStyle(
  fontSize: 20.0,
  color: Color.fromRGBO(255, 255, 255, 1.0),
  letterSpacing: 1.0,
  fontWeight: FontWeight.bold,
);

const kTagLabelTextStyle = TextStyle(
  fontSize: 17.0,
  color: kTagColor1,
  letterSpacing: 1.0,
  fontWeight: FontWeight.bold,
);
const kTagLabelTextStyle2 = TextStyle(
  fontSize: 25.0,
  color: kTagContentStyle,
  letterSpacing: 1.0,
  fontWeight: FontWeight.bold,
);

const kTagDateStyle = TextStyle(
  fontSize: 15.0,
  color: kTagDateColour,
  letterSpacing: 1.0,
  fontWeight: FontWeight.bold,
);


const kProgressTextStyle = TextStyle(
  fontSize: 20.0,
  letterSpacing: 1.0,
  color: Color.fromRGBO(189, 189, 189, 1.0),
);

const kTitleTextStyle = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: Color.fromRGBO(36, 36, 36, 1.0),
);

const kTitleTextStyle2 = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.bold,
  color: Color.fromRGBO(36, 36, 36, 1.0),
);

const kContentTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,

);
const kContentTextStyle2 = TextStyle(
  fontSize: 35.0,
  fontWeight: FontWeight.bold,
);

const kContentTextStyle3 = TextStyle(
  fontSize: 15.0,
);

const kContentTextStyle4 = TextStyle(
  fontSize: 15.0,
  color: Color.fromRGBO(189, 189, 189, 0.5),
);

const kContentTextStyle5 = TextStyle(
  fontSize: 20.0,
);

const kContentTextStyle6 = TextStyle(
  fontSize: 15.0,
  color: Color.fromRGBO(255, 255, 255, 1.0),
);

