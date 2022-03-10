import 'package:flutter/material.dart';
import 'package:frequency/database/sub.dart';
import 'package:frequency/provider/item_detail_provider.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../utils/color_utils.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({Key? key}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  List<Widget> grids(Sub sub) {
    var firstTime =
        Jiffy(sub.todos.isNotEmpty ? sub.todos.first.time! : DateTime.now());
    firstTime = Jiffy([firstTime.year, firstTime.month, 1]);
    var lastTime =
        Jiffy(sub.todos.isNotEmpty ? sub.todos.last.time! : DateTime.now());
    lastTime = Jiffy([lastTime.year, lastTime.month, 1]);
    List<Widget> grids = [];
    lastTime.add(months: 1);
    while (firstTime.isBefore(lastTime)) {
      var item = sub.item;
      var selectDates = sub.todos.map((e) => e.time!);
      var initDate = firstTime.dateTime;
      var grid = InkWell(
        onTap: () {
          context.read<ItemDetailProvider>().pushTodoDetails(context, initDate);
        },
        child: Hero(
          tag: '${item.id!}${firstTime.year}${firstTime.month}',
          child: Card(
            elevation: 5,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: IgnorePointer(
                      child: SfCalendar(
                        initialDisplayDate: firstTime.dateTime,
                        view: CalendarView.month,
                        viewHeaderHeight: 0,
                        headerStyle: const CalendarHeaderStyle(
                            textStyle: TextStyle(fontSize: 12)),
                        monthCellBuilder: (context, details) {
                          var isSelectDay = selectDates.contains(details.date);

                          var displayDate = details.visibleDates[7];

                          var textColor =
                              details.date.month == displayDate.month
                                  ? Theme.of(context).textTheme.bodyLarge?.color
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color
                                      ?.withOpacity(0.5);
                          // if (isSelectDay &&
                          //     details.date.month == displayDate.month) {
                          //   textColor = Colors.white;
                          // }

                          return CircleAvatar(
                            backgroundColor: isSelectDay &&
                                    details.date.month == displayDate.month
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
                ],
              ),
            ),
          ),
        ),
      );
      grids.add(grid);
      firstTime.add(months: 1);
    }
    return grids;
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ItemDetailProvider>();
    var sub = provider.sub;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(sub.item.name ?? ''),
            floating: true,
            snap: false,
            pinned: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(sub.item.note ?? '没有描述',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1 //const TextStyle(fontSize: 15, color: Theme.of(context).textTheme.titleLarge?.color),
                      ),
                ),
              ),
            ),
          ),
          SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver:
                  SliverGrid.count(crossAxisCount: 2, children: grids(sub))),
        ],
      ),
    );
  }
}
