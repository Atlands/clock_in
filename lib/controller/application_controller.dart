import 'dart:developer';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../database/item.dart';
import '../database/todo.dart';

class ApplicationController extends GetxController{
  late Database db;
  late PackageInfo packageInfo;

  Future initConfigure() async {
    List<Future> futures = [];
    futures.add(initDatabase());
    futures.add(initPackage());
    var r = await Future.wait(futures);
     log('end config');
     return r;
  }

  initPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
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