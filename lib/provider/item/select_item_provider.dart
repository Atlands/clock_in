import 'package:flutter/material.dart';
import 'package:frequency/database/item.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../page/item/add_item.dart';
import 'add_item_provider.dart';

class SelectItemProvider extends ChangeNotifier {
  List<Item> items = [];
  Database db;
  SelectItemProvider(this.db) {
    _queryAll();
  }

  pushAddItem(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (_) => AddItemProvider(),
                  child: const AddItem(),
                ))).then((value) => _addItem(value));
  }

  selectItem(BuildContext context, Item item) {
    Navigator.pop(context, item);
  }

  _addItem(Item? item) async {
    if (item == null) return;
    items.add(item);
    notifyListeners();
  }

  _queryAll() async {
    List<Map<String, Object?>> maps = await db.query(Item.keyClassName);
    items = maps.map((e) => Item.fromMap(e)).toList();
    notifyListeners();
  }
}
