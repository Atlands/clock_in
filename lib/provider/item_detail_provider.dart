import 'package:flutter/material.dart';
import 'package:frequency/database/item.dart';
import 'package:frequency/database/sub.dart';
import 'package:frequency/database/todo.dart';
import 'package:frequency/page/item/edit_item.dart';
import 'package:frequency/page/todo/todo_detail.dart';
import 'package:frequency/provider/edit_item_provider.dart';
import 'package:frequency/provider/todo_detail_provider.dart';
import 'package:frequency/utils/common_dialog.dart';
import 'package:provider/provider.dart';

import 'application_provider.dart';

class ItemDetailProvider extends ChangeNotifier {
  Sub sub;
  ItemDetailProvider(this.sub);

  _deleteItem(BuildContext context) async {
    showLoadingDialog(context);
    var db = context.read<ApplicationProvider>().db;

    await db.delete(Item.keyClassName,
        where: '${Item.keyId} = ?', whereArgs: [sub.item.id]);
    await db.delete(Todo.keyClassName,
        where: '${Todo.keyItemId} = ?', whereArgs: [sub.item.id]);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  showDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
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
                    Navigator.pop(context);
                    _deleteItem(context);
                  },
                  child: const Text('确定'))
            ],
          );
        });
  }

  pushEditItem(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (_) => EditItemProvider(sub.item),
                  child: const EditItem(),
                ))).then((value) {
      notifyListeners();
    });
  }

  pushTodoDetails(BuildContext context, DateTime initDate) {
    // Navigator.push(context,
    //     PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
    //   return FadeTransition(
    //     opacity: animation,
    //     child: ChangeNotifierProvider(
    //       create: (_) => TodoDetailProvider(sub, initDate),
    //       child: const TodoDetail(),
    //     ),
    //   );
    // }));

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                  create: (_) => TodoDetailProvider(sub, initDate),
                  child: const TodoDetail(),
                )));
  }
}
