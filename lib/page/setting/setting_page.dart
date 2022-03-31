import 'package:flutter/material.dart';
import 'package:frequency/controller/application_controller.dart';
import 'package:get/get.dart';

import 'setting_logic.dart';

class SettingPage extends StatelessWidget {
  final logic = Get.put(SettingLogic());

  SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
            appInfoView(context),
            const SizedBox(height: 10),
            Card(
              elevation: 12,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: ListTile(
                title: const Text('问题建议'),
                trailing: const Icon(Icons.navigate_next),
                onTap: logic.sendEmail,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appInfoView(BuildContext context) {
    var packageInfo = Get.find<ApplicationController>().packageInfo;
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: Image.asset(
            'assets/image/logo.png',
            width: 150,
            height: 150,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          packageInfo.appName,
          style: Theme.of(context).textTheme.headline6,
        ),
        const SizedBox(height: 5),
        Text(
          'version ${packageInfo.version}',
          style: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ],
    );
  }
}
