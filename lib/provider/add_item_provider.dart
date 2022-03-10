import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frequency/database/item.dart';
import 'package:frequency/provider/application_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class AddItemProvider extends ChangeNotifier {
  var colorValues = [
    'CC9999',
    'FF6666',
    '99CC99',
    '99CC33',
    '9933CC',
    'CCFF99',
    'CC3399',
    '666633'
  ];

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
