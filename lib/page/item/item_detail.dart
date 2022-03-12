import 'package:flutter/material.dart';
import 'package:frequency/provider/item/item_detail_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../utils/color_utils.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({Key? key}) : super(key: key);

  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<ItemDetailProvider>();
    var sub = provider.sub;

    return Scaffold(
      body: CustomScrollView(
        controller: provider.scrollController,
        slivers: [
          SliverAppBar(
            title: Text(sub.item.name ?? ''),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    context.read<ItemDetailProvider>().pushEditItem(context);
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    context
                        .read<ItemDetailProvider>()
                        .showDeleteDialog(context);
                  },
                  icon: const Icon(Icons.delete))
            ],
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
                      style: Theme.of(context).textTheme.bodyText1),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
            sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                    ((context, index) => cardBuilder(context, index)),
                    childCount: provider.initTimes.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2)),
          ),
        ],
      ),
    );
  }

  cardBuilder(BuildContext context, int index) {
    var provider = context.watch<ItemDetailProvider>();
    var sub = provider.sub;
    var initDate = provider.initTimes[index].dateTime;
    var item = sub.item;
    var selectDates = sub.todos
        .where(((element) => element.time?.month == initDate.month))
        .map((e) => e.time)
        .toList();
    return Hero(
      tag: '${item.id!}${initDate.year}${initDate.month}',
      child: Card(
        elevation: 5,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          onTap: () {
            context
                .read<ItemDetailProvider>()
                .pushTodoDetails(context, initDate);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: IgnorePointer(
                        child: SfCalendar(
                          initialDisplayDate: initDate,
                          maxDate: initDate.add(const Duration(days: 1)),
                          minDate: initDate,
                          view: CalendarView.month,
                          viewHeaderHeight: 0,
                          headerStyle: const CalendarHeaderStyle(
                              textStyle: TextStyle(fontSize: 12)),
                          monthCellBuilder: (context, details) {
                            var isSelectDay =
                                selectDates.contains(details.date);
                            //provider.selectDates.contains(details.date);

                            var displayDate = details.visibleDates[7];

                            var textColor = details.date.month ==
                                    displayDate.month
                                ? Theme.of(context).textTheme.bodyLarge?.color
                                : Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color
                                    ?.withOpacity(0.5);

                            return CircleAvatar(
                              backgroundColor: isSelectDay &&
                                      details.date.month == displayDate.month
                                  ? HexColor(item.color!)
                                  : Colors.transparent,
                              child: Text(
                                details.date.day.toString(),
                                style:
                                    TextStyle(color: textColor, fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // Text('${selectDates.length} 次/月',style: TextStyle(color: ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
