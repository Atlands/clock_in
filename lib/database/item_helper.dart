import 'package:frequency/database/item.dart';
import 'package:sqflite/sqflite.dart';

class ItemHelper {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table ${Item.keyClassName} ( 
  ${Item.keyId} text primary key autoincrement, 
  ${Item.keyName} text not null,
  ${Item.keyNote} text,
  ${Item.keyColor} text not null)
''');
    });
  }

  Future<Item> insert(Item item) async {
    item.id = await db.insert(Item.keyClassName, item.toMap());
    return item;
  }

  Future<Item?> getTodo(int id) async {
    List<Map> maps = await db.query(Item.keyClassName,
        // columns: [columnId, columnDone, columnTitle],
        where: '${Item.keyId} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Item.fromMap(maps.first as Map<String, Object?>);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(Item.keyClassName, where: '${Item.keyId} = ?', whereArgs: [id]);
  }

  Future<int> update(Item todo) async {
    return await db.update(Item.keyClassName, todo.toMap(),
        where: '${Item.keyId} = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}
