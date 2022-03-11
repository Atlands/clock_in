import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frequency/provider/application_provider.dart';
import 'package:provider/provider.dart';

import '../database/item.dart';

class EditItemProvider extends ChangeNotifier {
  Item item;
  EditItemProvider(this.item);

  updateAction(BuildContext context) async {
    if (item.name == null || item.color == null) {
      Fluttertoast.showToast(msg: '名称/颜色不能为空');
      return;
    }
    var db = context.read<ApplicationProvider>().db;
    item.id = await db.update(Item.keyClassName, item.toMap(),
        where: '${Item.keyId} = ?', whereArgs: [item.id]);
    Navigator.pop(context);
  }
}
