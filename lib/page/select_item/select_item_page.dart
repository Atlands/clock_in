import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color_utils.dart';
import 'select_item_logic.dart';

class SelectItemPage extends StatelessWidget {
  final logic = Get.put(SelectItemLogic());

  SelectItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var provider = context.watch<SelectItemProvider>();
    // var items = provider.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择事项'),
        actions: [
          IconButton(
              onPressed: () {
                logic.pushAddItem();
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: GetBuilder<SelectItemLogic>(builder: (logic) {
        var items = logic.items;
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: items.length,
          itemBuilder: (context, index) {
            var item = items[index];
            return Card(
              elevation: 10,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              color: HexColor(item.color ?? '#ffffff'),
              child: ListTile(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14))),
                title: Text(item.name!),
                subtitle: Text(
                  item.note ?? '',
                ),
                onTap: () {
                  // context.read<SelectItemProvider>().selectItem(context, item);
                  logic.selectItem(item);
                },
              ),
            );
          },
        );
      }),
    );
  }
}
