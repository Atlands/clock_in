import 'package:flutter/material.dart';
import 'package:frequency/provider/home_provider.dart';
import 'package:frequency/utils/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<HomeProvider>().queryData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<HomeProvider>();
    var subs = provider.subs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequency'),
        actions: [
          IconButton(
              onPressed: () {
                context.read<HomeProvider>().pushSetting(context);
              },
              icon: const Icon(Icons.settings_outlined))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<HomeProvider>().pushAddTodo(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      body: Stack(
        children: [
          if (subs.isEmpty)
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.date_range_outlined,
                  size: 150,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Text('没有记录',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.grey.withOpacity(0.5),
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 100)
              ],
            )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    crossAxisCount: 2,
                    childAspectRatio: 0.9),
                itemCount: subs.length,
                itemBuilder: (context, index) {
                  var sub = subs[index];
                  var item = sub.item;
                  var selectDates = sub.todos.map((e) => e.time!);
                  var maxDate = selectDates.isNotEmpty
                      ? selectDates.last
                      : DateTime.now();

                  return Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14))),
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(14)),
                      onTap: () {
                        context
                            .read<HomeProvider>()
                            .pushItemDetails(context, sub);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: IgnorePointer(
                                child: SfCalendar(
                                  maxDate: maxDate,
                                  view: CalendarView.month,
                                  viewHeaderHeight: 0,
                                  headerStyle: const CalendarHeaderStyle(
                                      textStyle: TextStyle(fontSize: 12)),
                                  monthCellBuilder: (context, details) {
                                    var isSelectDay =
                                        selectDates.contains(details.date);

                                    var displayDate = details.visibleDates[7];

                                    var textColor =
                                        details.date.month == displayDate.month
                                            ? Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color
                                            : Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color
                                                ?.withOpacity(0.5);

                                    return CircleAvatar(
                                      backgroundColor: isSelectDay
                                          ? HexColor(item.color!)
                                          : Colors.transparent,
                                      child: Text(
                                        details.date.day.toString(),
                                        style: TextStyle(
                                            color: textColor, fontSize: 10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const Divider(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
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
                }),
          ),
        ],
      ),
    );
  }
}
