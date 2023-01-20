// @dart=2.9
import 'package:final_academic_project/Widgets/reusable_card_calendar.dart';
import 'package:flutter/material.dart';
import 'package:final_academic_project/constants.dart';
import 'package:final_academic_project/Models/Task.dart';
import 'package:flutter/widgets.dart';
import 'package:final_academic_project/Screens/SubPages/TaskInputScreen.dart';
import 'package:final_academic_project/Screens/SubPages/task_detail_page.dart';
import 'package:final_academic_project/Services/Task_Database.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Calendar extends StatefulWidget {
  @override
  _Calendar createState() => _Calendar();
}

class _Calendar extends State<Calendar> {
  DateFormat dateFormat;
  DateFormat timeFormat;
  DateTime _selectedDate = DateTime.now().add(Duration(days: 5));
  List<Task> tasks = [];


  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    dateFormat = new DateFormat.yMMMMd('cs');
    timeFormat = new DateFormat.Hms('cs');

    _resetSelectedDate();
    refreshTask();
  }

  Future refreshTask() async{
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(_selectedDate);
    List<Task>tasks2 = await TaskDatabase.instance.readDateTask(formatted);
    print("Tasks length is "+ tasks.length.toString());
    setState(() {
      if(tasks.isNotEmpty || tasks.length > 0){
        tasks.clear();
      }
      if(tasks2.isNotEmpty)
        print(tasks2[0]);
      tasks = tasks2;
    });
  }

  void _resetSelectedDate() {
    setState(() {
      _selectedDate = DateTime.now();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Calendar',
                    style: kTitleTextStyle,
                  ),
                ),
                CalendarTimeline(
                  showYears: true,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2020).add(Duration(days: 11322)),
                  onDateSelected: (date){
                    setState(() {
                      _selectedDate = date;
                    });
                    refreshTask();
                    print(_selectedDate);
                    print(TimeOfDay.now().toString());
                  },
                  leftMargin: 20,
                  monthColor: kMonthColour,
                  dayColor: kDayColour,
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: kSelectedDayColour,
                  dotsColor: kSelectedDayColour,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'My Task',
                          style: kTitleTextStyle,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.redoAlt,
                        size: 20,
                        color: Color.fromRGBO(16, 16, 16, 1.0),
                      ),
                      onPressed: (){
                        refreshTask();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.plus,
                        size: 20,
                        color: Color.fromRGBO(16, 16, 16, 1.0),
                      ),
                      onPressed: (){
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => TaskInputScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                if(tasks.isNotEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: RawScrollbar(
                        thumbColor: kScrollBarColour,
                        radius: Radius.circular(20),
                        thickness: 5,
                        interactive: true,
                        isAlwaysShown: false,
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: tasks.length,
                          itemBuilder: (context, index){
                            return ReusableCardCalendar(
                                onPress: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) => TaskDetailPage(
                                        task: tasks[index],
                                      ),
                                    ),
                                  );
                                  print(tasks[index].taskDate);
                                },
                                TaskName: tasks[index].TaskName,
                                Category: tasks[index].Category,
                                startTime: tasks[index].startTime ,
                                colour: tasks[index].colour
                            );
                          },
                        ),
                      ),
                    ),
                  ),

              ],
            ),
        ),
      ),
    );
  }
}
