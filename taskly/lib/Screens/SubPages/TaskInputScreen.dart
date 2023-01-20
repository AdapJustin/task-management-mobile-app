// @dart=2.9
import 'package:flutter/material.dart';
import 'package:final_academic_project/Models/Task.dart';
import 'package:final_academic_project/Screens/MainMenu.dart';
import 'package:final_academic_project/constants.dart';
import 'package:final_academic_project/Widgets/reusable_card.dart';
import 'package:final_academic_project/Services/Task_Database.dart';
import 'package:final_academic_project/Screens/Calendar.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:final_academic_project/Services/ad_helper.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class TaskInputScreen extends StatefulWidget {
  @override
  _TaskInputScreen createState() => _TaskInputScreen();
}

class _TaskInputScreen extends State<TaskInputScreen> {
  final categoryController = TextEditingController();
  final taskController = TextEditingController();
  final desciptionController = TextEditingController();
  final goalController = TextEditingController();

  String category;
  String taskName;
  String description;
  Color currentColor = Color.fromRGBO(238, 153, 23, 1.0);
  List<String> TaskList = [];
  Map<String, int> TaskGoal = {};
  DateTime taskDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();

  //TimeOfDay _endTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final validCharacters = RegExp(r'^[a-zA-Z0-9_\-=@\. ]+$');

