import 'package:flutter/material.dart';
import 'package:frequency/database/item.dart';
import 'package:frequency/database/sub.dart';
import 'package:frequency/database/todo.dart';
import 'package:frequency/provider/todo_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../utils/color_utils.dart';

class TodoDetail extends StatefulWidget {
  const TodoDetail({Key? key}) : super(key: key);

  @override
  _TodoDetailState createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    // var provider = context.read<TodoDetailProvider>();
    // provider.viewChanged(provider.initDate);
    // });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<TodoDetailProvider>();
    var sub = provider.sub;
    var item = sub.item;
    var selectDates = sub.todos.map((e) => e.time!);
    return Scaffold(
      appBar: AppBar(title: Text(item.name ?? '')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            calendarView(item, provider, selectDates),
            todoLIstView(provider, item),
          ],
        ),
      ),
    );
  }

  Expanded todoLIstView(TodoDetailProvider provider, Item item) {
    return Expanded(
      child: ListView.builder(
        itemCount: provider.todos.length,
        itemBuilder: (context, index) {
          var todo = provider.todos[index];
          return Dismissible(
            key: Key('${todo.id}'),
            background:
                const ListTile(trailing: Icon(Icons.delete, color: Colors.red)),
            onDismissed: (direction) {
              context.read<TodoDetailProvider>().deleteTodo(context, index);
            },
            child: Card(
              elevation: 5,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: ListTile(
                title: Text(todo.name ?? ''),
                leading: CircleAvatar(
                  backgroundColor: HexColor(item.color!),
                  child: Text(
                    todo.time!.day.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Hero calendarView(
      Item item, TodoDetailProvider provider, Iterable<DateTime> selectDates) {
    return Hero(
      tag: '${item.id!}${provider.initDate.year}${provider.initDate.month}',
      child: Card(
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SfCalendar(
              view: CalendarView.month,
              showNavigationArrow: true,
              initialDisplayDate: provider.initDate,
              selectionDecoration:
                  const BoxDecoration(color: Colors.transparent),
              onViewChanged: (details) {
                context
                    .read<TodoDetailProvider>()
                    .viewChanged(details.visibleDates[8]);
              },
              monthCellBuilder: (context, details) {
                var isSelectDay = selectDates.contains(details.date);

                var displayDate = details.visibleDates[7];

                var textColor = details.date.month == displayDate.month
                    ? Colors.black
                    : Colors.grey;
                if (isSelectDay && details.date.month == displayDate.month) {
                  textColor = Colors.white;
                }

                return CircleAvatar(
                  backgroundColor:
                      isSelectDay && details.date.month == displayDate.month
                          ? HexColor(item.color!)
                          : Colors.transparent,
                  child: Text(
                    details.date.day.toString(),
                    style: TextStyle(color: textColor, fontSize: 15),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
