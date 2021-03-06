import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../database/item.dart';
import '../utils/color_utils.dart';

class CalendarCardCell extends StatelessWidget {
  const CalendarCardCell(
      {Key? key,
      required this.initDate,
      required this.selectDates,
      required this.item,
      this.showItem = false,
      this.onSelected})
      : super(key: key);

  final List<DateTime> selectDates;
  final Item item;
  final DateTime initDate;
  final bool showItem;
  final Function()? onSelected;

  List<DateTime> get _dates {
    var maxDate = DateTime(initDate.year, initDate.month + 1, 0);

    var dates = List.generate(maxDate.day,
        (index) => DateTime(initDate.year, initDate.month, index + 1));
    var before = dates.first.weekday == 7 ? 0 : dates.first.weekday;
    while (before > 0) {
      dates.insert(0, dates.first.add(const Duration(days: -1)));
      before--;
    }
    while (dates.length < 7 * 6) {
      dates.add(dates.last.add(const Duration(days: 1)));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(context.findRenderObject()?.constraints.toString());
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        padding: const EdgeInsets.all(8.0),
        primary: Get.theme.cardColor,
        onPrimary: HexColor(item.color!),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
      ),
      onPressed: onSelected,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              Jiffy(initDate).yMMM,
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                  fontSize: 12),
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(builder: (context, constraints) {
            // debugPrint(constraints.maxWidth.toString());
            return Wrap(
              spacing: 2,
              runSpacing: 2,
              children: [
                ..._dates.map((date) {
                  // var date = _dates[index];
                  var isSelectDay = selectDates.contains(date);

                  var textColor = date.month == initDate.month
                      ? Theme.of(context).textTheme.bodyLarge?.color
                      : Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.color
                          ?.withOpacity(0.5);

                  if (isSelectDay && date.month == initDate.month) {
                    textColor = Colors.white;
                  }
                  return SizedBox(
                    width: constraints.maxWidth / 7 - 2,
                    height: constraints.maxWidth / 7 - 2,
                    child: CircleAvatar(
                      backgroundColor:
                          isSelectDay && date.month == initDate.month
                              ? HexColor(item.color!)
                              : Colors.transparent,
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: textColor, fontSize: 10),
                      ),
                    ),
                  );
                })
              ],
            );
          }),
          if (showItem) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                item.name!,
                style: const TextStyle(fontSize: 18),
                maxLines: 1,
              ),
            )
          ]
        ],
      ),
    );
  }
}
