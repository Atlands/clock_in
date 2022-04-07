import 'dart:convert' as convert;
import 'dart:io';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frequency/controller/application_controller.dart';
import 'package:frequency/database/item.dart';
import 'package:frequency/database/todo.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class BackupLogic extends GetxController {
  late Database _db;
  late PackageInfo _info;

  final _tables = [Item.keyClassName, Todo.keyClassName];
  static const SECRET_KEY = "ASDFGHJKLASDFGHK";

  @override
  void onInit() {
    _db = Get.find<ApplicationController>().db;
    _info = Get.find<ApplicationController>().packageInfo;
    super.onInit();
  }

  backup() async {
    var status = await Permission.storage.status;
    if (status == PermissionStatus.granted) {
      _generateBackup();
    } else if (status == PermissionStatus.denied) {
      Fluttertoast.showToast(msg: '请前往设置打开本应用的存储访问权限');
    } else {
      status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        _generateBackup();
      }
    }
  }

  _generateBackup({bool isEncrypted = true}) async {
    // Directory copyTo = Directory("storage/emulated/0/Download/F");
    // if(!(await copyTo.exists())) await copyTo.create();

    List data = [];

    List<Map<String, dynamic>> listMaps = [];

    for (var table in _tables) {
      listMaps = await _db.query(table);
      data.add(listMaps);
    }

    List backups = [_tables, data];

    String json = convert.jsonEncode(backups);

    if (isEncrypted) {
      var key = encrypt.Key.fromUtf8(SECRET_KEY);
      var iv = encrypt.IV.fromLength(16);
      var encrypter = encrypt.Encrypter(encrypt.AES(key));
      json = encrypter.encrypt(json, iv: iv).base64;
      // return encrypted.base64;
    }
    await File(
            'storage/emulated/0/Download/frequency-backup-${Jiffy().format('yyyymmdd')}')
        .writeAsString(json);
    Get.snackbar(_info.appName, '数据备份完成');
  }

  restore() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      _restoreBackup(String.fromCharCodes(result.files.single.bytes!))
          .then((_) => Get.snackbar(_info.appName, '数据恢复完成'))
          .catchError((_) => Get.snackbar(_info.appName, '恢复失败'));
    }
  }

  Future<void> _restoreBackup(String backup, {bool isEncrypted = true}) async {
    Batch batch = _db.batch();
    var key = encrypt.Key.fromUtf8(SECRET_KEY);
    var iv = encrypt.IV.fromLength(16);
    var encrypter = encrypt.Encrypter(encrypt.AES(key));

    List json = convert
        .jsonDecode(isEncrypted ? encrypter.decrypt64(backup, iv: iv) : backup);

    for (var i = 0; i < json[0].length; i++) {
      for (var k = 0; k < json[1][i].length; k++) {
        var map = json[1][i][k];
        // map['id'] = null;
        batch.insert(json[0][i], map,
            conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }
    await batch.commit(continueOnError: false, noResult: true);
  }
}
