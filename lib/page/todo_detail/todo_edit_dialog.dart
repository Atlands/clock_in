import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../../database/todo.dart';

class TodoEditDialog extends Dialog {
  TodoEditDialog(this.todo, {Key? key}) : super(key: key);

  final Todo todo;
  late final _controller = TextEditingController(text: todo.name ?? '');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
          child: Container(
            height: 240,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  Jiffy(todo.time).format('MM月dd号事件'),
                  style: Get.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0))),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                    onPressed: () => Get.back(result: _controller.text),
                    child: const Text('完成'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
