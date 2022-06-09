import 'package:flutter/material.dart';
import 'package:frequency/widget/calendar_card_cell.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

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
              onPressed: () => logic.pushSetting(),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              Jiffy().format('今天，yyyy年M月dd日，EE'),
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: calendarList(),
          ),
        ],
      ),
    );
  }

  Widget calendarList() {
    return GetBuilder<HomeLogic>(builder: (logic) {
            return logic.items.isEmpty
                ? const EmptyView()
                : GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 50),
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
                    });
          });
  }
}
