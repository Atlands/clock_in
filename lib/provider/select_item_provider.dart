import 'package:flutter/cupertino.dart';
import 'package:frequency/database/item.dart';
import 'package:sqflite/sqflite.dart';

class SelectItemProvider extends ChangeNotifier {
  List<Item> items = [];
  Database db;
  SelectItemProvider(this.db) {
    _queryAll();
  }

  selectItem(BuildContext context, Item item) {
    Navigator.pop(context, item);
  }

  addItem(Item? item) async {
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
