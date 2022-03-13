import 'package:flutter/material.dart';
import 'package:frequency/provider/application_provider.dart';
import 'package:frequency/provider/setting_provider.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    var packageInfo = context.watch<ApplicationProvider>().packageInfo;

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 100),
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
            const SizedBox(height: 10),
            Card(
              elevation: 12,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14))),
              child: ListTile(
                title: const Text('问题建议'),
                trailing: const Icon(Icons.navigate_next),
                onTap: () {
                  context.read<SettingProvider>().sendEmail(context);
                },
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