  // TODO: Add _interstitialAd
  InterstitialAd _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
  }

  Future addTask() async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    //const  TimeOfDayFormat timeformatter = ;
    final String formatted = formatter.format(taskDate);

    final task = new Task(
        taskDate: formatted,
        Category: category.toUpperCase(),
        TaskName: taskName,
        Description: description,
        colour: currentColor,
        startTime: _startTime,
        goals: TaskGoal.toString() //TaskList.toString()
        );

    await TaskDatabase.instance.create(task);
  }

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              addTask();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task Added')),
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainMenu(
                          pageIndex1: 1,
                        )),
              );
            },
          );
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;

        },
      ),
    );
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

  void _selectStartTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (newTime != null) {
      setState(() {
        _startTime = newTime;
        print(_startTime.hour);
      });
    }
  }

  void checkTask() {
    int startTimeInMinutes = _startTime.hour * 60 + _startTime.minute;
    int currentTime = TimeOfDay.now().hour * 60 + TimeOfDay.now().minute;
    print(currentTime);
    print(startTimeInMinutes);
    print(taskDate);
    print(DateTime.now());

    if (!taskDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      if (startTimeInMinutes <= currentTime &&
          taskDate.month == DateTime.now().month &&
          taskDate.day == DateTime.now().day &&
          taskDate.year == DateTime.now().year) {
        showAlert('Invalid Time!',
            'Start time should not be the earlier than current time ');
      } else {
        if (_formKey.currentState.validate()) {
          if (TaskList.isNotEmpty) {
            category = categoryController.text;
            taskName = taskController.text;
            description = desciptionController.text;
            if (_isInterstitialAdReady) {
              _interstitialAd.show();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task Added')),
              );

              addTask();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainMenu(
                          pageIndex1: 1,
                        )),
              );
            }
          } else {
            showAlert('No Goals!', 'Please enter at least one goal');
          }
        }
      }
    } else {
      showAlert('Invalid Date',
          'Please dont enter a date that is before current date');
    }
  }

  @override
  void dispose() {
    // TODO: Dispose an InterstitialAd object
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Date: ' +
                taskDate.year.toString() +
                '-' +
                taskDate.month.toString() +
                '-' +
                taskDate.day.toString(),
          ),
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              FontAwesomeIcons.angleLeft,
              color: Color.fromRGBO(78, 77, 77, 0.7019607843137254),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                checkTask();
              },
              icon: Icon(
                FontAwesomeIcons.check,
                color: Color.fromRGBO(78, 77, 77, 0.7019607843137254),
              ),
            ),
          ],
        ),
        body: RawScrollbar(
          thumbColor: currentColor,
          radius: Radius.circular(20),
          thickness: 5,
          interactive: true,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
              child: Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: Text(
                              'CATEGORY',
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: currentColor,
                              ),
                            ),
                          ),
                          FlatButton(
                            minWidth: 10.0,
                            height: 15.0,
                            color: currentColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        scrollable: true,
                                        elevation: 0,
                                        title: Text('Choose a color'),
                                        content: Container(
                                          height: 600,
                                          width: 300,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                ColorPicker(
                                                  initialPicker:
                                                      Picker.swatches,
                                                  color: currentColor,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      currentColor = value;
                                                    });
                                                    print(value);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop('dialog');
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.check,
                                            ),
                                          ),
                                        ],
                                        backgroundColor: kAlertColour2,
                                      ));
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 10, 5),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid category';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1.0),
                          ),
                          controller: categoryController,
                          decoration: InputDecoration(
                            filled: false,
                            hintText: 'Enter Category',
                            hintStyle: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.times,
                                size: 15,
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                              onPressed: () {
                                categoryController.clear();
                              },
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 10, 5),
                        child: TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid task name';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1.0),
                          ),
                          controller: taskController,
                          decoration: InputDecoration(
                            labelText: 'TASK NAME',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                            filled: false,
                            hintText: 'Enter Task Name',
                            hintStyle: TextStyle(
                              fontSize: 10.0,
                              color: Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.times,
                                size: 15,
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                              onPressed: () {
                                taskController.clear();
                              },
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 10, 5),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a valid description';
                            }
                            return null;
                          },
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1.0),
                          ),
                          controller: desciptionController,
                          decoration: InputDecoration(
                            labelText: 'DESCRIPTION',
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                            filled: false,
                            hintText: 'Enter Description',
                            hintStyle: TextStyle(
                              fontSize: 10.0,
                              color: Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.times,
                                size: 15,
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                              onPressed: () {
                                desciptionController.clear();
                              },
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: ReusableCard(
                                onPress: (){
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      scrollable: true,
                                      elevation: 1,
                                      title: Text('Choose a Date'),
                                      content: Container(
                                        height: 300,
                                        width: 300,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize:
                                            MainAxisSize.max,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .stretch,
                                            children: [
                                              SfDateRangePicker(
                                                view: DateRangePickerView.month,
                                                selectionMode: DateRangePickerSelectionMode.single,
                                                showNavigationArrow: true,
                                                showActionButtons: true,
                                                onCancel: () {
                                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                                },
                                                onSubmit: (value) {
                                                  setState(() {
                                                    if (value == null) {
                                                      taskDate = DateTime.now();
                                                    } else {
                                                      taskDate = value;
                                                    }
                                                  });
                                                  print(value);
                                                  Navigator.of(context, rootNavigator: true).pop('dialog');
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      backgroundColor: kAlertColour2,
                                    ),
                                  );
                                },
                                colour: kActiveCardColour,
                                cardChild: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child:  Icon(
                                    calendar.icon,
                                    color: kActiveNavbarIconColour,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: ReusableCard(
                                colour: kActiveCardColour,
                                cardChild: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Icon( 
                                            FontAwesomeIcons.clock,
                                            color: kTagDateColour,
                                            size: 24,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Column(children: [
                                            Text(
                                              'Start',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                color: kTagDateColour,
                                              ),
                                            ),
                                            Text(
                                              ' ${_startTime.format(context)}',
                                              style: kTagDateStyle,
                                            ),
                                          ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onPress: _selectStartTime,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 10, 5),
                        child: Form(
                          key: _formKey2,
                          child: TextFormField(
                            validator: (value) {
                              if (TaskGoal.containsKey(goalController.text)) {
                                return 'Goal already exists!';
                              }
                              if (!validCharacters
                                  .hasMatch(goalController.text)) {
                                return 'Goal has invalid characters';
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1.0),
                            ),
                            controller: goalController,
                            decoration: InputDecoration(
                              labelText:
                                  'GOALS  [' + TaskList.length.toString() + ']',
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                              filled: false,
                              hintText: 'Enter Goals',
                              hintStyle: TextStyle(
                                fontSize: 10.0,
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.plus,
                                  size: 20,
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (goalController.text.isEmpty) {
                                    } else if (_formKey2.currentState
                                        .validate()) {
                                      TaskGoal[goalController.text.trim()] = 0;
                                      TaskList.add(goalController.text.trim());
                                      goalController.clear();
                                      print(TaskGoal.toString());
                                    } else {}
                                  });
                                },
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.center,
                              tileMode: TileMode.mirror,
                              colors: [kBackgroundColour, Colors.transparent],
                              stops: [0.0, 0.09],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstOut,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(40, 10, 20, 10),
                            shrinkWrap: true,
                            itemCount: TaskList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 50.0,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          TaskList[index].toString(),
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.times,
                                        size: 10,
                                        color:
                                            Color.fromRGBO(172, 166, 166, 1.0),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          TaskGoal.remove(TaskList[index]);
                                          TaskList.removeAt(index);
                                          print(TaskGoal);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: kInactiveCardColour,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
