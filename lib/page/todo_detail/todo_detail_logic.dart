import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sqflite/sqflite.dart';

import '../../controller/application_controller.dart';
import '../../database/item.dart';
import '../../database/todo.dart';

class TodoDetailLogic extends GetxController {
  Item item = Item();
  List<Todo> todos = [];

  late DateTime initDate;

  List<Todo> get showTodos {
    var ts = todos
        .where((element) =>
            element.time!.year == initDate.year &&
            element.time!.month == initDate.month)
        .toList();
    ts.sort(
      (a, b) => a.time!.compareTo(b.time!),
    );
    return ts;
  }

  late Database _db;

  @override
  void onInit() {
    _db = Get.find<ApplicationController>().db;

    _queryData();

    super.onInit();
  }

  _queryData() async {
    int itemId = int.tryParse(Get.parameters['itemId'] ?? '') ?? 0;

    initDate = Jiffy(Get.parameters['initDate']).dateTime;
    item.id = itemId;

    List<Future<List<Map<String, Object?>>>> futures = [];

    var futureItem = _db.query(Item.keyClassName,
        where: '${Item.keyId} = ?', whereArgs: [itemId], limit: 1);
    futures.add(futureItem);

    var futureTodo = _db.query(Todo.keyClassName,
        where: '${Todo.keyItemId} = ?',
        whereArgs: [itemId],
        orderBy: Todo.keyTime);
    futures.add(futureTodo);

    var list = await Future.wait(futures);

    item = list.first.map<Item>((e) => Item.fromMap(e)).first;
    todos = list.last.map((e) => Todo.fromMap(e)).toList();
    update(['todo_list', 'item']);
  }

  deleteTodo(Todo todo) async {
    Get.snackbar('${item.name}', '删除了${Jiffy(todo.time).format('dd')}日事件');
    await _db.delete(Todo.keyClassName,
        where: '${Todo.keyId} = ?', whereArgs: [todo.id]);
    todos.removeWhere((element) => element.id == todo.id);
    update(['todo_list']);
  }

  viewChanged(DateTime time) async {
    if (initDate.year != time.year || initDate.month != time.month) {
      initDate = time;
      update(['todo_list']);
    }
  }
}