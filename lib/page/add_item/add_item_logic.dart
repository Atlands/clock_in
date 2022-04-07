import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frequency/controller/application_controller.dart';
import 'package:frequency/utils/color_utils.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/item.dart';

class AddItemLogic extends GetxController {
  var item = Item();
  late final nameController = TextEditingController();
  late final noteController = TextEditingController();
  late final colorController = TextEditingController();

  late Database db;
  final _randomColor = Colors
      .primaries[Random().nextInt(Colors.primaries.length)][200]!.colorToString;

  @override
  void onInit() {
    db = Get.find<ApplicationController>().db;
    _initData();
    // colorController.text = item.color!;
    super.onInit();
  }

  _initData() {
    var itemId = int.tryParse(Get.parameters['itemId'] ?? '');
    if (itemId != null) {
      _queryData(itemId);
    } else {
      item.color = _randomColor;
      colorController.text = _randomColor;
    }
  }

  _queryData(int itemId) async {
    var res = await db.query(Item.keyClassName,
        where: '${Item.keyId} = ?', whereArgs: [itemId], limit: 1);
    item = res.map<Item>((e) => Item.fromMap(e)).first;
    nameController.text = item.name ?? '';
    noteController.text = item.note ?? '';
    colorController.text = item.color ?? _randomColor;
    update();
  }

  changeTextField(String value) {
    item.color = value;
    if (_colorValid) update();
  }

  bool get _colorValid =>
      item.color != null &&
      item.color!.length == 8 &&
      int.tryParse(item.color!, radix: 16) != null;

  changColor(Color color) {
    item.color = color.colorToString;
    colorController.text = item.color ?? '';
    update();
  }

  addAction() async {
    if (item.name == null || item.color == null) {
      Fluttertoast.showToast(msg: '名称/颜色不能为空');
      return;
    }
    if (!_colorValid) {
      Fluttertoast.showToast(msg: '请输入8位标准格式颜色代码');
      return;
    }
    if (item.id == null) {
      item.id = await db.insert(Item.keyClassName, item.toMap());
    } else {
      await db.update(Item.keyClassName, item.toMap(),
          where: '${Item.keyId} = ?', whereArgs: [item.id]);
    }
    Get.back(result: item);
  }

  @override
  void onClose() {
    nameController.dispose();
    noteController.dispose();
    colorController.dispose();
    super.onClose();
  }
}
