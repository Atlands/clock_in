import 'package:flutter/material.dart';
import 'package:frequency/page/item/add_item.dart';
import 'package:frequency/utils/color_utils.dart';
import 'package:frequency/provider/item/add_item_provider.dart';
import 'package:frequency/provider/item/select_item_provider.dart';
import 'package:provider/provider.dart';

class SelectItem extends StatefulWidget {
  const SelectItem({Key? key}) : super(key: key);

  @override
  _SelectItemState createState() => _SelectItemState();
}

class _SelectItemState extends State<SelectItem> {
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SelectItemProvider>();
    var items = provider.items;
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择事项'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                              create: (_) => AddItemProvider(),
                              child: const AddItem(),
                            ))).then((value) =>
                    context.read<SelectItemProvider>().addItem(value));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
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
                context.read<SelectItemProvider>().selectItem(context, item);
              },
            ),
          );
        },
      ),
    );
  }
}
