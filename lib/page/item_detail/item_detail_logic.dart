import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frequency/route/route_config.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sqflite/sqflite.dart';

import '../../controller/application_controller.dart';
import '../../database/item.dart';
import '../../database/todo.dart';
import '../../utils/common_dialog.dart';

class ItemDetailLogic extends GetxController {
  Item item = Item();
  List<Todo> todos = [];

  int get gridCount {
    if (todos.isEmpty) return 1;
    return (Jiffy(DateTime(todos.last.time!.year, todos.last.time!.month)).diff(
                DateTime(todos.first.time!.year, todos.first.time!.month),
                Units.MONTH) +
            1)
        .toInt();
  }

  late Database _db;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    _db = Get.find<ApplicationController>().db;
    _queryData();
    super.onInit();
  }

  _queryData() async {
    int itemId = int.tryParse(Get.parameters['itemId'] ?? '') ?? 0;

    await Future.wait([
      _queryItem(itemId),
      _queryTodos(itemId),
    ]);
    // Future.delayed(Duration(microseconds: 500), () {
    //   scrollController.jumpTo(500.0 * (todos.length/2 + 1));
    //   // scrollController.jumpTo(scrollController.position.maxScrollExtent);
    //   print('hhhhh ${scrollController.position.maxScrollExtent}');
    // });
    _scrollEnd();
  }

  _scrollEnd() async {
    var h = 180.0 * (gridCount/2);
    scrollController.jumpTo(h);
  }

  Future _queryItem(int itemId) async {
    var res = await _db.query(Item.keyClassName,
        where: '${Item.keyId} = ?', whereArgs: [itemId], limit: 1);
    item = Item.fromMap(res.first);
    update(['item_detail']);
  }

  Future _queryTodos(int itemId) async {
    var res = await _db.query(Todo.keyClassName,
        where: '${Todo.keyItemId} = ?',
        whereArgs: [itemId],
        orderBy: Todo.keyTime);
    todos = res.map((e) => Todo.fromMap(e)).toList();
    update(['todo_calendar_list']);
  }

  _deleteItem(BuildContext context) async {
    showLoadingDialog(context);
    var db = Get.find<ApplicationController>().db;

    await db.delete(Item.keyClassName,
        where: '${Item.keyId} = ?', whereArgs: [item.id]);
    await db.delete(Todo.keyClassName,
        where: '${Todo.keyItemId} = ?', whereArgs: [item.id]);
    Get.back(); //关闭loadingDialog
    Get.back(); //返回上一页
  }

  showDeleteDialog() {
    BuildContext context = Get.context!;
    Get.dialog(AlertDialog(
      title: const Text('确定要删除此事项及事项下的所有打卡标记吗？'),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                    Theme.of(context).textTheme.bodyLarge?.color),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).scaffoldBackgroundColor)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('取消')),
        ElevatedButton(
            onPressed: () {
              Get.back();
              _deleteItem(context);
            },
            child: const Text('确定'))
      ],
    ));
  }

  pushEditItem() async {
    var item =
        await Get.toNamed('${RouteConfig.editItem}?itemId=${this.item.id}');
    if (item != null) {
      this.item = item;
      update(['item_detail']);
    }
  }

  pushTodoDetails(DateTime dateTime) async {
    await Get.toNamed(
        '${RouteConfig.todoDetail}?itemId=${item.id}&initDate=$dateTime');
    _queryTodos(item.id!);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
