import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/color_utils.dart';
import 'add_item_logic.dart';

class AddItemPage extends StatelessWidget {
  final logic = Get.put(AddItemLogic());

  AddItemPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: GetBuilder<AddItemLogic>(builder: (logic) {
        return Text(logic.item.id == null ? '添加事项' : '编辑事项');
      })),
      floatingActionButton: FloatingActionButton(
        onPressed: logic.addAction,
        tooltip: 'Add',
        child: const Icon(Icons.done),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            detailCard(),
            const SizedBox(height: 16),
            colorCard(),
          ],
        ),
      ),
    );
  }

  Card colorCard() {
    return Card(
      elevation: 10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            selectColorItem(),
            const SizedBox(height: 5),
            Divider(
              color: Colors.grey[400],
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 200,
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 25,
                ),
                itemCount: Colors.primaries.length,
                itemBuilder: (context, index) {
                  Color color = Colors.primaries[index][200]!;
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: color,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100)))),
                    onPressed: () => logic.changColor(color),
                    child: Container(),
                  );
                },
                shrinkWrap: true,
                // physics: const NeverScrollableScrollPhysics(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget selectColorItem() {
    return GetBuilder<AddItemLogic>(builder: (logic) {
      var item = logic.item;
      return Row(
        children: [
          const Text(
            '主题色',
            style: TextStyle(fontSize: 18),
          ),
          const Spacer(flex: 1),
          SizedBox(
            height: 25,
            width: 25,
            child: CircleAvatar(
              backgroundColor: HexColor(item.color ?? ''),
            ),
          ),
          const SizedBox(width: 8),
          const Text('#'),
          Expanded(
            child: TextField(
              controller: logic.colorController,
              onChanged: logic.changeTextField,
            ),
          )
        ],
      );
    });
  }

  Card detailCard() {
    return Card(
      elevation: 10,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: logic.nameController,
              decoration: const InputDecoration(hintText: '名称'),
              onChanged: (value) {
                logic.item.name = value;
              },
            ),
            TextField(
              controller: logic.noteController,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              decoration: const InputDecoration(hintText: '备注'),
              onChanged: (value) {
                logic.item.note = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
