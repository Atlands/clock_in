import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frequency/database/sub.dart';
import 'package:frequency/database/todo.dart';
import 'package:frequency/page/item_detail.dart';
import 'package:frequency/provider/application_provider.dart';
import 'package:frequency/provider/item_detail_provider.dart';
import 'package:provider/provider.dart';

import '../database/item.dart';
import '../page/todo/add_todo.dart';
import 'add_todo_provider.dart';

class HomeProvider extends ChangeNotifier {
  List<Sub> subs = [];

  HomeProvider(BuildContext context) {
    queryData(context);
  }

  pushAddTodo(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => AddTodoProvider(),
            child: const AddTodo(),
          ),
        )).then((value) => queryData(context));
  }

  pushItemDetails(BuildContext context, Sub sub) {
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => ChangeNotifierProvider(
    //               create: (_) => ItemDetailProvider(sub),
    //               child: const ItemDetail(),
    //             )));
    Navigator.push(context,
        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return FadeTransition(
        opacity: animation,
        child: ChangeNotifierProvider(
          create: (_) => ItemDetailProvider(sub),
          child: const ItemDetail(),
        ),
      );
    })).then((value) => queryData(context));
  }

  queryData(BuildContext context) async {
    subs.clear();
    var db = context.read<ApplicationProvider>().db;
    var maps = await db.query(Item.keyClassName);
    var items = maps.map((e) => Item.fromMap(e));
    for (var item in items) {
      db
          .query(Todo.keyClassName,
              where: '${Todo.keyItemId} = ?',
              whereArgs: [item.id],
              orderBy: Todo.keyTime)
          .then((value) {
        subs.add(
            Sub(item: item, todos: value.map((e) => Todo.fromMap(e)).toList()));
        notifyListeners();
      });
    }
  }
}
