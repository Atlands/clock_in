import 'item.dart';

class Todo {
  static const keyClassName = 'Todo';
  static const keyId = 'id';
  static const keyItemId = 'itemId';
  static const keyName = 'name';
  static const keyTime = 'time';

  static const createTodoSql = '''
      create table $keyClassName(
        $keyId integer primary key autoincrement,
        $keyName text not null,
        $keyItemId integer not null,
        $keyTime text not null
      )
    ''';

  int? id;
  Item? item;
  String? name;
  DateTime? time;

  Todo();

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      keyItemId: item?.id,
      keyName: name,
      keyTime: time?.toIso8601String()
    };
    if (id != null) {
      map[keyId] = id;
    }
    return map;
  }

  Todo.fromMap(Map map) {
    id = map[keyId];
    item = Item()..id = map[keyItemId];
    name = map[keyName];
    time = DateTime.tryParse(map[keyTime]) ?? DateTime.now();
  }
}
