import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frequency/database/todo.dart';
import 'package:frequency/provider/application_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../database/item.dart';
import '../../page/item/select_item.dart';
import '../item/select_item_provider.dart';

class AddTodoProvider extends ChangeNotifier {
  CalendarController calendarController = CalendarController()
    ..selectedDate = DateTime.now();
  Todo todo = Todo()
    ..time =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  pushSelectItem(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) =>
                SelectItemProvider(context.read<ApplicationProvider>().db),
            child: const SelectItem(),
          ),
        )).then((value) => selectItem(value));
  }

  addAction(BuildContext context) async {
    if (todo.item == null) {
      Fluttertoast.showToast(msg: '请选择事项');
      return;
    }

    todo.name ??= todo.item!.name;
    var db = context.read<ApplicationProvider>().db;
    await db.insert(Todo.keyClassName, todo.toMap());
    Navigator.pop(context);
  }

  selectItem(Item? item) {
    if (item == null) return;
    todo.item = item;
    notifyListeners();
  }
}
