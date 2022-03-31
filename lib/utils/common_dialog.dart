import 'package:flutter/material.dart';
import 'package:frequency/dialog/loading_dialog.dart';
import 'package:get/get.dart';

showLoadingDialog(BuildContext context) {
  Get.dialog(LoadingDialog(color: Theme.of(context).scaffoldBackgroundColor));
  // showDialog(
  //     context: context,
  //     builder: (_) {
  //       return LoadingDialog(color: Theme.of(context).scaffoldBackgroundColor);
  //     });
}
