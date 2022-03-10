class Item {
  static const keyClassName = 'Item';
  static const keyId = 'id';
  static const keyName = 'name';
  static const keyNote = 'note';
  static const keyColor = 'color';
  int? id;
  String? name;
  String? note;
  String? color;

  Item();

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {keyName: name, keyNote: note, keyColor: color};
    if (id != null) {
      map[keyId] = id;
    }
    return map;
  }

  Item.fromMap(Map map) {
    id = map[keyId];
    name = map[keyName];
    note = map[keyNote];
    color = map[keyColor];
  }
}
