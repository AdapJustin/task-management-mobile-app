import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:final_academic_project/Models/Task.dart';
import 'package:final_academic_project/Screens/MainMenu.dart';
import 'package:final_academic_project/Services/Task_Database.dart';
import 'package:final_academic_project/Widgets/reusable_card_calendar.dart';
import 'package:final_academic_project/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class TaskDetailPage extends StatefulWidget {
  final Task? task;

  const TaskDetailPage({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  _TaskDetailPage createState() => _TaskDetailPage();
}

class _TaskDetailPage extends State<TaskDetailPage> {
  late String taskDate;
  late String Category;
  late String TaskName;
  late TimeOfDay startTime;
  late Color colour;
  late String Description;
  late String goals;

  Map<String, int> goals2 = {};

  List<String> g = [];
  List<bool> gValue = [];


  @override
  void initState() {
    super.initState();
    taskDate =  widget.task?.taskDate ?? 'unknown';
    Category = widget.task?.Category ?? '';
    TaskName = widget.task?.TaskName ?? '';
    Description = widget.task?.Description ?? '';
    colour = widget.task?.colour ?? Color.fromRGBO(0, 0, 0, 1.0);
    startTime = widget.task?.startTime ?? TimeOfDay(hour: 0, minute: 0);
    goals = widget.task?.goals ?? '';
    print(goals);
    convertGoals();
  }

  Future updateTask() async{
    final task = widget.task!.copy(
      goals: goals2.toString(),
    );

    await TaskDatabase.instance.update(task);

  }

  void convertGoals() {
    String v =  goals.replaceAll("{", "");
    v =  v.replaceAll("}", "");
    print(v);
    List<String> goals1 = v.split(",");
    for(var x in goals1){
      List<String> g2 = x.split(":");
      g.add(g2[0].trim());
      int val = int.parse(g2[1]);
      bool valConverted = convert(val);
      gValue.add(valConverted);
      goals2[g2[0].trim()] = int.parse(g2[1]);
    }
    print(goals2.keys);
    print(g);
  }

  bool convert(int b){
    if(b == 1 )
      return true;
    else
      return false;
  }


  int  convertBool(bool b){
    return b ? 1:0;
  }

  String fixTime(TimeOfDay timeStart , TimeOfDay timeEnd){
    String fixHrStart = timeStart.hour.toString();
    String fixMinStart = timeStart.minute.toString();
    String fixHrEnd = timeEnd.hour.toString();
    String fixMinEnd = timeEnd.minute.toString();

    if(int.parse(fixHrStart) < 10)
      fixHrStart = "0" + fixHrStart;
    if(int.parse(fixMinStart) < 10)
      fixMinStart = "0" + fixMinStart;
    if(int.parse(fixHrEnd) < 10)
      fixHrEnd = "0" + fixHrEnd;
    if(int.parse(fixMinEnd) < 10)
      fixMinEnd = "0" + fixMinEnd;

    String fixedTime  = fixHrStart + ":" + fixMinStart + " - " + fixHrEnd + ":" + fixMinEnd;

    return fixedTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        //shadowColor: widget.colour,
        title: Text(
            taskDate,
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
        /*title: Text(
          fixTime(widget.startTime, widget.endTime)
        ),*/
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.check),
            color: Color(0xff191D21),
            onPressed: () async{
              updateTask();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainMenu(
                  pageIndex1: 1,
                )),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Color(0xff191D21),
            onPressed: () async{
              await TaskDatabase.instance.delete(widget.task?.id ?? 0);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MainMenu(
                  pageIndex1: 1,
                )),
              );
            },
          ),
        ],
      ),
      body: RawScrollbar(
        thumbColor: colour,
        radius: Radius.circular(20),
        thickness: 5,
        interactive: true,
        isAlwaysShown: false,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    ReusableCardCalendar(
                      TaskName: TaskName,
                      Category: Category,
                      startTime: startTime ,
                      colour: colour,
                      onPress: () {  },
                    ),
                   /* Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Task Name',
                        style: kTagLabelTextStyle2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        TaskName,
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          fontSize: 18,
                        ),
                      ),
                    ),*/
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Description',
                        style: kTagLabelTextStyle2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        Description,
                        style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 0.5),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Goals',
                        style: kTagLabelTextStyle2,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: RawScrollbar(
                          thumbColor: colour,
                          radius: Radius.circular(20),
                          thickness: 5,
                          interactive: true,
                          isAlwaysShown: false,
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            //shrinkWrap: true,
                            itemCount: g.length,
                            itemBuilder: (context, index){
                              return Container(
                                height: 50.0,
                                child: CheckboxListTile(
                                  checkColor: Color.fromRGBO(0, 0, 0, 0.8),
                                  activeColor: Color.fromRGBO(0, 0, 0, 0),
                                  title: Text(g[index]),
                                  value:  gValue[index],
                                  onChanged: (newValue) {
                                    setState(() {
                                      goals2[g[index]] = convertBool(newValue!);
                                      gValue.removeAt(index);
                                      gValue.insert(index, newValue);
                                      print(goals2);
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                ),
                                //margin: EdgeInsets.all(5.0),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}