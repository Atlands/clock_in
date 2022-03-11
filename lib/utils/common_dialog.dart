import 'package:flutter/material.dart';
import 'package:frequency/dialog/loading_dialog.dart';

showLoadingDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) {
        return LoadingDialog(color: Theme.of(context).scaffoldBackgroundColor);
      });
}
