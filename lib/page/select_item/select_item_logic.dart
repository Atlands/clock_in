import 'package:frequency/controller/application_controller.dart';
import 'package:frequency/route/route_config.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../../database/item.dart';

class SelectItemLogic extends GetxController {
  List<Item> items = [];
  late Database db;

  @override
  void onInit() {
    db = Get.find<ApplicationController>().db;
    _queryAll();
    super.onInit();
  }

  pushAddItem() async {
    var item = await Get.toNamed(RouteConfig.addItem);
    _addItem(item);
  }

  selectItem(Item item) {
    Get.back(result: item);
  }

  _addItem(Item? item) async {
    if (item == null) return;
    items.add(item);
    update();
  }

  _queryAll() async {
    List<Map<String, Object?>> maps = await db.query(Item.keyClassName);
    items = maps.map((e) => Item.fromMap(e)).toList();
    update();
  }
}
