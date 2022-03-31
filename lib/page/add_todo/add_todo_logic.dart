import 'package:fluttertoast/fluttertoast.dart';
import 'package:frequency/controller/application_controller.dart';
import 'package:frequency/route/route_config.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../database/item.dart';
import '../../database/todo.dart';

class AddTodoLogic extends GetxController {
  CalendarController calendarController = CalendarController()
    ..selectedDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  Todo todo = Todo()
    ..time =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  onSelectionChanged(CalendarSelectionDetails details) {
    todo.time = details.date;
    update();
  }

  pushSelectItem() async {
    var item = await Get.toNamed(RouteConfig.selectItem);
    if (item != null) todo.item = item;
    update();
  }

  addAction() async {
    if (todo.item == null) {
      Fluttertoast.showToast(msg: '请选择事项');
      return;
    }

    todo.name ??= todo.item!.name;
    var db = Get.find<ApplicationController>().db;
    await db.insert(Todo.keyClassName, todo.toMap());
    Get.back(result: todo);
  }

  selectItem(Item? item) {
    if (item == null) return;
    todo.item = item;
    update();
  }
}
