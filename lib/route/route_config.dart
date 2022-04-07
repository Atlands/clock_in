import 'package:frequency/page/add_item/add_item_page.dart';
import 'package:frequency/page/add_todo/add_todo_page.dart';
import 'package:frequency/page/backup/backup_page.dart';
import 'package:frequency/page/home/home_page.dart';
import 'package:frequency/page/item_detail/item_detail_page.dart';
import 'package:frequency/page/select_item/select_item_page.dart';
import 'package:frequency/page/setting/setting_page.dart';
import 'package:frequency/page/todo_detail/todo_detail_page.dart';
import 'package:get/get.dart';

class RouteConfig {
  static const String main = '/';
  static const String home = '/home';
  static const String itemDetail = '/item_detail';
  static const String editItem = '/edit_item';
  static const String addTodo = '/add_todo';
  // static const String editTodo = '/edit_todo';
  static const String addItem = '/add_item';
  static const String todoDetail = '/todo_detail';
  static const String selectItem = '/select_item';
  static const String setting = '/setting';
  static const String backup = '/backup';

  static final List<GetPage> getPages = [
    GetPage(name: home, page: () => HomePage()),
    GetPage(name: addTodo, page: () => AddTodoPage()),
    // GetPage(name: editTodo, page: () => AddTodoPage()),
    GetPage(name: selectItem, page: () => SelectItemPage()),
    GetPage(name: addItem, page: () => AddItemPage()),
    GetPage(name: editItem, page: () => AddItemPage()),
    GetPage(name: setting, page: () => SettingPage()),
    GetPage(name: itemDetail, page: () => ItemDetailPage()),
    GetPage(name: todoDetail, page: () => TodoDetailPage()),
    GetPage(name: backup, page: () => BackupPage()),
  ];
}
