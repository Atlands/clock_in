import 'package:frequency/controller/application_controller.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingLogic extends GetxController {
  sendEmail() {
    var packageInfo = Get.find<ApplicationController>().packageInfo;
    var uri = Uri(
      scheme: 'mailto',
      path: 'atlands777@petalmail.com',
      query: _encodeQueryParameters(
          <String, String>{'subject': '[${packageInfo.appName}] 问题建议'}),
    );
    launch(uri.toString());
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
