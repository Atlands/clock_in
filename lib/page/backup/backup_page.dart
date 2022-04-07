import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'backup_logic.dart';

class BackupPage extends StatelessWidget {
  final logic = Get.put(BackupLogic());

  BackupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('备份与恢复')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
             const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('1.备份/恢复过程可能需要一点时间，请不要离开当前页面\n2.请不要重复点击以免崩溃\n3.请不要选择不相关的文件\n4.备份/恢复需要存储权限，请点击允许'),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(onPressed: logic.backup, child: const Text('备份')),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(onPressed: logic.restore, child: const Text('恢复')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
