import 'package:flutter/material.dart';
import 'package:frequency/database/sub.dart';
import 'package:frequency/provider/application_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../database/todo.dart';

class TodoDetailProvider extends ChangeNotifier {
  Sub sub;
  DateTime initDate;
  List<Todo> todos = [];
  TodoDetailProvider(this.sub, this.initDate);

  deleteTodo(BuildContext context, int index) async {
    var todo = todos[index];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('删除了${Jiffy(todo.time).format('dd')}日事件'),
        duration: const Duration(milliseconds: 500),
      ),
    );

    var db = context.read<ApplicationProvider>().db;
    await db.delete(Todo.keyClassName,
        where: '${Todo.keyId} = ?', whereArgs: [todos[index].id]);
    todos.removeAt(index);
    sub.todos.removeWhere((element) => element.id == todo.id);
    notifyListeners();
  }

  viewChanged(DateTime time) async {
    Future.delayed(Duration.zero, () async {
      todos = sub.todos
          .where((element) =>
              element.time!.year == time.year &&
              element.time!.month == time.month)
          .toList();
      todos.sort(
        (a, b) => a.time!.compareTo(b.time!),
      );
      notifyListeners();
    });
  }
}
