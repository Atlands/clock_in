import 'package:flutter/cupertino.dart';
import 'package:frequency/provider/application_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingProvider extends ChangeNotifier {
  SettingProvider();

  sendEmail(BuildContext context) {
    var packageInfo = context.read<ApplicationProvider>().packageInfo;
    var uri = Uri(
      scheme: 'mailto',
      path: 'atlands777@petalmail.com',
      query: encodeQueryParameters(
          <String, String>{'subject': '[${packageInfo.appName}] 问题建议'}),
    );
    launch(uri.toString());
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
