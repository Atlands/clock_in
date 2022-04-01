import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../utils/color_utils.dart';
import 'add_todo_logic.dart';

class AddTodoPage extends StatelessWidget {
  final logic = Get.put(AddTodoLogic());

  AddTodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('添加记录')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logic.addAction();
        },
        tooltip: 'Add',
        child: const Icon(Icons.done),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            calendarView(),
            itemView(),
            Card(
              elevation: 10,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GetBuilder<AddTodoLogic>(
                  assignId: true,
                  builder: (logic) {
                    return TextField(
                      maxLines: 5,
                      decoration: const InputDecoration(hintText: '备注'),
                      onChanged: (value) {
                        logic.todo.name = value;
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Card calendarView() {
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
              controller: logic.calendarController,
              selectionDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                    color: const Color.fromARGB(255, 68, 140, 255), width: 2),
                shape: BoxShape.circle,
              ),
              cellEndPadding: 0,
              monthCellBuilder: (context, details) {
                // var context = Get.context!;
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
                if (isToday) textColor = Colors.white;

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
              onSelectionChanged: logic.onSelectionChanged,
            ),
            const Divider(
              color: Colors.grey,
            ),
            GetBuilder<AddTodoLogic>(
                // tag: 'date',
                builder: (logic) {
              return Text(Jiffy(logic.todo.time).yMMMEd);
            })
          ],
        ),
      ),
    );
  }

  Card itemView() {
    return Card(
      elevation: 10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        onTap: () {
          logic.pushSelectItem();
        },
        child: GetBuilder<AddTodoLogic>(builder: (logic) {
          var item = logic.todo.item;
          // return Container();
          return Padding(
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
                      backgroundColor: HexColor(item.color ?? 'ffffff'),
                    ),
                  ),
                const SizedBox(width: 10),
                 Container(
                   constraints:const BoxConstraints(maxWidth: 100),
                    child: Text(
                  item?.name ?? '',
                  maxLines: 1,
                )),
                const Icon(Icons.navigate_next),
              ],
            ),
          );
        }),
      ),
    );
  }
}
