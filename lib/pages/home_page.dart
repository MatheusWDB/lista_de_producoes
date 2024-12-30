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
  final Map<String, TextEditingController> _toDoController = {
    'title': TextEditingController(),
    'description': TextEditingController()
  };

  List<Todo> _toDoList = [];

  Todo? _deletedTodo;
  int? _deletedTodoIndex;
  Map<String, String?> error = {'title': null, 'description': null};

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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 12.0,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  child: ElevatedButton(
                    onPressed: showAddTodosDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      iconColor: Colors.white,
                    ),
                    child: Text(
                      'Novo Título...',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Você possui ${_toDoList.length} títulos pendentes'),
                  ElevatedButton(
                    onPressed: showDeleteTodosConfirmationDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
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
          textColor: Colors.blueAccent,
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void showAddTodosDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: const Text('Novo Título...'),
            titleTextStyle: TextStyle(color: Colors.blueAccent, fontSize: 28),
            content: Column(
              spacing: 8.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _toDoController['title'],
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    errorText: error['title'],
                    labelStyle: TextStyle(
                      color: Colors.blueAccent,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                      ), // Cor quando está focado
                    ),
                  ),
                  onChanged: (value) {
                    setDialogState(() {
                      error['title'] = null; // Remove o erro ao digitar
                    });
                  },
                ),
                TextField(
                  controller: _toDoController['description'],
                  cursorColor: Colors.blueAccent,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    errorText: error['description'],
                    labelStyle: TextStyle(
                      color: Colors.blueAccent,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blueAccent,
                      ), // Cor quando está focado
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _toDoController['title']!.clear();
                  _toDoController['description']!.clear();
                  error['title'] = null;
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                ),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (_toDoController['title']!.text.isEmpty) {
                    setDialogState(() {
                      error['title'] = 'Campo obrigatório!';
                    });
                    return;
                  }
                  _addToDo();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                ),
                child: const Text('Adicionar'),
              ),
            ],
          ),
        );
      },
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
            'Tem certeza que deseja pagar todas os títulos?',
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
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
    if (_toDoController['title']!.text.isEmpty) {
      setState(() {
        error['title'] = 'Campo obrigatório!';
        print('AQUIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII ${error['title']}');
      });
      return;
    }

    Todo newToDo = Todo(
        title: _toDoController['title']!.text,
        ok: false,
        date: DateTime.now().toLocal(),
        description: _toDoController['description']!.text);

    setState(() {
      _toDoList.add(newToDo);
      error['title'] = null;
    });

    organize();
    _saveData();
    _toDoController['title']!.clear();
    _toDoController['description']!.clear();
    Navigator.of(context).pop();
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
