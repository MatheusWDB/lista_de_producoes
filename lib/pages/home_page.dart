import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list_2/models/todo.dart';
import 'package:todo_list_2/widgets/task_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _toDoController = TextEditingController();

  List<Todo> _toDoList = [];

  Todo? _deletedTodo;
  int? _deletedTodoIndex;
  String? error;

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      setState(() {
        if (data != null) {
          // Decodifica a string JSON e converte para List<Todo>
          List<dynamic> jsonData = json.decode(data);
          _toDoList = jsonData.map((item) => Todo.fromJson(item)).toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Programas'),
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
            spacing: 8,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _toDoController,
                      decoration: InputDecoration(
                        labelText: 'Novo Título...',
                        errorText: error,
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
              Flexible(
                child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in _toDoList)
                        TaskItem(
                          task: todo,
                          onChanged: (value) {
                            setState(() {
                              todo.ok = value!;
                              _saveData();
                            });
                          },
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
              ),
              Row(
                spacing: 8.0,
                children: [
                  Expanded(
                    child: Text(
                        'Você possui ${_toDoList.length} tarefas pendentes'),
                  ),
                  ElevatedButton(
                    onPressed: showDeleteTodosConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00b7f3),
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    child: const Text(
                      'Limpar Tudo',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    _deletedTodo = todo;
    _deletedTodoIndex = _toDoList.indexOf(todo);

    setState(() {
      _toDoList.remove(todo);
      _saveData();
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'A Tarefa "${todo.title}" foi removida com sucesso!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () {
            setState(() {
              _toDoList.insert(_deletedTodoIndex!, _deletedTodo!);
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Ação desfeita!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  duration: Duration(seconds: 2),
                ),
              );
            });
            _saveData();
          },
          textColor: const Color(0xff00b7f3),
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    if (_toDoList.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Limpar Tudo?',
          ),
          content: const Text(
            'Tem certeza que deseja pagar todas as tarefas?',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff00b7f3)),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteAllTodos();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text(
                'Limpar Tudo',
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Limpar Tudo?',
          ),
          content: const Text(
            'Você não possui tarefas!',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xff00b7f3)),
              child: const Text('Fechar'),
            ),
          ],
        ),
      );
    }
  }

  void deleteAllTodos() {
    setState(() {
      _toDoList.clear();
      _saveData();
    });
  }

  void _addToDo() {
    if (_toDoController.text.isEmpty) {
      setState(() {
        error = 'Preencha o campo';
      });
      return;
    }

    Todo newToDo = Todo(
        title: _toDoController.text, ok: false, date: DateTime.now().toLocal());

    setState(() {
      _toDoList.add(newToDo);
      error = null;
    });

    organize();
    _saveData();
    _toDoController.clear();
  }

  void organize() {
    _toDoList.sort((a, b) {
      if (a.ok && !b.ok) {
        return 1;
      } else if (!a.ok && b.ok) {
        return -1;
      } else {
        return a.title.toString().compareTo(b.title.toString());
      }
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
      organize();
      _saveData();
    });

    return null;
  }
}
