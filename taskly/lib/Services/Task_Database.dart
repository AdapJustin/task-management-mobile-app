import 'dart:async';
import 'package:final_academic_project/Models/Task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskDatabase{
  static final TaskDatabase instance = TaskDatabase._init();

  static Database? _database;

  TaskDatabase._init();

  Future<Database> get database async{
    if(_database != null) return _database!;

    _database = await _initDB('task.db');
    return _database!;
  }

  Future<Database>  _initDB(String filePath) async{
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate:  _createDB);
  }

  Future _createDB(Database db, int version) async{
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final stringType = 'TEXT NOT NULL';
    final intType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTask(
      ${TaskField.id} $idType,
      ${TaskField.taskDate} $stringType,
      ${TaskField.category} $stringType,
      ${TaskField.taskName} $stringType,
      ${TaskField.description} $stringType,
      ${TaskField.colour} $intType,
      ${TaskField.startTime} $intType,
      ${TaskField.startTimeMin} $intType,
      ${TaskField.goals} $stringType
      )
    ''');

  }

  Future<Task> create(Task task) async{
    final db = await instance.database;
    final id = await db.insert(tableTask, task.toJson());
    return task.copy(id: id);
  }

  Future<Task> readTask(int id) async{
    final db = await instance.database;
    final maps = await db.query(
      tableTask,
      columns: TaskField.values,
      where: '${TaskField.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty){
      return Task.fromJson(maps.first);
    }else{
      throw Exception('ID $id not found');
    }
  }

  Future<List<Task>> readDateTask(String date) async{
    final db = await instance.database;

    final orderBy = ' ${TaskField.taskDate} ASC';
    final results = await db.query(
      tableTask,
      columns: TaskField.values,
      where: '${TaskField.taskDate} = ?',
      whereArgs: [date],
      //orderBy: orderBy
    );

    List<Task> results1 = results.map((results) => Task.fromJson(results)).toList();
    print(results1);
    return results1;
  }

  Future<int> update(Task task) async{
    final db = await instance.database;
    return db.update(
      tableTask,
      task.toJson(),
      where: '${TaskField.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> delete(int id) async{
    final db = await instance.database;
    return await db.delete(
      tableTask,
      where: '${TaskField.id} = ?',
      whereArgs: [id],
    );
  }


  Future close() async{
    final db = await instance.database;
    _database = null;
    db.close();
  }
}