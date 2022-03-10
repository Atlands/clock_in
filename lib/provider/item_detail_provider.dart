import 'package:flutter/cupertino.dart';
import 'package:frequency/database/sub.dart';
import 'package:frequency/page/todo_detail.dart';
import 'package:frequency/provider/todo_detail_provider.dart';
import 'package:provider/provider.dart';

import '../database/item.dart';

class ItemDetailProvider extends ChangeNotifier {
  Sub sub;
  ItemDetailProvider(this.sub);

  pushTodoDetails(BuildContext context, DateTime initDate) {
    Navigator.push(context,
        PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) {
      return FadeTransition(
        opacity: animation,
        child: ChangeNotifierProvider(
          create: (_) => TodoDetailProvider(sub, initDate),
          child: const TodoDetail(),
        ),
      );
    }));
  }
}
