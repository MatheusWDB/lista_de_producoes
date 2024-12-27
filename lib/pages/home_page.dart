import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _toDoController = TextEditingController();

  List _toDoList = [];

  Map<String, dynamic>? _itemRemoved;
  int? _itemRemovedIndex;

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
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView.builder(
                    itemCount: _toDoList.length,
                    itemBuilder: buildItem,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(_toDoList[index]['title']),
        value: _toDoList[index]['ok'],
        secondary: CircleAvatar(
          child: Icon(
            _toDoList[index]['ok'] ? Icons.task_alt : Icons.pending_outlined,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _toDoList[index]['ok'] = value;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        _itemRemoved = Map.from(_toDoList[index]);
        _itemRemovedIndex = index;
        _toDoList.removeAt(index);
        _saveData();

        final snack = SnackBar(
          content: Text('Tarefa "${_itemRemoved!['title']}" removida!'),
          action: SnackBarAction(
            label: 'Desfazer!',
            onPressed: () {
              setState(() {
                _toDoList.insert(_itemRemovedIndex!, _itemRemoved);
                _saveData();
              });
            },
          ),
          duration: Duration(seconds: 5),
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(snack);
      },
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

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _toDoList.sort((a, b) {
        if (a['ok'] && !b['ok']) {
          return 1;
        } else if (!a['ok'] && b['ok']) {
          return -1;
        } else {
          return a['title'].toString().compareTo(b['title'].toString());
        }
      });

      _saveData();
    });

    return null;
  }
}
