import 'dart:developer';

import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite/sqflite.dart';

import '../database/item.dart';
import '../database/todo.dart';

class ApplicationController extends GetxController {
  late Database db;
  late PackageInfo packageInfo;

  final _createTables = [Item.createItemSql,Todo.createTodoSql];

  Future initConfigure() async {
   // await Jiffy.locale("zh_cn");
    List<Future> futures = [];
    futures.add(_initDatabase());
    futures.add(_initPackage());
    return Future.wait(futures);
  }

  _initPackage() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

  Future<bool> _initDatabase() async {
    db = await openDatabase('frequency.db', version: 3,
        onCreate: (Database db, int version) async {
      for(var sql in _createTables){
        await db.execute(sql);
      }
    }, onUpgrade: (Database db, int version, i) async {});
    return true;
  }

  @override
  void onClose() {
    db.close();
    super.onClose();
  }
}
