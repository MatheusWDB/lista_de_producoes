import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:watchlist_plus/models/production.dart';

class StorageServices {
  Future<File?> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory(directory.path);
    if (await dir.exists()) {
      return File('${directory.path}/data.json');
    } else {
      return null;
    }
  }

  Future<File> saveData(List<Production> productionList) async {
    String data = json.encode(productionList);
    final file = await getFile();
    return file!.writeAsString(data);
  }

  Future<String?> readData() async {
    final file = await getFile();
    if (file != null && await file.exists()) {
      return file.readAsString();
    } else {
      return null;
    }
  }
}
