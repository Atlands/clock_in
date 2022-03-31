import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frequency/utils/color_utils.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../controller/application_controller.dart';
import '../../database/item.dart';

class EditItemLogic extends GetxController {
  Item item = Item();
  late Database db;

  late var colorController = TextEditingController(text: item.color);

  @override
  void onInit() {
    db = Get.find<ApplicationController>().db;
    int itemId = int.tryParse(Get.parameters['itemId'] ?? '') ?? 0;
    _queryData(itemId);
    super.onInit();
  }

  _queryData(int itemId) async {
    var res = await db.query(Item.keyClassName,
        where: '${Item.keyId} = ?', whereArgs: [itemId], limit: 1);
    item = res.map<Item>((e) => Item.fromMap(e)).first;
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

  editAction() async {
    if (item.name == null || item.color == null) {
      Fluttertoast.showToast(msg: '名称/颜色不能为空');
      return;
    }
    await db.update(Item.keyClassName, item.toMap(),
        where: '${Item.keyId} = ?', whereArgs: [item.id]);
    Get.back(result: item);
  }
}
