import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frequency/database/item.dart';
import 'package:frequency/provider/application_provider.dart';
import 'package:provider/provider.dart';

class AddItemProvider extends ChangeNotifier {
  var item = Item();

  addAction(BuildContext context) async {
    if (item.name == null || item.color == null) {
      Fluttertoast.showToast(msg: '名称/颜色不能为空');
      return;
    }
    var db = context.read<ApplicationProvider>().db;
    item.id = await db.insert(Item.keyClassName, item.toMap());
    Navigator.pop(context, item);
  }
}
