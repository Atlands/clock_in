import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../utils/color_utils.dart';
import 'todo_detail_logic.dart';

class TodoDetailPage extends StatelessWidget {
  final logic = Get.put(TodoDetailLogic());

  TodoDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: GetBuilder<TodoDetailLogic>(
              id: 'item',
              builder: (logic) {
                return Text(logic.item.name ?? '详情');
              })),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            calendarView(),
            todoListView(),
          ],
        ),
      ),
    );
  }

  Widget todoListView() {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        child: GetBuilder<TodoDetailLogic>(
            id: 'todo_list',
            builder: (logic) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemCount: logic.showTodos.length,
                itemBuilder: (context, index) {
                  var todo = logic.showTodos[index];
                  return InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                    onTap: () => logic.showEditTodoDialog(todo),
                    child: SlidableAutoCloseBehavior(
                      closeWhenOpened: true,
                      child: Slidable(
                        endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: 0.3,
                            children: [
                              SlidableAction(
                                onPressed: (_) =>
                                    logic.showEditTodoDialog(todo),
                                icon: Icons.edit,
                                backgroundColor: Colors.blue,
                              ),
                              SlidableAction(
                                onPressed: (_) => logic.deleteTodo(todo),
                                icon: Icons.delete,
                                backgroundColor: Colors.red,
                              ),
                            ]),
                        child: ListTile(
                          title: Text(todo.name ?? ''),
                          leading: CircleAvatar(
                            backgroundColor: HexColor(logic.item.color!),
                            child: Text(
                              todo.time!.day.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }

  Widget calendarView() {
    return GetBuilder<TodoDetailLogic>(
        id: 'todo_list',
        builder: (logic) {
          var selectDates = logic.todos.map((e) => e.time!);
          return Hero(
            tag:
                '${logic.item.id!}${logic.initDate.year}${logic.initDate.month}',
            child: Card(
              elevation: 10,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SfCalendar(
                    view: CalendarView.month,
                    showNavigationArrow: true,
                    initialDisplayDate: logic.initDate,
                    selectionDecoration:
                        const BoxDecoration(color: Colors.transparent),
                    onViewChanged: (details) =>
                        logic.viewChanged(details.visibleDates[8]),
                    monthCellBuilder: (context, details) {
                      var isSelectDay = selectDates.contains(details.date);

                      var displayDate = details.visibleDates[7];

                      var textColor = details.date.month == displayDate.month
                          ? Theme.of(context).textTheme.bodyLarge?.color
                          : Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.color
                              ?.withOpacity(0.5);
                      if (isSelectDay &&
                          details.date.month == displayDate.month) {
                        textColor = Colors.white;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: CircleAvatar(
                          backgroundColor: isSelectDay &&
                                  details.date.month == displayDate.month
                              ? HexColor(logic.item.color!)
                              : Colors.transparent,
                          child: Text(
                            details.date.day.toString(),
                            style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          );
        });
  }
}
