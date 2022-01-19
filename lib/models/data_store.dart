import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

// ########################################
// DATA STORAGE
// ########################################
class DataStorage {
  String file_name = 'cross_slide.json';
  Map<String, dynamic> json = {};
  DataStorage(this.json);

  DataStorage.writeData(Map<String, dynamic> text) {
    _store(text);
    return;
  }

  Future<Null> _store(Map<String, dynamic> text) async {
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$file_name');
    String json = jsonEncode(text); 
    await file.writeAsString(json);
    return;
  }

  Future<Map<String, dynamic>> get readData async {
    String text = "{}";
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$file_name');
    text = await file.readAsString();
    json = jsonDecode(text);
    return json;
  }

}