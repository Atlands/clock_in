import 'package:flutter/material.dart';
import 'package:frequency/utils/color_utils.dart';
import 'package:frequency/provider/item/add_item_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/config.dart';

class AddItem extends StatefulWidget {
  const AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  var colorController = TextEditingController(text: '');
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AddItemProvider>();
    var item = provider.item;
    item.color ??= itemColorValues.first;
    colorController.value = TextEditingValue(
        text: item.color!,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: item.color!.length)));
    return Scaffold(
      appBar: AppBar(title: const Text('添加事项')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<AddItemProvider>().addAction(context);
        },
        tooltip: 'Add',
        child: const Icon(Icons.done),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Card(
              elevation: 10,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(hintText: '名称'),
                      onChanged: (value) {
                        item.name = value;
                      },
                    ),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      decoration: const InputDecoration(hintText: '备注'),
                      onChanged: (value) {
                        item.note = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 10,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                            backgroundColor: HexColor(item.color!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('#'),
                        Expanded(
                          child: TextField(
                            controller: colorController,
                            onChanged: (value) {
                              if (value.length > 6) {
                                colorController.value = TextEditingValue(
                                    text: item.color!,
                                    selection: TextSelection.fromPosition(
                                        TextPosition(
                                            affinity: TextAffinity.downstream,
                                            offset: item.color!.length)));
                              } else {
                                setState(() {
                                  item.color = value;
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Divider(
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 5),
                    GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 25,
                      ),
                      itemCount: itemColorValues.length,
                      itemBuilder: (context, index) {
                        var colorValue = itemColorValues[index];

                        return Ink(
                          decoration: BoxDecoration(
                              color: HexColor(colorValue),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50))),
                          child: InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            onTap: () {
                              setState(() {
                                item.color = colorValue;
                              });
                            },
                          ),
                        );
                      },
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
