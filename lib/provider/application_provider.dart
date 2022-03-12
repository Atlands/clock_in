import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:frequency/database/todo.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sqflite/sqflite.dart';

import '../database/item.dart';

class ApplicationProvider extends ChangeNotifier {
  late Database db;

  Future initConfigure() async {
    List<Future> futures = [];
    futures.add(initDatabase());
    return await Future.wait(futures);
  }

  Future<bool> initDatabase() async {
    log('message init database');
    db = await openDatabase('frequency.db', version: 3,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table ${Item.keyClassName} ( 
  ${Item.keyId} integer primary key autoincrement, 
  ${Item.keyName} text not null,
  ${Item.keyNote} text,
  ${Item.keyColor} text not null
)
''');
      await db.execute('''
create table ${Todo.keyClassName}(
  ${Todo.keyId} integer primary key autoincrement,
  ${Todo.keyName} text not null,
  ${Todo.keyItemId} integer not null,
  ${Todo.keyTime} text not null
)
''');
    }, onUpgrade: (Database db, int version, i) async {});
    return true;
  }

  @override
  void dispose() {
    super.dispose();
    db.close();
  }
}
