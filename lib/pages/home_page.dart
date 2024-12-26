import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list_2/widgets/list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _toDoController = TextEditingController();

  List _toDoList = [];

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tarefa'),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _toDoController,
                      decoration: InputDecoration(
                        labelText: 'Nova Tarefa',
                        labelStyle: TextStyle(
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _addToDo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      iconColor: Colors.white,
                    ),
                    child: Icon(Icons.add),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _toDoList.length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(_toDoList[index]['title']),
                      value: _toDoList[index]['ok'],
                      secondary: CircleAvatar(
                        child: Icon(
                          _toDoList[index]['ok']
                              ? Icons.task_alt
                              : Icons.pending_outlined,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _toDoList[index]['ok'] = value;
                          _saveData();
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = {};
      newToDo['title'] = _toDoController.text;
      _toDoController.clear();
      newToDo['ok'] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_toDoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String?> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
