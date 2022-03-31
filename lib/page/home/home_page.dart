import 'package:flutter/material.dart';
import 'package:frequency/widget/calendar_card_cell.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../database/item.dart';
import '../../utils/color_utils.dart';
import '../empty_view.dart';
import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.put(HomeLogic());

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var provider = context.watch<HomeProvider>();
    // var subs = provider.subs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequency'),
        actions: [
          IconButton(
              onPressed: () {
                // context.read<HomeProvider>().pushSetting(context);
                logic.pushSetting();
              },
              icon: const Icon(Icons.settings_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.read<HomeProvider>().pushAddTodo(context);
          logic.pushAddTodo();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Jiffy().format('今天，yyyy年M月dd日，EE'),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GetBuilder<HomeLogic>(builder: (logic) {
                // final subs = logic.subs;
                return logic.items.isEmpty
                    ? const EmptyView()
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 220),
                        itemCount: logic.items.length,
                        itemBuilder: (context, index) {
                          var item = logic.items[index];
                          var selectDates = logic.todos
                              .where((element) => element.item!.id == item.id)
                              .map((e) => e.time!)
                              .toList();
                          var initDate = selectDates.isNotEmpty
                              ? selectDates.last
                              : DateTime.now();
                          return CalendarCardCell(
                            initDate: initDate,
                            selectDates: selectDates,
                            item: item,
                            showItem: true,
                            onSelected: () => logic.pushItemDetails(item),
                          );
                          // return CalendarCard(
                          //     item: item,
                          //     dates: logic.itemDates(item),
                          //     onSelected: () => logic.pushItemDetails(item));
                        });
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarCard extends StatelessWidget {
  const CalendarCard(
      {Key? key,
      required this.item,
      required this.dates,
      required this.onSelected})
      : super(key: key);

  DateTime get _maxDate => dates.isNotEmpty ? dates.last : DateTime.now();
  final List<DateTime> dates;
  final Item item;
  final Function() onSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        onTap: onSelected,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: IgnorePointer(
                  child: SfCalendar(
                    maxDate: _maxDate,
                    view: CalendarView.month,
                    viewHeaderHeight: 0,
                    headerStyle: const CalendarHeaderStyle(
                        textStyle: TextStyle(fontSize: 12)),
                    monthCellBuilder: (context, details) {
                      var isSelectDay = dates.contains(details.date);

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

                      return CircleAvatar(
                        backgroundColor: isSelectDay
                            ? HexColor(item.color!)
                            : Colors.transparent,
                        child: Text(
                          details.date.day.toString(),
                          style: TextStyle(color: textColor, fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  item.name!,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
