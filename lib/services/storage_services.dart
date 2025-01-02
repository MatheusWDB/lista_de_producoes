import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list_2/models/todo.dart';

class StorageService {
  Future<File?> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final dir = Directory(directory.path);

    // Verificar se o diretório existe
    if (await dir.exists()) {
      return File('${directory.path}/data.json');
    } else {
      // Se o diretório não existir, não fazer nada
      return null;
    }
  }

  Future<File> saveData(List<Todo> toDoList) async {
    organize(toDoList);
    String data = json.encode(toDoList);
    final file = await getFile();
    return file!.writeAsString(data);
  }

  Future<String?> readData() async {
    final file = await getFile();
    if (file != null && await file.exists()) {
      return file.readAsString();
    } else {
      // Se o arquivo ou diretório não existir, retorna null
      return null;
    }
  }

  void organize(List<Todo> toDoList) {
    toDoList.sort((a, b) {
      if (a.ok && !b.ok) {
        return 1;
      } else if (!a.ok && b.ok) {
        return -1;
      } else {
        return a.title
            .toString()
            .toLowerCase()
            .compareTo(b.title.toString().toLowerCase());
      }
    });
  }
}
