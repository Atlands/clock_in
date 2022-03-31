import 'package:flutter/material.dart';
import 'package:frequency/page/empty_view.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../../widget/calendar_card_cell.dart';
import 'item_detail_logic.dart';

class ItemDetailPage extends StatelessWidget {
  final logic = Get.put(ItemDetailLogic());

  ItemDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: logic.scrollController,
        slivers: [
          SliverAppBar(
            title: GetBuilder<ItemDetailLogic>(
                id: 'item_detail',
                builder: (logic) {
                  return Text(logic.item.name ?? '');
                }),
            actions: [
              IconButton(
                  onPressed: logic.pushEditItem,
                  icon: const Icon(Icons.edit_outlined)),
              IconButton(
                  onPressed: logic.showDeleteDialog,
                  icon: const Icon(Icons.delete_outline))
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
                  child: GetBuilder<ItemDetailLogic>(
                      id: 'item_detail',
                      builder: (logic) {
                        return Text(logic.item.note ?? '没有描述',
                            style: Theme.of(context).textTheme.bodyText1);
                      }),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: GetBuilder<ItemDetailLogic>(
                id: 'todo_calendar_list',
                builder: (logic) {
                  return SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      ((context, index) => cardBuilder(context, index)),
                      childCount: logic.item.id == null ? 0 : logic.gridCount,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            mainAxisExtent: 180,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                  );
                }),
          ),
        ],
      ),
    );
  }

  cardBuilder(BuildContext context, int index) {
    var item = logic.item;
    var initDate =
        logic.todos.isNotEmpty ? logic.todos.first.time! : DateTime.now();
    initDate = Jiffy(initDate).add(months: index).dateTime;

    var selectDates = logic.todos
        .where((element) =>
            element.time!.year == initDate.year &&
            element.time!.month == initDate.month)
        .map((e) => e.time!)
        .toList();

    return Hero(
        tag: '${item.id}${initDate.year}${initDate.month}',
        child: CalendarCardCell(
          initDate: initDate,
          selectDates: selectDates,
          item: logic.item,
          onSelected: () => logic.pushTodoDetails(initDate),
        ));
  }
}
