import 'dart:developer';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:frequency/utils/color_utils.dart';
import 'package:frequency/database/todo.dart';
import 'package:frequency/provider/add_todo_provider.dart';
import 'package:frequency/provider/application_provider.dart';
import 'package:frequency/provider/select_item_provider.dart';
import 'package:frequency/page/item/select_item.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AddTodoProvider>();
    var todo = provider.todo;
    return Scaffold(
      appBar: AppBar(title: const Text('添加事项')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AddTodoProvider>().addAction(context);
        },
        tooltip: 'Add',
        child: const Icon(Icons.done),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            calendarView(context),
            itemView(context),
            Card(
              elevation: 10,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  maxLines: 5,
                  decoration: const InputDecoration(hintText: '备注'),
                  onChanged: (value) {
                    todo.name = value;
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Card calendarView(BuildContext context) {
    var provider = context.watch<AddTodoProvider>();
    var todo = provider.todo;
    return Card(
      elevation: 10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SfCalendar(
              showNavigationArrow: true,
              showDatePickerButton: true,
              view: CalendarView.month,
              controller: provider.calendarController,
              initialSelectedDate: DateTime.now(),
              selectionDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    color: const Color.fromARGB(255, 68, 140, 255), width: 2),
                shape: BoxShape.circle,
              ),
              cellEndPadding: 0,
              monthCellBuilder: (context, details) {
                var today = DateTime.now();
                today = DateTime(today.year, today.month, today.day);
                var isToday = details.date == today;

                var displayDate = details.visibleDates[7];

                var textColor = details.date.month == displayDate.month
                    ? Theme.of(context).textTheme.bodyLarge?.color
                    : Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                        ?.withOpacity(0.5);
                // if (isToday) textColor = Colors.white;

                return CircleAvatar(
                  backgroundColor: isToday
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  child: Text(
                    details.date.day.toString(),
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.bold),
                  ),
                );
              },
              onSelectionChanged: (details) {
                setState(() {
                  todo.time = details.date;
                });
              },
            ),
            const Divider(
              color: Colors.grey,
            ),
            Text(formatDate(todo.time!, [yyyy, '-', mm, '-', dd, ' ', DD]))
          ],
        ),
      ),
    );
  }

  Card itemView(BuildContext context) {
    var provider = context.watch<AddTodoProvider>();
    var item = provider.todo.item;
    return Card(
      elevation: 10,
      // color: HexColor(item?.color ?? ''),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Ink(
        child: InkWell(
          onTap: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) => SelectItemProvider(
                            context.read<ApplicationProvider>().db),
                        child: const SelectItem(),
                      ),
                    ))
                .then((value) =>
                    context.read<AddTodoProvider>().selectItem(value));
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text(
                  '事项',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (item != null)
                  SizedBox(
                    height: 25,
                    width: 25,
                    child: CircleAvatar(
                      backgroundColor: HexColor(item.color ?? ''),
                    ),
                  ),
                const SizedBox(width: 10),
                Text(item?.name ?? ''),
                const Icon(Icons.navigate_next),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
