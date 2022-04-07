import 'package:frequency/controller/application_controller.dart';
import 'package:frequency/route/route_config.dart';
import 'package:get/get.dart';

import '../../database/item.dart';
import '../../database/todo.dart';

class HomeLogic extends GetxController {
  List<Item> items = [];
  List<Todo> todos = [];

  List<DateTime> itemDates(Item item) => todos
      .where((element) => element.item!.id == item.id)
      .map((e) => e.time!)
      .toList();

  @override
  void onInit() {
    _queryData();
    super.onInit();
  }

  pushSetting() async {
    await Get.toNamed(RouteConfig.setting);
    _queryData();
  }

  pushAddTodo() async {
    await Get.toNamed(RouteConfig.addTodo);
    _queryData();
  }

  pushItemDetails(Item item) async {
    await Get.toNamed('${RouteConfig.itemDetail}?itemId=${item.id}');
    _queryData();
  }

  _queryData() async {
    List<Future<List<Map<String, Object?>>>> futures = [];

    var db = Get.find<ApplicationController>().db;
    futures.add(db.query(Item.keyClassName));

    var futureTodo = db.query(Todo.keyClassName,
        // where: '${Todo.keyItemId} = ?',
        // whereArgs: [item.id],
        orderBy: Todo.keyTime);
    futures.add(futureTodo);

    var list = await Future.wait(futures);

    items = list.first.map<Item>((e) => Item.fromMap(e)).toList();
    todos = list.last.map((e) => Todo.fromMap(e)).toList();
    update();
  }
}
