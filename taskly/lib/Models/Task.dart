import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'TaskGoal.dart';

final String tableTask = 'tasks';

class TaskField{
  static final List<String> values = [
    id, taskDate, category, taskName, description, colour, startTime,startTimeMin, goals
  ];

  static final String id = '_id';
  static final String taskDate = 'taskDate';
  static final String category = 'category';
  static final String taskName = 'taskName';
  static final String description = 'description';
  static final String colour = 'color';
  static final String startTime = 'startTime';
  static final String startTimeMin = 'startTimeMin';
  //static final String endTime = 'endTime';
  //static final String endTimeMin = 'endTimeMin';
  static final String goals = 'goals';

}

class Task {
  final int? id;
  final String taskDate;
  final String Category;
  final String TaskName;
  final String Description;
  final Color colour;
  final TimeOfDay startTime;
  //final TimeOfDay endTime;
  final String goals;

  const Task({
    this.id,
    required this.taskDate,
    required this.Category,
    required this.TaskName,
    required this.Description,
    required this.colour,
    required this.startTime,
    //required this.endTime,
    required this.goals,
  });

  static Task fromJson(Map<String, Object?> json) => Task(
    id: json["_id"] as int?,
    taskDate: json["taskDate"] as String,
    Category: json["category"] as String,
    TaskName: json["taskName"] as String,
    Description:json["description"] as String,
    colour: Color(json["color"] as int),
    startTime:  TimeOfDay(hour: json["startTime"] as int, minute: json["startTimeMin"] as int),
    //endTime:  TimeOfDay(hour: json["endTime"] as int, minute: json["endTimeMin"] as int),
    goals: json["goals"] as String,
  );


  Map<String, Object?> toJson() => {
    "_id":  id,
    "taskDate": taskDate,
    "category": Category,
    "taskName": TaskName,
    "description": Description,
    "color": colour.value,
    "startTime": startTime.hour,
    "startTimeMin": startTime.minute,
    //"endTime": endTime.hour,
    //"endTimeMin": endTime.minute,
    "goals": goals
  };

  Task copy({
    int? id,
    String? taskDate,
    String? Category,
    String? TaskName,
    String? Description,
    Color? colour,
    TimeOfDay? startDate,
    //TimeOfDay? endDate,
    String? goals,

  }) =>
    Task(
      id: id ?? this.id,
      taskDate: taskDate ?? this.taskDate,
      Category: Category ?? this.Category ,
      TaskName: TaskName ?? this.TaskName,
      Description: Description ?? this.Description,
      colour: colour ?? this.colour,
      startTime: startDate ?? this.startTime,
      //endTime: endDate ?? this.endTime,
      goals: goals ?? this.goals,
    );
}